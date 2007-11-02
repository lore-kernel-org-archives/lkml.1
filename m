Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXKBTbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXKBTbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXKBTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:31:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:42280 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbXKBTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Omj/Z0BKFB74BSIzEAidcz2r4vEfxiPUHBxs4Iv8cUzb8wwgpqLFIxk2F4DEMZGh9Ss19oaup59K0cdzD87ZCuc9+pCuom0OCUl8WXMzGMmLQdxaMXBMHQOiZLhyc8bh+jQNJM9tGd02HogoHBozeLpBQOKqGrxDL2J7gpyE/g0=
Message-ID: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com>
Date: Fri, 2 Nov 2007 15:31:23 -0400
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg (new) with disabled GART error reporting if anyone wants to
compare to previous dmesg with GART error reporting :
dmesg
Linux version 2.6.23.1 (root@unix) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #5 SMP Fri Oct 26 04:07:27 EDT 2007
Command line: root=/dev/md1 ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000c7ff0000 (usable)
 BIOS-e820: 00000000c7ff0000 - 00000000c7ffe000 (ACPI data)
 BIOS-e820: 00000000c7ffe000 - 00000000c8000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 819184) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
end_pfn_map = 2326528
DMI 2.3 present.
ACPI: RSDP 000F9200, 0024 (r2 ACPIAM)
ACPI: XSDT C7FF0100, 0054 (r1 A M I  OEMXSDT   8000729 MSFT       97)
ACPI: FACP C7FF0290, 00F4 (r3 A M I  OEMFACP   8000729 MSFT       97)
ACPI: DSDT C7FF0470, 3B36 (r1  0AAAA 0AAAA000        0 INTL  2002026)
ACPI: FACS C7FFE000, 0040
ACPI: APIC C7FF0390, 00DA (r1 A M I  OEMAPIC   8000729 MSFT       97)
ACPI: OEMB C7FFE040, 0056 (r1 A M I  AMI_OEM   8000729 MSFT       97)
ACPI: SRAT C7FF3FB0, 00E8 (r1 AMD    HAMMER          1 AMD         1)
ACPI: HPET C7FF40A0, 0038 (r1 A M I  OEMHPET   8000729 MSFT       97)
ACPI: SSDT C7FF40E0, 0A30 (r1 A M I  POWERNOW        1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-c8000000
Entering add_active_range(0, 0, 159) 1 entries of 3200 used
Entering add_active_range(0, 256, 819184) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-238000000
Entering add_active_range(0, 0, 159) 2 entries of 3200 used
Entering add_active_range(0, 256, 819184) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000238000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2326528
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   819184
    0:  1048576 ->  2326528
On node 0 totalpages: 2097039
  DMA zone: 56 pages used for memmap
  DMA zone: 3483 pages reserved
  DMA zone: 460 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 800808 pages, LIFO batch:31
  Normal zone: 17472 pages used for memmap
  Normal zone: 1260480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 5, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 6, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x0 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at cc000000 (gap: c8000000:36c00000)
PERCPU: Allocating 23592 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 2061748
Policy zone: Normal
Kernel command line: root=/dev/md1 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1895.280 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ c8000000 size 64 MB
Memory: 8246640k/9306112k available (8087k kernel code, 141516k
reserved, 4327k data, 476k init)
Calibrating delay using timer specific routine.. 3794.38 BogoMIPS (lpj=7588770)
Security Framework v1.0.0 initialized
Capability LSM initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 63k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12468942
Detected 12.468 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3790.94 BogoMIPS (lpj=7581899)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Quad-Core AMD Opteron(tm) Processor 2347 stepping 0a
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 3790.78 BogoMIPS (lpj=7581561)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Quad-Core AMD Opteron(tm) Processor 2347 stepping 0a
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 3790.75 BogoMIPS (lpj=7581512)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Quad-Core AMD Opteron(tm) Processor 2347 stepping 0a
Brought up 4 CPUs
xor: automatically using best checksumming function: generic_sse
   generic_sse:  7449.000 MB/sec
xor: using function: generic_sse (7449.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR28._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR32._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR3C._PRT]
ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 *7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  CA,
should be BF [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0700
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
Generic PHY: Registered new driver
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: match found with the PnP device '00:09' and the driver 'system'
pnp: 00:09: ioport range 0x580-0x58f has been reserved
pnp: 00:09: ioport range 0x590-0x593 has been reserved
pnp: 00:09: ioport range 0x700-0x703 has been reserved
pnp: 00:09: ioport range 0xca0-0xcaf has been reserved
pnp: 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:09: iomem range 0xfec01000-0xfec01fff could not be reserved
pnp: 00:09: iomem range 0xfec02000-0xfec02fff could not be reserved
pnp: 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: 00:0a: ioport range 0x600-0x61f has been reserved
pnp: 00:0a: ioport range 0x520-0x53f has been reserved
pnp: 00:0a: ioport range 0x540-0x54f has been reserved
pnp: 00:0a: ioport range 0x640-0x65f has been reserved
pnp: match found with the PnP device '00:0b' and the driver 'system'
pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
pnp: match found with the PnP device '00:0c' and the driver 'system'
pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0c: iomem range 0x0-0x0 could not be reserved
pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0c: iomem range 0x100000-0xc7ffffff could not be reserved
PCI: Bridge: 0000:01:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:01.0
  IO window: a000-bfff
  MEM window: ff400000-ff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: ff500000-ff5fffff
  PREFETCH window: cfe00000-cfefffff
PCI: Bridge: 0000:00:08.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
Time: acpi_pm clocksource has been installed.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1193347450.728:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.8)
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
OCFS2 1.3.3
OCFS2 Node Manager 1.3.3
OCFS2 DLM 1.3.3
OCFS2 DLMFS 1.3.3
OCFS2 User DLM kernel interface loaded
async_tx: api initialized (async)
io scheduler noop registered
io scheduler cfq registered (default)
PCI: Firmware left 0000:00:04.0 e100 interrupts enabled, disabling
PCI: Found enabled HT MSI Mapping on 0000:00:08.0
PCI: Found enabled HT MSI Mapping on 0000:00:09.0
PCI: Found enabled HT MSI Mapping on 0000:00:0a.0
PCI: Found enabled HT MSI Mapping on 0000:00:0b.0
Boot video device is 0000:00:0c.0
PCI: MSI quirk detected. MSI deactivated.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=200.00 Mhz, System=200.00 MHz
radeonfb: PLL min 12000 max 35000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type CRT found
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 80x30
radeonfb (0000:00:0c.0): ATI Radeon Q^
vga16fb: initializing
vga16fb: mapped to 0xffff8100000a0000
fb1: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
platform pc8736x_gpio.0: no device found
nsc_gpio initializing
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address
0xca8, slave address 0x20, irq 0
ipmi_si: Interface detection failed
ipmi_si: Unable to find any System Interface(s)
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
is 60 seconds).
Hangcheck: Using get_cycles().
pnp: the driver 'tpm_tis' has been registered
pnp: the driver 'tpm_inf_pnp' has been registered
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:05' and the driver 'serial'
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
loop: module loaded
nbd: registered device at major 43
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Intel(R) PRO/10GbE Network Driver - version 1.0.126-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target
module parameters must be specified, otherwise bonding will not detect
link failures! see bonding.txt for details.
pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
eepro100.c:v1.09j-t 9/29/99 Donald Becker
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V.
Savochkin <saw@saw.sw.com.sg> and others
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
eth0: 0000:00:04.0, 00:E0:81:47:C6:C9, IRQ 16.
  Board assembly 567812-052, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0xd0a6c714).
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
tg3.c:v3.81 (September 5, 2007)
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 26 (level, low) -> IRQ 26
eth1: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)]
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:47:c7:22
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76144000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:04:04.1[B] -> GSI 27 (level, low) -> IRQ 27
eth2: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)]
(PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:47:c7:23
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[76144000] dma_mask[40-bit]
Marvell 88E1101: Registered new driver
Marvell 88E1112: Registered new driver
Marvell 88E1111: Registered new driver
Marvell 88E1145: Registered new driver
Davicom DM9161E: Registered new driver
Davicom DM9161A: Registered new driver
Davicom DM9131: Registered new driver
Cicada Cis8204: Registered new driver
Cicada Cis8201: Registered new driver
LXT970: Registered new driver
LXT971: Registered new driver
QS6612: Registered new driver
SMSC LAN83C185: Registered new driver
Vitesse VSC8244: Registered new driver
Fixed PHY: Registered new driver
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller
(davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
myri10ge: Version 1.3.2-1.269
ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson
<johns393@maroon.tc.umn.edu>
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks HT1000: IDE controller at PCI slot 0000:00:02.1
SvrWks HT1000: chipset revision 0
SvrWks HT1000: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:pio, hdb:DMA
Probing IDE interface ide0...
hdb: DV-28E-R, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdb: ATAPI 24X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Adaptec aacraid driver 1.1-5[2449]-ms
scsi: <fdomain> Detection failed (no card)
QLogic Fibre Channel HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
DC390: clustering now enabled by default. If you get problems load
with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25
scsi0 : scsi_debug, version 1.81 [20070104], dev_size_mb=8, opts=0x0
sata_svw 0000:01:0e.0: version 2.3
scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:01:0e.0[A] -> GSI 11 (level, low) -> IRQ 11
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
sd 0:0:0:0: [sda] 16384 512-byte hardware sectors (8 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
scsi4 : sata_svw
ata1: SATA max UDMA/133 cmd 0xffffc20002d2c000 ctl 0xffffc20002d2c020
bmdma 0xffffc20002d2c030 irq 11
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
ata2: SATA max UDMA/133 cmd 0xffffc20002d2c100 ctl 0xffffc20002d2c120
bmdma 0xffffc20002d2c130 irq 11
ata3: SATA max UDMA/133 cmd 0xffffc20002d2c200 ctl 0xffffc20002d2c220
bmdma 0xffffc20002d2c230 irq 11
ata4: SATA max UDMA/133 cmd 0xffffc20002d2c300 ctl 0xffffc20002d2c320
bmdma 0xffffc20002d2c330 irq 11
sd 0:0:0:0: [sda] 16384 512-byte hardware sectors (8 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports
DPO and FUA
 sda: unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: WDC WD10EACS-00ZJB0, 01.01B01, max UDMA/133
ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EACS-00Z 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
aoe: AoE v32 initialised.
ACPI: PCI Interrupt 0000:00:03.2[A] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6eb000
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6e9000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:03.1[A] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ea000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver ldusb
usbcore: registered new interface driver usbled
pnp: the driver 'i8042 kbd' has been registered
pnp: the driver 'i8042 aux' has been registered
pnp: the driver 'i8042 kbd' has been unregistered
pnp: the driver 'i8042 aux' has been unregistered
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
pnp: the driver 'rtc_cmos' has been registered
pnp: match found with the PnP device '00:02' and the driver 'rtc_cmos'
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:02 does not support disabling.
rtc_cmos: probe of 00:02 failed with error -16
max6902 spi driver
i2c /dev entries driver
i2c-parport-light: adapter type unspecified
piix4_smbus 0000:00:02.0: Found 0000:00:02.0 device
i2c-adapter i2c-4: Unsupported chip (man_id=0x5C, chip_id=0x68).
i2c-adapter i2c-4: detect fail: address match, 0x2e
hwmon-vid: Unknown VRM version of your x86 CPU
 : Not supporting VRM 0.0
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
i2c-adapter i2c-4: lm85: Detected SMSC chip
i2c-adapter i2c-4: lm85: Unrecognized version/stepping 0x68 Defaulting
to Generic LM85.
hwmon-vid: Unknown VRM version of your x86 CPU
pc87360: PC8736x not detected, module not inserted.
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int64x1   1920 MB/s
raid6: int64x2   2353 MB/s
raid6: int64x4   2331 MB/s
raid6: int64x8   1254 MB/s
raid6: sse2x1    2664 MB/s
raid6: sse2x2    4214 MB/s
raid6: sse2x4    4905 MB/s
raid6: using algorithm sse2x4 (4905 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath emc: version 0.0.3 loaded
NET: Registered protocol family 26
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on
    Actions configured
Netfilter messages via NETLINK v0.30.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP scalable registered
TCP lp registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Ebtables v2.0 registered
NET: Registered protocol family 4
NET: Registered protocol family 5
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 2347
processors (4 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0x3 did 0x0 (1900 MHz)
powernow-k8:    1 : fid 0x1 did 0x0 (1700 MHz)
powernow-k8:    2 : fid 0xc did 0x1 (1400 MHz)
powernow-k8:    3 : fid 0x8 did 0x1 (1200 MHz)
powernow-k8:    4 : fid 0x4 did 0x1 (1000 MHz)
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md: sdc1 has different UUID to sdc2
md:  adding sdb2 ...
md: sdb1 has different UUID to sdc2
md: created md1
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: running: <sdc1><sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 476k freed
Adding 19342252k swap on /dev/sdb3.  Priority:-1 extents:1 across:19342252k
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth0: no IPv6 routers present
eth1: no IPv6 routers present
eth2: no IPv6 routers present
