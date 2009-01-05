Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZAEWQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZAEWQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZAEWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:16:23 -0500
Received: from mail.lang.hm ([64.81.33.126]:40795 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZAEWQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:16:19 -0500
Date: Mon, 5 Jan 2009 15:18:23 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901051516060.27641@asgard.lang.hm>
References: <20090102174845.GD5372@localhost> <20090102203058.GH5372@localhost>  <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>  <20090103161052.GB11093@localhost>  <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>  <20090103190316.GB7367@localhost>
 <20090103212426.GC7367@localhost>  <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>  <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm> <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Yinghai Lu wrote:

> Can you send out boot log with working kernel before 2.6.28?
>
> need to look at the e820 table.


here is the 32 bit kernel I'm running now (from dmesg )

Linux version 2.6.25.14 (root@dlang) (gcc version 3.3.6) #1 SMP PREEMPT 
Mon Aug 4 18:22:50 PDT 2008
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000004cff0000 (usable)
  BIOS-e820: 000000004cff0000 - 000000004cfff000 (ACPI data)
  BIOS-e820: 000000004cfff000 - 000000004d000000 (ACPI NVS)
  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00ff780] 000ff780
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->  1048576
On node 0 totalpages: 1048576
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 6400 pages used for memmap
   HighMem zone: 812800 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F68E0, 0024 (r2 ACPIAM)
ACPI: XSDT 4CFF0100, 0054 (r1 A M I  OEMXSDT   6000428 MSFT       97)
ACPI: FACP 4CFF0281, 00F4 (r1 A M I  OEMFACP   6000428 MSFT       97)
ACPI: DSDT 4CFF0400, 30A7 (r1  0AAAA 0AAAA000        0 INTL  2002026)
ACPI: FACS 4CFFF000, 0040
ACPI: APIC 4CFF0380, 0074 (r1 A M I  OEMAPIC   6000428 MSFT       97)
ACPI: OEMB 4CFFF040, 0041 (r1 A M I  OEMBIOS   6000428 MSFT       97)
ACPI: SRAT 4CFF34B0, 00F0 (r1 A M I  OEMSRAT   6000428 MSFT       97)
ACPI: HPET 4CFF35A0, 0038 (r1 A M I  OEMHPET   6000428 MSFT       97)
ACPI: ASF! 4CFF35E0, 0086 (r1 AMIASF AMDSTRET        1 INTL  2002026)
ACPI: PM-Timer IO Port: 0x5008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:5 APIC version 16
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xff6ff000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xff6ff000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xff6fe000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xff6fe000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
ACPI: HPET id: 0x102282a0 base: 0xfec01000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 4d000000:b2780000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 
1040384
Kernel command line: BOOT_IMAGE=2.6.25.14 ro root=802
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (ff6ff000)
mapped IOAPIC to ffff8000 (ff6fe000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
CPU 0 irqstacks, hard=c07e3000 soft=c07e1000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1394.218 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1216196k/4194304k available (4621k kernel code, 44152k reserved, 
2074k data, 304k init, 344000k highmem)
virtual kernel memory layout:
     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0792000 - 0xc07de000   ( 304 kB)
       .data : 0xc0583639 - 0xc078a1fc   (2074 kB)
       .text : 0xc0100000 - 0xc0583639   (4621 kB)
Checking if this processor honours the WP bit even in supervisor 
mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 2791.98 BogoMIPS 
(lpj=4651182)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: AMD Opteron(tm) Processor 240 stepping 0a
Booting processor 1/1 ip 2000
CPU 1 irqstacks, hard=c07e4000 soft=c07e2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2789.41 BogoMIPS 
(lpj=4647056)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Opteron(tm) Processor 240 stepping 0a
Total of 2 processors activated (5581.39 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
Brought up 2 CPUs
CPU0 attaching sched-domain:
  domain 0: span 3
   groups: 1 2
CPU1 attaching sched-domain:
  domain 0: span 3
   groups: 2 1
net_namespace: 448 bytes
xor: automatically using best checksumming function: pIII_sse
    pIII_sse  :  4393.200 MB/sec
xor: using function: pIII_sse (4393.200 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hpet0: at MMIO 0xfec01000, IRQs 2, 8, 0
hpet0: 3 32-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:0b: ioport range 0x680-0x6ff has been reserved
system 00:0b: ioport range 0x295-0x296 has been reserved
system 00:0b: ioport range 0x778-0x77f has been reserved
system 00:0b: ioport range 0xb78-0xb7f has been reserved
system 00:0b: ioport range 0xf78-0xf7f has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x5000-0x50bf has been reserved
system 00:0c: ioport range 0x50e0-0x50ff has been reserved
system 00:0c: ioport range 0x50c0-0x50df has been reserved
system 00:0c: ioport range 0xde00-0xde7f has been reserved
system 00:0c: ioport range 0xde80-0xdeff has been reserved
system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0e: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0e: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:0e: iomem range 0xff780000-0xff7fffff could not be reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0xc0000-0xdffff could not be reserved
system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
system 00:0f: iomem range 0x100000-0x4cffffff could not be reserved
system 00:0f: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:06.0
   IO window: b000-bfff
   MEM window: 0xff500000-0xff5fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
   IO window: disabled.
   MEM window: 0xff400000-0xff4fffff
   PREFETCH window: 0x00000000fea00000-0x00000000feafffff
PCI: Bridge: 0000:01:01.0
   IO window: a000-afff
   MEM window: 0xff200000-0xff2fffff
   PREFETCH window: 0x00000000ce900000-0x00000000ee9fffff
PCI: Bridge: 0000:01:03.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
   IO window: a000-afff
   MEM window: 0xff200000-0xff3fffff
   PREFETCH window: 0x00000000ce900000-0x00000000fe9fffff
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 29 (level, low) -> IRQ 29
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
SGI XFS with no debug enabled
async_tx: api initialized (sync-only)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:05:08.0: Firmware left e100 interrupts enabled; disabling
pci 0000:03:00.0: Boot video device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
Console: switching to colour frame buffer device 80x30
fb0: VGA16 VGA frame buffer device
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
hpet_resources: 0xfec01000 is busy
Non-volatile memory driver v1.2
AMD768 RNG detected
ppdev: user-space parallel port driver
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 29 (level, low) -> IRQ 29
PCI: Setting latency timer of device 0000:03:00.0 to 64
[drm] Initialized radeon 1.28.0 20060524 on minor 0
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Unable to find any System Interface(s)
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 
60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
nbd: registered device at major 43
usbcore: registered new interface driver ub
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
Ethernet Channel Bonding Driver: v3.2.5 (March 21, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module 
parameters must be specified, otherwise
  bonding will not detect link failures! see bonding.txt for details.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 18 (level, low) -> IRQ 18
e100: eth0: e100_probe: addr 0xff5fc000, irq 18, MAC addr 
00:e0:81:2a:cc:b2
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with 
idebus=xx
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
AMD8111: IDE controller (0x1022:0x7469 rev 0x03) at  PCI slot 0000:00:07.1
AMD8111: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:PIO, hdb:PIO
     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:PIO
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: VOM-12E48X, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 1X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-869.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
ACPI: PCI Interrupt 0000:01:03.1[A] -> GSI 28 (level, low) -> IRQ 28
Adaptec I2O RAID controller 0 at f8880000 size=100000 irq=28
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: ADAPTEC      Device: AIC-7899     Rev: 00000001
TID 009  Vendor: ADAPTEC      Device: AIC-7899     Rev: 00000001
TID 523  Vendor: ADAPTEC      Device: RAID-1       Rev: 370F
TID 524  Vendor: ADAPTEC      Device: RAID-1       Rev: 370F
scsi0 : Vendor: Adaptec  Model: 3210S            FW:370F
scsi 0:0:1:0: Direct-Access     ADAPTEC  RAID-1           370F PQ: 0 ANSI: 
2
scsi 0:1:0:0: Direct-Access     ADAPTEC  RAID-1           370F PQ: 0 ANSI: 
2
Adaptec aacraid driver 1.1-5[2455]-ms
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:1:0: [sda] 71686144 512-byte hardware sectors (36703 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: cf 00 10 08
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO 
and FUA
sd 0:0:1:0: [sda] 71686144 512-byte hardware sectors (36703 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: cf 00 10 08
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO 
and FUA
  sda: sda1 sda2 sda3
sd 0:0:1:0: [sda] Attached SCSI disk
sd 0:1:0:0: [sdb] 71686144 512-byte hardware sectors (36703 MB)
sd 0:1:0:0: [sdb] Write Protect is off
sd 0:1:0:0: [sdb] Mode Sense: ab 00 10 08
sd 0:1:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO 
and FUA
sd 0:1:0:0: [sdb] 71686144 512-byte hardware sectors (36703 MB)
sd 0:1:0:0: [sdb] Write Protect is off
sd 0:1:0:0: [sdb] Mode Sense: ab 00 10 08
sd 0:1:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO 
and FUA
  sdb: sdb1 sdb2
sd 0:1:0:0: [sdb] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
sd 0:0:1:0: Attached scsi generic sg0 type 0
sd 0:1:0:0: Attached scsi generic sg1 type 0
SCSI Media Changer driver v0.25
Driver 'ch' needs updating - please use bus_type methods
I2O subsystem v1.325
i2o: max drivers = 8
i2o: Checking for PCI I2O controllers...
iop0: controller found (0000:01:03.1)
PCI: Unable to reserve mem region #1:8000000@f0000000 for device 
0000:01:03.1
iop0: device already claimed
iop0: DMA / IO allocation for I2O controller failed
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:05:00.0[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:05:00.0: OHCI Host Controller
ohci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:05:00.0: irq 19, io mem 0xff5fd000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25.14 ohci_hcd
usb usb1: SerialNumber: 0000:05:00.0
ACPI: PCI Interrupt 0000:05:00.1[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:05:00.1: OHCI Host Controller
ohci_hcd 0000:05:00.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:05:00.1: irq 19, io mem 0xff5fe000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.14 ohci_hcd
usb usb2: SerialNumber: 0000:05:00.1
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver berry_charge
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
rtc_cmos: probe of 00:02 failed with error -16
i2c /dev entries driver
w83627hf: Found W83627HF chip at 0x290
i2c-adapter i2c-0: detect fail: address match, 0x2e
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
pc87360: PC8736x not detected, module not inserted.
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1    582 MB/s
raid6: int32x2    834 MB/s
raid6: int32x4    498 MB/s
raid6: int32x8    312 MB/s
raid6: mmxx1     1176 MB/s
raid6: mmxx2     2177 MB/s
raid6: sse1x1     739 MB/s
raid6: sse1x2    1393 MB/s
raid6: sse2x1    1469 MB/s
raid6: sse2x2    2169 MB/s
raid6: using algorithm sse2x2 (2169 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: 
dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Bluetooth: Virtual HCI driver ver 1.2
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: HCILL protocol initialized
Bluetooth: Broadcom Blutonium firmware driver ver 1.1
usbcore: registered new interface driver bcm203x
Bluetooth: Digianswer Bluetooth USB driver ver 0.9
usbcore: registered new interface driver bpa10x
Bluetooth: BlueFRITZ! USB driver ver 1.1
usbcore: registered new interface driver bfusb
EDAC MC: Ver: 2.1.0 Aug  4 2008
cpuidle: using governor ladder
cpuidle: using governor menu
Bluetooth: HCI BCSP protocol initialized
Bluetooth: HCILL protocol initialized
Bluetooth: Broadcom Blutonium firmware driver ver 1.1
usbcore: registered new interface driver bcm203x
Bluetooth: Digianswer Bluetooth USB driver ver 0.9
usbcore: registered new interface driver bpa10x
Bluetooth: BlueFRITZ! USB driver ver 1.1
usbcore: registered new interface driver bfusb
EDAC MC: Ver: 2.1.0 Aug  4 2008
cpuidle: using governor ladder
cpuidle: using governor menu
oprofile: using NMI interrupt.
pktgen v2.69: Packet Generator for packet performance testing.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 304k freed

