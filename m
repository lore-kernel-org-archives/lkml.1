Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbZAWWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbZAWWYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZAWWYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:24:31 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35171 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbZAWWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:24:29 -0500
Message-ID: <497A439A.8070006@cfl.rr.com>
Date: Fri, 23 Jan 2009 17:24:26 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, markh@compro.net,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <20090123144723.GA12790@aftab>
In-Reply-To: <20090123144723.GA12790@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi,
> 
> [.. ]
> 
>> Can you please try to boot with idle=poll, or idle=mwait, or nolapic_timer
>> when using 2.6.26.X?
>> Can you also try to boot .27 or .28?
> 
> Also, can you send me the output of dmidecode please?
> 
> Thanks.
> 

Yes, here it is.

# dmidecode 2.9
SMBIOS 2.5 present.
54 structures occupying 2295 bytes.
Table at 0x000F0000.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Phoenix Technologies, LTD
        Version: 6.00 PG
        Release Date: 12/25/2008
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 1024 kB
        Characteristics:
                ISA is supported
                PCI is supported
                PNP is supported
                APM is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                BIOS ROM is socketed
                EDD is supported
                5.25"/360 KB floppy services are supported (int 13h)
                5.25"/1.2 MB floppy services are supported (int 13h)
                3.5"/720 KB floppy services are supported (int 13h)
                3.5"/2.88 MB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                ATAPI Zip drive boot is supported
                BIOS boot specification is supported
                Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: BIOSTAR Group
        Product Name: A78XA-A2T
        Version: 1.0
        Serial Number: Unknow
        UUID: Not Present
        Wake-up Type: Power Switch
        SKU Number:
        Family:

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
        Manufacturer: BIOSTAR Group
        Product Name: TA770 A2+
        Version: 1.0
        Serial Number:

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
        Manufacturer: BIOSTAR Group
        Type: Desktop
        Lock: Not Present
        Version: A78XA-A2T
        Serial Number:
        Asset Tag:
        Boot-up State: Unknown
        Power Supply State: Unknown
        Thermal State: Unknown
        Security Status: Unknown
        OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
        Socket Designation: Socket AM2
        Type: Central Processor
        Family: 80287
        Manufacturer: AMD
        ID: 42 0F 10 00 FF FB 8B 17
        Version: AMD Phenom(tm) II X4 940 Processor
        Voltage: 1.5 V
        External Clock: 200 MHz
        Max Speed: 3000 MHz
        Current Speed: 3000 MHz
        Status: Populated, Enabled
        Upgrade: Socket 940
        L1 Cache Handle: 0x000A
        L2 Cache Handle: 0x000B
        L3 Cache Handle: Not Provided
        Serial Number:
        Asset Tag:
        Part Number:
        Core Count: 4
        Core Enabled: 4
        Thread Count: 4
        Characteristics:
                64-bit capable

Handle 0x0005, DMI type 5, 24 bytes
Memory Controller Information
        Error Detecting Method: 64-bit ECC
        Error Correcting Capabilities:
                None
        Supported Interleave: One-way Interleave
        Current Interleave: One-way Interleave
        Maximum Memory Module Size: 4096 MB
        Maximum Total Memory Size: 16384 MB
        Supported Speeds:
                70 ns
                60 ns
                50 ns
        Supported Memory Types:
                Standard
                DIMM
        Memory Module Voltage: 2.9 V
        Associated Memory Slots: 4
                0x0006
                0x0007
                0x0008
                0x0009
        Enabled Error Correcting Capabilities: None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A0
        Bank Connections: 0 1
        Current Speed: Unknown
        Type: Other Unknown EDO
        Installed Size: 1024 MB (Double-bank Connection)
        Enabled Size: 1024 MB (Double-bank Connection)
        Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A1
        Bank Connections: 2 3
        Current Speed: Unknown
        Type: Other Unknown EDO
        Installed Size: 1024 MB (Double-bank Connection)
        Enabled Size: 1024 MB (Double-bank Connection)
        Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A2
        Bank Connections: 4 5
        Current Speed: Unknown
        Type: Other Unknown EDO
        Installed Size: 1024 MB (Double-bank Connection)
        Enabled Size: 1024 MB (Double-bank Connection)
        Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
        Socket Designation: A3
        Bank Connections: 6 7
        Current Speed: Unknown
        Type: Other Unknown EDO
        Installed Size: 1024 MB (Double-bank Connection)
        Enabled Size: 1024 MB (Double-bank Connection)
        Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
        Socket Designation: Internal Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 128 KB
        Maximum Size: 128 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
        Socket Designation: External Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 512 KB
        Maximum Size: 512 KB
        Supported SRAM Types:
                Synchronous
        Installed SRAM Type: Synchronous
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: Unknown

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: PRIMARY IDE
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: SECONDARY IDE
        Internal Connector Type: On Board IDE
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: FDD
        Internal Connector Type: On Board Floppy
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: 8251 FIFO Compatible

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: COM1
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator:
        External Connector Type: DB-9 male
        Port Type: Serial Port 16450 Compatible

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: COM2
        Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
        External Reference Designator:
        External Connector Type: DB-9 male
        Port Type: Serial Port 16450 Compatible

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: LPT1
        Internal Connector Type: DB-25 female
        External Reference Designator:
        External Connector Type: DB-25 female
        Port Type: Parallel Port ECP/EPP

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Keyboard
        Internal Connector Type: PS/2
        External Reference Designator:
        External Connector Type: PS/2
        Port Type: Keyboard Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: PS/2 Mouse
        Internal Connector Type: PS/2
        External Reference Designator:
        External Connector Type: PS/2
        Port Type: Mouse Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB0
        External Connector Type: Other
        Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB1
        External Connector Type: Other
        Port Type: USB

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB2
        External Connector Type: Other
        Port Type: USB

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB3
        External Connector Type: Other
        Port Type: USB

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB4
        External Connector Type: Other
        Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB5
        External Connector Type: Other
        Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB6
        External Connector Type: Other
        Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB7
        External Connector Type: Other
        Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB8
        External Connector Type: Other
        Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
        Internal Reference Designator: Not Specified
        Internal Connector Type: None
        External Reference Designator: USB9
        External Connector Type: Other
        Port Type: USB

Handle 0x001E, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI0
        Type: 32-bit PCI Express
        Current Usage: In Use
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x001F, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI1
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 2
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0020, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI2
        Type: 32-bit PCI Express
        Current Usage: In Use
        Length: Long
        ID: 3
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI3
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 4
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0022, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI-X
        Type: 32-bit PCI-X
        Current Usage: Available
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided

Handle 0x0023, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI-X
        Type: 32-bit PCI-X
        Current Usage: Available
        Length: Long
        ID: 29
        Characteristics:
                5.0 V is provided

Handle 0x0024, DMI type 9, 13 bytes
System Slot Information
        Designation: PCI-X
        Type: 32-bit PCI-X
        Current Usage: Available
        Length: Long
        ID: 8
        Characteristics:
                5.0 V is provided

Handle 0x0025, DMI type 13, 22 bytes
BIOS Language Information
        Installable Languages: 3
                n|US|iso8859-1
                n|US|iso8859-1
                r|CA|iso8859-1
        Currently Installed Language: n|US|iso8859-1

Handle 0x0026, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 2 GB
        Error Information Handle: Not Provided
        Number Of Devices: 4

Handle 0x0027, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0026
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: None
        Locator: A0
        Bank Locator: Bank0/1
        Type: Unknown
        Type Detail: None
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0028, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0026
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: None
        Locator: A1
        Bank Locator: Bank2/3
        Type: Unknown
        Type Detail: None
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0029, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0026
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: None
        Locator: A2
        Bank Locator: Bank4/5
        Type: Unknown
        Type Detail: None
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x002A, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0026
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: None
        Locator: A3
        Bank Locator: Bank6/7
        Type: Unknown
        Type Detail: None
        Speed: Unknown
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x002B, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 4 GB
        Physical Array Handle: 0x0026
        Partition Width: 0

Handle 0x002C, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x0027
        Memory Array Mapped Address Handle: 0x002B
        Partition Row Position: 1

Handle 0x002D, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00040000000
        Ending Address: 0x0007FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x0028
        Memory Array Mapped Address Handle: 0x002B
        Partition Row Position: 1

Handle 0x002E, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00080000000
        Ending Address: 0x000BFFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x0029
        Memory Array Mapped Address Handle: 0x002B
        Partition Row Position: 1

Handle 0x002F, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x000C0000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x002A
        Memory Array Mapped Address Handle: 0x002B
        Partition Row Position: 1

Handle 0x0030, DMI type 32, 11 bytes
System Boot Information
        Status: No errors detected

Handle 0x0031, DMI type 188, 212 bytes
OEM-specific Type
        Header and Data:
                BC D4 31 00 00 00 00 C0 00 00 00 00 00 00 00 40
                01 00 00 00 00 06 76 00 00 00 00 00 08 00 00 00
                00 40 40 00 10 08 01 00 03 00 00 00 00 00 3F 01
                00 00 00 00 01 00 00 00 00 00 00 00 02 00 00 00
                00 00 00 00 03 00 00 00 00 00 00 00 04 00 00 00
                00 00 00 00 05 00 00 00 00 00 00 00 06 00 00 00
                00 00 00 00 07 00 00 00 03 40 00 C0 01 00 00 00
                01 01 00 00 01 02 00 00 01 03 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 E0 3C F8 00
                E0 3C F8 00 00 00 00 00 00 00 00 00 06 00 48 0B
                00 00 00 00 22 00 00 00 40 00 00 00 26 99 14 0C
                45 60 92 00 10 08 01 00 00 02 00 00 00 00 00 00
                5C 00 B0 4A 0C 00 58 3F 00 00 00 00 00 00 00 00
                00 00 00 00

Handle 0x0032, DMI type 190, 212 bytes
OEM-specific Type
        Header and Data:
                BE D4 32 00 10 05 00 00 00 00 00 00 24 A4 40 04
                C0 0F E0 2C 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 27 00 00 00 00 00 00 00
                00 00 00 00 27 5F E0 31 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00

Handle 0x0033, DMI type 192, 244 bytes
OEM-specific Type
        Header and Data:
                C0 F4 33 00 06 40 00 00 22 32 11 10 20 20 2F 00
                E7 88 71 0E F0 00 0C 00 22 32 11 10 11 12 11 11
                11 11 12 11 11 12 11 11 11 10 10 11 11 10 12 10
                11 10 10 11 11 11 00 20 20 2F 00 0E 0E 0E 0E 10
                10 0E 10 0E 0E 0E 0E 0E 0E 0E 10 0E 0E 0E 0E 0E
                0E 0E 10 0E 10 00 AD 36 FB 30 F0 00 0C 00 75 00
                72 00 6D 00 6B 00 75 00 7C 00 79 00 73 00 71 00
                7C 00 15 00 12 00 0D 00 0B 00 00 00 1C 00 19 00
                13 00 11 00 00 00 6B 00 6B 00 6F 00 74 00 00 00
                70 00 73 00 78 00 7C 00 00 00 0B 00 0B 00 0F 00
                14 00 00 00 10 00 13 00 18 00 1C 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 14 13 13 14 14 12 13 14 13 00 00 00
                98 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00

Handle 0x0034, DMI type 194, 244 bytes
OEM-specific Type
        Header and Data:
                C2 F4 34 00 06 40 00 00 22 32 11 10 20 20 2F 00
                63 8C 31 06 F0 00 0C 00 22 32 11 10 11 12 11 12
                11 12 11 12 11 12 11 12 10 11 11 10 11 11 12 12
                10 11 11 10 11 11 00 20 20 2F 00 10 0E 0E 10 10
                10 0E 0E 10 0E 0E 10 0E 0E 10 10 0C 10 0E 10 0E
                0E 10 10 10 10 00 EB 95 EC 2F F0 00 0C 00 76 00
                73 00 6E 00 6A 00 76 00 7E 00 7B 00 76 00 72 00
                7E 00 16 00 13 00 0E 00 0A 00 00 00 1E 00 1B 00
                16 00 12 00 00 00 6B 00 6C 00 73 00 74 00 00 00
                73 00 75 00 7C 00 7E 00 00 00 0B 00 0C 00 13 00
                14 00 00 00 13 00 15 00 1C 00 1E 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00 13 14 14 14 14 13 14 13 14 00 00 00
                2C 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                00 00 00 00

Handle 0x0035, DMI type 127, 4 bytes
End Of Table


Regards
Mark
