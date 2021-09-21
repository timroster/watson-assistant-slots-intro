# Use a standard nodejs v14 image as our base builder image.
# Here we use an image from Alpine which contains the PhantomJS package
# required to build the application.
# Note that this image from Alpine is pulled from Docker Hub, which may
# limit downloads. If you reach your pull rate limit, try again later.
FROM node:14.0.0-alpine3.10 AS builder

WORKDIR /app
ADD . /app

# Install dependencies
RUN npm install

# Build our deployable image based on UBI
FROM registry.access.redhat.com/ubi8/nodejs-14:1-46
COPY --from=builder /app .

# Add license file to satisfy requirement for building a certifiable image.
# Certification requires the files have a proper extension and be placed in
# a directory named licenses. Our example repo license file is named LICENSE
# and in the root directory, so we use the following command to comply:
COPY --from=builder /app/LICENSE /licenses/LICENSE.txt

# Start app
EXPOSE 3000

CMD [ "npm","start"]

# Add label information that will be associated with our image. This is another
# requirement for building a certifiable image.
LABEL name="dev-rh/watson-assistant-slots-intro" \
vendor="IBM" \
version="0.0.9" \
release="" \
summary="Pizza chatbot" \
description="This chatbot allows users to order pizza."