Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYEHHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYEHHAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYEHHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:00:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:34310 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbYEHHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iYpvAB1XAh+3d9EYCBhHnkCuXRGHyY1+inPHFS7hBMtq2KFcaN0kY9Q29w25Cuy7OUDhfSLF7KpzozCCrBuJSUTWVpAsumaC8DrWTJU0ZnSUAY2NQyQ/7HY2t++rOBd1YmRYvPbRGmGxV9spIsKNLO5uoRczbbtvVl12Pf3nHGw=
Message-ID: <4822A4EB.3010901@gmail.com>
Date: Thu, 08 May 2008 07:59:55 +0100
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25 pci=noacpi
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com> <4813B5AB.4060308@keyaccess.nl> <200804281507.38309.bjorn.helgaas@hp.com> <4816C605.4000601@gmail.com> <481E0D2D.1030608@keyaccess.nl>
In-Reply-To: <481E0D2D.1030608@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 29-04-08 08:53, Richard wrote:
>
>> Using an AMD Sempron notebook (HP Compaq 6715b) single processor 
>> machine,  It shuts down during bootup when ACPI is fully enabled.  I 
>> added pci=noacpi to the cmdline and it finally boots, but its 
>> extremely slow...  (kdm times out with error saying it took too long 
>> to load and disables graphical)
>
> Does booting with io_delay=0xed on the kernel command line fix it? If 
> so, we need the output of
>
> # dmidecode -s baseboard-manufacturer
>
> and
>
> # dmidecode -s baseboard-product-name
>
> Rene.
>
dmidecode -s baseboard-manufacturer
Hewlett-Packard

dmidecode -s baseboard-product-name
30C2


...................
dmidecode
# dmidecode 2.9
SMBIOS 2.4 present.
23 structures occupying 1029 bytes.
Table at 0x000FBBE6.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Hewlett-Packard
        Version: 68YTT Ver. F.07
        Release Date: 07/16/2007
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
        BIOS Revision: 15.7
        Firmware Revision: 113.40

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: Hewlett-Packard
        Product Name: HP Compaq 6715b (GR616ES#ABN)
        Version: F.07
        Serial Number: CNU1234RYP
        UUID: 3B9F2FDD-B215-EE11-3898-6D99022F5D29
        Wake-up Type: Power Switch
        SKU Number: GR616ES#ABN
        Family: 103C_5336AN

Handle 0x0040, DMI type 126, 34 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
        Manufacturer: Hewlett-Packard
        Product Name: 30C2
        Version: KBC Version 71.28
        Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
        Manufacturer: Hewlett-Packard
        Type: Notebook
        Lock: Not Present
        Version: Not Specified
        Serial Number: CNU1234RYP
        Asset Tag: CNU1234RYP
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Safe
        Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 32 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
        Socket Designation: U10
        Type: Central Processor
        Family: Pentium M
        Manufacturer: AMD(R)
        ID: C2 0F 04 00 FF FB 8B 07
        Signature: Type 0, Family 15, Model 76, Stepping 2
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
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
                SSE2 (Streaming SIMD extensions 2)
        Version: Mobile AMD Sempron(tm) 3600+
        Voltage: 1.1 V
        External Clock: 200 MHz
        Max Speed: 2000 MHz
        Current Speed: 2000 MHz
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
        Installed Size: 256 KB
        Maximum Size: 256 KB
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
        Description: 00

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
        Size: 1024 MB
        Form Factor: SODIMM
        Set: None
        Locator: DIMM #1
        Bank Locator: Not Specified
        Type: DDR2
        Type Detail: Synchronous
        Speed: 667 MHz (1.5 ns)
        Manufacturer: 7F7F7F0B00000000
        Serial Number: E6892811
        Asset Tag: Not Specified
        Part Number: NT1GT64U8HB0BN-3C

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x000A
        Error Information Handle: No Error
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: SODIMM
        Set: None
        Locator: DIMM #2
        Bank Locator: Not Specified
        Type: DDR2
        Type Detail: Synchronous
        Speed: Unknown
        Manufacturer:
        Serial Number:
        Asset Tag: Not Specified
        Part Number:

Handle 0x000D, DMI type 19, 15 bytes
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Array Handle: 0x000A
        Partition Width: 0

Handle 0x000E, DMI type 20, 19 bytes
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x000B
        Memory Array Mapped Address Handle: 0x000D
        Partition Row Position: 1

Handle 0x000F, DMI type 126, 19 bytes
Inactive

Handle 0x0010, DMI type 32, 11 bytes
System Boot Information
        Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
        Header and Data:
                85 22 85 00 01 EC 13 A7 11 52 11 02 00 5E 00 1D
                00 C5 2D 47 F5 30 2A 02 E0 40 00 00 55 0F 70 0F
                00 0F
        Strings:
                01358 06/17/2007
                HP

Handle 0x0086, DMI type 126, 34 bytes
Inactive

Handle 0x0011, DMI type 144, 26 bytes
OEM-specific Type
        Header and Data:
                90 1A 11 00 FF FF FF FF FF FF FF FF FF FF FF FF
                FF FF FF FF FF FF FF FF 00 00

Handle 0x0012, DMI type 127, 4 bytes
End Of Table



