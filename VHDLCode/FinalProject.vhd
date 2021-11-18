library ieee;
use ieee.std_logic_1164.all;

-- REGISTERS
entity reg is port
(
	clk: in std_logic;
	rin: in std_logic_vector (3 downto 0);
	a: in std_logic;
	rout: out std_logic_vector (3 downto 0)
);

end entity;

architecture r of reg is
signal rt: std_logic_vector (3 downto 0);

begin

	process (clk,a)
	-- Update the register output on the clock's falling edge
	begin
		if (falling_edge(clk)) and a = '1' then
			rt <= rin;
		end if;
	end process;
	rout <= rt;
	
end r;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Unsigned Adder/Subtractor
entity unsigned_adder_subtractor is
port 
(
	a: in std_logic_vector (3 downto 0);
	b: in std_logic_vector (3 downto 0);
	add_sub: in std_logic_vector (2 downto 0);
	result: out std_logic_vector (3 downto 0)
);

end entity;

architecture rtl of unsigned_adder_subtractor is
signal a0, b0, result0: unsigned (3 downto 0);
begin

	a0 <= unsigned(a);
	b0 <= unsigned(b);

	process(a0,b0,add_sub)
	begin
		-- add if "add_sub" is 001, subtract if "add_sub" is 101
		if (add_sub = "001") then
			result0 <= a0 + b0;
		elsif (add_sub = "101") then
			result0 <= a0 - b0;
		end if;
		result <= std_logic_vector(result0);
	end process;

end rtl;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--MULTIPLEXER 1: selecting input into register 0 and 1
entity mv_mux is
port
(
	in_value: in std_logic_vector (3 downto 0);
	r2: in std_logic_vector (3 downto 0);
	opcode: in std_logic_vector (2 downto 0);
	y: out std_logic_vector (3 downto 0)
);

end entity;

architecture mr of mv_mux is
begin

	--multiplexer to choose between input value and register 2
	y <= r2 when opcode = "100" else in_value;

end mr;



library ieee;
use ieee.std_logic_1164.all;

--MULTIPLEXER 2: selecting bits in register 0 or 1 to be inverted
entity not_mux is
port
(
	r0: in std_logic_vector (3 downto 0);
	r1: in std_logic_vector (3 downto 0);
	rbit: in std_logic;
	y: out std_logic_vector (3 downto 0)
);

end entity;

architecture nr of not_mux is
begin

	--multiplexer to choose either register 0 or 1 to invert
	y <= r0 when rbit = '0' else r1;

end nr;





library ieee;
use ieee.std_logic_1164.all;

--MULTIPLEXER 3: selecting operation result to be sent to register 2
entity op_mux is
port
(
	an: in std_logic_vector (3 downto 0);
	o_r: in std_logic_vector (3 downto 0);
	ad_sb: in std_logic_vector (3 downto 0);
	nt: in std_logic_vector (3 downto 0);
	opcode: in std_logic_vector (2 downto 0);
	y: out std_logic_vector (3 downto 0)
);

end entity;

architecture rr of op_mux is
begin

	process(an,o_r,ad_sb,nt,opcode)
	--multiplexer to choose which operation's result is displayed
	begin
		case opcode is
			when "010" =>	y <= an;
			when "011" =>	y <= o_r;
			when "111" =>	y <= nt;
			when "001" =>	y <= ad_sb;
			when "101" =>	y <= ad_sb;
			when others => y <= "1110";
		end case;
	end process;

end rr;





library ieee;
use ieee.std_logic_1164.all;

--MULTIPLEXER 4: selecting operation result to be displayed on board
entity ds_mux is
port
(
	reg0: in std_logic_vector (3 downto 0);
	reg1: in std_logic_vector (3 downto 0);
	reg2: in std_logic_vector (3 downto 0);
	dscode: in std_logic_vector (3 downto 0);
	y: out std_logic_vector (3 downto 0)
);

end entity;

architecture rrr of ds_mux is
begin

	process(reg0,reg1,reg2,dscode)
	--multiplexer to choose which operation's result is displayed
	begin
		case dscode is
			when "1100" =>	y <= reg0;
			when "1101" =>	y <= reg1;
			when others => y <= reg2;
		end case;
	end process;

end rrr;



library ieee;
use ieee.std_logic_1164.all;

--SEGMENT DISPLAY
entity display is
port
(
	a: in std_logic_vector (3 downto 0);
	y: out std_logic_vector (6 downto 0)
);

end entity;

architecture ds of display is
begin

	process(a)
	begin
		case a is
			when "0000" =>	y <= "0111111";
			when "0001" =>	y <= "0000110";
			when "0010" =>	y <= "1011011";
			when "0011" =>	y <= "1001111";
			when "0100" =>	y <= "1100110";
			when "0101" =>	y <= "1101101";
			when "0110" =>	y <= "1111101";
			when "0111" =>	y <= "0000111";
			when "1000" =>	y <= "1111111";
			when "1001" =>	y <= "1100111";
			when "1010" =>	y <= "1110111";
			when "1011"	=>	y <= "1111100";
			when "1100" =>	y <= "0111001";
			when "1101" =>	y <= "1011110";
			when "1110"	=> y <= "1111001";
			when "1111"	=>	y <= "1110001";
		end case;
	end process;

end ds;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--START OF MCA-4
entity final_project is
port
(
	x: in std_logic_vector (7 downto 0);
	clk: in std_logic;
	y3: out std_logic_vector (3 downto 0);
	a: out std_logic_vector (6 downto 0)
);
end entity;

--ARCHTECTURE OF MCA-4
architecture r_cmp of final_project is
component reg
port
(
	clk: in std_logic;
	rin: in std_logic_vector (3 downto 0);
	a: in std_logic;
	rout: out std_logic_vector (3 downto 0)
);
end component;

component unsigned_adder_subtractor
port 
(
	a		: in std_logic_vector (3 downto 0);
	b		: in std_logic_vector (3 downto 0);
	add_sub : in std_logic_vector (2 downto 0);
	result	: out std_logic_vector (3 downto 0)
);
end component;


component mv_mux
port
(
	in_value: in std_logic_vector (3 downto 0);
	r2: in std_logic_vector (3 downto 0);
	opcode: in std_logic_vector (2 downto 0);
	y: out std_logic_vector (3 downto 0)
);
end component;

component not_mux
port
(
	r0: in std_logic_vector (3 downto 0);
	r1: in std_logic_vector (3 downto 0);
	rbit: in std_logic;
	y: out std_logic_vector (3 downto 0)
);
end component;

component op_mux is
port
(
	an: in std_logic_vector (3 downto 0);
	o_r: in std_logic_vector (3 downto 0);
	ad_sb: in std_logic_vector (3 downto 0);
	nt: in std_logic_vector (3 downto 0);
	opcode: in std_logic_vector (2 downto 0);
	y: out std_logic_vector (3 downto 0)
);
end component;

component ds_mux
port
(
	reg0: in std_logic_vector (3 downto 0);
	reg1: in std_logic_vector (3 downto 0);
	reg2: in std_logic_vector (3 downto 0);
	dscode: in std_logic_vector (3 downto 0);
	y: out std_logic_vector (3 downto 0)
);

end component;

component display
port
(
	a: in std_logic_vector (3 downto 0);
	y: out std_logic_vector (6 downto 0)
);

end component;


signal value,y,y1,c0,c1,c2,c3,c4,can,cor,cadsb,cnot,result: std_logic_vector (3 downto 0);
signal y2: std_logic_vector (6 downto 0);
signal opcode: std_logic_vector (2 downto 0);
--putting the pieces together
begin
	value <= x(3 downto 0);
	opcode <= x(7 downto 5);
	y3 <= y1;
	mux1: mv_mux port map (value, y, opcode, c0);
	mux2: mv_mux port map (value, y, opcode, c1);
	r0: reg port map (clk, c0, (not x(4) and not opcode(1) and not opcode(0)), c2);
	r1: reg port map (clk, c1, (x(4) and not opcode(1) and not opcode(0)), c3);
	can <= c2 and c3;
	cor <= c2 or c3;
	add_sub: unsigned_adder_subtractor port map (c3, c2, opcode, cadsb);
	mux3: not_mux port map (c2, c3, x(4), c4);
	cnot <= not c4;
	mux4: op_mux port map (can, cor, cadsb, cnot, opcode, result);
	r2: reg port map (clk, result, (x(5) or (not x(5) and x(6) and not x(7))), y);
	mux5: ds_mux port map (c2, c3, y, x(7 downto 4), y1);
	ds: display port map (y1, y2);
	a <= y2;
end r_cmp;