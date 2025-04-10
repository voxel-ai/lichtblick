# Build stage
FROM node:20 AS build
WORKDIR /src
COPY . ./

RUN corepack enable
RUN yarn install --immutable

RUN yarn run web:build:prod

# Release stage
FROM caddy:2.7.6-alpine
WORKDIR /src
COPY --from=build /src/web/.webpack ./

EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
CMD ["caddy", "file-server", "--listen", ":8080"]
