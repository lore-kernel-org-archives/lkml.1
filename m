Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0AOJrM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050Ab0AOJrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:47:11 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:32853 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0AOJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:47:08 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: intermittent failure to power down with 2.6.33-rc3
Date: Fri, 15 Jan 2010 10:47:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001151047.50667.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing an intermittent failure to power down on this laptop. It's
a regression. It does not depend on a shutdown vs. STD. I haven't
observed a failure to reboot.

	Regards
		Oliver

# dmidecode 2.10
SMBIOS 2.5 present.
41 structures occupying 1870 bytes.
Table at 0x000FCEC0.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: American Megatrends Inc.
        Version: 202
        Release Date: 09/15/2008
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 1024 kB
        Characteristics:
                ISA is supported
                PCI is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                Boot from CD is supported
                Selectable boot is supported
                EDD is supported
                5.25"/1.2 MB floppy services are supported (int 13h)
                3.5"/720 kB floppy services are supported (int 13h)
                3.5"/2.88 MB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Printer services are supported (int 17h)
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                Smart battery is supported
                BIOS boot specification is supported
                Function key-initiated network boot is supported
                Targeted content distribution is supported
        BIOS Revision: 2.2
        Firmware Revision: 32.1

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: ASUSTeK Computer Inc.
        Product Name: M70Vn
        Version: 1.0
        Serial Number: 100233070004
        UUID: 0069792B-F116-DE81-32F2-00248C745CDB
        Wake-up Type: Power Switch
        SKU Number:
        Family:

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
        Manufacturer: ASUSTeK Computer Inc.
        Product Name: M70Vn
        Version: 1.0
        Serial Number: BSN12345678901234567
        Asset Tag: ATN12345678901234567
        Features:
                Board is a hosting board
                Board requires at least one daughter board
                Board is replaceable
        Location In Chassis: MIDDLE
        Chassis Handle: 0x0003
        Type: Motherboard
        Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
        Manufacturer: ASUSTeK Computer Inc.
        Type: Notebook
        Lock: Not Present
        Version: 1.0
        Serial Number: CSN12345678901234567
        Asset Tag: ATN12345678901234567
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Other
        Security Status: Other
        OEM Information: 0x00000000
        Height: Unspecified
        Number Of Power Cords: 1
        Contained Elements: 0

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
        Socket Designation: Socket 478
        Type: Central Processor
        Family: Core 2 Duo
        Manufacturer: Intel
        ID: 76 06 01 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 23, Stepping 6
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
        Version: Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
        Voltage: 1.1 V
        External Clock: 267 MHz
        Max Speed: 2533 MHz
        Current Speed: 2533 MHz
        Status: Populated, Enabled
        Upgrade: Socket 478
        L1 Cache Handle: 0x0005
        L2 Cache Handle: 0x0007
        L3 Cache Handle: Not Provided
        Serial Number: PSN12345678901234567
        Asset Tag: PATN1234567890123456
        Part Number: PPN12345678901234567
        Core Count: 2
        Core Enabled: 2
        Thread Count: 2
        Characteristics:
                64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L1-Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 64 kB
        Maximum Size: 64 kB
        Supported SRAM Types:
                Other
        Installed SRAM Type: Other
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Data
        Associativity: 8-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L1-Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 64 kB
        Maximum Size: 64 kB
        Supported SRAM Types:
                Other
        Installed SRAM Type: Other
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Instruction
        Associativity: 8-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L2-Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 6144 kB
        Maximum Size: 6144 kB
        Supported SRAM Types:
                Other
        Installed SRAM Type: Other
        Speed: Unknown
        Error Correction Type: Single-bit ECC
        System Type: Unified
        Associativity: Other

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J3401
        Internal Connector Type: None
        External Reference Designator: LAN
        External Connector Type: RJ-45
        Port Type: Network Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J4501
        Internal Connector Type: None
        External Reference Designator: VGA
        External Connector Type: DB-15 female
        Port Type: Video Port

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J5201
        Internal Connector Type: None
        External Reference Designator: USB1
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J5201
        Internal Connector Type: None
        External Reference Designator: USB2
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J4800
        Internal Connector Type: None
        External Reference Designator: HDMI
        External Connector Type: Other
        Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J5101
        Internal Connector Type: None
        External Reference Designator: SATA 1
        External Connector Type: SAS/SATA Plug Receptacle
        Port Type: SATA

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J4202
        Internal Connector Type: None
        External Reference Designator: FlashCard
        External Connector Type: Other
        Port Type: Other

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J4301
        Internal Connector Type: None
        External Reference Designator: ExpressCard
        External Connector Type: Other
        Port Type: Other

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J6601
        Internal Connector Type: None
        External Reference Designator: eSATA
        External Connector Type: SAS/SATA Plug Receptacle
        Port Type: SATA

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J3703
        Internal Connector Type: None
        External Reference Designator: Audio Out
        External Connector Type: Mini Jack (headphones)
        Port Type: Audio Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J3801
        Internal Connector Type: None
        External Reference Designator: Mic In
        External Connector Type: Mini Jack (headphones)
        Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J2502
        Internal Connector Type: None
        External Reference Designator: USB3
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J4203
        Internal Connector Type: None
        External Reference Designator: 1394
        External Connector Type: IEEE 1394
        Port Type: Firewire (IEEE P1394)

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: J5401
        Internal Connector Type: None
        External Reference Designator: DockPort
        External Connector Type: Other
        Port Type: Other

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
        Designation: PEG
        Type: x16 PCI Express
        Current Usage: In Use
        Length: Short
        ID: 0
        Characteristics:
                3.3 V is provided

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
        Designation: PCIE1
        Type: 64-bit PCI Express
        Current Usage: In Use
        Length: Short
        ID: 1
        Characteristics:
                3.3 V is provided
                PME signal is supported

Handle 0x0018, DMI type 9, 13 bytes
System Slot Information
        Designation: PCIE2
        Type: x1 PCI Express
        Current Usage: Available
        Length: Short
        ID: 2
        Characteristics:
                3.3 V is provided
                PME signal is supported

Handle 0x0019, DMI type 9, 13 bytes
System Slot Information
        Designation: PCIE3
        Type: x1 PCI Express
        Current Usage: Available
        Length: Short
        ID: 3
        Characteristics:
                3.3 V is provided
                PME signal is supported
                Hot-plug devices are supported

Handle 0x001A, DMI type 10, 6 bytes
On Board Device Information
        Type: Video
        Status: Enabled
        Description:  Gfx Card

Handle 0x001B, DMI type 10, 6 bytes
On Board Device Information
        Type: Ethernet
        Status: Enabled
        Description:  NIC

Handle 0x001C, DMI type 10, 6 bytes
On Board Device Information
        Type: Sound
        Status: Enabled
        Description:  Audio Codec

Handle 0x001D, DMI type 10, 6 bytes
On Board Device Information
        Type: SATA Controller
        Status: Enabled
        Description:  SATA Controller

Handle 0x001E, DMI type 10, 6 bytes
On Board Device Information
        Type: Other
        Status: Enabled
        Description:  1394/FlashCardReader

Handle 0x001F, DMI type 13, 22 bytes
BIOS Language Information
        Installable Languages: 1
                en|US|iso8859-1
        Currently Installed Language: en|US|iso8859-1

Handle 0x0020, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 8 GB
        Error Information Handle: Not Provided
        Number Of Devices: 2

Handle 0x0021, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 4 GB
        Physical Array Handle: 0x0020
        Partition Width: 0

Handle 0x0022, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0020
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: SODIMM
        Set: None
        Locator: SODIMM0
        Bank Locator: BANK0
        Type: DDR2
        Type Detail: Synchronous
        Speed: 800 MHz
        Manufacturer: N/A
        Serial Number: N/A
        Asset Tag: N/A
        Part Number: N/A

Handle 0x0023, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0007FFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0022
        Memory Array Mapped Address Handle: 0x0021
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0024, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0020
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: SODIMM
        Set: None
        Locator: SODIMM1
        Bank Locator: BANK1
        Type: DDR2
        Type Detail: Synchronous
        Speed: 800 MHz
        Manufacturer: N/A
        Serial Number: N/A
        Asset Tag: N/A
        Part Number: N/A

Handle 0x0025, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00080000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 2 GB
        Physical Device Handle: 0x0024
        Memory Array Mapped Address Handle: 0x0021
        Partition Row Position: Unknown
        Interleave Position: Unknown
        Interleaved Data Depth: Unknown

Handle 0x0026, DMI type 22, 26 bytes
Portable Battery
        Location: In the back
        Manufacturer: AS011OM33F
        Manufacture Date: 09/03/12
        Serial Number: 4788
        Name: M70--26
        Chemistry: Other
        Design Capacity: 5060 mWh
        Design Voltage: 14800 mV
        SBDS Version: SMART Ver 0123
        Maximum Error: Unknown
        OEM-specific Information: 0x00000000

Handle 0x0027, DMI type 200, 27 bytes
OEM-specific Type
        Header and Data:
                C8 1B 27 00 01 02 03 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00
        Strings:
                ASUSTeK Computer Inc.
                Notebook
                1.0

Handle 0x0028, DMI type 127, 4 bytes
End Of Table
