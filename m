Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZEYNM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZEYNM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbZEYNMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:12:49 -0400
Received: from bender.cm4all.net ([87.106.27.49]:38731 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZEYNMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:12:47 -0400
Date: Mon, 25 May 2009 15:12:50 +0200
From: Max Kellermann <mk@cm4all.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
Message-ID: <20090525131250.GA8776@rabbit.intern.cm-ag>
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer> <20081020065149.GA11213@rabbit.intern.cm-ag> <4A171221.5020800@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <4A171221.5020800@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2009/05/22 22:59, "H. Peter Anvin" <hpa@zytor.com> wrote:
> I was just pointed to this thread in the archives, and I'm really
> wondering what was going on here.  In particular, if this machine still
> is around, I would appreciate a dump of /proc/cpuinfo as well as
> dmidecode from this machine.

Here it is.  We run these machines with 2.6.29, the problem is gone.

Max

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 3.06GHz
stepping	: 5
cpu MHz		: 3066.590
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 6105.99
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 3.06GHz
stepping	: 5
cpu MHz		: 3066.590
cache size	: 1024 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 6
initial apicid	: 6
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 6106.57
clflush size	: 64
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 3.06GHz
stepping	: 5
cpu MHz		: 3066.590
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 6106.63
clflush size	: 64
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 3.06GHz
stepping	: 5
cpu MHz		: 3066.590
cache size	: 1024 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 7
initial apicid	: 7
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 6106.64
clflush size	: 64
power management:


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.9
SMBIOS 2.3 present.
49 structures occupying 1334 bytes.
Table at 0x000EC000.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: HP
	Version: P29
	Release Date: 07/25/2003
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported

Handle 0x0100, DMI type 1, 25 bytes
System Information
	Manufacturer: HP
	Product Name: ProLiant DL380 G3
	Version: Not Specified
	Serial Number: 8090LDN31R      
	UUID: 38303930-4C44-4E33-3152-202020202020
	Wake-up Type: Power Switch

Handle 0x0300, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: HP
	Type: Rack Mount Chassis
	Lock: Not Present
	Version: Not Specified
	Serial Number: 8090LDN31R      
	Asset Tag:                                 
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown

Handle 0x0406, DMI type 4, 32 bytes
Processor Information
	Socket Designation: Proc 1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: 25 0F 00 00 FF FB EB BF
	Signature: Type 0, Family 15, Model 2, Stepping 5
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Not Specified
	Voltage: 1.7 V
	External Clock: 533 MHz
	Max Speed: 3600 MHz
	Current Speed: 3066 MHz
	Status: Populated, Idle
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0716
	L2 Cache Handle: 0x0726
	L3 Cache Handle: 0x0736

Handle 0x0400, DMI type 4, 32 bytes
Processor Information
	Socket Designation: Proc 2
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: 25 0F 00 00 FF FB EB BF
	Signature: Type 0, Family 15, Model 2, Stepping 5
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Not Specified
	Voltage: 1.7 V
	External Clock: 533 MHz
	Max Speed: 3600 MHz
	Current Speed: 3066 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0710
	L2 Cache Handle: 0x0720
	L3 Cache Handle: 0x0730

Handle 0x0716, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 1 Internal L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: 4-way Set-associative

Handle 0x0710, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 2 Internal L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: 4-way Set-associative

Handle 0x0726, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 1 Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Other

Handle 0x0720, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 2 Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Other

Handle 0x0736, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 1 Internal L3 Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Other

Handle 0x0730, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Processor 2 Internal L3 Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Other

Handle 0x0801, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J58
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: USB Port 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0802, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J58
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: USB Port 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0901, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot 1
	Type: 64-bit PCI-X
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0902, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot 2
	Type: 64-bit PCI-X
	Current Usage: In Use
	Length: Long
	ID: 2
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0903, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot 3
	Type: 64-bit PCI-X
	Current Usage: In Use
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported

Handle 0x1000, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Single-bit ECC
	Maximum Capacity: 12 GB
	Error Information Handle: Not Provided
	Number Of Devices: 6

Handle 0x1100, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM 01
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1101, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM 02
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1102, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM 03
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1103, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM 04
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1104, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM 05
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1105, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM 06
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 266 MHz (3.8 ns)

Handle 0x1300, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x1000
	Partition Width: 0

Handle 0x1400, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x1100
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: Unknown

Handle 0x1401, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x1101
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 2
	Interleaved Data Depth: Unknown

Handle 0x1402, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x000BFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x1102
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: Unknown

Handle 0x1403, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x000BFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x1103
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 2
	Interleaved Data Depth: Unknown

Handle 0x1404, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x000C0000000
	Ending Address: 0x000F50003FF
	Range Size: 868353 kB
	Physical Device Handle: 0x1104
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: Unknown

Handle 0x1405, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x000C0000000
	Ending Address: 0x000F50003FF
	Range Size: 868353 kB
	Physical Device Handle: 0x1105
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1
	Interleave Position: 2
	Interleaved Data Depth: Unknown

Handle 0x1450, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0000
	Memory Array Mapped Address Handle: 0x0000
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: Unknown

Handle 0x1451, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0000
	Memory Array Mapped Address Handle: 0x0000
	Partition Row Position: 1
	Interleave Position: 2
	Interleaved Data Depth: Unknown

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
	Status: Firmware-detected hardware failure

Handle 0xC100, DMI type 193, 7 bytes
OEM-specific Type
	Header and Data:
		C1 07 00 C1 01 01 02
	Strings:
		07/25/2003
		03/19/2003

Handle 0xC200, DMI type 194, 5 bytes
OEM-specific Type
	Header and Data:
		C2 05 00 C2 09

Handle 0xC300, DMI type 195, 5 bytes
OEM-specific Type
	Header and Data:
		C3 05 00 C3 01
	Strings:
		$0E110727

Handle 0xC400, DMI type 196, 5 bytes
OEM-specific Type
	Header and Data:
		C4 05 00 C4 00

Handle 0xC506, DMI type 197, 10 bytes
OEM-specific Type
	Header and Data:
		C5 0A 06 C5 06 04 06 00 FF 01

Handle 0xC500, DMI type 197, 10 bytes
OEM-specific Type
	Header and Data:
		C5 0A 00 C5 00 04 00 01 FF 02

Handle 0xC600, DMI type 198, 10 bytes
OEM-specific Type
	Header and Data:
		C6 0A 00 C6 17 00 00 01 3C 00

Handle 0xC700, DMI type 199, 52 bytes
OEM-specific Type
	Header and Data:
		C7 34 00 C7 11 00 00 00 03 20 13 06 25 0F 00 00
		15 00 00 00 03 20 04 06 29 0F 00 00 1D 00 00 00
		03 20 16 01 24 0F 00 00 38 00 00 00 03 20 04 06
		27 0F 00 00

Handle 0xCD00, DMI type 205, 22 bytes
OEM-specific Type
	Header and Data:
		CD 16 00 CD 01 01 46 41 54 78 00 00 F1 FF 00 00
		00 00 00 80 02 00

Handle 0xCA00, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 00 CA 00 11 FF 01

Handle 0xCA01, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 01 CA 01 11 FF 02

Handle 0xCA02, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 02 CA 02 11 FF 03

Handle 0xCA03, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 03 CA 03 11 FF 04

Handle 0xCA04, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 04 CA 04 11 FF 05

Handle 0xCA05, DMI type 202, 8 bytes
OEM-specific Type
	Header and Data:
		CA 08 05 CA 05 11 FF 06

Handle 0x7F00, DMI type 127, 4 bytes
End Of Table


--ibTvN161/egqYuK8--
