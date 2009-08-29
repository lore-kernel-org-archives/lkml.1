Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZH2VFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZH2VFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 17:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZH2VFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 17:05:47 -0400
Received: from smtp1m5.poczta.onet.pl ([213.180.138.32]:42542 "EHLO
	smtp1m5.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZH2VFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 17:05:46 -0400
From: Mario <rety@poczta.onet.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Is acpi_ec_ecdt_probe() broken? (was: Re: ACPI locks hardware devices when it doesn't detect vista)
Date: Sat, 29 Aug 2009 23:05:54 +0200
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1250945310.14167.150.camel@maxim-laptop> <200908292140.06935.rjw@sisk.pl> <1251575484.10321.11.camel@maxim-laptop>
In-Reply-To: <1251575484.10321.11.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zgZmK4C3FkD+Kob"
Message-Id: <200908292305.55050.rety@poczta.onet.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zgZmK4C3FkD+Kob
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Exact model is Compal JFL92.
I've attached a dmidecode output.
Regards
Mario

Saturday 29 of August 2009 21:51:24 Maxim Levitsky wrote:
> dmidecode

>No, Mairo's system is a compal laptop, and I know that it does't have a
>ECDT (as well as mine btw, today hardware is quite similar)

>On top of that, I have asked Mairo to put acpi_ec_ecdt_probe(); just
>below the acpi_initialize_objects, but he said his system didn't boot
>after this change.

>_SB._INI does some black SMI magic that might need a EC after all.

>For reference, I attach acpidump of his system, and dmesg with some acpi
>debugging enabled.

>Mairo, could you post output of dmidecode, so I know exactly the laptop
>model.


>Best regards,
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Maxim Levitsky

--Boundary-00=_zgZmK4C3FkD+Kob
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmidecode_output"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmidecode_output"

# dmidecode 2.9
SMBIOS 2.4 present.
24 structures occupying 1067 bytes.
Table at 0x000DC010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: COMPAL          
	Version: 1.16
	Release Date: 12/31/2007
	Address: 0xE6010
	Runtime Size: 106480 bytes
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
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
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 49.49
	Firmware Revision: 49.49

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: -
	Product Name: N/A                                            
	Version: N/A                             
	Serial Number: N/A                                                             
	UUID: 9CCC7D2C-134E-11DD-9C8D-001EEC42BF70
	Wake-up Type: Power Switch
	SKU Number: Compal
	Family: Compal

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: -
	Product Name: JFL92         
	Version: IFT00
	Serial Number: N/A                                                                       

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: No Enclosure
	Type: Notebook
	Lock: Not Present
	Version: N/A
	Serial Number: None
	Asset Tag: -
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00001234

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel
	ID: 76 06 01 00 FF FB EB BF
	Version: CPU Version
	Voltage: 3.3 V
	External Clock: Unknown
	Max Speed: 4096 MHz
	Current Speed: 2500 MHz
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
	Location: Internal
	Installed Size: 6144 KB
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
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: Circular DIN-8 male
	Port Type: Keyboard Port

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS/2 Mouse
	External Connector Type: Circular DIN-8 male
	Port Type: Mouse Port

Handle 0x0009, DMI type 9, 13 bytes
System Slot Information
	Designation: PEG Slot J6C1
	Type: 32-bit PCI Express
	Current Usage: In Use
	Length: Long
	ID: 6
	Characteristics:
		5.0 V is provided
		3.3 V is provided

Handle 0x000A, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Disabled
	Description: HD-Audio

Handle 0x000B, DMI type 11, 5 bytes
OEM Strings
	String 1: -

Handle 0x000C, DMI type 12, 5 bytes
System Configuration Options
	Option 1: None

Handle 0x000D, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1000 MB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x000E, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000D
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: 1
	Locator: M1
	Bank Locator: Bank 0
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Mfg 0
	Serial Number: 1234-B0
	Asset Tag: Not Specified
	Part Number: SODIMM000

Handle 0x000F, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000D
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: 1
	Locator: M2
	Bank Locator: Bank 1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: Mfg 1
	Serial Number: 1234-B1
	Asset Tag: Not Specified
	Part Number: SODIMM001

Handle 0x0010, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x000D
	Partition Width: 0

Handle 0x0011, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x000E
	Memory Array Mapped Address Handle: 0x0010
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: 2

Handle 0x0012, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x000F
	Memory Array Mapped Address Handle: 0x0010
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: 2

Handle 0x0013, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x0014, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 14 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x0015, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 15 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x0016, DMI type 135, 10 bytes
OEM-specific Type
	Header and Data:
		87 0A 16 00 50 54 07 03 01 00

Handle 0x0017, DMI type 127, 4 bytes
End Of Table


--Boundary-00=_zgZmK4C3FkD+Kob--
