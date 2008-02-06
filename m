Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYBFNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYBFNyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYBFNyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:54:05 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43597 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYBFNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:54:00 -0500
Date: Wed, 6 Feb 2008 08:53:06 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
Message-ID: <20080206135306.GI27119@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jiri Kosina <jikos@jikos.cz>,
	Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
	Andrew Morton <akpm@linux-foundation.org>,
	"Klaus S. Madsen" <ksm@hjernemadsen.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com> <20080204194038.d8851b8d.akpm@linux-foundation.org> <20080205113633.GI27738@hjernemadsen.org> <20080205102219.83fe459d.akpm@linux-foundation.org> <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com> <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz> <20080206022517.GB27119@mit.edu> <Pine.LNX.4.64.0802060909420.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802060909420.30873@twin.jikos.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2008 at 09:11:27AM +0100, Jiri Kosina wrote:
> On Tue, 5 Feb 2008, Theodore Tso wrote:
> 
> I have also seen sound working flawlessly on another X61s. Maybe they 
> changed some chipset revisions on the fly, or whatever.
> 
> What does lspci -v show for your soundcard please?

Attached please find my lspci -v and dmidecode information.

						- Ted


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci-v.x61"

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Lenovo Unknown device 20b3
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])
	Subsystem: Lenovo Unknown device 20b5
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo Unknown device 20b5
	Flags: bus master, fast devsel, latency 0
	Memory at f8200000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Unknown device 20de
	Flags: bus master, fast devsel, latency 0, IRQ 508
	Memory at fe000000 (32-bit, non-prefetchable) [size=128K]
	Memory at fe225000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 1840 [size=32]
	Capabilities: <access denied>

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Lenovo Thinkpad T61
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 1860 [size=32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Lenovo Thinkpad T60
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 1880 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Lenovo Thinkpad T61
	Flags: bus master, medium devsel, latency 0, IRQ 22
	Memory at fe226c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Lenovo Thinkpad T61
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fe220000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: dc100000-dfcfffff
	Prefetchable memory behind bridge: 00000000dfe00000-00000000dfefffff
	Capabilities: <access denied>

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
	Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 20aa
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 18a0 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 20aa
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at 18c0 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Unknown device 20ab
	Flags: bus master, medium devsel, latency 0, IRQ 19
	Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=08, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: f8300000-fbffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
	Subsystem: Lenovo Unknown device 20b6
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Lenovo Unknown device 20a6
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 18e0 [size=16]

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Unknown device 20a7
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 509
	I/O ports at 1c30 [size=8]
	I/O ports at 1c24 [size=4]
	I/O ports at 1c28 [size=8]
	I/O ports at 1c20 [size=4]
	I/O ports at 1c00 [size=32]
	Memory at fe226000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo Unknown device 20a9
	Flags: medium devsel, IRQ 10
	Memory at fe227400 (32-bit, non-prefetchable) [size=256]
	I/O ports at 1c40 [size=32]

02:00.0 Memory controller: Intel Corporation Turbo Memory Controller (rev 01)
	Subsystem: Intel Corporation Turbo Memory Controller
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at dfcffc00 (32-bit, non-prefetchable) [size=1K]
	I/O ports at 2000 [size=128]
	[virtual] Expansion ROM at dfe00000 [disabled] [size=64K]
	Capabilities: <access denied>

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
	Subsystem: Intel Corporation Lenovo Thinkpad T61
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at fdf00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>

05:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Unknown device 20c6
	Flags: bus master, medium devsel, latency 168, IRQ 16
	Memory at f8300000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=05, secondary=06, subordinate=07, sec-latency=176
	Memory window 0: f4000000-f7fff000 (prefetchable)
	Memory window 1: c4000000-c7fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	16-bit legacy interface ports at 0001

05:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
	Subsystem: Lenovo Unknown device 20c7
	Flags: bus master, medium devsel, latency 0, IRQ 5
	Memory at f8301000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>

05:00.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Lenovo Unknown device 20c8
	Flags: bus master, medium devsel, latency 0, IRQ 6
	Memory at f8301800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmidecode.x61"

# dmidecode 2.9
SMBIOS 2.4 present.
63 structures occupying 2129 bytes.
Table at 0x000E0010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: LENOVO
	Version: 7NET30WW (1.11 )
	Release Date: 11/15/2007
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 1.17
	Firmware Revision: 1.2

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: LENOVO
	Product Name: 7668CTO
	Version: ThinkPad X61s
	Serial Number: XXXXXXX
	UUID: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: ThinkPad X61s

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: LENOVO
	Product Name: 7668CTO
	Version: Not Available
	Serial Number: XXXXXXXXXXX

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: LENOVO
	Type: Notebook
	Lock: Not Present
	Version: Not Available
	Serial Number: Not Available
	Asset Tag: No Asset Information
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown

Handle 0x0004, DMI type 126, 13 bytes
Inactive

Handle 0x0005, DMI type 126, 13 bytes
Inactive

Handle 0x0006, DMI type 4, 35 bytes
Processor Information
	Socket Designation: None
	Type: Central Processor
	Family: Other
	Manufacturer: GenuineIntel
	ID: FB 06 00 00 FF FB EB BF
	Version: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz
	Voltage: 1.1 V
	External Clock: 200 MHz
	Max Speed: 1600 MHz
	Current Speed: 1600 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000C
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0007, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 4096 MB
	Maximum Total Memory Size: 8192 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 2
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		Unknown

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 1
	Bank Connections: 0 1
	Current Speed: 155 ns
	Type: DIMM SDRAM
	Installed Size: 2048 MB (Double-bank Connection)
	Enabled Size: 2048 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 2
	Bank Connections: 2 3
	Current Speed: 155 ns
	Type: DIMM SDRAM
	Installed Size: 2048 MB (Double-bank Connection)
	Enabled Size: 2048 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 4096 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: External Monitor
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Microphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Headphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Modem
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0015, DMI type 126, 9 bytes
Inactive

Handle 0x0016, DMI type 126, 9 bytes
Inactive

Handle 0x0017, DMI type 126, 9 bytes
Inactive

Handle 0x0018, DMI type 126, 9 bytes
Inactive

Handle 0x0019, DMI type 126, 9 bytes
Inactive

Handle 0x001A, DMI type 126, 9 bytes
Inactive

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: IEEE1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x001C, DMI type 9, 13 bytes
System Slot Information
	Designation: CardBus Slot 1
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported
		PME signal is supported
		Hot-plug devices are supported

Handle 0x001D, DMI type 9, 13 bytes
System Slot Information
	Designation: Media Card Slot 1
	Type: Other
	Current Usage: Available
	Length: Other
	Characteristics:
		Hot-plug devices are supported

Handle 0x001E, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: IBM Embedded Security hardware

Handle 0x001F, DMI type 11, 5 bytes
OEM Strings
	String 1: IBM ThinkPad Embedded Controller -[7MHT24WW-1.02    ]-

Handle 0x0020, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		enUS
	Currently Installed Language: enUS

Handle 0x0021, DMI type 15, 25 bytes
System Event Log
	Area Length: 0 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Valid, Not Full
	Change Token: 0x000000F8
	Header Format: Type 1
	Supported Log Type Descriptors: 1
	Descriptor 1: POST error
	Data Format 1: POST results bitmap

Handle 0x0022, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0023, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0022
	Error Information Handle: 0xFF01
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 1
	Bank Locator: Bank 0/1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0024, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0022
	Error Information Handle: 0xFF01
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 2
	Bank Locator: Bank 2/3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0025, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0026, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x0022
	Partition Width: 0

Handle 0x0027, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0023
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x0028, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0024
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x0029, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Track Point
	Interface: PS/2
	Buttons: 3

Handle 0x002A, DMI type 22, 26 bytes
Portable Battery
	Location: Rear
	Manufacturer: SANYO
	Name: 42T4506
	Design Capacity: 74880 mWh
	Design Voltage: 14400 mV
	SBDS Version: 03.01
	Maximum Error: Unknown
	SBDS Serial Number: XXXX
	SBDS Manufacture Date: 2007-09-23
	SBDS Chemistry: LION
	OEM-specific Information: 0x00000000

Handle 0x002B, DMI type 126, 26 bytes
Inactive

Handle 0x002C, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Enabled
	Keyboard Password Status: Disabled
	Administrator Password Status: Enabled
	Front Panel Reset Status: Unknown

Handle 0x002D, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x002E, DMI type 131, 17 bytes
OEM-specific Type
	Header and Data:
		83 11 2E 00 01 02 03 FF FF 1F 00 00 00 00 00 02
		00
	Strings:
		BOOTINF 20h
		BOOTDEV 21h
		KEYPTRS 23h

Handle 0x002F, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 2F 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x0030, DMI type 132, 7 bytes
OEM-specific Type
	Header and Data:
		84 07 30 00 02 D8 36

Handle 0x0031, DMI type 133, 5 bytes
OEM-specific Type
	Header and Data:
		85 05 31 00 01
	Strings:
		KHOIHGIUCCHHII

Handle 0x0032, DMI type 134, 13 bytes
OEM-specific Type
	Header and Data:
		86 0D 32 00 10 10 07 20 00 00 00 00 00

Handle 0x0033, DMI type 134, 16 bytes
OEM-specific Type
	Header and Data:
		86 10 33 00 00 41 54 4D 4C 01 01 00 00 03 01 02
	Strings:
		TPM INFO
		System Reserved

Handle 0x0034, DMI type 135, 13 bytes
OEM-specific Type
	Header and Data:
		87 0D 34 00 54 50 07 00 01 00 00 00 00

Handle 0x0035, DMI type 135, 18 bytes
OEM-specific Type
	Header and Data:
		87 12 35 00 54 50 07 01 01 B2 01 00 00 00 00 00
		00 00

Handle 0x0036, DMI type 135, 35 bytes
OEM-specific Type
	Header and Data:
		87 23 36 00 54 50 07 02 42 41 59 20 49 2F 4F 20
		01 00 02 00 00 0A 00 30 1C 26 1C 02 00 0E 00 F0
		01 F6 03

Handle 0x0037, DMI type 135, 26 bytes
OEM-specific Type
	Header and Data:
		87 1A 37 00 54 50 07 04 01 04 01 01 02 00 02 02
		02 00 03 01 02 00 04 01 02 00

Handle 0x0038, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 38 00 5A 5A

Handle 0x0039, DMI type 137, 28 bytes
OEM-specific Type
	Header and Data:
		89 1C 39 00 0C 02 00 01 01 00 00 01 50 57 4D 53
		20 49 6E 66 6F 72 6D 61 74 69 6F 6E

Handle 0x003A, DMI type 138, 40 bytes
OEM-specific Type
	Header and Data:
		8A 28 3A 00 14 01 02 01 40 02 01 40 02 01 40 02
		01 40 01 40 42 49 4F 53 20 50 61 73 73 77 6F 72
		64 20 46 6F 72 6D 61 74

Handle 0x003B, DMI type 139, 37 bytes
OEM-specific Type
	Header and Data:
		8B 25 3B 00 11 01 0A 00 00 00 00 00 00 00 00 00
		00 50 57 4D 53 20 4B 65 79 20 49 6E 66 6F 72 6D
		61 74 69 6F 6E

Handle 0x003C, DMI type 129, 8 bytes
OEM-specific Type
	Header and Data:
		81 08 3C 00 01 01 02 00
	Strings:
		Intel_ASF
		Intel_ASF_001

Handle 0x003D, DMI type 130, 20 bytes
OEM-specific Type
	Header and Data:
		82 14 3D 00 24 41 4D 54 01 00 00 00 00 A5 00 00
		00 00 00 00

Handle 0x003E, DMI type 127, 4 bytes
End Of Table


--H+4ONPRPur6+Ovig--
