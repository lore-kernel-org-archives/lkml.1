Return-Path: <linux-kernel-owner+w=401wt.eu-S2993026AbXDRX6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993026AbXDRX6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993023AbXDRX6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:58:46 -0400
Received: from msen.com ([148.59.86.2]:58610 "EHLO shell.msen.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993020AbXDRX6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:58:43 -0400
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 19:58:42 EDT
X-Sent-To: linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2007 19:30:27 -0400 (EDT)
From: Lou Poppler <lwp@mail.msen.com>
X-X-Sender: lwp@shell.msen.com
To: linux-kernel@vger.kernel.org, submit@bugs.debian.org
Subject: NETDEV WATCHDOG, tulip, 2.6.18
Message-ID: <20070418192352.Q96860@shell.msen.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Milter: Spamilter (Reciever: shell.msen.com; Sender-ip: 148.59.86.2; Sender-helo: shell.msen.com;)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Package: linux-kernel
Version: 2.6.18-4-686 (Debian 2.6.18.dfsg.1-12)

(Submitted to linux-kernel@vger.kernel.org && submit@bugs.debian.org)

I also have recurrent problems with
NETDEV WATCHDOG: eth0: transmit timed out

I am running on a Pentium 3 with a Linksys LNE100TX V5.1
PCI ethernet card, which also identifies itself as  ADMtek Comet rev 17
for which the kernel uses the tulip driver module,
Linux Tulip driver version 1.1.13-NAPI (May 11, 2002)

This works fine after booting, and for a day or two after booting,
no problems with heavy net traffic or light traffic.
Eventually something happens to it though, and then it is not right again
until reboot.  The behavior then is an occasional freeze, where nothing
moves for 10 seconds or so, then full-speed network I/O for a few seconds,
then another freeze, etc.

I only got this machine recently.  I first installed Debian Sarge on it,
and had the same problem with Sarge's 2.6.8 kernel.  I read many messages
about the NETDEV WATCHDOG situation, and some writers suggested it might
be fixed in later kernels, so I upgraded to Etch with the 2.6.18 kernel.
For me at least, the problem is still the same.

I am holding the machine in the broken condition (rather than rebooting)
in case anyone wants me to test something else.

Here is some info to document the problem:

dmesg at boot:
Linux version 2.6.18-4-686 (Debian 2.6.18.dfsg.1-12) (waldi@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Mon Mar 26 17:17:36 UTC 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e7000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000040fd800 (usable)
  BIOS-e820: 00000000040fd800 - 00000000040ff800 (ACPI data)
  BIOS-e820: 00000000040ff800 - 00000000040ffc00 (ACPI NVS)
  BIOS-e820: 00000000040ffc00 - 0000000018000000 (usable)
  BIOS-e820: 00000000fffe7000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
384MB LOWMEM available.
On node 0 totalpages: 98304
   DMA zone: 4096 pages, LIFO batch:0
   Normal zone: 94208 pages, LIFO batch:31
DMI 2.1 present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6ac0
ACPI: RSDT (v001 PTLTD    RSDT   0x00000000 PTL  0x01000000) @ 0x040fda87
ACPI: FADT (v001 GATEWA TABOR II 0x19990928 PTL  0x000f4240) @ 0x040ff78c
ACPI: DSDT (v001 GATEWA TABOR II 0x00000000 MSFT 0x01000000) @ 0x00000000
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 20000000 (gap: 18000000:e7fe7000)
Detected 596.938 MHz processor.
Built 1 zonelists.  Total pages: 98304
Kernel command line: root=/dev/hda2 ro 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0130a000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 382128k/393216k available (1544k kernel code, 10556k reserved, 577k data, 196k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1194.90 BogoMIPS (lpj=2389801)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 1a00)
CPU0: Intel Pentium III (Katmai) stepping 03
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
migration_cost=0
checking if image is initramfs... it is
Freeing initrd memory: 4397k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd983, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
PCI quirk: region 8000-803f claimed by PIIX4 ACPI
PCI quirk: region 7000-700f claimed by PIIX4 SMB
Boot video device is 0000:00:0d.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 *12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: ioport range 0x7000-0x700f has been reserved
pnp: 00:01: ioport range 0x8000-0x803f could not be reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1176329263.932:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: Card 'OPL3-SAX Sound Board'
isapnp: 1 Plug & Play card detected total
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: Device 00:0b activated.
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MICE] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI No-Shortcut mode
ACPI: (supports S0 S1 S5)
Freeing unused kernel memory: 196k freed
Time: tsc clocksource has been installed.
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Transitioning device [FAN1] to D3
ACPI: Transitioning device [FAN1] to D3
ACPI: Fan [FAN1] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:pio, hdb:DMA
     ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
usbcore: registered new driver usbfs
usbcore: registered new driver hub
Linux Tulip driver version 1.1.13-NAPI (May 11, 2002)
USB Universal Host Controller Interface driver v3.0
hda: WDC WD800JB-00CRA1, ATA DISK drive
Time: acpi_pm clocksource has been installed.
hdb: ST3250623A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: Hewlett-Packard CD-Writer Plus 9100, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
PCI: Enabling device 0000:00:10.0 (0114 -> 0117)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
tulip0:  MII transceiver #1 config 1000 status 786d advertising 05e1.
eth0: ADMtek Comet rev 17 at 00011800, 00:14:BF:5C:E1:35, IRQ 9.
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 9, io base 0x00001020
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(33)
hda: cache flushes not supported
  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 hda10 >
hdb: max request size: 512KiB
hdb: 488397168 sectors (250059 MB) w/16384KiB Cache, CHS=30401/255/63, UDMA(33)
hdb: cache flushes supported
  hdb: hdb1 hdb2
hdc: ATAPI 32X CD-ROM CD-R/RW drive, 4096kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
usb 1-2: new full speed USB device using uhci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
input: PC Speaker as /class/input/input1
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Floppy drive(s): fd0 is 1.44M
Real Time Clock Driver v1.12ac
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
FDC 0 is a post-1991 82077
pnp: Device 01:01.01 activated.
gameport: NS558 PnP Gameport is pnp01:01.01/gameport0, io 0x201, speed 727kHz
pnp: Device 01:01.00 activated.
pnp: Device 01:01.00 disabled.
snd-opl3sa2-pnpbios: probe of 01:01.00 failed with error -2
pnp: Device 01:01.00 activated.
Adding 979956k swap on /dev/hda3.  Priority:-1 extents:1 across:979956k
Adding 979924k swap on /dev/hdb1.  Priority:-2 extents:1 across:979924k
EXT3 FS on hda2, internal journal
device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
0000:00:10.0: tulip_stop_rxtx() failed
eth0: Setting full-duplex based on MII#1 link partner capability of 41e1.
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
eth0: no IPv6 routers present


lspci at boot:
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
 	Flags: bus master, medium devsel, latency 64
 	Memory at f8000000 (32-bit, prefetchable) [size=64M]
 	Capabilities: [a0] AGP version 1.0

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
 	Flags: bus master, 66MHz, medium devsel, latency 64
 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
 	Flags: bus master, medium devsel, latency 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
 	Flags: bus master, medium devsel, latency 64
 	I/O ports at 1000 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
 	Flags: bus master, medium devsel, latency 64, IRQ 9
 	I/O ports at 1020 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
 	Flags: medium devsel, IRQ 9

00:0d.0 VGA compatible controller: S3 Inc. ViRGE/DX or /GX (rev 01) (prog-if 00 [VGA])
 	Subsystem: S3 Inc. ViRGE/DX
 	Flags: bus master, medium devsel, latency 64, IRQ 11
 	Memory at f0000000 (32-bit, non-prefetchable) [size=64M]
 	[virtual] Expansion ROM at 20020000 [disabled] [size=64K]

00:0f.0 Communication controller: Motorola Wildcard X100P
 	Subsystem: Motorola Unknown device 0000
 	Flags: bus master, medium devsel, latency 64, IRQ 12
 	I/O ports at 1400 [disabled] [size=256]
 	Memory at f4000000 (32-bit, non-prefetchable) [disabled] [size=4K]
 	Capabilities: [40] Power Management version 2

00:10.0 Ethernet controller: ADMtek NC100 Network Everywhere Fast Ethernet 10/100 (rev 11)
 	Subsystem: ADMtek Unknown device 0574
 	Flags: bus master, medium devsel, latency 64, IRQ 9
 	I/O ports at 1800 [size=256]
 	Memory at f4001000 (32-bit, non-prefetchable) [size=1K]
 	[virtual] Expansion ROM at 20000000 [disabled] [size=128K]
 	Capabilities: [c0] Power Management version 2


dmidecode at boot:
# dmidecode 2.8
SMBIOS 2.1 present.
49 structures occupying 1595 bytes.
Table at 0x000EFCE0.

Handle 0x0000, DMI type 0, 19 bytes
BIOS Information
 	Vendor: Intel Corp.
 	Version: 4W4SB0X0.15A.0015.P10
 	Release Date: 09/28/1999
 	Address: 0x00000
 	Runtime Size: 1024 kB
 	ROM Size: 512 kB
 	Characteristics:
 		ISA is supported
 		PCI is supported
 		PNP is supported
 		APM is supported
 		BIOS is upgradeable
 		BIOS shadowing is allowed
 		ESCD support is available
 		Boot from CD is supported
 		Selectable boot is supported
 		EDD is supported
 		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
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
 		AGP is supported
 		LS-120 boot is supported
 		ATAPI Zip drive boot is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
 	Manufacturer: Gateway
 	Product Name:
 	Version:
 	Serial Number: 0016510741
 	UUID: 00EE6199-DB1D-B211-8000-D2492E8CD433
 	Wake-up Type: Unknown

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
 	Manufacturer: Intel Corporation
 	Product Name: WS440BX
 	Version: AA744110-205
 	Serial Number: IMWS94711208

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
 	Manufacturer: Gateway
 	Type: Unknown
 	Lock: Not Present
 	Version:
 	Serial Number: 0016510741
 	Asset Tag:
 	Boot-up State: Unknown
 	Power Supply State: Unknown
 	Thermal State: Unknown
 	Security Status: Unknown

Handle 0x0004, DMI type 4, 32 bytes
Processor Information
 	Socket Designation: J4J1, CPU
 	Type: Central Processor
 	Family: Pentium III
 	Manufacturer: Intel Corporation
 	ID: 73 06 00 00 FF F9 87 03
 	Signature: Type 0, Family 6, Model 7, Stepping 3
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
 		SEP (Fast system call)
 		MTRR (Memory type range registers)
 		PGE (Page global enable)
 		MCA (Machine check architecture)
 		CMOV (Conditional move instruction supported)
 		PAT (Page attribute table)
 		PSE-36 (36-bit page size extension)
 		PSN (Processor serial number present and enabled)
 		MMX (MMX technology supported)
 		FXSR (Fast floating-point save and restore)
 		SSE (Streaming SIMD extensions)
 	Version: Intel Pentium(R) III Processor
 	Voltage: 2.0 V
 	External Clock: 100 MHz
 	Max Speed: 600 MHz
 	Current Speed: 600 MHz
 	Status: Populated, Enabled
 	Upgrade: Slot 1
 	L1 Cache Handle: 0x0009
 	L2 Cache Handle: 0x000A
 	L3 Cache Handle: No L3 Cache

Handle 0x0005, DMI type 5, 22 bytes
Memory Controller Information
 	Error Detecting Method: 32-bit ECC
 	Error Correcting Capabilities:
 		Single-bit Error Correcting
 	Supported Interleave: Other
 	Current Interleave: Other
 	Maximum Memory Module Size: 256 MB
 	Maximum Total Memory Size: 768 MB
 	Supported Speeds:
 		Other
 	Supported Memory Types:
 		ECC
 		DIMM
 		SDRAM
 	Memory Module Voltage: 3.3 V
 	Associated Memory Slots: 3
 		0x0006
 		0x0007
 		0x0008
 	Enabled Error Correcting Capabilities:
 		Unknown

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
 	Socket Designation: J6J1, Bank 0
 	Bank Connections: 1 0
 	Current Speed: Unknown
 	Type: DIMM SDRAM
 	Installed Size: 128 MB (Single-bank Connection)
 	Enabled Size: 128 MB (Single-bank Connection)
 	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
 	Socket Designation: J6J2, Bank 1
 	Bank Connections: 3 2
 	Current Speed: Unknown
 	Type: DIMM SDRAM
 	Installed Size: 128 MB (Single-bank Connection)
 	Enabled Size: 128 MB (Single-bank Connection)
 	Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
 	Socket Designation: J7J1, Bank 3
 	Bank Connections: 5 4
 	Current Speed: Unknown
 	Type: DIMM SDRAM
 	Installed Size: 128 MB (Single-bank Connection)
 	Enabled Size: 128 MB (Single-bank Connection)
 	Error Status: OK

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
 	Socket Designation: None
 	Configuration: Enabled, Not Socketed, Level 1
 	Operational Mode: Write Back
 	Location: Internal
 	Installed Size: 32 KB
 	Maximum Size: 32 KB
 	Supported SRAM Types:
 		Non-burst
 	Installed SRAM Type: Non-burst
 	Speed: Unknown
 	Error Correction Type: Unknown
 	System Type: Unknown
 	Associativity: Unknown

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
 	Socket Designation: None
 	Configuration: Enabled, Not Socketed, Level 2
 	Operational Mode: Write Back
 	Location: External
 	Installed Size: 512 KB
 	Maximum Size: 512 KB
 	Supported SRAM Types:
 		Pipeline Burst
 		Synchronous
 	Installed SRAM Type: Unknown
 	Speed: Unknown
 	Error Correction Type: Unknown
 	System Type: Unknown
 	Associativity: Unknown

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1K1
 	Internal Connector Type: None
 	External Reference Designator: COM A
 	External Connector Type: DB-9 male
 	Port Type: Serial Port 16550A Compatible

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1J1
 	Internal Connector Type: None
 	External Reference Designator: COM B
 	External Connector Type: DB-9 male
 	Port Type: Serial Port 16550A Compatible

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1J2
 	Internal Connector Type: None
 	External Reference Designator: LPT1
 	External Connector Type: DB-25 female
 	Port Type: Parallel Port ECP/EPP

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1M1
 	Internal Connector Type: None
 	External Reference Designator: Keyboard
 	External Connector Type: PS/2
 	Port Type: Keyboard Port

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1M1
 	Internal Connector Type: None
 	External Reference Designator: MOUSE
 	External Connector Type: PS/2
 	Port Type: Mouse Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1L1
 	Internal Connector Type: None
 	External Reference Designator: USB0
 	External Connector Type: Access Bus (USB)
 	Port Type: USB

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1L1
 	Internal Connector Type: None
 	External Reference Designator: USB1
 	External Connector Type: Access Bus (USB)
 	Port Type: USB

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J8K2, FLOPPY
 	Internal Connector Type: On Board Floppy
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J8G1, PRI IDE
 	Internal Connector Type: On Board IDE
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J7G1, SEC IDE
 	Internal Connector Type: On Board IDE
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1G1
 	Internal Connector Type: None
 	External Reference Designator: GAME
 	External Connector Type: DB-15 female
 	Port Type: MIDI Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1G1
 	Internal Connector Type: None
 	External Reference Designator: MIC
 	External Connector Type: Mini Jack (headphones)
 	Port Type: Audio Port

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1G1
 	Internal Connector Type: None
 	External Reference Designator: LINE IN
 	External Connector Type: Mini Jack (headphones)
 	Port Type: Audio Port

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1G1
 	Internal Connector Type: None
 	External Reference Designator: LINE OUT
 	External Connector Type: Mini Jack (headphones)
 	Port Type: Audio Port

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1F1 CD
 	Internal Connector Type: On Board Sound Input From CD-ROM
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Audio Port

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J1F2 Telephony, 4 pin
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Audio Port

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J2D1 AUX IN
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Audio Port

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J2C1 WOL, Wake on LAN
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J5B1 WOR, Wake on Ring
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J2B1, AC97 Header
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
 	Internal Reference Designator: J7C1, Front Panel USB
 	Internal Connector Type: Other
 	External Reference Designator:
 	External Connector Type: None
 	Port Type: Other

Handle 0x0020, DMI type 9, 13 bytes
System Slot Information
 	Designation: ISA-1, J4A2
 	Type: 16-bit ISA
 	Current Usage: Unknown
 	Length: Long
 	Characteristics:
 		5.0 V is provided

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
 	Designation: PCI-1, J4D2
 	Type: 32-bit PCI
 	Current Usage: In Use
 	Length: Long
 	ID: 1
 	Characteristics:
 		3.3 V is provided

Handle 0x0022, DMI type 9, 13 bytes
System Slot Information
 	Designation: PCI-2, J4D1
 	Type: 32-bit PCI
 	Current Usage: Available
 	Length: Long
 	ID: 2
 	Characteristics:
 		3.3 V is provided

Handle 0x0023, DMI type 9, 13 bytes
System Slot Information
 	Designation: PCI-3, J4C1
 	Type: 32-bit PCI
 	Current Usage: In Use
 	Length: Long
 	ID: 3
 	Characteristics:
 		3.3 V is provided

Handle 0x0024, DMI type 9, 13 bytes
System Slot Information
 	Designation: PCI-4, J4B1
 	Type: 32-bit PCI
 	Current Usage: In Use
 	Length: Long
 	ID: 4
 	Characteristics:
 		3.3 V is provided

Handle 0x0025, DMI type 9, 13 bytes
System Slot Information
 	Designation: PCI-5, J4A1
 	Type: 32-bit PCI
 	Current Usage: Available
 	Length: Long
 	ID: 5
 	Characteristics:
 		3.3 V is provided

Handle 0x0026, DMI type 9, 13 bytes
System Slot Information
 	Designation: AGP, J4E1
 	Type: 32-bit AGP 2x
 	Current Usage: Unknown
 	Length: Long
 	ID: 0
 	Characteristics:
 		3.3 V is provided

Handle 0x0027, DMI type 10, 6 bytes
On Board Device Information
 	Type: Sound
 	Status: Disabled
 	Description: ENSONIQ

Handle 0x0028, DMI type 11, 5 bytes
OEM Strings
 	String 1:

Handle 0x0029, DMI type 12, 5 bytes
System Configuration Options
 	Option 1: J7B1 pins 1 and 2 for normal operation
 	Option 2: J7B1 pins 2 and 3 for configuration mode
 	Option 3: J7B1 remove jumper for recovery mode

Handle 0x002A, DMI type 15, 23 bytes
System Event Log
 	Area Length: 4096 bytes
 	Header Start Offset: 0x0000
 	Header Length: 16 bytes
 	Data Start Offset: 0x0010
 	Access Method: Memory-mapped physical 32-bit address
 	Access Address: 0xFFF9F000
 	Status: Valid, Not Full
 	Change Token: 0x00000009
 	Header Format: Type 1
 	Supported Log Type Descriptors: 0

Handle 0x002B, DMI type 16, 15 bytes
Physical Memory Array
 	Location: System Board Or Motherboard
 	Use: System Memory
 	Error Correction Type: Single-bit ECC
 	Maximum Capacity: 768 MB
 	Error Information Handle: Not Provided
 	Number Of Devices: 3

Handle 0x002C, DMI type 17, 21 bytes
Memory Device
 	Array Handle: 0x002B
 	Error Information Handle: No Error
 	Total Width: 32 bits
 	Data Width: 32 bits
 	Size: 128 MB
 	Form Factor: DIMM
 	Set: 1
 	Locator: J6J1
 	Bank Locator: BANK 0
 	Type: DRAM
 	Type Detail: Synchronous

Handle 0x002D, DMI type 17, 21 bytes
Memory Device
 	Array Handle: 0x002B
 	Error Information Handle: No Error
 	Total Width: 32 bits
 	Data Width: 32 bits
 	Size: 128 MB
 	Form Factor: DIMM
 	Set: 1
 	Locator: J6J2
 	Bank Locator: BANK 1
 	Type: DRAM
 	Type Detail: Synchronous

Handle 0x002E, DMI type 17, 21 bytes
Memory Device
 	Array Handle: 0x002B
 	Error Information Handle: No Error
 	Total Width: 32 bits
 	Data Width: 32 bits
 	Size: 128 MB
 	Form Factor: DIMM
 	Set: 1
 	Locator: J7J1
 	Bank Locator: BANK 2
 	Type: DRAM
 	Type Detail: Synchronous

Handle 0x002F, DMI type 19, 15 bytes
Memory Array Mapped Address
 	Starting Address: 0x00000000000
 	Ending Address: 0x000180003FF
 	Range Size: 393217 kB
 	Physical Array Handle: 0x002B
 	Partition Width: 0

Handle 0x0030, DMI type 20, 19 bytes
Memory Device Mapped Address
 	Starting Address: 0x00000000000
 	Ending Address: 0x00007FFFFFF
 	Range Size: 128 MB
 	Physical Device Handle: 0x002C
 	Memory Array Mapped Address Handle: 0x002F
 	Partition Row Position: Unknown
 	Interleave Position: Unknown
 	Interleaved Data Depth: Unknown


/proc/interrupts at boot:
            CPU0
   0:      82205          XT-PIC  timer
   1:        712          XT-PIC  i8042
   2:          0          XT-PIC  cascade
   4:       2327          XT-PIC  serial
   5:          2          XT-PIC  OPL3-SA2
   6:          5          XT-PIC  floppy
   7:          3          XT-PIC  parport0
   8:          1          XT-PIC  rtc
   9:        713          XT-PIC  acpi, uhci_hcd:usb1, eth0
  14:       6931          XT-PIC  ide0
  15:       2756          XT-PIC  ide1
NMI:          0 
LOC:          0 
ERR:          0
MIS:          0


ethtool at boot:
Cannot get EEPROM data: Operation not supported


An extract from kern.log, showing calm after boot, one warning after
20 hours, then the full problem starting after another 40 hours:
Apr 14 17:28:41 legba kernel: NET: Registered protocol family 10
Apr 14 17:28:41 legba kernel: lo: Disabled Privacy Extensions
Apr 14 17:28:41 legba kernel: IPv6 over IPv4 tunneling driver
Apr 14 17:28:41 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 14 17:28:41 legba kernel: eth0: Setting full-duplex based on MII#1 link partner capability of 41e1.
Apr 14 17:28:45 legba kernel: lp0: using parport0 (interrupt-driven).
Apr 14 17:28:45 legba kernel: ppdev: user-space parallel port driver
Apr 14 17:28:47 legba kernel: eth0: no IPv6 routers present
Apr 15 13:23:39 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 17 05:30:38 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 17 05:30:38 legba last message repeated 2 times
Apr 17 05:34:41 legba kernel: NETDEV WATCHDOG: eth0: transmit timed out
Apr 17 05:34:41 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 17 05:34:41 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 17 05:35:09 legba kernel: NETDEV WATCHDOG: eth0: transmit timed out
Apr 17 05:35:09 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
Apr 17 05:35:09 legba kernel: 0000:00:10.0: tulip_stop_rxtx() failed
etc. almost all writes sluggish now, this goes on for thousands of lines.
