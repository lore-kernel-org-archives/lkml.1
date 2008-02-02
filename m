Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbYBBXrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbYBBXrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYBBXri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:47:38 -0500
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:40342 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751031AbYBBXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:47:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=iOYL0cW7o1HEqvaWTGLTjF5Z8iqnTU4rJnntGSXaqI/GIy41l/VCY+i6E5DFVcp3/BgJj3PY7HMMG8K57OEIn25vl7kf+5174yS5J5yNaGu/nMpUABExpAfBTbd+30g0Ky4yT2c7abouKnKINLXsXZAkeAAiNedELSPSPisLFGo=;
X-YMail-OSG: d_XDnUMVM1lr5CdPs2tvDHfDkskLlDGUejgicP7tlf1SE2Uei.CpC.kYypli139A37Zu5000KOFoPiEm5bnRa9UnP4nd9s9vJQCu.Dpd9NJGv3gNOPeqAr1lqHuA2g--
Date: Sat, 2 Feb 2008 23:40:55 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] 2.6.24 refuses to boot - ATA problem?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <643979.82914.qm@web52904.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried to boot a 2.6.24 kernel on my 1 GHz Coppermine / 512 MB RAM PC. (This is without the
nmi_watchdog=1 option.) However, the ATA layer is failing to initialise:

Linux version 2.6.24 (chris@twopit.underworld) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1
SMP PREEMPT Sat Feb 2 22:21:52 GMT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffeb000 (usable)
 BIOS-e820: 000000001ffeb000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131051
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131051
DMI 2.3 present.
ACPI: RSDP 000F7B40, 0014 (r0 ASUS  )
ACPI: RSDT 1FFEB000, 0030 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: FACP 1FFEB100, 0074 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: DSDT 1FFEB180, 39FA (r1   ASUS TUSL2-C      1000 MSFT  100000B)
ACPI: FACS 1FFFF000, 0040
ACPI: BOOT 1FFEB040, 0028 (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: APIC 1FFEB080, 005A (r1 ASUS   TUSL2-C  30303031 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
Enabling APIC mode:  Logical Cluster.  Using 1 I/O APICs, target cpus f
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130028
Kernel command line: ro root=LABEL=/ video=matroxfb:vesa:0x11A console=ttyS0,115200n8 console=tty0
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0356000 soft=c0352000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1005.042 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 513520k/524204k available (1548k kernel code, 10088k reserved, 605k data, 192k init, 0k
highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffeb000   ( 511 MB)
      .init : 0xc031f000 - 0xc034f000   ( 192 kB)
      .data : 0xc02830d2 - 0xc031a7c4   ( 605 kB)
      .text : 0xc0100000 - 0xc02830d2   (1548 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2011.85 BogoMIPS (lpj=4023704)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 9k freed
ACPI: Core revision 20070126
CPU0: Intel Pentium III (Coppermine) stepping 06
Leaving ESR disabled.
Total of 1 processors activated (2011.85 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0e30, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
system 00:03: ioport range 0x3f0-0x3f1 has been reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
system 00:04: ioport range 0xe400-0xe47f has been reserved
system 00:04: ioport range 0xec00-0xec3f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f8800000-f9cfffff
  PREFETCH window: f9f00000-fbffffff
PCI: Bridge: 0000:02:0d.0
  IO window: disabled.
  MEM window: f6000000-f7ffffff
  PREFETCH window: f9d00000-f9dfffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-dfff
  MEM window: f5800000-f87fffff
  PREFETCH window: f9d00000-f9efffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 196608 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2969k freed
Simple Boot Flag at 0x3a set to 0x1
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
matroxfb: Matrox Millennium G400 MAX (AGP) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1280x1024x16bpp (virtual: 1280x6553)
matroxfb: framebuffer at 0xFA000000, mapped to 0xe0880000, size 33554432
Console: switching to colour frame buffer device 160x64
fb0: MATROX frame buffer device
matroxfb_crtc2: secondary head of fb0 was registered as fb1
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0c: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Feb  2 2008
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 192k freed
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:03:0d.2[C] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:03:0d.2: EHCI Host Controller
ehci_hcd 0000:03:0d.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:03:0d.2: irq 20, io mem 0xf6000000
ehci_hcd 0000:03:0d.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 22 (level, low) -> IRQ 17
ohci_hcd 0000:03:0d.0: OHCI Host Controller
ohci_hcd 0000:03:0d.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:03:0d.0: irq 17, io mem 0xf7000000
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:03:0d.1[B] -> GSI 23 (level, low) -> IRQ 18
ohci_hcd 0000:03:0d.1: OHCI Host Controller
ohci_hcd 0000:03:0d.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:03:0d.1: irq 18, io mem 0xf6800000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000a400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) -> IRQ 18
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1f.4: irq 18, io base 0x0000a000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xa800 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xa808 irq 15
ata1.00: ATA-4: ST320420A, 3.12, max UDMA/66
ata1.00: 39851760 sectors, multi 16: LBA 
ata1.00: configured for UDMA/66
ata2.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0122, E1.22, max UDMA/66
ata2.01: ATAPI: SONY    CD-RW  CRX145E, 1.0b, max UDMA/33
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.12 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<4>ehci_hcd 0000:03:0d.2: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/66
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/66
ata1: EH complete
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Remount R/O
Emergency Remount complete
SysRq : Resetting

With 2.6.23.11, the ATA layer does the following instead:

libata version 2.21 loaded.
ata_piix 0000:00:1f.1: version 2.12
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001a800 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001a808 irq 15
ata1.00: ATA-4: ST320420A, 3.12, max UDMA/66
ata1.00: 39851760 sectors, multi 16: LBA 
ata1.00: configured for UDMA/66
ata2.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0122, E1.22, max UDMA/66
ata2.01: ATAPI: SONY    CD-RW  CRX145E, 1.0b, max UDMA/33
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.12 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            PIONEER  DVD-ROM DVD-116  1.22 PQ: 0 ANSI: 5
scsi 1:0:1:0: CD-ROM            SONY     CD-RW  CRX145E   1.0b PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
scsi 1:0:1:0: Attached scsi generic sg2 type 5
sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

