Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYJEVU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYJEVU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYJEVUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:20:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:56251 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYJEVUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zr6RMJpBRYtLKaDoVvzzXWFcdA3ZkSabQ0XwvHVXA7+TsCexiTuYDhPz+zlEOgeiO/
         T9E6SSdnIZ2dLEuL8jdBnLvS9ZpBQsGw+C/J81/VQxjcm01hfyohOvoxdcyzYcN/6UlY
         j85QPJnee/2ax/qa2uLwFuD9U2gFKgflW+R6s=
Date: Sun, 5 Oct 2008 17:18:02 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081005211748.GA11576@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <200810052059.49942.rjw@sisk.pl> <20081005190658.GC3263@amd.corenet.prv> <200810052119.13881.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810052119.13881.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 09:19:13PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > Hi,
> > > > 
> > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > speed, fans are constantly on, everything seems sluggish.
> > > > 
> > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > somewhere in tty_init.
> > > 
> > > Is that an HP box, by chance?
> > > 
> > 
> > Yeah, HP nx6115.
> 
> Oh well.
> 
> Please send me the output of dmidecode from it.
> 

Here you go:

# dmidecode 2.9
SMBIOS 2.3 present.
23 structures occupying 972 bytes.
Table at 0x000FC68F.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: 68DTT Ver. F.0D
	Release Date: 11/22/2005
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

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name: HP Compaq nx6115 (PZ886UA#ABA)  
	Version: F.0D
	Serial Number: CND6080M6F
	UUID: B58EC937-7FA3-DA11-15A0-66990C033D29
	Wake-up Type: Power Switch

Handle 0x0040, DMI type 126, 4 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 308E
	Version: KBC Version 45.25
	Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Notebook
	Lock: Not Present
	Version: Not Specified
	Serial Number: CND6080M6F
	Asset Tag:                      
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 4 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U10
	Type: Central Processor
	Family: Pentium M
	Manufacturer: AMD(R)
	ID: 42 0F 02 00 FF FB 8B 07
	Signature: Type 0, Family 15, Model 36, Stepping 2
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
	Version: AMD Turion(tm) 64 Mobile ML-30                 
	Voltage: 1.1 V
	External Clock: 200 MHz
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
	Installed Size: 128 KB
	Maximum Size: 128 KB
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
	Installed Size: 1024 KB
	Maximum Size: 1024 KB
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
	Description: 128

Handle 0x0009, DMI type 11, 5 bytes
OEM Strings
	String 1: www.hp.com

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 2 GB
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
	Type: DDR
	Type Detail: Synchronous
	Speed: 333 MHz (3.0 ns)
	Manufacturer: 7FA8000000000000
	Serial Number: 00000000
	Asset Tag: Not Specified
	Part Number:                   

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #2
	Bank Locator: Not Specified
	Type: DDR
	Type Detail: Synchronous
	Speed: 333 MHz (3.0 ns)
	Manufacturer: CE00000000000000
	Serial Number: 02077132
	Asset Tag: Not Specified
	Part Number: M4 70L6524CU0-CB3 

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
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x000B
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 1

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x000C
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 2

Handle 0x0010, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
	Header and Data:
		85 22 85 00 01 A0 0F D9 02 D7 02 02 00 68 00 1C
		00 7B 30 00 00 30 2A 02 E0 40 00 00 31 10 07 10
		44 10
	Strings:
		00159 12/16/2005
		HP                

Handle 0x0086, DMI type 134, 34 bytes
OEM-specific Type
	Header and Data:
		86 22 86 00 01 A0 0F D6 0B 30 0B 02 00 13 01 1C
		00 2D 3F 00 00 40 38 02 E0 40 CE 0F CF 0F CA 0F
		C6 0F
	Strings:
		46335 11/04/2005
		HP                

Handle 0x0011, DMI type 144, 26 bytes
OEM-specific Type
	Header and Data:
		90 1A 11 00 90 00 41 00 FC 00 67 00 96 00 DE 01
		00 00 00 00 01 00 CD 01 00 00

Handle 0x0012, DMI type 127, 4 bytes
End Of Table

-- 
Dmitry
