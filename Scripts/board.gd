extends Node2D

var grid_size = Vector2(10, 10)

var tileScene = preload("res://Scenes/Tile.tscn")
var squareTexture = preload("res://Assets/square.png")
var circleTexture = preload("res://Assets/circle.png")
var triangleTexture = preload("res://Assets/triangle.png")
var starTexture = preload("res://Assets/star.png")

var grid = []

func _ready():
	randomize()
	seed(122)

	initialize_grid()
	pass
	
func initialize_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			var pattern
			var node = tileScene.instance()
			pattern = randi() % 4
			if pattern == 0:
				node.get_node("Sprite").set_texture(squareTexture)
			elif pattern == 1:
				node.get_node("Sprite").set_texture(circleTexture)
			elif pattern == 2:
				node.get_node("Sprite").set_texture(triangleTexture)
			else:
				node.get_node("Sprite").set_texture(starTexture)
			node.pattern = pattern
			node.set_pos(Vector2(64 * x + 100 + (x * 3), 64 * y + 100 + (y * 3)))
			add_child(node)
			grid[x].append(node)
	clear_matches()

	
func clear_matches():
	var matchFound = false
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var current = grid[x][y]
			# Check for vertical matches
			var i = 1
			while y + i < grid_size.y:
				if current.pattern != grid[x][y+i].pattern:
					break
				i += 1
			if i > 2:
				matchFound = true
				for j in range(y, y+i):
					grid[x][j].pattern = -1
					grid[x][j].get_node("AnimationPlayer").play("fade")
					
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var current = grid[x][y]
			# Check for horizontal matches
			var i = 1
			print("current.pattern = " + str(current.pattern))
			while x + i < grid_size.x:
				if current.pattern != grid[x + i][y].pattern:
					break
				print("found match: (" + str(x) + "," + str(y) + ")")
				i += 1
			if i > 2:
				matchFound = true
				for j in range(x, x+i):
					grid[j][y].pattern = -1
					grid[j][y].get_node("AnimationPlayer").play("fade")
					
#	# Drop tiles
#	for y in range(grid_size.y - 1, 1, -1):
#		for x in range(grid_size.x):
#			