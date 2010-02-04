Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0BDRuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:50:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:47135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751890Ab0BDRun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:50:43 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/vlSJLRHbvcRewVMf3mEHcC2EBtUHpXa/aRtqx/J
	nlfR/rMGTzE/ng
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: hadi@cyberus.ca
Subject: Re: patch net-restore-ip-source-validation.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 18:50:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
References: <1265060041850@kroah.org> <201002032114.59960.s.L-H@gmx.de> <1265282011.4204.12.camel@bigi>
In-Reply-To: <1265282011.4204.12.camel@bigi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041850.31310.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 04 February 2010, jamal wrote:
> Hi there,
> 
> I am downloading 2.6.32-7 to see if i can reproduce it. My gut is
> telling me it will be hard to see in my setup.
> Can you try to see if it something in your boot initialization i.e with
> no init e.g something like init=/bin/sh and then initcall_debug?

I just managed to catch a bootlog through a serial console now:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.32-7.slh.2-sidux-686 (Debian 2.6.32-33) (s.l-h@gmx.de) (gcc version 4.0
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ec000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000017ff0000 (usable)
 BIOS-e820: 0000000017ff0000 - 0000000017ff8000 (ACPI data)
 BIOS-e820: 0000000017ff8000 - 0000000018000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x17ff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-0000000017ff0000
RAMDISK: 17792000 - 17fdf2ff
ACPI: RSDP 000fa7b0 00014 (v00 AMI   )
ACPI: RSDT 17ff0000 00028 (v01 AMIINT VIA_K7   00000010 MSFT 00000097)
ACPI: FACP 17ff0030 00074 (v01 AMIINT VIA_K7   00000011 MSFT 00000097)
ACPI: DSDT 17ff00b0 02AC4 (v01    VIA   VT8371 00001000 MSFT 0100000B)
ACPI: FACS 17ff8000 00040
0MB HIGHMEM available.
383MB LOWMEM available.
  mapped low ram: 0 - 17ff0000
  low ram: 0 - 17ff0000
  node 0 low ram: 00000000 - 17ff0000
  node 0 bootmap 00012000 - 00015000
(9 early reservations) ==> bootmem [0000000000 - 0017ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00005cf2a4]    TEXT DATA BSS ==> [0000100000 - 00005cf2a4]
  #4 [0017792000 - 0017fdf2ff]          RAMDISK ==> [0017792000 - 0017fdf2ff]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [00005d0000 - 00005d210c]              BRK ==> [00005d0000 - 00005d210c]
  #7 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #8 [0000012000 - 0000015000]          BOOTMAP ==> [0000012000 - 0000015000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00017ff0
  HighMem  0x00017ff0 -> 0x00017ff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x00017ff0
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Local APIC disabled by BIOS -- you can enable it with "lapic"
APIC: disable apic facility
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ec000
PM: Registered nosave memory: 00000000000ec000 - 0000000000100000
Allocating PCI resources starting at 18000000 (gap: 18000000:e7ff0000)
Booting paravirtualized kernel on bare hardware
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @c1400000 s34392 r0 d22952 u4194304
pcpu-alloc: s34392 r0 d22952 u4194304 alloc=1*4194304
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 97407
Kernel command line: root=LABEL=debian ro vga=0 console=ttyS0,115200 console=tty
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (00000000:00000000)
Memory: 375384k/393152k available (2987k kernel code, 17016k reserved, 1100k data, 404k )
virtual kernel memory layout:
    fixmap  : 0xffd55000 - 0xfffff000   (2728 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xd87f0000 - 0xff3fe000   ( 620 MB)
    lowmem  : 0xc0000000 - 0xd7ff0000   ( 383 MB)
      .init : 0xc04ff000 - 0xc0564000   ( 404 kB)
      .data : 0xc03eae37 - 0xc04fe068   (1100 kB)
      .text : 0xc0100000 - 0xc03eae37   (2987 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:2304 nr_irqs:256
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 1102.332 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2204.66 BogoM)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
mce: CPU supports 4 MCE banks
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20090903
ACPI: setting ELCR to 0200 (from 0e20)
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (2204.66 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb61, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.4: quirk: region 0800-08ff claimed by vt82c586 ACPI
pci 0000:00:07.4: quirk: region 0c00-0c7f claimed by vt82c686 HW-mon
pci 0000:00:07.4: quirk: region 0400-040f claimed by vt82c686 SMB
pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0f.0: PME# disabled
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xddc00000-0xdfcfffff
pci 0000:00:01.0:   PREFETCH window: 0xcda00000-0xddafffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
sysctl table check failed: /net/ipv4/conf/all/src_valid_mark .3.5.16.-2.24 Unknown syscth
Pid: 1, comm: swapper Not tainted 2.6.32-7.slh.2-sidux-686 #1
Call Trace:
 [<c015fa69>] ? set_fail+0x49/0x50
 [<c015fd9d>] ? sysctl_check_table+0x32d/0x640
 [<c015fa0e>] ? sysctl_check_lookup+0x11e/0x130
 [<c015fdb5>] ? sysctl_check_table+0x345/0x640
 [<c015fa0e>] ? sysctl_check_lookup+0x11e/0x130
 [<c015fdb5>] ? sysctl_check_table+0x345/0x640
 [<c015fa0e>] ? sysctl_check_lookup+0x11e/0x130
 [<c015fdb5>] ? sysctl_check_table+0x345/0x640
 [<c015fa0e>] ? sysctl_check_lookup+0x11e/0x130
 [<c015fdb5>] ? sysctl_check_table+0x345/0x640
 [<c0144dd9>] ? sysctl_set_parent+0x19/0x30
 [<c0146267>] ? __register_sysctl_paths+0xc7/0x2c0
 [<c03d82ad>] ? register_net_sysctl_table+0x4d/0x60
 [<c03a6168>] ? __devinet_sysctl_register+0xc8/0x100
 [<c03a6819>] ? devinet_init_net+0xa9/0x190
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c0350cdb>] ? register_pernet_operations+0x5b/0xe0
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c0350e99>] ? register_pernet_subsys+0x19/0x30
 [<c052d3db>] ? devinet_init+0xd/0x76
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c052cc9f>] ? ip_rt_init+0x180/0x250
 [<c052ce85>] ? ip_init+0x5/0xf
 [<c052d55c>] ? inet_init+0x118/0x1d1
 [<c0350ea5>] ? register_pernet_subsys+0x25/0x30
 [<c010112f>] ? do_one_initcall+0x2f/0x190
 [<c04ff31e>] ? kernel_init+0x126/0x17b
 [<c04ff1f8>] ? kernel_init+0x0/0x17b
 [<c0104477>] ? kernel_thread_helper+0x7/0x10
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c03a6253>] inetdev_init+0x63/0x180
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.32-7.slh.2-sidux-686 #1)
EIP: 0060:[<c03a6253>] EFLAGS: 00010286 CPU: 0
EIP is at inetdev_init+0x63/0x180
EAX: c05cca60 EBX: d701e000 ECX: 0000001a EDX: 00000000
ESI: 00000000 EDI: d701e068 EBP: d70b5800 ESP: d7023eec
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=d7022000 task=d7024000 task.ti=d7022000)
Stack:
 c03a618d d7023efc c047df33 d701e000 00000000 00000005 d70b5800 c05cca60
<0> c03a66a1 00000010 d70c00a8 fffffffe 00000000 00000000 d70b5800 c05cca60
<0> c04f28c0 c04f2920 c03a6819 c04f2840 d7023f48 c05cca98 c04f23b0 d70b5800
Call Trace:
 [<c03a618d>] ? __devinet_sysctl_register+0xed/0x100
 [<c03a66a1>] ? inetdev_event+0x331/0x400
 [<c03a6819>] ? devinet_init_net+0xa9/0x190
 [<c03567e3>] ? register_netdevice_notifier+0x73/0x1b0
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c052d3f4>] ? devinet_init+0x26/0x76
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c052cc9f>] ? ip_rt_init+0x180/0x250
 [<c052ce85>] ? ip_init+0x5/0xf
 [<c052d55c>] ? inet_init+0x118/0x1d1
 [<c0350ea5>] ? register_pernet_subsys+0x25/0x30
 [<c010112f>] ? do_one_initcall+0x2f/0x190
 [<c04ff31e>] ? kernel_init+0x126/0x17b
 [<c04ff1f8>] ? kernel_init+0x0/0x17b
 [<c0104477>] ? kernel_thread_helper+0x7/0x10
Code: 35 e4 ea 4c c0 85 d2 89 c3 0f 85 d4 00 00 00 85 db 89 5c 24 0c 74 61 8b 85 24 02 0
EIP: [<c03a6253>] inetdev_init+0x63/0x180 SS:ESP 0068:d7023eec
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.32-7.slh.2-sidux-686 #1
Call Trace:
 [<c03e7522>] ? panic+0x4d/0xf3
 [<c0140f80>] ? do_exit+0x600/0x700
 [<c03e75df>] ? printk+0x17/0x20
 [<c010745b>] ? oops_end+0x8b/0xd0
 [<c0123f8a>] ? no_context+0xba/0x150
 [<c01242e0>] ? do_page_fault+0x0/0x300
 [<c012418f>] ? bad_area_nosemaphore+0xf/0x20
 [<c03ea306>] ? error_code+0x66/0x6c
 [<c01242e0>] ? do_page_fault+0x0/0x300
 [<c03a6253>] ? inetdev_init+0x63/0x180
 [<c03a618d>] ? __devinet_sysctl_register+0xed/0x100
 [<c03a66a1>] ? inetdev_event+0x331/0x400
 [<c03a6819>] ? devinet_init_net+0xa9/0x190
 [<c03567e3>] ? register_netdevice_notifier+0x73/0x1b0
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c052d3f4>] ? devinet_init+0x26/0x76
 [<c052d444>] ? inet_init+0x0/0x1d1
 [<c052cc9f>] ? ip_rt_init+0x180/0x250
 [<c052ce85>] ? ip_init+0x5/0xf
 [<c052d55c>] ? inet_init+0x118/0x1d1
 [<c0350ea5>] ? register_pernet_subsys+0x25/0x30
 [<c010112f>] ? do_one_initcall+0x2f/0x190
 [<c04ff31e>] ? kernel_init+0x126/0x17b
 [<c04ff1f8>] ? kernel_init+0x0/0x17b
 [<c0104477>] ? kernel_thread_helper+0x7/0x10

> cheers,
> jamal
> 
> On Wed, 2010-02-03 at 21:14 +0100, Stefan Lippers-Hollmann wrote:
> > This patch, as part of the current 2.6.32 stable queue, breaks booting with
> > an oops very early, before the framebuffer got a chance to initialize 
> > (unfortunately most of it is cut with the unavoidable vga=0, so I didn't 
> > write it down yet), on amd64 and i386 (kernel configs attached). Removing
> > just this patch from queue-2.6.32 fixes the problem for me; kernel 2.6.33 
> > HEAD doesn't seem to be affected.

Greg, please note that this patch is still part of your 2.6.32.8-rc1 stable
review, it reliably crashes all amd64/ i386 systems very early in the 
system boot for me; 2.6.33 HEAD is not affected.

Regards
	Stefan Lippers-Hollmann
