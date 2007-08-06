Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXHFToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXHFToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXHFToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:44:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:53338 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761046AbXHFToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mC1v3Uuh1sT2wJTNBvZpwLIzTjQ4DOOwndCn4NTQKZj+iFQVTQqqXg0elQHr1HMnSUWcfelglscSp8hOL4yeZv+ELs4FPzDuSgkv1cK4JSoYcxAmC1Mr6wWjRN/drkqUicrDx/MHOqhNtIdceSR9zKIiAXmz4/tPQUixclrZIAI=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <46B76BBC.9010107@gmail.com>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>
	 <1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Aug 2007 21:43:56 +0200
Message-Id: <1186429436.6936.4.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 07-08-2007, Wt o godzinie 03:43 +0900, Tejun Heo napisał(a):
> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> it spins down the disk correctly.  Does emergency unload count increase
> after each power down?  Also, please post the result of 'dmidecode'.
> 
> Thanks.
> 
I do not know how to check this emergency unload count, so please
explain what do I need to do.

dmidecode:
dmidecode 2.9
SMBIOS 2.4 present.
23 structures occupying 1029 bytes.
Table at 0x000F38EB.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Hewlett-Packard
        Version: 68YDU Ver. F.0D
        Release Date: 04/17/2007
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 1024 kB
        Characteristics:
                PCI is supported
                PC Card (PCMCIA) is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                Boot from CD is supported
                Selectable boot is supported
                EDD is supported
                3.5"/720 KB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                ACPI is supported
                USB legacy is supported
                LS-120 boot is supported
                Smart battery is supported
                BIOS boot specification is supported
                Function key-initiated network boot is supported
                Targeted content distribution is supported
        BIOS Revision: 15.13
        Firmware Revision: 88.18

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: Hewlett-Packard
        Product Name:                                 
        Version: F.0D
        Serial Number:                                 
        UUID: Not Settable
        Wake-up Type: Power Switch
        SKU Number:                 
        Family: 103C_5336AN

Handle 0x0040, DMI type 126, 4 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
        Manufacturer: Hewlett-Packard
        Product Name: 30AA
        Version: KBC Version 58.12
        Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
        Manufacturer: Hewlett-Packard
        Type: Notebook
        Lock: Not Present
        Version: Not Specified
        Serial Number:                                 
        Asset Tag: CNU63515Y3
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Safe
        Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 10 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
        Socket Designation: U10
        Type: Central Processor
        Family: Pentium M
        Manufacturer: Intel(R)
        ID: E8 06 00 00 FF FB E9 BF
        Signature: Type 0, Family 6, Model 14, Stepping 8
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
        Version: Genuine Intel(R) CPU           T2050  @ 1.60GHz
        Voltage: 1.1 V
        External Clock: 133 MHz
        Max Speed: 1600 MHz
        Current Speed: 1600 MHz
        Status: Populated, Enabled
        Upgrade: None
        L1 Cache Handle: 0x0005
        L2 Cache Handle: 0x0006
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
        Socket Designation: Internal L1 Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 64 KB
        Maximum Size: 64 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unified
        Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
        Socket Designation: Internal L2 Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Back
        Location: External
        Installed Size: 2048 KB
        Maximum Size: 2048 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: None
        System Type: Unified
        Associativity: 4-way Set-associative

Handle 0x0007, DMI type 9, 13 bytes
System Slot Information
        Designation: PC CARD-Slot 0
        Type: 32-bit PC Card (PCMCIA)
        Current Usage: Available
        Length: Short
        ID: Adapter 0, Socket 0
        Characteristics:
                5.0 V is provided
                3.3 V is provided
                PC Card-16 is supported
                Cardbus is supported
                PME signal is supported

Handle 0x0008, DMI type 10, 6 bytes
On Board Device Information
        Type: Video
        Status: Enabled
        Description: 8

Handle 0x0009, DMI type 11, 5 bytes
OEM Strings
        String 1: www.hp.com
        String 2: ABS 70/71 79 7A 7B 7C

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 4 GB
        Error Information Handle: No Error
        Number Of Devices: 2

Handle 0x000B, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x000A
        Error Information Handle: No Error
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 512 MB
        Form Factor: SODIMM
        Set: None
        Locator: DIMM #1
        Bank Locator: Not Specified
        Type: DDR2
        Type Detail: Synchronous
        Speed: 667 MHz (1.5 ns)
        Manufacturer: 7F7F7F7F7F510000
        Serial Number: 03016A14
        Asset Tag: Not Specified
        Part Number: 64T64020HDL3SB    

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x000A
        Error Information Handle: No Error
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: SODIMM
        Set: None
        Locator: DIMM #2
        Bank Locator: Not Specified
        Type: DDR2
        Type Detail: Synchronous
        Speed: 667 MHz (1.5 ns)
        Manufacturer: 7F7F7F2500000000
        Serial Number: 00000000
        Asset Tag: Not Specified
        Part Number: KSCD48F-A8KB5     

Handle 0x000D, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0005FFFFFFF
        Range Size: 1536 MB
        Physical Array Handle: 0x000A
        Partition Width: 0

Handle 0x000E, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0001FFFFFFF
        Range Size: 512 MB
        Physical Device Handle: 0x000B
        Memory Array Mapped Address Handle: 0x000D
        Partition Row Position: 1

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00020000000
        Ending Address: 0x0005FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x000C
        Memory Array Mapped Address Handle: 0x000D
        Partition Row Position: 2

Handle 0x0010, DMI type 32, 11 bytes
System Boot Information
        Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
        Header and Data:
                85 22 85 00 01 A0 0F 2B 0F 56 0E 05 00 25 00 1D
                00 71 30 00 00 30 2A 02 E0 40 00 00 22 10 25 10
                2B 10
        Strings:
                11952 08/03/2006
                HP                

Handle 0x0086, DMI type 126, 34 bytes
Inactive

Handle 0x0011, DMI type 144, 26 bytes
OEM-specific Type
        Header and Data:
                90 1A 11 00 5B 00 65 00 DE 00 5D 00 0C 00 13 00
                00 00 0C 00 19 00 43 01 00 00

Handle 0x0012, DMI type 127, 4 bytes
End Of Table




