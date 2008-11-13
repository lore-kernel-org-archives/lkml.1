Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYKMT1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYKMT1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKMT0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:26:55 -0500
Received: from eazy.amigager.de ([213.239.192.238]:56491 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYKMT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:26:53 -0500
Date: Thu, 13 Nov 2008 20:26:56 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081113192656.GA5735@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Greg KH <greg@kroah.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <200811120103.55253.rjw@sisk.pl> <20081112073617.GA4996@dose.home.local> <200811122241.09943.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <200811122241.09943.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2008 at 22:41:08 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 12 of November 2008, Tino Keitel wrote:
> > On Wed, Nov 12, 2008 at 01:03:54 +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > Also, can you check this patch on top of 2.6.27.4 and see what happens?
> > 
> > With that patch, resume works (although I used 2.6.27.5 and not
> > 2.6.27.5, if that matters).
> 
> It shouldn't really matter.
> 
> Thanks for testing and please send me the output of dmidecode.
> It seems that blacklisting may be the only way to handle your box. :-(

Attached.

Regards,
Tino

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.9
SMBIOS 2.4 present.
39 structures occupying 1542 bytes.
Table at 0x000E73F0.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Apple Computer, Inc.
	Version:     MM11.88Z.0055.B08.0610121326
	Release Date: 10/12/06
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		ACPI is supported
		IEEE 1394 boot is supported
		Smart battery is supported
		Function key-initiated network boot is supported
	BIOS Revision: 0.1

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Apple Computer, Inc.
	Product Name: Macmini1,1
	Version: 1.0
	Serial Number: XXX
	UUID: XXX
	Wake-up Type: Power Switch
	SKU Number: System SKUNumber
	Family: Napa Mac

Handle 0x0002, DMI type 2, 16 bytes
Base Board Information
	Manufacturer: Apple Computer, Inc.
	Product Name: Mac-F4208EC8
	Version: PVT
	Serial Number: 1
	Asset Tag: Base Board Asset Tag
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Part Component
	Chassis Handle: 0x0003
	Type: Unknown
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Apple Computer, Inc.
	Type: Low Profile Desktop
	Lock: Not Present
	Version: Mac-F4208EC8
	Serial Number: XXX
	Asset Tag: Asset Tag
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Other
	Security Status: Other
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0004, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0005, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		<BAD INDEX>
	Currently Installed Language: Not Specified

Handle 0x0106, DMI type 12, 5 bytes
System Configuration Options

Handle 0x0107, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0108, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: DVI
	External Connector Type: Other
	Port Type: Video Port

Handle 0x0109, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB0
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x010A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x010B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x010C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x010D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: FireWire0
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x010E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: iPod Dock
	External Connector Type: Other
	Port Type: Other

Handle 0x010F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Audio Line In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0110, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Audio Line Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0111, DMI type 9, 13 bytes
System Slot Information
	Designation: AirPort
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0112, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: Integrated Graphics Controller 

Handle 0x0113, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: Yukon Ethernet Controller

Handle 0x0114, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: Azalia Audio Codec

Handle 0x0115, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: SATA

Handle 0x0116, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: PATA

Handle 0x0117, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 17 01 00 00

Handle 0x0118, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Unknown
	Manufacturer: Intel(R) Corporation
	ID: E8 06 00 00 FF FB E9 BF
	Version: Genuine Intel(R) CPU           T
	Voltage: 1.6 V
	External Clock: 166 MHz
	Max Speed: 1660 MHz
	Current Speed: 1660 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x011B
	L2 Cache Handle: 0x0119
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Unknown
	Part Number: Not Specified

Handle 0x0119, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x011A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x011B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x011C, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Unknown
	Manufacturer: Intel(R) Corporation
	ID: E8 06 00 00 FF FB E9 BF
	Version: Genuine Intel(R) CPU           T
	Voltage: 1.6 V
	External Clock: 166 MHz
	Max Speed: 1660 MHz
	Current Speed: 1660 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x011F
	L2 Cache Handle: 0x011D
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Unknown
	Part Number: Not Specified

Handle 0x011D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x011E, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x011F, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0120, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0121, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0120
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK 0
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 0xAD00000000000000
	Serial Number: 0x00006201
	Asset Tag: Unknown
	Part Number: 0x48594D503536345336344350362D59352020

Handle 0x0122, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x0121
	Memory Array Mapped Address Handle: 0x0125
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: 1

Handle 0x0123, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0120
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK 1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 0x2CFFFFFFFFFFFFFF
	Serial Number: 0x49191A8B
	Asset Tag: Unknown
	Part Number: 0x38485446363436344844592D363637423320

Handle 0x0124, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x0123
	Memory Array Mapped Address Handle: 0x0125
	Partition Row Position: 2
	Interleave Position: 2
	Interleaved Data Depth: 1

Handle 0x0125, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Array Handle: 0x0120
	Partition Width: 0

Handle 0xFFFD, DMI type 127, 4 bytes
End Of Table


--qDbXVdCdHGoSgWSk--
