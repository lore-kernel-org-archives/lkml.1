Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZBKJvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZBKJvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZBKJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:51:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBKJvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:51:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Date: Wed, 11 Feb 2009 10:50:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20090204191540.2d6abd87@infradead.org> <200902102300.19065.rjw@sisk.pl> <alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_h9pkJpJD/kDsT5e"
Message-Id: <200902111050.25008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_h9pkJpJD/kDsT5e
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 11 February 2009, Jiri Kosina wrote:
> On Tue, 10 Feb 2009, Rafael J. Wysocki wrote:
> 
> > > Well, that beast was selling with linux preloaded, no? Or was it 
> > > another msi wind? In such case I'd expect old kernel to work... or 
> > > maybe some reasonable workaround somewhere...
> > In fact I have an MSI Wind and the touchpad is works on it just fine with the
> > current mainline.
> > Perhaps this one is just another MSI Wind.  What model is it?
> 
> From what I have heard there are different models of MSI Wind out there, 
> with different set of hardware configurations.
> 
> Arjan, Rafael, could you please provide the dmidecode outputs for the 
> working and non-working systems, so that we can see what are the 
> differences?

Attached.

Thanks,
Rafael

--Boundary-00=_h9pkJpJD/kDsT5e
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="wind-dmidecode.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="wind-dmidecode.log"

# dmidecode 2.9
SMBIOS 2.4 present.
45 structures occupying 1626 bytes.
Table at 0x3F607010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 4.6.3
	Release Date: 06/26/2008
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: MICRO-STAR INTERNATIONAL CO., LTD
	Product Name: U-100
	Version: Ver.001
	Serial Number: FFFFFFFF
	UUID: 00000000-0000-0000-0000-001D925AD702
	Wake-up Type: Power Switch
	SKU Number: To be filled by O.E.M.
	Family: To be filled by O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: MICRO-STAR INTERNATIONAL CO., LTD
	Product Name: U-100
	Version: Ver.001
	Serial Number: FFFFFFFF
	Asset Tag: To be filled by O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To be filled by O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: MICRO-STAR INTERNATIONAL CO., LTD
	Type: Desktop
	Lock: Present
	Version: Ver.001
	Serial Number: FFFFFFFF
	Asset Tag: To Be Filled By O.E.M.
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel            
	ID: C2 06 01 00 FF FB E9 BF
	Signature: Type 0, Family 6, Model 28, Stepping 2
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
	Version: Intel(R) Atom(TM) CPU N270   @ 1.60GH          
	Voltage: 3.3 V 2.9 V
	External Clock: 533 MHz
	Max Speed: 4000 MHz
	Current Speed: 1599 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 24 KB
	Maximum Size: 24 KB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: Other

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0007, DMI type 126, 19 bytes
Inactive

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS2Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A1
	Internal Connector Type: None
	External Reference Designator: TV Out
	External Connector Type: Mini Centronics Type-14
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2A
	Internal Connector Type: None
	External Reference Designator: COM A
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2B
	Internal Connector Type: None
	External Reference Designator: Video
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J5A1
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J5A1
	Internal Connector Type: None
	External Reference Designator: USB4
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J5A1
	Internal Connector Type: None
	External Reference Designator: USB5
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1E1 - ITP
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J8J2 - SATA 0
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J7H1 - SATA 1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3C1 - CPU FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3C1 - CPU FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J4J1 - MAIN POWER
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6J1 - ITP
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J7J1 - IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001B, DMI type 9, 13 bytes
System Slot Information
	Designation: J6C1
	Type: x16 PCI Express
	Current Usage: Available
	Length: Long
	ID: 0
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x001C, DMI type 9, 13 bytes
System Slot Information
	Designation: J7C1
	Type: x1 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x001D, DMI type 9, 13 bytes
System Slot Information
	Designation: J8C1
	Type: x1 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x001E, DMI type 9, 13 bytes
System Slot Information
	Designation: J8B1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x001F, DMI type 9, 13 bytes
System Slot Information
	Designation: J9B1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0020, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:    To Be Filled By O.E.M.

Handle 0x0021, DMI type 10, 6 bytes
On Board Device Information
	Type: <OUT OF SPEC>
	Status: Enabled
	Description: To Be Filled By O.E.M.

Handle 0x0022, DMI type 11, 5 bytes
OEM Strings
	String 1: To Be Filled By O.E.M.

Handle 0x0023, DMI type 12, 5 bytes
System Configuration Options
	Option 1: To Be Filled By O.E.M.

Handle 0x0024, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x0025, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 2048 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0026, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Array Handle: 0x0025
	Partition Width: 0

Handle 0x0027, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0025
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: 64 bits
	Size: Unknown
	Form Factor: DIMM
	Set: Unknown
	Locator: DIMM0
	Bank Locator: BANK0
	Type: DDR2
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Manufacturer0
	Serial Number: SerNum0
	Asset Tag: AssetTagNum0
	Part Number: PartNum0

Handle 0x0028, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0027
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x0029, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0025
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: 64 bits
	Size: Unknown
	Form Factor: DIMM
	Set: Unknown
	Locator: DIMM1
	Bank Locator: BANK1
	Type: DDR2
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Manufacturer1
	Serial Number: SerNum1
	Asset Tag: AssetTagNum1
	Part Number: PartNum1

Handle 0x002A, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0029
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x002B, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x002C, DMI type 127, 4 bytes
End Of Table


--Boundary-00=_h9pkJpJD/kDsT5e--
