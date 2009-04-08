Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZDHQCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZDHQCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZDHQBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:01:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZDHQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:01:51 -0400
Date: Wed, 8 Apr 2009 18:04:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christian Weidle <slateroni@gmail.com>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>
Subject: Re: lis3lv02d axis info HP6930p
Message-ID: <20090408160446.GA30078@elf.ucw.cz>
References: <49DCC33A.2010305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCC33A.2010305@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
>
> I realize that the axis orientations of the accelerometer in my HP6930p  
> are misconfigured so I'd like to submit information as requested in the  
> documentation. As far as I could figure out from googling, there is  
> still axis info missing for that model? (I'm not at all into kernel  
> programming myself, so I consider it safer to pass this on to you).
>
> I currently run Ubuntu Jaunty  2.6.28-11-generic.

Well, whitelist has very simple format, can you try simply add that
one entry?

It is in linux/drivers/hwmon/hp_accel.c ...

								Pavel

> dmidecode output is appended.
>
> dmesg gives me this:
> $ dmesg | grep lis3lv
> [    8.590435] lis3lv02d: laptop model unknown, using default axes  
> configuration
> [    8.604650] input: ST LIS3LV02DL Accelerometer as  
> /devices/platform/lis3lv02d/input/input6
> [    8.608916] lis3lv02d driver loaded.
>
> position output in the four requested cases:
> horizontal position:
> $ cat /sys/devices/platform/lis3lv02d/position
> (768,-768,13568)
> $ cat /sys/devices/platform/lis3lv02d/position
> (512,-768,13312)
> $ cat /sys/devices/platform/lis3lv02d/position
> (512,-1024,13568)
>
> elevated left:
> $ cat /sys/devices/platform/lis3lv02d/position
> (768,2048,13056)
> $ cat /sys/devices/platform/lis3lv02d/position
> (768,2304,12800)
> $ cat /sys/devices/platform/lis3lv02d/position
> (512,2048,13056)
>
> elevated front:
> $ cat /sys/devices/platform/lis3lv02d/position
> (-3584,-768,12544)
> $ cat /sys/devices/platform/lis3lv02d/position
> (-3584,-768,12800)
> $ cat /sys/devices/platform/lis3lv02d/position
> (-3584,-768,12800)
>
> upside down (keyboard horizontal):
> $ cat /sys/devices/platform/lis3lv02d/position
> (-256,-1536,-14848)
> $ cat /sys/devices/platform/lis3lv02d/position
> (256,-1536,-15104)
> $ cat /sys/devices/platform/lis3lv02d/position
> (-256,-1536,-14848)
>
> Thanks anyway for the great work on this module so far. Looking forward  
> to an updated version that let's me actually _play_ neverball ;)


> # dmidecode 2.9
> SMBIOS 2.4 present.
> 22 structures occupying 1030 bytes.
> Table at 0xBBBC4000.
> 
> Handle 0x000A, DMI type 0, 24 bytes
> BIOS Information
> 	Vendor: Hewlett-Packard
> 	Version: 68PCU Ver. F.0C
> 	Release Date: 10/17/2008
> 	Address: 0xF0000
> 	Runtime Size: 64 kB
> 	ROM Size: 1536 kB
> 	Characteristics:
> 		PCI is supported
> 		PC Card (PCMCIA) is supported
> 		BIOS is upgradeable
> 		BIOS shadowing is allowed
> 		Boot from CD is supported
> 		Selectable boot is supported
> 		EDD is supported
> 		Print screen service is supported (int 5h)
> 		8042 keyboard services are supported (int 9h)
> 		Serial services are supported (int 14h)
> 		Printer services are supported (int 17h)
> 		ACPI is supported
> 		USB legacy is supported
> 		Smart battery is supported
> 		BIOS boot specification is supported
> 		Function key-initiated network boot is supported
> 		Targeted content distribution is supported
> 	BIOS Revision: 15.12
> 	Firmware Revision: 87.22
> 
> Handle 0x000B, DMI type 1, 27 bytes
> System Information
> 	Manufacturer: Hewlett-Packard
> 	Product Name: HP EliteBook 6930p
> 	Version: F.0C
> 	Serial Number: CZC8483BCS
> 	UUID: 35AC2787-44C1-DD11-9C77-909047038091
> 	Wake-up Type: Power Switch
> 	SKU Number: J1059077
> 	Family: 103C_5336AN
> 
> Handle 0x000C, DMI type 2, 16 bytes
> Base Board Information
> 	Manufacturer: Hewlett-Packard
> 	Product Name: 30DB
> 	Version: KBC Version 87.22
> 	Serial Number: Not Specified
> 	Asset Tag: Not Specified
> 	Features:
> 		Board is a hosting board
> 		Board is replaceable
> 	Location In Chassis:  
> 	Chassis Handle: 0x000D
> 	Type: Unknown
> 	Contained Object Handles: 0
> 
> Handle 0x000D, DMI type 3, 17 bytes
> Chassis Information
> 	Manufacturer: Hewlett-Packard
> 	Type: Notebook
> 	Lock: Not Present
> 	Version: Not Specified
> 	Serial Number: CZC8483BCS
> 	Asset Tag: CZC8483BCS
> 	Boot-up State: Safe
> 	Power Supply State: Safe
> 	Thermal State: Other
> 	Security Status: Other
> 	OEM Information: 0x00000000
> 
> Handle 0x0000, DMI type 4, 35 bytes
> Processor Information
> 	Socket Designation: Intel(R) Genuine processor
> 	Type: Central Processor
> 	Family: Other
> 	Manufacturer: Intel(R) Corporation
> 	ID: 76 06 01 00 FF FB EB BF
> 	Version: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
> 	Voltage: 1.6 V
> 	External Clock: 266 MHz
> 	Max Speed: 2400 MHz
> 	Current Speed: 1600 MHz
> 	Status: Populated, Enabled
> 	Upgrade: ZIF Socket
> 	L1 Cache Handle: 0x0003
> 	L2 Cache Handle: 0x0001
> 	L3 Cache Handle: Not Provided
> 	Serial Number: Not Specified
> 	Asset Tag: Intel(R) Genuine processor
> 	Part Number: Not Specified
> 
> Handle 0x0001, DMI type 7, 19 bytes
> Cache Information
> 	Socket Designation: Internal Cache
> 	Configuration: Enabled, Not Socketed, Level 2
> 	Operational Mode: Write Back
> 	Location: Internal
> 	Installed Size: 3072 KB
> 	Maximum Size: 3072 KB
> 	Supported SRAM Types:
> 		Asynchronous
> 	Installed SRAM Type: Asynchronous
> 	Speed: Unknown
> 	Error Correction Type: Single-bit ECC
> 	System Type: Unified
> 	Associativity: <OUT OF SPEC>
> 
> Handle 0x0003, DMI type 7, 19 bytes
> Cache Information
> 	Socket Designation: Internal Cache
> 	Configuration: Enabled, Not Socketed, Level 1
> 	Operational Mode: Write Back
> 	Location: Internal
> 	Installed Size: 32 KB
> 	Maximum Size: 32 KB
> 	Supported SRAM Types:
> 		Asynchronous
> 	Installed SRAM Type: Asynchronous
> 	Speed: Unknown
> 	Error Correction Type: Single-bit ECC
> 	System Type: Data
> 	Associativity: 8-way Set-associative
> 
> Handle 0x0002, DMI type 7, 19 bytes
> Cache Information
> 	Socket Designation: Internal Cache
> 	Configuration: Enabled, Not Socketed, Level 1
> 	Operational Mode: Write Back
> 	Location: Internal
> 	Installed Size: 32 KB
> 	Maximum Size: 32 KB
> 	Supported SRAM Types:
> 		Asynchronous
> 	Installed SRAM Type: Asynchronous
> 	Speed: Unknown
> 	Error Correction Type: Single-bit ECC
> 	System Type: Instruction
> 	Associativity: 8-way Set-associative
> 
> Handle 0x0011, DMI type 9, 13 bytes
> System Slot Information
> 	Designation: PCI SLOT1
> 	Type: 32-bit PCI
> 	Current Usage: Available
> 	Length: Long
> 	ID: 1
> 	Characteristics:
> 		3.3 V is provided
> 		PME signal is supported
> 		SMBus signal is supported
> 
> Handle 0x000F, DMI type 10, 6 bytes
> On Board Device Information
> 	Type: Video
> 	Status: Enabled
> 	Description: 64
> 
> Handle 0x0010, DMI type 11, 5 bytes
> OEM Strings
> 	String 1: ABS 70/71 79 7A 7B 7C
> 	String 2: CSM v01.24
> 	String 3: www.hp.com
> 
> Handle 0x0004, DMI type 16, 15 bytes
> Physical Memory Array
> 	Location: System Board Or Motherboard
> 	Use: System Memory
> 	Error Correction Type: None
> 	Maximum Capacity: 8 GB
> 	Error Information Handle: Not Provided
> 	Number Of Devices: 2
> 
> Handle 0x0005, DMI type 17, 27 bytes
> Memory Device
> 	Array Handle: 0x0004
> 	Error Information Handle: Not Provided
> 	Total Width: 64 bits
> 	Data Width: 64 bits
> 	Size: 2048 MB
> 	Form Factor: SODIMM
> 	Set: None
> 	Locator: Top
> 	Bank Locator: BANK 0
> 	Type: DDR2
> 	Type Detail: Synchronous
> 	Speed: 800 MHz (1.2 ns)
> 	Manufacturer: Samsung
> 	Serial Number: 620FED9C
> 	Asset Tag: Unknown
> 	Part Number: M4 70T5663QZ3-CF7 
> 
> Handle 0x0007, DMI type 17, 27 bytes
> Memory Device
> 	Array Handle: 0x0004
> 	Error Information Handle: Not Provided
> 	Total Width: 64 bits
> 	Data Width: 64 bits
> 	Size: 2048 MB
> 	Form Factor: SODIMM
> 	Set: None
> 	Locator: Bottom
> 	Bank Locator: BANK 2
> 	Type: DDR2
> 	Type Detail: Synchronous
> 	Speed: 800 MHz (1.2 ns)
> 	Manufacturer: Samsung
> 	Serial Number: 620FED80
> 	Asset Tag: Unknown
> 	Part Number: M4 70T5663QZ3-CF7 
> 
> Handle 0x0009, DMI type 19, 15 bytes
> Memory Array Mapped Address
> 	Starting Address: 0x00000000000
> 	Ending Address: 0x000FFFFFFFF
> 	Range Size: 4 GB
> 	Physical Array Handle: 0x0004
> 	Partition Width: 0
> 
> Handle 0x0006, DMI type 20, 19 bytes
> Memory Device Mapped Address
> 	Starting Address: 0x00000000000
> 	Ending Address: 0x0007FFFFFFF
> 	Range Size: 2 GB
> 	Physical Device Handle: 0x0005
> 	Memory Array Mapped Address Handle: 0x0009
> 	Partition Row Position: 1
> 	Interleave Position: 1
> 	Interleaved Data Depth: 1
> 
> Handle 0x0008, DMI type 20, 19 bytes
> Memory Device Mapped Address
> 	Starting Address: 0x00000000000
> 	Ending Address: 0x0007FFFFFFF
> 	Range Size: 2 GB
> 	Physical Device Handle: 0x0007
> 	Memory Array Mapped Address Handle: 0x0009
> 	Partition Row Position: 1
> 	Interleave Position: 2
> 	Interleaved Data Depth: 1
> 
> Handle 0x0012, DMI type 22, 26 bytes
> Portable Battery
> 	Location: Primary
> 	Manufacturer: SDI - SDI
> 	Manufacture Date: 3939
> 	Serial Number: 007B
> 	Name: TD06055
> 	Design Capacity: 5100 mWh
> 	Design Voltage: 10800 mV
> 	SBDS Version: 1.1
> 	Maximum Error: Unknown
> 	SBDS Chemistry: LION
> 	OEM-specific Information: 0x00000000
> 
> Handle 0x000E, DMI type 32, 20 bytes
> System Boot Information
> 	Status: No errors detected
> 
> Handle 0x0013, DMI type 129, 8 bytes
> OEM-specific Type
> 	Header and Data:
> 		81 08 13 00 01 01 02 00
> 	Strings:
> 		Intel_ASF
> 		Intel_ASF_001
> 
> Handle 0x0014, DMI type 130, 20 bytes
> OEM-specific Type
> 	Header and Data:
> 		82 14 14 00 24 41 4D 54 01 00 00 00 00 A5 0B 02
> 		00 00 00 00
> 
> Handle 0xFFFD, DMI type 127, 4 bytes
> End Of Table
> 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
