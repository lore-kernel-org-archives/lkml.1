Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYIFGjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYIFGjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYIFGjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 02:39:03 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38680 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYIFGjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 02:39:00 -0400
Date: Sat, 6 Sep 2008 08:45:58 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
Message-Id: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: dec0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a dmesg dump  below from my Compaq AP550 workstation.
It has 3 WARN_ON() dumps: 1 from acpi layer and 2 from vmap_pte_range()
There is no such thing in 2.6.27-rc4 which I use daily so I assume
it is something in the -mm tree.

It is a Pentium3 SMP machine.

Kind regards,
Krzysztof

Linux version 2.6.27-rc5-mm1 (root@xxx) (gcc version 3.4.6) #1 SMP Sat Sep 6 07:47:58 CEST 2008
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (reserved)
last_pfn = 0x1fff0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 1fff0000 @ 7000-d000
DMI 2.3 present.
ACPI: RSDP 000E0010, 0014 (r0 COMPAQ)
ACPI: RSDT 000E0080, 0040 (r1 COMPAQ CPQB154  20010410             0)
ACPI: FACP 000E00EC, 0074 (r1 COMPAQ CARMEL          1             0)
ACPI: DSDT 000E0230, 1B6C (r1 COMPAQ     DSDT        1 MSFT  100000D)
ACPI: FACS 000E0040, 0040
ACPI: APIC 000E0160, 0068 (r1 COMPAQ CARMEL          1             0)
ACPI: SSDT 000E1D9C, 005B (r1 COMPAQ   ZURICH        1 MSFT  100000D)
ACPI: SSDT 000E1FE8, 06A5 (r1 COMPAQ PNP_PRSS        1 MSFT  100000D)
ACPI: SSDT 000E3414, 005D (r1 COMPAQ     FHUB        1 MSFT  100000D)
ACPI: SSDT 000E268D, 0CBF (r1 COMPAQ  THERMAL        1 MSFT  100000D)
ACPI: SSDT 000E334C, 0024 (r1 COMPAQ       S1        1 MSFT  100000D)
511MB LOWMEM available.
  mapped low ram: 0 - 1fff0000
  low ram: 00000000 - 1fff0000
  bootmap 00002000 - 00006000
(8 early reservations) ==> bootmem [0000000000 - 001fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004dbb24]    TEXT DATA BSS ==> [0000100000 - 00004dbb24]
  #4 [00004dc000 - 00004df000]    INIT_PG_TABLE ==> [00004dc000 - 00004df000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
sizeof(struct page) = 32
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001fff0
On node 0 totalpages: 130959
Node 0 memmap at 0xc1000000 size 4194304 first pfn 0xc1000000
free_area_init_node: node 0, pgdat c045d4a0, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 125968 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
dyn_array 0xc04b92a4 size:0x1c nr:32 align:0x1000
dyn_array 0xc04b92ac size:0xc nr:256 align:0x1000
dyn_array 0xc04ce274 size:0x60 nr:32 align:0x1000
dyn_array total_size: 0x3000
dyn_array 0xc04b92a4 ==> [0x1402000 - 0x1402380]
dyn_array 0xc04b92ac ==> [0x1403000 - 0x1403c00]
dyn_array 0xc04ce274 ==> [0x1404000 - 0x1404c00]
kstat_irqs ==> [0x1405000 - 0x1405100]
PERCPU: Allocating 32768 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129935
Kernel command line: BOOT_IMAGE=Linux-mm ro root=306 video=tridentfb:1024x768
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
found new irq_desc for irq 0
found new irq_desc for irq 1
found new irq_desc for irq 2
found new irq_desc for irq 3
found new irq_desc for irq 4
found new irq_desc for irq 5
found new irq_desc for irq 6
found new irq_desc for irq 7
found new irq_desc for irq 8
found new irq_desc for irq 9
found new irq_desc for irq 10
found new irq_desc for irq 11
found new irq_desc for irq 12
found new irq_desc for irq 13
found new irq_desc for irq 14
found new irq_desc for irq 15
CPU 0 irqstacks, hard=c04aa000 soft=c04a6000
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 863.928 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515180k/524224k available (2583k kernel code, 8564k reserved, 893k data, 228k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xe07f0000 - 0xfffb7000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc046a000 - 0xc04a3000   ( 228 kB)
      .data : 0xc0385de5 - 0xc04652b8   ( 893 kB)
      .text : 0xc0100000 - 0xc0385de5   (2583 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 1727.85 BogoMIPS (lpj=3455712)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080729
 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Pentium III (Coppermine) stepping 03
CPU 1 irqstacks, hard=c04ab000 soft=c04a7000
Booting processor 1/0 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1727.95 BogoMIPS (lpj=3455917)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU1: Intel Pentium III (Coppermine) stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (3455.81 BogoMIPS).
net_namespace: 296 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xedb08, last bus=2
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x4c/0x50()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5-mm1 #1
 [<c012530f>] warn_slowpath+0x6f/0xa0
 [<c03837b0>] __sched_text_start+0x2b0/0x4b0
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c01f6dc9>] sub_alloc+0x69/0x160
 [<c01f6f75>] idr_get_empty_slot+0xb5/0x140
 [<c01f768f>] ida_get_new_above+0x3f/0x1b0
 [<c0383a65>] wait_for_common+0xb5/0x130
 [<c01b6420>] sysfs_ilookup_test+0x0/0x10
 [<c01b6420>] sysfs_ilookup_test+0x0/0x10
 [<c01b67ca>] sysfs_find_dirent+0x1a/0x30
 [<c01b64fc>] __sysfs_add_one+0x1c/0x80
 [<c01b65ac>] sysfs_add_one+0x4c/0x50
 [<c01b6888>] create_dir+0x48/0xb0
 [<c01b6939>] sysfs_create_dir+0x29/0x50
 [<c01f7b89>] create_dir+0x19/0x50
 [<c01f7dca>] kobject_add_internal+0x8a/0x120
 [<c01f7e9a>] kobject_set_name_vargs+0x3a/0x50
 [<c01f7f92>] kobject_add_varg+0x22/0x60
 [<c01f8059>] kobject_init_and_add+0x29/0x30
 [<c04795db>] kernel_param_sysfs_setup+0x5b/0xc0
 [<c01b6891>] create_dir+0x51/0xb0
 [<c047974e>] param_sysfs_builtin+0x10e/0x150
 [<c0479790>] param_sysfs_init+0x0/0x60
 [<c04797bc>] param_sysfs_init+0x2c/0x60
 [<c0471531>] mtrr_init_finialize+0x31/0x40
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
 [<c01f7e48>] kobject_add_internal+0x108/0x120
 [<c01f7f92>] kobject_add_varg+0x22/0x60
 [<c01f8059>] kobject_init_and_add+0x29/0x30
 [<c04795db>] kernel_param_sysfs_setup+0x5b/0xc0
 [<c01b6891>] create_dir+0x51/0xb0
 [<c047974e>] param_sysfs_builtin+0x10e/0x150
 [<c0479790>] param_sysfs_init+0x0/0x60
 [<c04797bc>] param_sysfs_init+0x2c/0x60
 [<c0471531>] mtrr_init_finialize+0x31/0x40
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region f800-f87f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region fa00-fa3f claimed by ICH4 GPIO
pci 0000:01:00.0: supports D1 D2
PCI: bridge 0000:00:01.0 32bit mmio: [fd000000, fe7fffff]
pci 0000:02:02.0: supports D1 D2
pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:0b.0: supports D2
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [5000, 5fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [fcb00000, fcffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BUS1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11)
ACPI: Power Resource [PFN0] (on)
ACPI: Power Resource [PFN1] (on)
ACPI: Power Resource [PFN2] (on)
ACPI: Power Resource [PFN3] (on)
ACPI: Power Resource [PFN4] (on)
ACPI: Power Resource [PFN5] (on)
ACPI: Power Resource [PFN6] (on)
ACPI: Power Resource [PFN7] (on)
ACPI: Power Resource [PFN8] (on)
ACPI: Power Resource [PFN9] (on)
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 7 (0xf800-0xf87f), disabling
pnp 00:0d: io resource (0xfa00-0xfa1f) overlaps 0000:00:1f.0 BAR 8 (0xfa00-0xfa3f), disabling
pnp 00:0d: io resource (0xfa20-0xfa3f) overlaps 0000:00:1f.0 BAR 8 (0xfa00-0xfa3f), disabling
pnp 00:0e: mem resource (0x0-0x9ffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:0e: mem resource (0xe0000-0xfffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:0e: mem resource (0xd3600-0xd3fff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
ACPI: RTC can wake from S4
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x400-0x41f has been reserved
system 00:0d: ioport range 0x420-0x43f has been reserved
system 00:0d: ioport range 0x440-0x45f has been reserved
system 00:0d: ioport range 0x460-0x47f has been reserved
system 00:0e: iomem range 0x100000-0x2000ffff could not be reserved
system 00:0e: iomem range 0xfff80000-0xffffffff has been reserved
system 00:0e: iomem range 0xfeea0000-0xfeebffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfd000000-0xfe7fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000030000000-0x000000300fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x5000-0x5fff
pci 0000:00:1e.0:   MEM window: 0xfcb00000-0xfcffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000030100000-0x000000302fffff
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [fd000000, fe7fffff]
bus: 01 index 2 mmio: [30000000, 300fffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [5000, 5fff]
bus: 02 index 1 mmio: [fcb00000, fcffffff]
bus: 02 index 2 mmio: [30100000, 302fffff]
bus: 02 index 3 io port: [0, ffff]
bus: 02 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
pci 0000:02:02.0: Firmware left e100 interrupts enabled; disabling
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PBTN]
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (27 C)
USB Universal Host Controller Interface driver v3.0
found new irq_cfg for irq 19
 0 add_pin_to_irq: irq 19 --> apic 0 pin 19
found new irq_desc for irq 19
uhci_hcd 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1f.2: setting latency timer to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 19, io base 0x00006440
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
msgmni has been set to 1006
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
found new irq_cfg for irq 18
 0 add_pin_to_irq: irq 18 --> apic 0 pin 18
found new irq_desc for irq 18
tridentfb 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
tridentfb: framebuffer size = 8192 Kb
Console: switching to colour frame buffer device 128x48
tridentfb: fb0: Trident frame buffer device 1024x768-8bpp
ACPI: Transitioning device [FN0] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FN0] (off)
ACPI: Transitioning device [FN1] to D3
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [FN1] (off)
ACPI: Transitioning device [FN2] to D3
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [FN2] (off)
ACPI: Transitioning device [FN3] to D3
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [FN3] (off)
ACPI: Transitioning device [FN4] to D3
fan PNP0C0B:04: registered as cooling_device4
ACPI: Fan [FN4] (off)
ACPI: Transitioning device [FN5] to D3
fan PNP0C0B:05: registered as cooling_device5
ACPI: Fan [FN5] (off)
ACPI: Transitioning device [FN6] to D3
fan PNP0C0B:06: registered as cooling_device6
ACPI: Fan [FN6] (off)
ACPI: Transitioning device [FN7] to D3
fan PNP0C0B:07: registered as cooling_device7
ACPI: Fan [FN7] (off)
ACPI: Transitioning device [FN8] to D3
fan PNP0C0B:08: registered as cooling_device8
ACPI: Fan [FN8] (off)
fan PNP0C0B:09: registered as cooling_device9
ACPI: Fan [FN9] (on)
processor ACPI0007:00: registered as cooling_device10
processor ACPI0007:01: registered as cooling_device11
Intel 82802 RNG detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel i840 Chipset
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:105 vmap_pte_range+0xcb/0x100()
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
 [<c012526f>] warn_on_slowpath+0x5f/0x90
 [<c0217a5e>] fbcon_clear+0x13e/0x1a0
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c01460cc>] generic_exec_single+0x9c/0xa0
 [<c0109776>] read_tsc+0x6/0x30
 [<c013e4f8>] getnstimeofday+0x38/0x150
 [<c015496c>] buffered_rmqueue+0x12c/0x210
 [<c011b53c>] update_curr+0x4c/0x70
 [<c016768b>] vmap_pte_range+0xcb/0x100
 [<c01676ed>] vmap_pmd_range+0x2d/0x40
 [<c016772d>] vmap_pud_range+0x2d/0x40
 [<c01677a6>] vmap_page_range+0x66/0x90
 [<c016844f>] map_vm_area+0x2f/0x50
 [<c0168996>] __vmalloc_area_node+0xb6/0x110
 [<c0168a95>] __vmalloc_node+0x85/0xb0
 [<c02603a2>] agp_backend_initialize+0x82/0x230
 [<c0168b01>] vmalloc+0x21/0x30
 [<c02603a2>] agp_backend_initialize+0x82/0x230
 [<c02603a2>] agp_backend_initialize+0x82/0x230
 [<c027f790>] __driver_attach+0x0/0xc0
 [<c02606b5>] agp_add_bridge+0x55/0x1a0
 [<c020955a>] pci_call_probe+0xa/0x10
 [<c02095ae>] __pci_device_probe+0x4e/0x60
 [<c02095e6>] pci_device_probe+0x26/0x60
 [<c027f5cb>] really_probe+0x9b/0x130
 [<c02094b0>] pci_match_device+0x10/0xb0
 [<c027f6af>] driver_probe_device+0x3f/0x60
 [<c027f819>] __driver_attach+0x89/0xc0
 [<c027e519>] bus_for_each_dev+0x39/0x60
 [<c027f866>] driver_attach+0x16/0x20
 [<c027f790>] __driver_attach+0x0/0xc0
 [<c027ed29>] bus_add_driver+0x109/0x1a0
 [<c01f85ed>] kset_find_obj+0x2d/0x60
 [<c0209660>] pci_device_shutdown+0x0/0x20
 [<c0209660>] pci_device_shutdown+0x0/0x20
 [<c027fcff>] driver_register+0x3f/0xd0
 [<c0125b17>] printk+0x17/0x20
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c02096c7>] __pci_register_driver+0x47/0x80
 [<c0482250>] agp_intel_init+0x0/0x20
 [<c0101032>] _stext+0x32/0x180
 [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
 [<c011aeb4>] resched_task+0x54/0x60
 [<c011e76e>] try_to_wake_up+0x12e/0x140
 [<c0135211>] __create_workqueue_key+0x131/0x150
 [<c046a8d3>] do_initcalls+0x53/0xd0
 [<c046a9a0>] kernel_init+0x0/0xb0
 [<c046a9f5>] kernel_init+0x55/0xb0
 [<c0103f3b>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
agpgart-intel 0000:00:00.0: can't allocate memory for key lists
agpgart-intel 0000:00:00.0: agp_backend_initialize() failed
agpgart-intel: probe of 0000:00:00.0 failed with error -12
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
loop: module loaded
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x2411 rev 0x02)
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x6460-0x6467
    ide1: BM-DMA at 0x6468-0x646f
Probing IDE interface ide0...
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
hda: SAMSUNG SP0411N, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
Probing IDE interface ide1...
hdc: ATAPI DVD A DH20A3H, ATAPI CD/DVD-ROM drive
hdd: Compaq CRD-8402B, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 78242976 sectors (40060 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 hda7 > hda3
hdc: ATAPI 12X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X CD-ROM drive, 128kB Cache
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, native irqs
i2c /dev entries driver
found new irq_cfg for irq 17
 0 add_pin_to_irq: irq 17 --> apic 0 pin 17
found new irq_desc for irq 17
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
iTCO_wdt: Found a ICH TCO device (Version=1, TCOBASE=0xf860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18rc1.
ALSA device list:
  No soundcards found.
TCP cubic registered
Using IPI No-Shortcut mode
rtc_cmos 00:03: setting system clock to 2008-09-06 08:22:22 UTC (1220689342)
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 228k freed
EXT3 FS on hda6, internal journal
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:105 vmap_pte_range+0xcb/0x100()
Modules linked in:
Pid: 776, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
 [<c012526f>] warn_on_slowpath+0x5f/0x90
 [<c01617e9>] handle_mm_fault+0x1d9/0x210
 [<c01bd0a0>] ext3_get_block+0x0/0x100
 [<c011759b>] do_page_fault+0x12b/0x4f0
 [<c0105dde>] do_IRQ+0x7e/0xd0
 [<c0154ce4>] __alloc_pages_internal+0x94/0x410
 [<c0117470>] do_page_fault+0x0/0x4f0
 [<c038506a>] error_code+0x72/0x78
 [<c015496c>] buffered_rmqueue+0x12c/0x210
 [<c014fbab>] find_get_page+0x2b/0xa0
 [<c016768b>] vmap_pte_range+0xcb/0x100
 [<c01676ed>] vmap_pmd_range+0x2d/0x40
 [<c016772d>] vmap_pud_range+0x2d/0x40
 [<c01677a6>] vmap_page_range+0x66/0x90
 [<c016844f>] map_vm_area+0x2f/0x50
 [<c0168996>] __vmalloc_area_node+0xb6/0x110
 [<c0168a95>] __vmalloc_node+0x85/0xb0
 [<c0148eb9>] load_module+0x89/0xd90
 [<c0168b01>] vmalloc+0x21/0x30
 [<c0148eb9>] load_module+0x89/0xd90
 [<c0148eb9>] load_module+0x89/0xd90
 [<c01380e0>] autoremove_wake_function+0x0/0x50
 [<c0177db0>] vfs_read+0x90/0x150
 [<c0149c44>] sys_init_module+0x44/0x1a0
 [<c0178111>] sys_read+0x41/0x70
 [<c01031fa>] syscall_call+0x7/0xb
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH 0000:00:1f.5: setting latency timer to 64
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
de2104x PCI Ethernet driver v0.7 (Mar 17, 2004)
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
intel8x0_measure_ac97_clock: measured 54697 usecs
intel8x0: clocking to 48000
de2104x 0000:02:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
de0: SROM leaf offset 30, default media 10baseT auto
de0:   media block #0: 10baseT-FD
de0:   media block #1: BNC
de0:   media block #2: 10baseT-HD
eth0: 21041 at 0xe1128000, 00:80:c8:e8:5f:b9, IRQ 18
au8820 0000:02:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Vortex: init.... <6>done.
gameport: AU88x0 Gameport is pci0000:02:0b.0/gameport0, speed 1355kHz
aic7xxx 0000:02:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7892 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi 0:0:0:0: Direct-Access     COMPAQ   BD009222BB       3B09 PQ: 0 ANSI: 2
scsi0:A:0:0: Tagged Queuing enabled.  Depth 64
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
sd 0:0:0:0: [sda] 17773524 512-byte hardware sectors (9100 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: f3 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 17773524 512-byte hardware sectors (9100 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: f3 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
lp0: using parport0 (interrupt-driven).
SGI XFS with security attributes, no debug enabled
XFS mounting filesystem hda7
Ending clean XFS mount for filesystem: hda7
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
JFS: nTxBlock = 4027, nTxLock = 32218
NET: Registered protocol family 17
eth0: enabling interface
eth0: set link 10baseT auto
eth0:    mode 0x7ffc0040, sia 0x12c4,0xffffef01,0xffffffff,0xffff0008
eth0:    set mode 0x7ffc0040, set sia 0xef01,0xffff,0x8
eth0: link up, media 10baseT auto
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

----------------------------------------------------------------------
Nie zwlekaj! Tapetuj z nami!
Sprawdz >>  http://link.interia.pl/f1f01

