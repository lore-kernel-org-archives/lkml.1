Return-Path: <linux-kernel-owner+w=401wt.eu-S1765405AbYD2Sz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765405AbYD2Sz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763023AbYD2SwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:52:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:30921 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762970AbYD2SwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xaPqXzN98bMZDkrrgmcd9VlFCnrQ3mzYrZoa57t/aY67ht36xlY/4Peu9Vu4ZLYGjrKDaxjN96E5LG6lFlkLw/bjBHRusoJ1/mz7nDUXIXgOnHQtDcQj0zoolgIDo95cFLdCa+eXOo6oyvsDajuVhxHb7OGQAi7w1TFhHtDjnRc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: queue_flag_clear warnings with the latest git tree
Date: Tue, 29 Apr 2008 21:07:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804292107.09770.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They happen both with IDE and SCSI/libata...

IDE:

Linux version 2.6.25-06476-gc9a3f6d-dirty (bzolnier@localhost.localdomain) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #225 PREEMPT Tue Apr 29 20:53:53 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
 BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
127MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    32752
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    32752
DMI not present or invalid.
ACPI: RSDP 000FA5D0, 0014 (r0 QEMU  )
ACPI: RSDT 07FF0000, 002C (r0 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 07FF002C, 0074 (r0 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 07FF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
ACPI: FACS 07FF00C0, 0040
ACPI: APIC 07FF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 10000000 (gap: 08000000:f7fc0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32497
Kernel command line: root=/dev/hda init=/bin/sh  console=ttyS0,115200
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c03e1000 soft=c03e0000
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 1495.172 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 126096k/131008k available (1912k kernel code, 4432k reserved, 832k data, 180k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xc8800000 - 0xfffb3000   ( 887 MB)
    lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
      .init : 0xc03b0000 - 0xc03dd000   ( 180 kB)
      .data : 0xc02de117 - 0xc03ae1e0   ( 832 kB)
      .text : 0xc0100000 - 0xc02de117   (1912 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay using timer specific routine.. 3012.98 BogoMIPS (lpj=6025962)
Mount-cache hash table entries: 512
CPU: L1 I cache: 8K
CPU: L2 cache: 128K
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium II (Klamath) stepping 03
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
APIC calibration not consistent with PM Timer: 52ms instead of 100ms
APIC delta adjusted to PM-Timer: 6250026 (3292476)
net_namespace: 480 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(1209495511.389:1): initialized
Total HugeTLB memory allocated, 0
fuse init (API version 7.9)
msgmni has been set to 246 for ipc namespace c0394260
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Switched to NOHz mode on CPU #0
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
Uniform Multi-Platform E-IDE driver
PIIX3: IDE controller (0x8086:0x7010 rev 0x00) at  PCI slot 0000:00:01.1
PIIX3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xc000-0xc007
    ide1: BM-DMA at 0xc008-0xc00f
hda: QEMU HARDDISK, ATA DISK drive
Clocksource tsc unstable (delta = -713139329 ns)
hda: MWDMA2 mode selected
hdc: QEMU CD-ROM, ATAPI CD/DVD-ROM drive
hdc: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 512KiB
hda: 102400 sectors (52 MB) w/256KiB Cache, CHS=101/255/63
hda: cache flushes supported
 hda:<4>------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:439 queue_flag_clear+0x1e/0x3e()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-06476-gc9a3f6d-dirty #225
 [<c011a21e>] warn_on_slowpath+0x40/0x67
 [<c01b6ce3>] elv_rb_add+0x47/0x4f
 [<c01bda3e>] as_add_request+0x92/0xbe
 [<c01b6b8a>] elv_insert+0x11a/0x142
 [<c01b8b30>] __make_request+0x24e/0x292
 [<c01b8b53>] __make_request+0x271/0x292
 [<c01b7cb0>] generic_make_request+0x163/0x190
 [<c0140257>] mempool_alloc+0x32/0xfa
 [<c01b87ba>] submit_bio+0x9f/0xa5
 [<c017866f>] bio_alloc_bioset+0x9b/0xf3
 [<c01b7cfb>] queue_flag_clear+0x1e/0x3e
 [<c01b8506>] blk_remove_plug+0x3b/0x4c
 [<c01b854a>] __generic_unplug_device+0x1e/0x29
 [<c01b87d1>] generic_unplug_device+0x11/0x30
 [<c01b74ac>] blk_unplug+0x9/0xa
 [<c0175137>] blk_run_backing_dev+0xd/0xe
 [<c013e1df>] sync_page+0x39/0x43
 [<c02dc619>] __wait_on_bit_lock+0x2a/0x51
 [<c013e172>] __lock_page+0x4d/0x53
 [<c01293b0>] wake_bit_function+0x0/0x43
 [<c013e6aa>] read_cache_page_async+0x89/0xdf
 [<c017a1d9>] blkdev_readpage+0x0/0xc
 [<c013e70a>] read_cache_page+0xa/0x44
 [<c018a243>] read_dev_sector+0x22/0x6f
 [<c018a2f7>] msdos_partition+0x0/0x495
 [<c018a33f>] msdos_partition+0x48/0x495
 [<c01c4ac1>] snprintf+0x1c/0x1f
 [<c011ac03>] printk+0x14/0x18
 [<c018a2f7>] msdos_partition+0x0/0x495
 [<c018a043>] rescan_partitions+0xfa/0x200
 [<c0179fdf>] do_open+0x1ac/0x247
 [<c017a125>] __blkdev_get+0x5e/0x69
 [<c017a13a>] blkdev_get+0xa/0xc
 [<c0189f02>] register_disk+0xc7/0x10e
 [<c01bbbc3>] add_disk+0x2b/0x36
 [<c01bb811>] exact_match+0x0/0x7
 [<c01bba2e>] exact_lock+0x0/0xd
 [<c02312f8>] ide_disk_probe+0x48c/0x4a4
 [<c0220fd3>] __driver_attach+0x0/0x55
 [<c02269a3>] generic_ide_probe+0x1c/0x1d
 [<c0220f5d>] driver_probe_device+0xb4/0x12a
 [<c022100a>] __driver_attach+0x37/0x55
 [<c0220a3a>] bus_for_each_dev+0x34/0x56
 [<c0220df9>] driver_attach+0x11/0x13
 [<c0220fd3>] __driver_attach+0x0/0x55
 [<c02204e7>] bus_add_driver+0x8a/0x1a5
 [<c02211ed>] driver_register+0x45/0x99
 [<c03b05f8>] kernel_init+0x8f/0x194
 [<c0116591>] schedule_tail+0xe/0x39
 [<c0102b9e>] ret_from_fork+0x6/0x1c
 [<c03b0569>] kernel_init+0x0/0x194
 [<c03b0569>] kernel_init+0x0/0x194
 [<c010382b>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace be7c4407f4cbe739 ]---

hdc: ATAPI 4X CD-ROM drive, 512kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP bic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Using IPI Shortcut mode
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 180k freed

SCSI/libata:

Linux version 2.6.25-06476-gc9a3f6d-dirty (bzolnier@localhost.localdomain) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #226 PREEMPT Tue Apr 29 21:05:07 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
 BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
127MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    32752
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    32752
DMI not present or invalid.
ACPI: RSDP 000FA5D0, 0014 (r0 QEMU  )
ACPI: RSDT 07FF0000, 002C (r0 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 07FF002C, 0074 (r0 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 07FF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
ACPI: FACS 07FF00C0, 0040
ACPI: APIC 07FF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 10000000 (gap: 08000000:f7fc0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32497
Kernel command line: root=/dev/sda init=/bin/sh  console=ttyS0,115200
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c03cb000 soft=c03ca000
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 1495.108 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 126200k/131008k available (1858k kernel code, 4328k reserved, 802k data, 176k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xc8800000 - 0xfffb3000   ( 887 MB)
    lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
      .init : 0xc039b000 - 0xc03c7000   ( 176 kB)
      .data : 0xc02d086f - 0xc03991e0   ( 802 kB)
      .text : 0xc0100000 - 0xc02d086f   (1858 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay using timer specific routine.. 3012.58 BogoMIPS (lpj=6025175)
Mount-cache hash table entries: 512
CPU: L1 I cache: 8K
CPU: L2 cache: 128K
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium II (Klamath) stepping 03
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
APIC calibration not consistent with PM Timer: 51ms instead of 100ms
APIC delta adjusted to PM-Timer: 6249992 (3228274)
net_namespace: 480 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(1209495928.399:1): initialized
Total HugeTLB memory allocated, 0
fuse init (API version 7.9)
msgmni has been set to 246 for ipc namespace c0380260
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Switched to NOHz mode on CPU #0
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
ata1.00: ATA-7: QEMU HARDDISK, 0.9.0, max UDMA/100
ata1.00: 102400 sectors, multi 16: LBA48 
ata1.00: configured for MWDMA2
Clocksource tsc unstable (delta = -517774480 ns)
ata2.00: ATAPI: QEMU CD-ROM, 0.9.0, max UDMA/100
ata2.00: configured for MWDMA2
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:439 queue_flag_clear+0x1e/0x3e()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-06476-gc9a3f6d-dirty #226
 [<c011a21e>] warn_on_slowpath+0x40/0x67
 [<c01e8995>] acpi_ns_lookup+0x205/0x2ea
 [<c01ba619>] blk_recalc_rq_segments+0x32/0x1ec
 [<c01ba7fa>] blk_recount_segments+0x27/0x48
 [<c014156d>] page_count+0x8/0x14
 [<c01211cf>] __mod_timer+0xb2/0xc5
 [<c01b7cfb>] queue_flag_clear+0x1e/0x3e
 [<c01b8506>] blk_remove_plug+0x3b/0x4c
 [<c01b854a>] __generic_unplug_device+0x1e/0x29
 [<c01ba501>] blk_execute_rq_nowait+0x59/0x77
 [<c01ba590>] blk_execute_rq+0x71/0x8b
 [<c01ba5aa>] blk_end_sync_rq+0x0/0x26
 [<c0140257>] mempool_alloc+0x32/0xfa
 [<c0178ae4>] bio_add_pc_page+0x16/0x1b
 [<c0179086>] bio_phys_segments+0xe/0x14
 [<c022ae92>] scsi_execute+0xb6/0xc8
 [<c022af28>] scsi_execute_req+0x84/0xa1
 [<c022c689>] scsi_probe_and_add_lun+0x161/0x712
 [<c02cef34>] mutex_lock+0x15/0x23
 [<c022323e>] attribute_container_add_device+0x17/0xf9
 [<c022340f>] transport_setup_classdev+0x0/0x1a
 [<c01c1555>] kobject_get+0xf/0x13
 [<c022d4d8>] __scsi_add_device+0x83/0xa6
 [<c02393ab>] ata_scsi_scan_host+0x8c/0x17a
 [<c023753a>] ata_host_register+0x1cc/0x1e7
 [<c023d9c2>] ata_pci_sff_activate_host+0x17a/0x19e
 [<c023f6c8>] ata_sff_interrupt+0x0/0x8b
 [<c02cd0cf>] piix_init_one+0x4d1/0x4f0
 [<c0220fd3>] __driver_attach+0x0/0x55
 [<c01cb648>] pci_device_probe+0x36/0x57
 [<c0220f5d>] driver_probe_device+0xb4/0x12a
 [<c022100a>] __driver_attach+0x37/0x55
 [<c0220a3a>] bus_for_each_dev+0x34/0x56
 [<c0220df9>] driver_attach+0x11/0x13
 [<c0220fd3>] __driver_attach+0x0/0x55
 [<c02204e7>] bus_add_driver+0x8a/0x1a5
 [<c02211ed>] driver_register+0x45/0x99
 [<c01cb70a>] __pci_register_driver+0x2b/0x56
 [<c03ad968>] piix_init+0x11/0x23
 [<c039b5f8>] kernel_init+0x8f/0x194
 [<c0116591>] schedule_tail+0xe/0x39
 [<c0102b9e>] ret_from_fork+0x6/0x1c
 [<c039b569>] kernel_init+0x0/0x194
 [<c039b569>] kernel_init+0x0/0x194
 [<c010382b>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eea7c75508727b1 ]---
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 102400 512-byte hardware sectors (52 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 102400 512-byte hardware sectors (52 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda:
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.9. PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
Uniform CD-ROM driver Revision: 3.20
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP bic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Using IPI Shortcut mode
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 176k freed
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:427 queue_flag_set+0x1e/0x32()
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W 2.6.25-06476-gc9a3f6d-dirty #226
 [<c011a21e>] warn_on_slowpath+0x40/0x67
 [<c02d0032>] __kprobes_text_end+0x300/0x316
 [<c01145b8>] enqueue_task_fair+0x16/0x24
 [<c0113cc0>] enqueue_task+0xa/0x14
 [<c0113cf4>] activate_task+0x16/0x1a
 [<c0116252>] task_rq_unlock+0x18/0x22
 [<c01164fc>] try_to_wake_up+0x53/0x5b
 [<c0129390>] autoremove_wake_function+0xd/0x2d
 [<c0113e81>] __wake_up_common+0x2d/0x52
 [<c0201e59>] mix_pool_bytes_extract+0x13b/0x153
 [<c01b807f>] queue_flag_set+0x1e/0x32
 [<c01b86f4>] __blk_run_queue+0x2d/0x54
 [<c01b8804>] blk_run_queue+0x14/0x36
 [<c022a73d>] scsi_next_command+0x25/0x2f
 [<c022a909>] scsi_end_request+0x62/0x6b
 [<c022b0c9>] scsi_io_completion+0x184/0x342
 [<c01b88d7>] blk_done_softirq+0x4a/0x55
 [<c011e1b9>] __do_softirq+0x30/0x5e
 [<c0104e7b>] do_softirq+0x3b/0x6e
 [<c013c6a0>] handle_edge_irq+0x0/0x10d
 [<c011e108>] irq_exit+0x25/0x65
 [<c0104f55>] do_IRQ+0xa7/0xb7
 [<c0101b48>] default_idle+0x0/0x3b
 [<c010367b>] common_interrupt+0x23/0x28
 [<c0101b48>] default_idle+0x0/0x3b
 [<c0101b70>] default_idle+0x28/0x3b
 [<c0101b1f>] cpu_idle+0x49/0x72
 =======================
---[ end trace 4eea7c75508727b1 ]---

