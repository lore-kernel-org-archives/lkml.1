Return-Path: <linux-kernel-owner+w=401wt.eu-S2992910AbXDDOyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992910AbXDDOyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992909AbXDDOx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:53:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49028 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992910AbXDDOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:53:54 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
	 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
Content-Type: multipart/mixed; boundary="=-JZzWxCCv7akfvBZahA8N"
Date: Wed, 04 Apr 2007 07:53:57 -0700
Message-Id: <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JZzWxCCv7akfvBZahA8N
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-04-03 at 16:55 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > Hmm. booted fine with slub_debug :(
> 
> Try to selectively disable debug options... if you got the 
> time...
> 
> F.e. Try with sanity checks only
> 
> slub_debug=F

slub_debug=F got something. 



--=-JZzWxCCv7akfvBZahA8N
Content-Disposition: attachment; filename="slub_debug=F"
Content-Type: text/plain; name="slub_debug=F"; charset=utf-8
Content-Transfer-Encoding: 8bit

Linux version 2.6.21-rc5-mm4 (root@elm3b29) (gcc version 4.1.0 (SUSE Linux)) #2 SMP Tue Apr 3 17:36:21 PDT 2007
Command line: root=/dev/hda2 vga=0x314  slub_debug=F selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfef0000 (usable)
 BIOS-e820: 00000000dfef0000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (ACPI NVS)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001e0000000 (usable)
end_pfn_map = 1966080
DMI 2.3 present.
ACPI: RSDP 000F6970, 0024 (r2 PTLTD )
ACPI: XSDT DFEFC625, 003C (r1 PTLTD  	 XSDT    6040000  LTP        0)
ACPI: FACP DFEFED02, 00F4 (r3 AMD    HAMMER    6040000 PTEC    F4240)
ACPI: DSDT DFEFC661, 262D (r1 AMD-K8  AMDACPI  6040000 MSFT  100000D)
ACPI: FACS DFEFFFC0, 0040
ACPI: SRAT DFEFEDF6, 0160 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: APIC DFEFEF56, 00AA (r1 PTLTD  	 APIC    6040000  LTP        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: PXM 2 -> APIC 2 -> Node 2
SRAT: PXM 3 -> APIC 3 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-e0000000
SRAT: Node 0 PXM 0 0-180000000
SRAT: PXM 1 (100000000-1a0000000) overlaps with PXM 0 (0-180000000)
SRAT: SRAT not used.
Scanning NUMA topology in Northbridge 24
Number of nodes 4
Node 0 MemBase 0000000000000000 Limit 0000000180000000
Node 1 MemBase 0000000180000000 Limit 00000001a0000000
Node 2 MemBase 00000001a0000000 Limit 00000001c0000000
Node 3 MemBase 00000001c0000000 Limit 00000001e0000000
Using node hash shift of 29
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-00000001a0000000
Bootmem setup node 2 00000001a0000000-00000001c0000000
Bootmem setup node 3 00000001c0000000-00000001e0000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1966080
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917232
    0:   917248 ->   917504
    0:  1048576 ->  1572864
    1:  1572864 ->  1703936
    2:  1703936 ->  1835008
    3:  1835008 ->  1966080
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfa3e0000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xfa3e0000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xfa3e1000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xfa3e1000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xfa3e2000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xfa3e2000, GSI 32-35
ACPI: IOAPIC (id[0x08] address[0xfa3e4000] gsi_base[36])
IOAPIC[4]: apic_id 8, address 0xfa3e4000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
PERCPU: Allocating 41984 bytes of per cpu data
Built 4 zonelists.  Total pages: 1771993
Kernel command line: root=/dev/hda2 vga=0x314  slub_debug=F selinux=0   console=tty0 console=ttyS0,38400 resume=/dev/hda1 resume=/dev/hda1  splash=silent showopts
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1398.218 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 7021948k/7864320k available (3113k kernel code, 317632k reserved, 1229k data, 364k init)
SLUB V6: General Slabs=18, HW alignment=128, Processors=4, Nodes=64
Calibrating delay using timer specific routine.. 2798.99 BogoMIPS (lpj=5597989)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12484097
Detected 12.484 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593188)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 1
Opteron MP w/ 1MB stepping 00
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593187)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 2
Opteron MP w/ 1MB stepping 00
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 2796.59 BogoMIPS (lpj=5593189)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 3
Opteron MP w/ 1MB stepping 00
Brought up 4 CPUs
migration_cost=0,769
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
ACPI: PCI Root Bridge [PCI1] (0000:08)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
*** SLUB: Freepointer corrupt in kmalloc-16@0xffff8100001e22a0 Slab 0xffff81017400f100
    offset=672 flags=0x00c7 inuse=42 freelist=0xffff8100001e22a0
  Bytes b4 0xffff8100001e2290:  a0 22 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 ."..............
    Object 0xffff8100001e22a0:  00 00 00 00 00 81 ff ff 00 00 00 00 00 00 00 00 ......ÿÿ........
FreePointer 0xffff8100001e22a0 -> 0xffff810000000000

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff802dcb27>] sysfs_create_link+0xb7/0x160
 [<ffffffff8024f431>] module_add_driver+0x41/0xd0
 [<ffffffff8040241e>] bus_add_driver+0xce/0x1d0
 [<ffffffff8040324d>] driver_register+0x5d/0x90
 [<ffffffff803a16a8>] __pci_register_driver+0x68/0xb0
 [<ffffffff806d6066>] agp_amd64_init+0x36/0xe0
 [<ffffffff806c3ad6>] gart_iommu_init+0x4c6/0x560
 [<ffffffff80227a8e>] __wake_up+0x4e/0x70
 [<ffffffff80495eb0>] genl_rcv+0x0/0x70
 [<ffffffff8049432c>] netlink_kernel_create+0x14c/0x160
 [<ffffffff80495cd0>] genl_unlock+0x10/0x40
 [<ffffffff806bc8de>] pci_iommu_init+0xe/0x20
 [<ffffffff806b2a04>] kernel_init+0x154/0x330
 [<ffffffff8020a8c8>] child_rip+0xa/0x12
 [<ffffffff806b28b0>] kernel_init+0x0/0x330
 [<ffffffff8020a8be>] child_rip+0x0/0x12

PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:05: ioport range 0x4d0-0x4d1 has been reserved
Time: tsc clocksource has been installed.
pnp: 00:05: ioport range 0x1100-0x117f has been reserved
pnp: 00:05: ioport range 0x1180-0x11ff has been reserved
pnp: 00:06: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:06: iomem range 0xc0000-0xc87ff has been reserved
pnp: 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:06: iomem range 0xffc00000-0xfff7ffff has been reserved
PCI: Bridge: 0000:00:06.0
Time: acpi_pm clocksource has been installed.
  IO window: 2000-2fff
  MEM window: fa000000-fa0fffff
  PREFETCH window: e2000000-e20fffff
PCI: Bridge: 0000:09:01.0
  IO window: disabled.
  MEM window: fa400000-faffffff
  PREFETCH window: fc000000-fdffffff
PCI: Bridge: 0000:08:01.0
  IO window: disabled.
  MEM window: fa400000-faffffff
  PREFETCH window: fc000000-fdffffff
PCI: Bridge: 0000:08:02.0
  IO window: 3000-3fff
  MEM window: fb000000-fb0fffff
  PREFETCH window: e2100000-e21fffff
PCI: Bridge: 0000:08:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:04.0
  IO window: 4000-4fff
  MEM window: fb100000-fb1fffff
  PREFETCH window: e2200000-e22fffff
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 36 (level, low) -> IRQ 36
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
vesafb: framebuffer at 0xfc000000, mapped to 0xffffc20002780000, using 1875k, total 16384k
vesafb: mode is 800x600x16, linelength=1600, pages=16
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
AMD768 RNG detected
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
loop: module loaded
tg3.c:v3.75 (March 23, 2007)
ACPI: PCI Interrupt 0000:19:02.0[A] -> GSI 38 (level, low) -> IRQ 38
eth0: Tigon3 [partno(3C996B-T) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:04:76:f0:f9:aa
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff000f] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0x1020-0x1027, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1028-0x102f, BIOS settings: hdc:DMA, hdd:pio
hda: IC35L080AVVA07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: TOSHIBA DVD-ROM SD-M1612, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2
hdc: ATAPI 48X DVD-ROM drive, 512kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: PS/2 Generic Mouse as /class/input/input2
async_tx: api initialized (sync-only)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  4489.000 MB/sec
xor: using function: generic_sse (4489.000 MB/sec)
TCP cubic registered
NET: Registered protocol family 1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: hda2: found reiserfs format "3.6" with standard journal
ReiserFS: hda2: using ordered data mode
ReiserFS: hda2: journal params: device hda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda2: checking transaction log (hda2)
ReiserFS: hda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 364k freed
INIT: version 2.86 booting
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting sysfs at /sys7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting tmpfs at /dev7[?25l[80C[10D[1;32mdone[m8[?25h
Initializing /dev7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting devpts at /dev/pts7[?25l[80C[10D[1;32mdone[m8[?25h
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
lp0: using parport0 (interrupt-driven).
Starting udevd hwup invoked oom-killer: gfp_mask=0xd1, order=0, oomkilladj=-17

Call Trace:
hwup invoked oom-killer: gfp_mask=0x40d1, order=2, oomkilladj=-17
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff8025f363>] find_lock_page+0x33/0xb0
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff8028b6b9>] get_empty_filp+0x39/0x160
 [<ffffffff8029620a>] __path_lookup_intent_open+0x3a/0xc0
 [<ffffffff8029631c>] path_lookup_open+0xc/0x10
 [<ffffffff80296430>] open_namei+0x70/0x6d0
 [<ffffffff80291f8c>] path_release+0x2c/0x40
 [<ffffffff8028dd78>] cp_new_stat+0xf8/0x120
 [<ffffffff80283ec9>] check_valid_pointer+0x29/0x90
 [<ffffffff80288908>] do_filp_open+0x28/0x50
 [<ffffffff80284b09>] alloc_object_checks+0x99/0x110
 [<ffffffff80288576>] get_unused_fd+0x76/0x110
 [<ffffffff8028898a>] do_sys_open+0x5a/0xf0
 [<ffffffff80288a4b>] sys_open+0x1b/0x20
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:5861 inactive:1292 dirty:0 writeback:0 unstable:0
 free:1733706 slab:2596 mapped:658 pagetables:690 bounce:0
Node 0 DMA free:120kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587656kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1884664kB min:3052kB low:3812kB high:4576kB active:3388kB inactive:32kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:491864kB min:760kB low:948kB high:1140kB active:3568kB inactive:164kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:491476kB min:760kB low:948kB high:1140kB active:4608kB inactive:132kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:479044kB min:760kB low:948kB high:1140kB active:11880kB inactive:4840kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 28*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 112kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 61*4kB 84*8kB 25*16kB 17*32kB 2*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1884740kB
Node 1 Normal: 154*4kB 59*8kB 14*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 492032kB
Node 2 Normal: 111*4kB 63*8kB 27*16kB 11*32kB 2*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 491588kB
Node 3 Normal: 96*4kB 79*8kB 24*16kB 10*32kB 2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 479160kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
14803 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 1897 (hwup) score 0 or a child

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
hwup invoked oom-killer: gfp_mask=0x40d1, order=2, oomkilladj=-17
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80291f8c>] path_release+0x2c/0x40
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a1ade>] expand_files+0xce/0x300
 [<ffffffff8022d881>] dup_fd+0x2a1/0x2f0
 [<ffffffff8022d924>] copy_files+0x54/0x80
 [<ffffffff80247702>] ktime_get_ts+0x52/0x60
 [<ffffffff8022e307>] copy_process+0x547/0x1420
 [<ffffffff8022f24d>] do_fork+0x6d/0x1c0
 [<ffffffff80239612>] recalc_sigpending+0x12/0x20
 [<ffffffff8023968a>] sigprocmask+0x6a/0xf0
 [<ffffffff80209aae>] system_call+0x7e/0x83
 [<ffffffff80207f63>] sys_clone+0x23/0x30
 [<ffffffff80209dc7>] ptregscall_common+0x67/0xb0

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:   0
Active:3861 inactive:1312 dirty:0 writeback:0 unstable:0
 free:1736204 slab:2538 mapped:674 pagetables:335 bounce:0
Node 0 DMA free:348kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587656kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1886200kB min:3052kB low:3812kB high:4576kB active:2080kB inactive:228kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495236kB min:760kB low:948kB high:1140kB active:896kB inactive:108kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:493600kB min:760kB low:948kB high:1140kB active:2832kB inactive:56kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:481776kB min:760kB low:948kB high:1140kB active:9636kB inactive:4856kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 38*4kB 24*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 360kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 123*4kB 86*8kB 71*16kB 28*32kB 7*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1886412kB
Node 1 Normal: 65*4kB 84*8kB 68*16kB 38*32kB 12*64kB 5*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495396kB
Node 2 Normal: 172*4kB 130*8kB 70*16kB 20*32kB 4*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 493728kB
Node 3 Normal: 36*4kB 96*8kB 69*16kB 29*32kB 14*64kB 7*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 481920kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
7736 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 1981 (hwup) score 0 or a child
hwup invoked oom-killer: gfp_mask=0x40d1, order=2, oomkilladj=-17

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80291f8c>] path_release+0x2c/0x40
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff8026b7ea>] __inc_zone_page_state+0x2a/0x30
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff802a1ade>] expand_files+0xce/0x300
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff8022d881>] dup_fd+0x2a1/0x2f0
 [<ffffffff8022de80>] copy_process+0xc0/0x1420
 [<ffffffff8022d924>] copy_files+0x54/0x80
 [<ffffffff80241714>] alloc_pid+0x1d4/0x320
 [<ffffffff80247702>] ktime_get_ts+0x52/0x60
 [<ffffffff8022f24d>] do_fork+0x6d/0x1c0
 [<ffffffff8022e307>] copy_process+0x547/0x1420
 [<ffffffff80239612>] recalc_sigpending+0x12/0x20
 [<ffffffff8022f24d>] do_fork+0x6d/0x1c0
 [<ffffffff8023968a>] sigprocmask+0x6a/0xf0
 [<ffffffff80239612>] recalc_sigpending+0x12/0x20
 [<ffffffff80209aae>] system_call+0x7e/0x83
 [<ffffffff8023968a>] sigprocmask+0x6a/0xf0
 [<ffffffff80207f63>] sys_clone+0x23/0x30
 [<ffffffff80209aae>] system_call+0x7e/0x83
 [<ffffffff80209dc7>] ptregscall_common+0x67/0xb0
 [<ffffffff80207f63>] sys_clone+0x23/0x30

Mem-info:
 [<ffffffff80209dc7>] ptregscall_common+0x67/0xb0
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:3853 inactive:1316 dirty:0 writeback:0 unstable:0
 free:1736289 slab:2539 mapped:652 pagetables:313 bounce:0
Node 0 DMA free:344kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587656kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1886304kB min:3052kB low:3812kB high:4576kB active:2128kB inactive:244kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495136kB min:760kB low:948kB high:1140kB active:1100kB inactive:108kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:493868kB min:760kB low:948kB high:1140kB active:2616kB inactive:56kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:481848kB min:760kB low:948kB high:1140kB active:9568kB inactive:4856kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 37*4kB 25*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 364kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 123*4kB 86*8kB 71*16kB 28*32kB 7*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1886412kB
Node 1 Normal: CPU    1: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
1*4kB 80*8kB 69*16kB 38*32kB 12*64kB 5*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495124kB
Node 2 Normal: CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
183*4kB 138*8kB 74*16kB 23*32kB 4*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 493996kB
Node 3 Normal: Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
35*4kB 96*8kB 69*16kB 29*32kB 14*64kB 7*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 481916kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:3853 inactive:1316 dirty:0 writeback:0 unstable:0
 free:1736289 slab:2539 mapped:652 pagetables:313 bounce:0
Node 0 DMA free:344kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587656kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1886304kB min:3052kB low:3812kB high:4576kB active:2128kB inactive:244kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495136kB min:760kB low:948kB high:1140kB active:1100kB inactive:108kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:493868kB min:760kB low:948kB high:1140kB active:2616kB inactive:56kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:481848kB min:760kB low:948kB high:1140kB active:9568kB inactive:4856kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 37*4kB 25*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 364kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 123*4kB 86*8kB 71*16kB 28*32kB 7*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1886412kB
Node 1 Normal: 1*4kB 80*8kB 69*16kB 38*32kB 12*64kB 5*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495124kB
Node 2 Normal: 183*4kB 138*8kB 74*16kB 23*32kB 4*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 493996kB
Node 3 Normal: 35*4kB 96*8kB 69*16kB 29*32kB 14*64kB 7*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 481916kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
7735 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 1923 (hwup) score 0 or a child
1966080 pages of RAM
210493 reserved pages
7735 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 1981 (hwup) score 0 or a child
startpar: page allocation failure. order:4, mode:0x40d1

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff80264857>] __alloc_pages+0x2d7/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
ERROR: could not read /proc/stat: Cannot allocate memory
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd: 153   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:  48   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  25   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:  35   Cold: hi:   62, btch:  15 usd:   7
Active:3241 inactive:1376 dirty:0 writeback:0 unstable:0
 free:1736624 slab:2506 mapped:713 pagetables:251 bounce:0
Node 0 DMA free:540kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1886096kB min:3052kB low:3812kB high:4576kB active:836kB inactive:220kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495200kB min:760kB low:948kB high:1140kB active:1224kB inactive:104kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:495544kB min:760kB low:948kB high:1140kB active:1368kB inactive:96kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:481336kB min:760kB low:948kB high:1140kB active:9536kB inactive:5084kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 1*8kB 8*16kB 9*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 492kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 1*4kB 0*8kB 44*16kB 46*32kB 11*64kB 4*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1886276kB
Node 1 Normal: 1*4kB 52*8kB 68*16kB 37*32kB 12*64kB 6*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495236kB
Node 2 Normal: 159*4kB 97*8kB 76*16kB 41*32kB 19*64kB 6*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 495652kB
Node 3 Normal: 72*4kB 83*8kB 39*16kB 24*32kB 12*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 481448kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
6669 pages shared
0 pages swap cached
startpar invoked oom-killer: gfp_mask=0x40d1, order=4, oomkilladj=0

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:3168 inactive:1583 dirty:0 writeback:0 unstable:0
 free:1736890 slab:2589 mapped:704 pagetables:181 bounce:0
Node 0 DMA free:164kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1887696kB min:3052kB low:3812kB high:4576kB active:716kB inactive:288kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:494092kB min:760kB low:948kB high:1140kB active:1628kB inactive:1012kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496156kB min:760kB low:948kB high:1140kB active:724kB inactive:104kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:481672kB min:760kB low:948kB high:1140kB active:9604kB inactive:4928kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 6*4kB 10*8kB 2*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 200kB

telnet> send brk
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 169*4kB 79*8kB 58*16kB 47*32kB 13*64kB 4*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1887964kB
Node 1 Normal: 158*4kB 60*8kB 17*16kB 12*32kB 10*64kB 6*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 494184kB
Node 2 Normal: 74*4kB 58*8kB 50*16kB 43*32kB 24*64kB 10*128kB 4*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 496248kB
Node 3 Normal: 150*4kB 83*8kB 39*16kB 24*32kB 12*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 481760kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
5195 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 972 (startpar) score 0 or a child
Killed process 974 (boot.rootfsck)
startpar: page allocation failure. order:4, mode:0x40d1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff80264857>] __alloc_pages+0x2d7/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83
ERROR: could not read /proc/stat: Cannot allocate memory
7[?25l[80C[10D[1;32mdone[m8[?25h

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  39   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:  34   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:  39   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   4   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd:   8
Active:2171 inactive:1644 dirty:0 writeback:0 unstable:0
 free:1737676 slab:2597 mapped:398 pagetables:94 bounce:0
Node 0 DMA free:196kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1887300kB min:3052kB low:3812kB high:4576kB active:368kB inactive:284kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495500kB min:760kB low:948kB high:1140kB active:332kB inactive:1000kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496640kB min:760kB low:948kB high:1140kB active:260kB inactive:104kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:483288kB min:760kB low:948kB high:1140kB active:7724kB inactive:5188kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 36*4kB 7*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 216kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 94*4kB 72*8kB 54*16kB 48*32kB 13*64kB 4*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1887576kB
Node 1 Normal: 52*4kB 83*8kB 61*16kB 34*32kB 12*64kB 6*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495480kB
Node 2 Normal: 43*4kB 42*8kB 36*16kB 34*32kB 26*64kB 11*128kB 8*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 496764kB
Node 3 Normal: 214*4kB 143*8kB 73*16kB 37*32kB 13*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 483392kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
1421 pages shared
0 pages swap cached
startpar invoked oom-killer: gfp_mask=0x40d1, order=4, oomkilladj=0

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff80273a7f>] do_mmap_pgoff+0x61f/0x8b0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:2171 inactive:1644 dirty:0 writeback:0 unstable:0
 free:1738133 slab:2590 mapped:398 pagetables:94 bounce:0
Node 0 DMA free:196kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888292kB min:3052kB low:3812kB high:4576kB active:368kB inactive:284kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495652kB min:760kB low:948kB high:1140kB active:332kB inactive:1000kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496564kB min:760kB low:948kB high:1140kB active:260kB inactive:104kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:484048kB min:760kB low:948kB high:1140kB active:7724kB inactive:5188kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 36*4kB 9*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 232kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 88*4kB 88*8kB 75*16kB 51*32kB 14*64kB 7*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1888560kB
Node 1 Normal: 71*4kB 85*8kB 59*16kB 31*32kB 17*64kB 6*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495764kB
Node 2 Normal: 13*4kB 41*8kB 36*16kB 34*32kB 26*64kB 11*128kB 8*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 496636kB
Node 3 Normal: 210*4kB 145*8kB 89*16kB 42*32kB 16*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 484128kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
1515 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 2335 (startpar) score 0 or a child
Killed process 2335 (startpar)
startpar: page allocation failure. order:4, mode:0x40d1

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff80264857>] __alloc_pages+0x2d7/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff80273a7f>] do_mmap_pgoff+0x61f/0x8b0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:2171 inactive:1644 dirty:0 writeback:0 unstable:0
 free:1738133 slab:2590 mapped:398 pagetables:94 bounce:0
Node 0 DMA free:196kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888292kB min:3052kB low:3812kB high:4576kB active:368kB inactive:284kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495652kB min:760kB low:948kB high:1140kB active:332kB inactive:1000kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496564kB min:760kB low:948kB high:1140kB active:260kB inactive:104kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:484048kB min:760kB low:948kB high:1140kB active:7724kB inactive:5188kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 36*4kB 9*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 232kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 88*4kB 88*8kB 75*16kB 51*32kB 14*64kB 7*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1888560kB
Node 1 Normal: 71*4kB 85*8kB 59*16kB 31*32kB 17*64kB 6*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495764kB
Node 2 Normal: 13*4kB 41*8kB 36*16kB 34*32kB 26*64kB 11*128kB 8*256kB 0*512kB 0*1024kB 1*2048kB 119*4096kB = 496636kB
Node 3 Normal: 210*4kB 145*8kB 89*16kB 42*32kB 16*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 484128kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
1515 pages shared
0 pages swap cached
Activating swap-devices in /etc/fstab...
7[?25l[1A[80C[10D[1;32mdone[m8[?25hshowconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
/bin/mknod -m600 /dev/shm/root b 3 2
Checking root file system...
fsck 1.40-WIP (02-Oct-2006)
[/sbin/fsck.reiserfs (1) -- /dev/shm/root] fsck.reiserfs -a /dev/shm/root 
Reiserfs super block in block 16 on 0x302 of format 3.6 with standard journal
Blocks (total/free): 19842352/8198608 by 4096 bytes
Filesystem is clean
Filesystem seems mounted read-only. Skipping journal replay.
Checking internal tree..finished
Activating device mapper...
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
7[?25l[80C[10D[1;32mdone[m8[?25h
Loading required kernel modules
7[?25l[1A[80C[10D[1;32mdone[m8[?25hStarting MD Raid 
telnet> q 
7[?25l[80C[10D[1;32mdone[m8[?25h
Waiting for udev to settle...
Scanning for LVM volume groups...
  Locking type 1 initialisation failed.
Activating LVM volume groups...
  Locking type 1 initialisation failed.
7[?25l[80C[10D[1;33mskipped[m8[?25h
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Checking file systems...
fsck 1.40-WIP (02-Oct-2006)
Checking all file systems.
7[?25l[1A[80C[10D[1;32mdone[m8[?25hrm: cannot remove `/success': Read-only file system
7[?25l[80C[10D[1;31mfailed[m8[?25h
Mounting local file systems...
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
nothing was mounted
7[?25l[1A[80C[10D[1;32mdone[m8[?25hSetting up the hardware clock7[?25l[80C[10D[1;32mdone[m8[?25h
FATAL: Module apparmor not found.
Loading AppArmor module [80C[10D[1;31mfailed[m
- could not start AppArmor[80C[10D[1;31mfailed[m
rm: cannot remove `/tmp/ssh-vbEyrP3915/agent.3915': Read-only file system
/etc/init.d/boot.cleanup: line 48: /var/run/utmp: Read-only file system
Setting up hostname 'elm3b29'7startpar invoked oom-killer: gfp_mask=0x40d1, order=4, oomkilladj=0
[?25l[80C[10D[1;32mdone[m8[?25h
Setting up loopback interface     lo        
    lo        IP address: 127.0.0.1/8   
7[?25l[80C[10D[1;32mdone[m8[?25h
mv: cannot move `/v
ar/log/boot.msg' to `/var/log/boot.omsg': Read-only file system
Creating /var/log/boot.msg
Can't open or create /var/run/klogd.pid.
Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff80228bf6>] nr_context_switches+0x46/0x60
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff80286551>] __kmalloc+0x21/0x30
 [<ffffffff802a7fd8>] seq_read+0xc8/0x2e0
 [<ffffffff80273a7f>] do_mmap_pgoff+0x61f/0x8b0
 [<ffffffff802ccef1>] proc_reg_read+0x81/0xe0
 [<ffffffff8028aa81>] vfs_read+0xe1/0x190
 [<ffffffff8028af30>] sys_read+0x50/0x90
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:1271 inactive:451 dirty:0 writeback:0 unstable:0
 free:1740655 slab:2235 mapped:391 pagetables:105 bounce:0
Node 0 DMA free:1608kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888632kB min:3052kB low:3812kB high:4576kB active:644kB inactive:100kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:496420kB min:760kB low:948kB high:1140kB active:568kB inactive:36kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496888kB min:760kB low:948kB high:1140kB active:76kB inactive:44kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:491292kB min:760kB low:948kB high:1140kB active:3796kB inactive:1624kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 18*4kB 90*8kB 34*16kB 7*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1624kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 59*4kB 84*8kB 62*16kB 38*32kB 22*64kB 10*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 459*4096kB = 1888940kB
Node 1 Normal: 73*4kB 56*8kB 46*16kB 30*32kB 21*64kB 8*128kB 5*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 496580kB
Node 2 Normal: 41*4kB 26*8kB 25*16kB 19*32kB 16*64kB 8*128kB 4*256kB 2*512kB 2*1024kB 1*2048kB 119*4096kB = 496996kB
Node 3 Normal: 240*4kB 154*8kB 101*16kB 61*32kB 37*64kB 18*128kB 5*256kB 1*512kB 0*1024kB 2*2048kB 116*4096kB = 491456kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
1966080 pages of RAM
210493 reserved pages
1396 pages shared
7[?25l[1A[80C[10D[1;32mdone[m8[?25h0 pages swap cached
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
No available memory (MPOL_BIND): kill process 2535 (startpar) score 0 or a child
Killed process 2535 (startpar)
Activating remaining swap-devices in /etc/fstab...
Adding 1048784k swap on /dev/hda1.  Priority:-1 extents:1 across:1048784k
7[?25l[1A[80C[10D[1;32mdone[m8[?25hSetting current sysctl status from /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
7[?25l[80C[10D[1;32mdone[m8[?25h
Enabling syn flood protection[80C[10D[1;32mdone[m
Disabling IP forwarding7[?25l[80C[10D[1;32mdone[m8[?25h
7[?25l[80C[10D[1;32mdone[m8[?25h
System Boot Control: The system has been [80C[10D[1mset up[m
Failed features: [80C[33D[1;31mboot.rootfsck boot.cleanup[m
Skipped features: [80C[17D[1;33mboot.cycle[m
System Boot Control: Running /etc/init.d/boot.local
7[?25l[1A[80C[10D[1;32mdone[m8[?25hINIT: Entering runlevel: 3
blogd: Warning: the ioctl TIOCGDEV is not known by the kernel
Boot logging started on /dev/ttyS0(/dev/console) at Wed Apr  4 08:52:44 2007
Master Resource Control: previous runlevel: N, switching to runlevel: [80C[10D[1m3[m
Initializing random number generatorchmod: changing permissions of `/var/lib/misc/random-seed': Read-only file system
7[?25l[80C[10D[1;31mfailed[m8[?25h
Starting D-BUS daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting resource manager7[?25l[80C[10D[1;31mfailed[m8[?25h
FATAL: Module apparmor not found.
Loading AppArmor module [80C[10D[1;31mfailed[m
- could not start AppArmor[80C[10D[1;31mfailed[m
Failed to start message bus: Failed to bind socket "/var/run/dbus/system_bus_socket": Read-only file system
Starting irqbalance 7[?25l[80C[10D[1;32mdone[m8[?25h
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input4
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
chgrp: changing group of `/opt/ibm/ewlm/ms/usr/sbin/ewlmarmd': Read-only file system
/bin/rm: cannot remove directory `/tmp/ewlmarm4': Read-only file system
chgrp: changing group of `/tmp/ewlmarm4': Read-only file system
Starting EWLM daemon
acpid: loading ACPI modules ( ac battery button fan processor thermal ) 7[?25l[80C[10D[1;32mdone[m8[?25h
acpid: will skip unsupported modules
acpid: loading ACPI laptop modules ( ) 7[?25l[80C[10D[1;32mdone[m8[?25h
Starting acpid acpid: can't open socket /var/run/acpid.socket: Address already in use
startproc:  exit status of parent of /sbin/acpid: 1
7[?25l[80C[10D[1;31mfailed[m8[?25h
Starting HAL daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Setting up network interfaces:
hald-probe-pc-f: page allocation failure. order:3, mode:0x10d1

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff80264857>] __alloc_pages+0x2d7/0x3d0
 [<ffffffff803902fa>] kobject_get+0x1a/0x30
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80263ede>] __get_free_pages+0xe/0x40
 [<ffffffff88029d63>] :floppy:dma_mem_alloc+0x23/0x30
 [<ffffffff8802ba86>] :floppy:floppy_open+0x2f6/0x410
 [<ffffffff802b45b0>] blkdev_open+0x0/0x80
 [<ffffffff802b40fd>] do_open+0xad/0x320
 [<ffffffff802b45b0>] blkdev_open+0x0/0x80
 [<ffffffff802b45ee>] blkdev_open+0x3e/0x80
 [<ffffffff802886e8>] __dentry_open+0xd8/0x200
 [<ffffffff802888cc>] nameidata_to_filp+0x3c/0x50
 [<ffffffff8028892a>] do_filp_open+0x4a/0x50
 [<ffffffff80288576>] get_unused_fd+0x76/0x110
 [<ffffffff8028898a>] do_sys_open+0x5a/0xf0
 [<ffffffff80288a4b>] sys_open+0x1b/0x20
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:2522 inactive:1367 dirty:0 writeback:0 unstable:0
 free:1738153 slab:2384 mapped:816 pagetables:116 bounce:0
Node 0 DMA free:948kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888984kB min:3052kB low:3812kB high:4576kB active:620kB inactive:116kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:495612kB min:760kB low:948kB high:1140kB active:1164kB inactive:164kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:495536kB min:760kB low:948kB high:1140kB active:1228kB inactive:40kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:483752kB min:760kB low:948kB high:1140kB active:7076kB inactive:5148kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 57*8kB 29*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 968kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 129*4kB 97*8kB 17*16kB 34*32kB 18*64kB 9*128kB 4*256kB 2*512kB 0*1024kB 1*2048kB 459*4096kB = 1889116kB
Node 1 Normal: 100*4kB 84*8kB 21*16kB 17*32kB 11*64kB 10*128kB 5*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 495712kB
Node 2 Normal: 141*4kB 93*8kB 32*16kB 11*32kB 2*64kB 1*128kB 3*256kB 2*512kB 2*1024kB 1*2048kB 119*4096kB = 495740kB
Node 3 Normal: 191*4kB 167*8kB 77*16kB 38*32kB 27*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 483844kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1048784kB
Total swap = 1048784kB
Free swap:       1048784kB
1966080 pages of RAM
210493 reserved pages
2941 pages shared
0 pages swap cached
    lo        
    lo        IP address: 127.0.0.1/8   
7[?25l[1A[80C[10D[1;32mdone[m8[?25h    eth0      device: Broadcom Corporation NetXtreme BCM5701 Gigabit Ethernet (rev 15)
    eth0      configuration: eth-id-00:04:76:f0:f9:aa
ip invoked oom-killer: gfp_mask=0x40d1, order=4, oomkilladj=0

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff802628d4>] out_of_memory+0x254/0x2b0
 [<ffffffff80215a92>] smp_call_function+0x42/0x70
 [<ffffffff802647fc>] __alloc_pages+0x27c/0x3d0
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
/sbin/ifup: line 1045:  2997 Killed                  ip link set up dev $INTERFA [<ffffffff802861d9>] kmem_cache_zalloc+0x19/0x40
CE ${LLADDR:+address $LLADDR} $LINK_OPTIONS
Cannot enable interface eth0.
 [<ffffffff8041bc64>] tg3_open+0xa4/0x630
 [<ffffffff8026ca06>] __do_fault+0x196/0x3a0
 [<ffffffff8047d780>] dev_open+0x40/0x90
 [<ffffffff8047b3bd>] dev_change_flags+0x6d/0x160
 [<ffffffff804c941d>] devinet_ioctl+0x58d/0x760
 [<ffffffff8047d489>] dev_ioctl+0x249/0x320
 [<ffffffff804c992d>] inet_ioctl+0x5d/0x80
 [<ffffffff8046f596>] sock_ioctl+0x56/0x230
 [<ffffffff802979a1>] do_ioctl+0x31/0x90
 [<ffffffff80297a73>] vfs_ioctl+0x73/0x2c0
 [<ffffffff80297d51>] sys_ioctl+0x91/0xb0
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:   0
Active:1734 inactive:1038 dirty:0 writeback:0 unstable:0
 free:1739355 slab:2334 mapped:591 pagetables:118 bounce:0
Node 0 DMA free:1180kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888220kB min:3052kB low:3812kB high:4576kB active:968kB inactive:312kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:496192kB min:760kB low:948kB high:1140kB active:784kB inactive:108kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496508kB min:760kB low:948kB high:1140kB active:460kB inactive:140kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:487540kB min:760kB low:948kB high:1140kB active:4724kB inactive:3592kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 16*4kB 52*8kB 37*16kB 4*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1200kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 147*4kB 111*8kB 62*16kB 27*32kB 7*64kB 3*128kB 4*256kB 2*512kB 0*1024kB 1*2048kB 459*4096kB = 1888324kB
Node 1 Normal: 106*4kB 81*8kB 42*16kB 21*32kB 13*64kB 10*128kB 5*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 496304kB
Node 2 Normal: 103*4kB 88*8kB 45*16kB 21*32kB 9*64kB 2*128kB 3*256kB 2*512kB 2*1024kB 1*2048kB 119*4096kB = 496652kB
Node 3 Normal: 329*4kB 190*8kB 100*16kB 53*32kB 38*64kB 7*128kB 4*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 487668kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1048784kB
Total swap = 1048784kB
Free swap:       1048784kB
1966080 pages of RAM
210493 reserved pages
2219 pages shared
0 pages swap cached
No available memory (MPOL_BIND): kill process 2997 (ip) score 0 or a child
Killed process 2997 (ip)
ip: page allocation failure. order:4, mode:0x40d1

Call Trace:
 [<ffffffff80230e35>] printk_ratelimit+0x15/0x20
 [<ffffffff80264857>] __alloc_pages+0x2d7/0x3d0
 [<ffffffff8027ea8a>] alloc_pages_current+0x5a/0x90
 [<ffffffff80285014>] new_slab+0x244/0x290
 [<ffffffff80286154>] kmem_cache_alloc+0x134/0x1a0
 [<ffffffff802861d9>] kmem_cache_zalloc+0x19/0x40
 [<ffffffff8041bc64>] tg3_open+0xa4/0x630
 [<ffffffff8026ca06>] __do_fault+0x196/0x3a0
 [<ffffffff8047d780>] dev_open+0x40/0x90
 [<ffffffff8047b3bd>] dev_change_flags+0x6d/0x160
 [<ffffffff804c941d>] devinet_ioctl+0x58d/0x760
 [<ffffffff8047d489>] dev_ioctl+0x249/0x320
 [<ffffffff804c992d>] inet_ioctl+0x5d/0x80
 [<ffffffff8046f596>] sock_ioctl+0x56/0x230
 [<ffffffff802979a1>] do_ioctl+0x31/0x90
 [<ffffffff80297a73>] vfs_ioctl+0x73/0x2c0
 [<ffffffff80297d51>] sys_ioctl+0x91/0xb0
 [<ffffffff80209aae>] system_call+0x7e/0x83

Mem-info:
Node 0 DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 0 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 1 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 2 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Node 3 Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
CPU    3: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15 usd:   0
Active:1734 inactive:1038 dirty:0 writeback:0 unstable:0
 free:1739355 slab:2334 mapped:591 pagetables:118 bounce:0
Node 0 DMA free:1180kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:9636kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3440 5424 5424
Node 0 DMA32 free:3587780kB min:5292kB low:6612kB high:7936kB active:0kB inactive:0kB present:3523008kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1984 1984
Node 0 Normal free:1888220kB min:3052kB low:3812kB high:4576kB active:968kB inactive:312kB present:2031616kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:496192kB min:760kB low:948kB high:1140kB active:784kB inactive:108kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 2 Normal free:496508kB min:760kB low:948kB high:1140kB active:460kB inactive:140kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 3 Normal free:487540kB min:760kB low:948kB high:1140kB active:4724kB inactive:3592kB present:507904kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 16*4kB 52*8kB 37*16kB 4*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1200kB
Node 0 DMA32: 1*4kB 2*8kB 1*16kB 1*32kB 2*64kB 0*128kB 2*256kB 2*512kB 2*1024kB 2*2048kB 874*4096kB = 3587780kB
Node 0 Normal: 147*4kB 111*8kB 62*16kB 27*32kB 7*64kB 3*128kB 4*256kB 2*512kB 0*1024kB 1*2048kB 459*4096kB = 1888324kB
Node 1 Normal: 106*4kB 81*8kB 42*16kB 21*32kB 13*64kB 10*128kB 5*256kB 0*512kB 1*1024kB 1*2048kB 119*4096kB = 496304kB
Node 2 Normal: 103*4kB 88*8kB 45*16kB 21*32kB 9*64kB 2*128kB 3*256kB 2*512kB 2*1024kB 1*2048kB 119*4096kB = 496652kB
Node 3 Normal: 329*4kB 190*8kB 100*16kB 53*32kB 38*64kB 7*128kB 4*256kB 0*512kB 0*1024kB 1*2048kB 116*4096kB = 487668kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1048784kB
Total swap = 1048784kB
Free swap:       1048784kB
1966080 pages of RAM
210493 reserved pages
2219 pages shared
0 pages swap cached
interface eth0 is not up
7[?25l[1A[80C[10D[1;31mfailed[m8[?25hWaiting for mandatory devices:  eth-id-00:04:76:f0:f9:aa __NSC__
5 4 3 2 1 
    eth0      device: Broadcom Corporation NetXtreme BCM5701 Gigabit Ethernet (rev 15)
    eth0      configuration: eth-id-00:04:76:f0:f9:aa
    eth0      is down
7[?25l[1A[80C[10D[1;31mfailed[m8[?25h    eth0      interface could not be set up until now
7[?25l[1A[80C[10D[1;31mfailed[m8[?25hSetting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .7[?25l[80C[10D[1;31mfailed[m8[?25h
Starting syslog services7[?25l[80C[10D[1;32mdone[m8[?25h
Starting slpd A FATAL Error has occured:
Could not open logfile /var/log/slpd.log
startproc:  exit status of parent of /usr/sbin/slpd: 1
7[?25l[80C[10D[1;31mfailed[m8[?25h
Starting RPC portmap daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting auditd 7[?25l[80C[10D[1;31mfailed[m8[?25h
Importing Net File System (NFS)[80C[10D[1munused[m
Checking/updating CPU microcode 7[?25l[80C[10D[1munused[m8[?25h
Starting nfsboot (sm-notify) 7[?25l[80C[10D[1;32mdone[m8[?25h
Mount SMB/ CIFS File Systems [80C[10D[1munused[m
touch: cannot touch `/var/lock/subsys/smbfs': Read-only file system
Starting Name Service Cache Daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting cupsd7[?25l[80C[10D[1;32mdone[m8[?25h
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Starting SSH daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting ZENworks Management Daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting powersaved: ###############################################
# ACPI system but acpid not running.          #
# Start acpid first, then restart powersaved! #
###############################################[80C[10D[1;33mskipped[m
Starting mail service (Postfix)7[?25l[80C[10D[1;32mdone[m8[?25h
Starting CRON daemon/usr/sbin/cron: can't open or create /var/run/cron.pid: Read-only file system
startproc:  exit status of parent of /usr/sbin/cron: 1
7[?25l[80C[10D[1;31mfailed[m8[?25h
Master Resource Control: runlevel 3 has been [80C[10D[1mreached[m
Failed services in runlevel 3: [1;31macpid random resmgr network slpd auditd cron[m
Skipped services in runlevel 3: [80C[44D[1;33msmbfs nfs microcode powersaved splash[m
blogd: no message logging because /var file system is not accessible



Welcome to SUSE Linux Enterprise Server 10 (x86_64) - Kernel 2.6.21-rc5-mm4 (ttyS0).



Welcome to SUSE Linux Enterprise Server 10 (x86_64) - Kernel 2.6.21-rc5-mm4 (console).


elm3b29 login: elm3b29 login: 
telnet> q
Connection closed.
]0;badari@dyn9047017100:~[badari@dyn9047017100 ~]$ 
]0;badari@dyn9047017100:~[badari@dyn9047017100 ~]$ 
]0;badari@dyn9047017100:~[badari@dyn9047017100 ~]$ exit

Script done on Wed 04 Apr 2007 07:50:14 AM PDT

--=-JZzWxCCv7akfvBZahA8N--

