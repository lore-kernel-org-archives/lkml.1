Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYIIDfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYIIDfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYIIDfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:35:14 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:48767 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYIIDfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:35:12 -0400
Message-ID: <48C5EEE4.6090209@diamondcut.com.br>
Date: Tue, 09 Sep 2008 00:35:00 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net> <48C57FDE.2010306@diamondcut.com.br> <alpine.LNX.1.00.0809081544410.19665@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0809081544410.19665@iabervon.org>
Content-Type: multipart/mixed;
 boundary="------------060202030202000607030501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060202030202000607030501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Daniel Barkalow wrote:
> Renato S. Yamane wrote:
>> Henrique de Moraes Holschuh wrote:
>>> I fell I need to warn you guys that you are likely breaking machines that
>>> match that DMI info but have a newer BIOS, unless they use different BIOSes
>>> (not enough data without a full dmidecode output from the other machine).
>>
>> dmidecode just from 3000-N100?
>> Attached a dmidecode from a Lenovo Thinkpad T61.
>> I have a Lenovo 3000-V200 too. You want a dmidecode from it?
> 
> It's almost certainly only 3000 series that's interesting; I think they 
> test the Thinkpads with Linux and wouldn't ship with a quirky BIOS there.

Here is the dmidecode from a Lenovo 3000-V200.
I hope this help something.
Let me know if you need more info.

Best regards,
Renato S. Yamane

--------------060202030202000607030501
Content-Type: text/plain;
 name="dmidecode_lenovo_3000-v200.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmidecode_lenovo_3000-v200.txt"

# dmidecode 2.9
SMBIOS 2.4 present.
45 structures occupying 1366 bytes.
Table at 0x000DC010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: LENOVO
	Version: 65ET59WW (0.10 )
	Release Date: 03/28/2008
	Address: 0xE6B90
	Runtime Size: 103536 bytes
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 0.10

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: LENOVO
	Product Name: 076426P
	Version: LENOVO3000 V200
	Serial Number: LVB14P5
	UUID: 511F85E0-BFB8-11DC-8862-F2CB945B3A80
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: LENOVO
	Product Name: INVALID
	Version: Not Applicable
	Serial Number: 47AZ12Z

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: LENOVO
	Type: Notebook
	Lock: Not Present
	Version: N/A
	Serial Number: INVALID
	Asset Tag: No Asset Tag
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00001234

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: Intel
	ID: FD 06 00 00 FF FB EB BF
	Version: A0
	Voltage: 3.3 V
	External Clock: Unknown
	Max Speed: 2048 MHz
	Current Speed: 1800 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 KB
	Maximum Size: 64 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: External
	Installed Size: 2048 KB
	Maximum Size: 4096 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0007, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J19
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: COM 1
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: Circular DIN-8 male
	Port Type: Keyboard Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS/2 Mouse
	External Connector Type: Circular DIN-8 male
	Port Type: Mouse Port

Handle 0x000A, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot J8B3
	Type: 32-bit PCI
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000B, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Slot S9B1
	Type: 32-bit PCI
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000C, DMI type 9, 13 bytes
System Slot Information
	Designation: PEG Slot J6B2
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Long
	ID: 6
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express Slot J6B1
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Long
	ID: 7
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000E, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express Slot J6D1
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Long
	ID: 8
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000F, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express Slot J8B4
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Long
	ID: 9
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x0010, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express Slot J8D1
	Type: 32-bit PCI Express
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x0011, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI Express Slot J7B1
	Type: 32-bit PCI Express
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x0012, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Disabled
	Description: HD-Audio

Handle 0x0013, DMI type 11, 5 bytes
OEM Strings
	String 1: This is the Intel Crestline
	String 2: Chipset CRB Platform

Handle 0x0014, DMI type 12, 5 bytes
System Configuration Options
	Option 1: Jumper settings can be described here.

Handle 0x0015, DMI type 15, 29 bytes
System Event Log
	Area Length: 16 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Valid, Not Full
	Change Token: 0x00000002
	Header Format: Type 1
	Supported Log Type Descriptors: 3
	Descriptor 1: POST error
	Data Format 1: POST results bitmap
	Descriptor 2: Single-bit ECC memory error
	Data Format 2: Multiple-event
	Descriptor 3: Multi-bit ECC memory error
	Data Format 3: Multiple-event

Handle 0x0016, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0017, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0016
	Error Information Handle: No Error
	Total Width: 32 bits
	Data Width: 32 bits
	Size: 512 MB
	Form Factor: SODIMM
	Set: 1
	Locator: M1
	Bank Locator: Bank 0
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0018, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0016
	Error Information Handle: No Error
	Total Width: 32 bits
	Data Width: 32 bits
	Size: 512 MB
	Form Factor: SODIMM
	Set: 1
	Locator: M2
	Bank Locator: Bank 1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0019, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Array Handle: 0x0016
	Partition Width: 0

Handle 0x001A, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x0017
	Memory Array Mapped Address Handle: 0x0019
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x001B, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x0018
	Memory Array Mapped Address Handle: 0x0019
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x001C, DMI type 23, 13 bytes
System Reset
	Status: Enabled
	Watchdog Timer: Present
	Boot Option: Do Not Reboot
	Boot Option On Limit: Do Not Reboot
	Reset Count: Unknown
	Reset Limit: Unknown
	Timer Interval: Unknown
	Timeout: Unknown

Handle 0x001D, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Unknown
	Administrator Password Status: Enabled
	Front Panel Reset Status: Unknown

Handle 0x001E, DMI type 25, 9 bytes
	System Power Controls
	Next Scheduled Power-on: 12-31 23:59:59

Handle 0x001F, DMI type 26, 20 bytes
Voltage Probe
	Description: Voltage Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0020, DMI type 27, 12 bytes
Cooling Device
	Temperature Probe Handle: 0x0021
	Type: Fan
	Status: OK
	OEM-specific Information: 0x00000000

Handle 0x0021, DMI type 28, 20 bytes
Temperature Probe
	Description: Temperature Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0022, DMI type 29, 20 bytes
Electrical Current Probe
	Description: Electrical Current Probe
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000

Handle 0x0023, DMI type 30, 6 bytes
Out-of-band Remote Access
	Manufacturer Name: Intel
	Inbound Connection: Enabled
	Outbound Connection: Disabled

Handle 0x0024, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x0025, DMI type 129, 16 bytes
OEM-specific Type
	Header and Data:
		81 10 25 00 01 01 02 01 00 00 00 01 00 00 08 01
	Strings:
		Intel_ASF_001
		Intel_ASF_001

Handle 0x0026, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 26 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x0027, DMI type 133, 5 bytes
OEM-specific Type
	Header and Data:
		85 05 27 00 01
	Strings:
		KHOIHGIUCCHHII

Handle 0x0028, DMI type 135, 10 bytes
OEM-specific Type
	Header and Data:
		87 0A 28 00 54 50 07 03 01 07

Handle 0x0029, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 29 00 FF FF

Handle 0x002A, DMI type 150, 14 bytes
OEM-specific Type
	Header and Data:
		96 0E 2A 00 01 01 00 00 00 00 00 00 00 00
	Strings:
		ABSOLUTE(PHOENIX) CLM

Handle 0x002B, DMI type 200, 7 bytes
OEM-specific Type
	Header and Data:
		C8 07 2B 00 01 02 03
	Strings:
		17C0
		             
		0001

Handle 0x002C, DMI type 127, 4 bytes
End Of Table


--------------060202030202000607030501--
