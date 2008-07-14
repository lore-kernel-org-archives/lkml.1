Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYGNToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYGNToh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYGNTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:44:26 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:36157 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYGNToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:44:24 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 15:44:23 EDT
Date: Mon, 14 Jul 2008 21:37:55 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: BIOS-controlled FN keys works only with "acpi={off | ht}" on
 Samsung P500
Message-ID: <20080714213755.7e892550@paolo-laptop>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dbiaBns_O1K1xfJxobKbMwb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/dbiaBns_O1K1xfJxobKbMwb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

on this laptop, Samsung NP-P500Y, some function keys are
BIOS-controlled (they work before Linux boots).

As soon as Linux boots they stop working. Trying some boot options I've
found that "acpi=off" makes them work and the less drastic "acpi=ht"
works too.

I'm mostly interested in brightness adjusting... and since both
xbacklight and radeontool fail I've to use "acpi=ht".

Disabling ACPI is not a good idea on a laptop... so other boot
options/patches to try are welcomed :)


tested kernels: 2.6.22 / 2.6.24 (Ubuntu)
	2.6.18 - 2.6.26-rc9 (vanilla)


lspci:
00:00.0 Host bridge: ATI Technologies Inc Unknown device 7930
00:01.0 PCI bridge: ATI Technologies Inc Unknown device 7932
00:05.0 PCI bridge: ATI Technologies Inc Unknown device 7935
00:06.0 PCI bridge: ATI Technologies Inc Unknown device 7936
00:07.0 PCI bridge: ATI Technologies Inc Unknown device 7937
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon Xpress 1250
02:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
05:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8039 PCI-E Fast Ethernet Controller (rev 15)


dmidecode and dmesg attached
--MP_/dbiaBns_O1K1xfJxobKbMwb
Content-Type: text/plain; name=dmidecode
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.9
SMBIOS 2.4 present.
29 structures occupying 1046 bytes.
Table at 0x000DC010.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Phoenix Technologies LTD
	Version: 05YI
	Release Date: 12/28/2007
	Address: 0xE4730
	Runtime Size: 112848 bytes
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
	Product Name: R59P/R60P/R61P
	Version: 03YI
	Serial Number: AL7993BPA00063
	UUID: 40E2A836-D21D-B211-8000-C0570E4C0824
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
	Product Name: R59P/R60P/R61P
	Version:     
	Serial Number: 123490EN400015

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
	Type: Other
	Lock: Not Present
	Version: N/A
	Serial Number: None
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
	Max Speed: 4096 MHz
	Current Speed: 1660 MHz
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
	Installed Size: 2048 KB
	Maximum Size: 4096 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0007, DMI type 9, 13 bytes
System Slot Information
	Designation: Mini PCIE Card Slot   
	Type: 32-bit PCI Express
	Current Usage: Unknown
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		Hot-plug devices are supported

Handle 0x0008, DMI type 11, 5 bytes
OEM Strings
	String 1: AABBAAAAAAAA
	String 2: 20YY/MM

Handle 0x0009, DMI type 12, 5 bytes
System Configuration Options
	Option 1: Jumper settings can be described here.

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x000B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: J400
	Bank Locator: Channel A0
	Type: DRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 3
	Locator: J501
	Bank Locator: Channel B0
	Type: DRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x000D, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x000E, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x000A
	Partition Width: 0

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000B
	Memory Array Mapped Address Handle: 0x000E
	Partition Row Position: 2
	Interleave Position: 1
	Interleaved Data Depth: 6

Handle 0x0010, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Touch Pad
	Interface: PS/2
	Buttons: 4

Handle 0x0011, DMI type 22, 26 bytes
Portable Battery
	Location: Rear
	Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
	Name: SAMSUNG ELECTRONICS CO., LTD.
	Chemistry: Lithium Ion
	Design Capacity: 1000 mWh
	Design Voltage: 19 mV
	SBDS Version: BATT_1234
	Maximum Error: Unknown
	SBDS Serial Number: 0000
	SBDS Manufacture Date: 1980-00-00
	OEM-specific Information: 0x00000000

Handle 0x0012, DMI type 23, 13 bytes
System Reset
	Status: Enabled
	Watchdog Timer: Present
	Boot Option: Do Not Reboot
	Boot Option On Limit: Do Not Reboot
	Reset Count: Unknown
	Reset Limit: Unknown
	Timer Interval: Unknown
	Timeout: Unknown

Handle 0x0013, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Unknown
	Administrator Password Status: Disabled
	Front Panel Reset Status: Unknown

Handle 0x0014, DMI type 25, 9 bytes
	System Power Controls
	Next Scheduled Power-on: 12-31 23:59:59

Handle 0x0015, DMI type 26, 22 bytes
Voltage Probe
	Description: Voltage Probe 1
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: 8.192 V

Handle 0x0016, DMI type 27, 14 bytes
Cooling Device
	Temperature Probe Handle: 0x0018
	Type: Fan
	Status: OK
	Cooling Unit Group: 255
	OEM-specific Information: 0x00000000
	Nominal Speed: Unknown Or Non-rotating

Handle 0x0017, DMI type 27, 12 bytes
Cooling Device
	Temperature Probe Handle: 0x0018
	Type: Fan
	Status: OK
	Cooling Unit Group: 255
	OEM-specific Information: 0x00000000

Handle 0x0018, DMI type 28, 22 bytes
Temperature Probe
	Description: Temperature Probe 1
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0019, DMI type 29, 22 bytes
Electrical Current Probe
	Description: Electrical Current Probe 1
	Location: Processor
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x001A, DMI type 30, 6 bytes
Out-of-band Remote Access
	Manufacturer Name: Intel
	Inbound Connection: Enabled
	Outbound Connection: Disabled

Handle 0x001B, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x001C, DMI type 127, 4 bytes
End Of Table


--MP_/dbiaBns_O1K1xfJxobKbMwb
Content-Type: text/plain; name=dmesg
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.26-rc9-small (paolo@paolo-laptop) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #2 Sun Jul 13 18:18:17 CEST 2008
Command line: root=UUID=b23f672e-82eb-4ca8-95f5-4ea0387ca751 ro single
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000006fe90000 (usable)
 BIOS-e820: 000000006fe90000 - 000000006fe9b000 (ACPI data)
 BIOS-e820: 000000006fe9b000 - 000000006fe9d000 (ACPI NVS)
 BIOS-e820: 000000006fe9d000 - 0000000070000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 458384) 1 entries of 256 used
max_pfn_mapped = 1048576
init_memory_mapping
DMI present.
ACPI: RSDP 000F7310, 0024 (r2 PTLTD )
ACPI: XSDT 6FE90AA8, 0064 (r1 SECCSD LH43STAR  6040000  LTP        0)
ACPI: FACP 6FE9ACCE, 00F4 (r3 SEC    PRAHA     6040000 SEC     F4240)
ACPI: DSDT 6FE945E8, 6672 (r1    ATI    SB600  6040000 INTL 20050228)
ACPI: FACS 6FE9CFC0, 0040
ACPI: APIC 6FE9ADC2, 0054 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: MCFG 6FE9AE16, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: HPET 6FE9AE52, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: SLIC 6FE9AE8A, 0176 (r1 SECCSD LH43STAR  6040000  LTP        0)
ACPI: SSDT 6FE91FB7, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20050228)
ACPI: SSDT 6FE91F11, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20050228)
ACPI: SSDT 6FE90B0C, 1405 (r1  PmRef    CpuPm     3000 INTL 20050228)
ACPI: DMI detected: Samsung
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 458384) 1 entries of 256 used
  early res: 0 [0-fff] BIOS data page
  early res: 1 [200000-4aa413] TEXT DATA BSS
  early res: 2 [37821000-37fef003] RAMDISK
  early res: 3 [9dc00-fffff] BIOS reserved
  early res: 4 [8000-bfff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   458384
On node 0 totalpages: 458285
  DMA zone: 56 pages used for memmap
  DMA zone: 787 pages reserved
  DMA zone: 3154 pages, LIFO batch:0
  DMA32 zone: 6211 pages used for memmap
  DMA32 zone: 448077 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x43538310 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 78000000 (gap: 70000000:70000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 451231
Kernel command line: root=UUID=b23f672e-82eb-4ca8-95f5-4ea0387ca751 ro single
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 1662.507 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Memory: 1793456k/1833536k available (1580k kernel code, 39004k reserved, 653k data, 176k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3328.39 BogoMIPS (lpj=6656781)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
ACPI: Core revision 20080321
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Using local APIC timer interrupts.
APIC timer calibration result 10390666
Detected 10.390 MHz APIC timer.
net_namespace: 344 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:12.0: set SATA to AHCI mode
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 5) *0, disabled.
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
ACPI: EC: non-query interrupt received, switching to interrupt mode
pnp 00:09: mem resource (0xe0000-0xfffff) overlaps 0000:00:07.0 BAR 8 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 7 of bridge 0000:00:07.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:07.0
PCI-GART: No AMD northbridge found.
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:08: ioport range 0x1080-0x1080 has been reserved
system 00:08: ioport range 0x220-0x22f has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x530-0x537 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc50-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0xcd0-0xcd1 has been reserved
system 00:08: ioport range 0xcd2-0xcd3 has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0x8210-0x821f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x280-0x293 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xffb83020-0xffb8401f has been reserved
system 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: 0xd0000000-0xd00fffff
  PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: 0xd0100000-0xd01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: a000-afff
  MEM window: 0xd0200000-0xd02fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:14.4
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:00:07.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 7992k freed
msgmni has been set to 3519
io scheduler noop registered
io scheduler deadline registered (default)
pci 0000:01:05.0: Boot video device
Linux agpgart interface v0.103
loop: module loaded
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:12.0: version 3.0
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xd0509000 port 0xd0509100 irq 22
ata2: SATA max UDMA/133 abar m1024@0xd0509000 port 0xd0509180 irq 22
ata3: SATA max UDMA/133 abar m1024@0xd0509000 port 0xd0509200 irq 22
ata4: SATA max UDMA/133 abar m1024@0xd0509000 port 0xd0509280 irq 22
ata1: softreset failed (device not ready)
ata1: failed due to HW bug, retry pmp=0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: Hitachi HTS542516K9A300, BBCOC32P, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54251 BBCO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
Freeing unused kernel memory: 176k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Adding 995988k swap on /dev/sda7.  Priority:-1 extents:1 across:995988k
EXT3 FS on sda6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

--MP_/dbiaBns_O1K1xfJxobKbMwb--
