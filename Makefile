DB_URL=postgresql://root:secret@localhost:5432/transaction_system?sslmode=disable

postgres:
	docker run --name postgres --network transaction-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres createdb --username=root --owner=root transaction_system

dropdb:
	docker exec -it postgres dropdb transaction_system

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/tanvirhasan74/transaction_system/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock