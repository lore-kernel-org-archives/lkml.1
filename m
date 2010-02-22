Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0BVVwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:52:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:54148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754278Ab0BVVw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:52:27 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/fRJN/OCnfEM0dBf9dnTpetaHaKqMUfE6HStwjTm
	aHJEIUqkiUB3Ck
Date: Mon, 22 Feb 2010 22:52:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: RE: What's the right value for idle= (was: Re: [linux-pm] regression
 on P-II SMP)
In-Reply-To: <7C53B33EE871F14797C999838AA8B5A9143F39E1@orsmsx505.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.1002222250050.4120@axis700.grange>
References: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
 <201002212136.03783.rjw@sisk.pl> <7C53B33EE871F14797C999838AA8B5A9143F39E1@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Pallipadi, Venkatesh wrote:

> This CPU doesn't support mwait. So, idle=halt is what you should be 
> using. That said, halt based idle is what should be used on this system 
> by default, unless it supports ACPI based C-states. Can you send in the 
> dmesg, with 2.6.25 without any boot parameter.

I do need some parameters to boot at all, notable "acpi=noirq" otherwise:

Linux version 2.6.25 (lyakh@6a) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #2 SMP PREEMPT Wed Apr 23 18:56:29 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000008000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
128MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f6680] 000f6680
Entering add_active_range(0, 0, 32768) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    32768
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    32768
On node 0 totalpages: 32768
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 224 pages used for memmap
  Normal zone: 28448 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI not present or invalid.
ACPI: RSDP 000EC010, 0014 (r0 COMPAQ)
ACPI: RSDT 000EC080, 0034 (r1 COMPAQ LAREDO          1             0)
ACPI: FACP 000EC0CC, 0074 (r1 COMPAQ LAREDO          1             0)
ACPI: DSDT 000EC19A, 093D (r1 COMPAQ     DSDT        1 MSFT  1000005)
ACPI: FACS 000EC040, 0040
ACPI: APIC 000EC140, 005A (r1 COMPAQ LAREDO          1             0)
ACPI: SSDT 000ECAD7, 0C15 (r1 COMPAQ VILLTBL1        1 MSFT  1000005)
ACPI: SSDT 000ED6EC, 03E5 (r1 COMPAQ PNP_PRSS        1 MSFT  1000005)
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:5 APIC version 17
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:5 APIC version 17
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: COMPAQ   Product ID: Workstation  APIC at: 0xFEE00000
I/O APIC #8 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 10000000 (gap: 08000000:f6c00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: root=/dev/sdb1 acpi=noirq scsi_mod.scan=sync netconsole=@172.29.21.102/eth0,6670@172.29.21.101/00:13:3B:00:01:AD
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 399.077 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 125924k/131072k available (2103k kernel code, 4680k reserved, 755k data, 304k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xc8800000 - 0xfffb3000   ( 887 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
      .init : 0xc03d1000 - 0xc041d000   ( 304 kB)
      .data : 0xc030dd4a - 0xc03ca970   ( 755 kB)
      .text : 0xc0100000 - 0xc030dd4a   (2103 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 799.35 BogoMIPS (lpj=3996764)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0a00 (from 0800)
CPU0: Intel Pentium II (Deschutes) stepping 02
Booting processor 1/0 ip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 798.19 BogoMIPS (lpj=3990955)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium II (Deschutes) stepping 01
Total of 2 processors activated (1597.54 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 448 bytes
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xe10b4, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:14.3: quirk: region f800-f83f claimed by PIIX4 ACPI
pci 0000:00:14.3: quirk: region fc00-fc0f claimed by PIIX4 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:14.0
PCI->APIC IRQ transform: 0000:00:0b.0[A] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:0c.0[A] -> IRQ 20
PCI->APIC IRQ transform: 0000:00:0d.0[B] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:0d.1[C] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:0d.2[D] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:0d.3[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:0e.0[A] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:0f.0[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:0f.1[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:10.0[A] -> IRQ 16
PCI: using PPB 0000:00:01.0[A] to get irq 22
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 22
ACPI: RTC can wake from S4
system 00:0b: iomem range 0x0-0x9ffff could not be reserved
system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
system 00:0b: iomem range 0x100000-0xffffff could not be reserved
system 00:0b: iomem range 0xfffc0000-0xffffffff could not be reserved
system 00:0c: ioport range 0x15c-0x15d has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x77e-0x77f has been reserved
system 00:0c: ioport range 0xc06-0xc07 has been reserved
system 00:0c: ioport range 0xc50-0xc51 has been reserved
system 00:0c: ioport range 0xc70-0xc77 has been reserved
system 00:0c: ioport range 0xc82-0xc82 has been reserved
system 00:0d: ioport range 0xf800-0xf81f has been reserved
system 00:0d: ioport range 0xf820-0xf83f has been reserved
system 00:0d: ioport range 0xfc00-0xfc0f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0x50000000-0x510fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:0c.0: Firmware left e100 interrupts enabled; disabling
pci 0000:01:00.0: Boot video device
input: Power Button (CM) as /class/input/input0
ACPI: Power Button (CM) [PBTN]
isapnp: Scanning for PnP cards...
isapnp: Card 'ESS ES1869 Plug and Play AudioDrive'
isapnp: 1 Plug & Play card detected total
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial 00:08: activated
00:08: ttyS0 at I/O 0x3e8 (irq = 4) is a 16550A
serial 00:09: activated
00:09: ttyS1 at I/O 0x2e8 (irq = 3) is a NS16550A
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100: eth0: e100_probe: addr 0x51900000, irq 20, MAC addr 00:08:c7:82:82:3c
netconsole: local port 6665
netconsole: local IP 172.29.21.102
netconsole: interface eth0
netconsole: remote port 6670
netconsole: remote IP 172.29.21.101
netconsole: remote ethernet address 00:13:3b:00:01:ad
netconsole: device eth0 not up yet, forcing it
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
netconsole: timeout waiting for carrier
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:14.1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x58c0-0x58c7, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0x58c8-0x58cf, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
Probing IDE interface ide1...
Probing IDE interface ide0...
Probing IDE interface ide1...
sym0: <875> rev 0x4 at pci 0000:00:0b.0 irq 21
sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
scsi 0:0:0:0: Direct-Access     COMPAQ   DDRS-34560W      S97A PQ: 0 ANSI: 2
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
scsi 0:0:8:0: Direct-Access     QUANTUM  VIKING II 4.5WSE 4110 PQ: 0 ANSI: 2
 target0:0:8: tagged command queuing enabled, command queue depth 16.
 target0:0:8: Beginning Domain Validation
 target0:0:8: asynchronous
 target0:0:8: wide asynchronous
 target0:0:8: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target0:0:8: Domain Validation skipping write tests
 target0:0:8: Ending Domain Validation
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 8386000 512-byte hardware sectors (4294 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b9 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 8386000 512-byte hardware sectors (4294 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: b9 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:8:0: [sdb] 8910423 512-byte hardware sectors (4562 MB)
sd 0:0:8:0: [sdb] Write Protect is off
sd 0:0:8:0: [sdb] Mode Sense: d9 00 00 08
sd 0:0:8:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:8:0: [sdb] 8910423 512-byte hardware sectors (4562 MB)
sd 0:0:8:0: [sdb] Write Protect is off
sd 0:0:8:0: [sdb] Mode Sense: d9 00 00 08
sd 0:0:8:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 0:0:8:0: [sdb] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
EISA: Probing bus 0 at eisa.0
EISA: Cannot allocate resource for mainboard
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
rtc_cmos 00:03: hctosys: invalid date/time
input: PS/2 Logitech Mouse as /class/input/input2
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 304k freed
kjournald starting.  Commit interval 5 seconds
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0d.0: OHCI Host Controller
ohci_hcd 0000:00:0d.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0d.0: irq 18, io mem 0x51300000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd 0000:00:0d.1: OHCI Host Controller
ohci_hcd 0000:00:0d.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0d.1: irq 19, io mem 0x51400000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
ohci_hcd 0000:00:0d.2: OHCI Host Controller
ohci_hcd 0000:00:0d.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:0d.2: irq 16, io mem 0x51500000
USB Universal Host Controller Interface driver v3.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: PC Speaker as /class/input/input3
dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
Uhhuh. NMI received for unknown reason a1 on CPU 0.
You have some hardware problem, likely on the PCI bus.
Dazed and confused, but trying to continue
FDC 0 is a National Semiconductor PC87306
usb 3-2: new full speed USB device using ohci_hcd and address 2
parport_pc 00:07: activated
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 5 [PCSPP(,...)]
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 4 ports detected
dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x77
dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
dc395x: Connectors: ext50  Termination: Auto Low High 
dc395x: Performing initial SCSI bus reset
scsi1 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Host bridge needs ETBF enabled.
usb 3-2.3: new low speed USB device using ohci_hcd and address 3
usb 3-2.3: configuration #1 chosen from 1 choice
usb 3-2.4: new low speed USB device using ohci_hcd and address 4
usb 3-2.4: configuration #1 chosen from 1 choice
input: HID 062a:0000 as /class/input/input4
es18xx-pnpbios 01:01.01: activated
es18xx-pnpbios 01:01.01: disabled
es18xx-pnpbios: probe of 01:01.01 failed with error -2
es18xx 01:01.00: activated
es18xx 01:01.01: activated
input: USB HID v1.10 Mouse [HID 062a:0000] on usb-0000:00:0d.2-2.3
input: BTC USB Multimedia Keyboard as /class/input/input5
input: USB HID v1.10 Keyboard [BTC USB Multimedia Keyboard] on usb-0000:00:0d.2-2.4
input: BTC USB Multimedia Keyboard as /class/input/input6
input: USB HID v1.10 Device [BTC USB Multimedia Keyboard] on usb-0000:00:0d.2-2.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
scsi2 : Tekram DC390/AM53C974 V2.1d 2004-05-27
scsi 2:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-305  1.05 PQ: 0 ANSI: 2
scsi 2:0:5:0: Sequential-Access HP       C1533A           A708 PQ: 0 ANSI: 2
uhci_hcd 0000:00:14.2: UHCI Host Controller
uhci_hcd 0000:00:14.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:14.2: irq 11, io base 0x000058a0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
piix4_smbus 0000:00:14.3: Found 0000:00:14.3 device
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:00:0f.0, irq: 18, latency: 66, mmio: 0x51a00000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: enabling ETBF (430FX/VP3 compatibilty)
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 1-0050: Hauppauge model 44804, rev D148, serial# 6989715
tveeprom 1-0050: tuner model is LG TP18PSB11D (idx 48, type 29)
tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: has no radio
bttv0: Hauppauge eeprom indicates model#44804
bttv0: tuner type=29
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Driver 'sr' needs updating - please use bus_type methods
DC390: Target 1: Sync transfer 10.0 MHz, Offset 15
sr0: scsi3-mmc drive: 16x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:1:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:8:0: Attached scsi generic sg1 type 0
sr 2:0:1:0: Attached scsi generic sg2 type 5
scsi 2:0:5:0: Attached scsi generic sg3 type 1
tuner' 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 1-0061: type set to 29 (LG PAL_BG (TPI8PSB11D))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
ehci_hcd 0000:00:0d.3: EHCI Host Controller
ehci_hcd 0000:00:0d.3: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:0d.3: debug port 1
ehci_hcd 0000:00:0d.3: irq 17, io mem 0x51800000
usb 3-2: USB disconnect, address 2
usb 3-2.3: USB disconnect, address 3
ehci_hcd 0000:00:0d.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 6 ports detected
usb 3-2.4: USB disconnect, address 4
usb 3-2: new full speed USB device using ohci_hcd and address 5
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 4 ports detected
Adding 248996k swap on /dev/sda2.  Priority:-1 extents:1 across:248996k
usb 3-2.3: new low speed USB device using ohci_hcd and address 6
usb 3-2.3: configuration #1 chosen from 1 choice
input: HID 062a:0000 as /class/input/input7
input: USB HID v1.10 Mouse [HID 062a:0000] on usb-0000:00:0d.2-2.3
usb 3-2.4: new low speed USB device using ohci_hcd and address 7
EXT3 FS on sdb1, internal journal
usb 3-2.4: configuration #1 chosen from 1 choice
input: BTC USB Multimedia Keyboard as /class/input/input8
input: USB HID v1.10 Keyboard [BTC USB Multimedia Keyboard] on usb-0000:00:0d.2-2.4
input: BTC USB Multimedia Keyboard as /class/input/input9
input: USB HID v1.10 Device [BTC USB Multimedia Keyboard] on usb-0000:00:0d.2-2.4
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
lp0: using parport0 (interrupt-driven).
lp0: console ready
ppdev: user-space parallel port driver
DC390: Target 5: Sync transfer 10.0 MHz, Offset 15

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
