Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYHOCrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYHOCrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYHOCqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:46:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11900 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYHOCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:46:45 -0400
Date: Thu, 14 Aug 2008 19:46:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       ak@linux.intel.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-Id: <20080814194631.eb98c63d.randy.dunlap@oracle.com>
In-Reply-To: <1218768111.3209.43.camel@rzhang-dt>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	<20080814083828.d10e126d.randy.dunlap@oracle.com>
	<1218768111.3209.43.camel@rzhang-dt>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__14_Aug_2008_19_46_31_-0700_/ZWuke=0rFKSo/yt"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__14_Aug_2008_19_46_31_-0700_/ZWuke=0rFKSo/yt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Aug 2008 10:41:51 +0800 Zhang Rui wrote:

> Please attach the full dmesg output.

Done.


> thanks,
> rui
> 
> 
> On Thu, 2008-08-14 at 08:38 -0700, Randy Dunlap wrote:
> > calling  param_sysfs_init+0x0/0x1e7
> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> > sysfs: duplicate filename 'acpi' can not be created
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080814 #1
> > 
> > Call Trace:
> >  [<ffffffff802358cb>] warn_slowpath+0xae/0xdd
> >  [<ffffffff8036a6be>] ? number+0x115/0x21f
> >  [<ffffffff8036574d>] ? __next_cpu+0x19/0x26
> >  [<ffffffff8022d575>] ? find_busiest_group+0x25b/0x6ee
> >  [<ffffffff8036aefc>] ? string+0x3d/0xa2
> >  [<ffffffff80365e02>] ? idr_get_empty_slot+0x161/0x24e
> >  [<ffffffff8036b2ea>] ? vsnprintf+0x389/0x678
> >  [<ffffffff802def96>] ? sysfs_ilookup_test+0x0/0x14
> >  [<ffffffff802aa5bf>] ? ifind+0x3d/0xac
> >  [<ffffffff802df1bd>] ? sysfs_find_dirent+0x1c/0x31
> >  [<ffffffff802df1f1>] ? __sysfs_add_one+0x1f/0x7c
> >  [<ffffffff802df283>] sysfs_add_one+0x35/0x3d
> >  [<ffffffff802df7d2>] create_dir+0x58/0x93
> >  [<ffffffff802df845>] sysfs_create_dir+0x38/0x4f
> >  [<ffffffff80366b8a>] kobject_add_internal+0xce/0x18f
> >  [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
> >  [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
> >  [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
> >  [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
> >  [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
> >  [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
> >  [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
> >  [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
> >  [<ffffffff80209047>] _stext+0x47/0x13f
> >  [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
> >  [<ffffffff807508e5>] kernel_init+0x11b/0x171
> >  [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
> >  [<ffffffff8020ce49>] child_rip+0xa/0x11
> >  [<ffffffff807507ca>] ? kernel_init+0x0/0x171
> >  [<ffffffff8020ce3f>] ? child_rip+0x0/0x11
> > 
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> > kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
> > Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080814 #1
> > 
> > Call Trace:
> >  [<ffffffff8036698f>] ? kobject_put+0x47/0x4b
> >  [<ffffffff80366c08>] kobject_add_internal+0x14c/0x18f
> >  [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
> >  [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
> >  [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
> >  [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
> >  [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
> >  [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
> >  [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
> >  [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
> >  [<ffffffff80209047>] _stext+0x47/0x13f
> >  [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
> >  [<ffffffff807508e5>] kernel_init+0x11b/0x171
> >  [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
> >  [<ffffffff8020ce49>] child_rip+0xa/0x11
> >  [<ffffffff807507ca>] ? kernel_init+0x0/0x171
> >  [<ffffffff8020ce3f>] ? child_rip+0x0/0x11
> > 
> > Module 'acpi' failed to be added to sysfs, error number -17
> > The system will be unstable now.
> > initcall param_sysfs_init+0x0/0x1e7 returned 0 after 19 msecs


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

--Multipart=_Thu__14_Aug_2008_19_46_31_-0700_/ZWuke=0rFKSo/yt
Content-Type: text/x-log;
 name="netcon-4839.log"
Content-Disposition: attachment;
 filename="netcon-4839.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.27-rc3-next-20080814 (root@ca-ostest293.us.oracle.com) (g=
cc version 4.1.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Thu Aug 14 00:01:41 PD=
T 2008
Command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=3D5483=
9@139.185.50.77/eth0,54839@139.185.50.76/00:18:FE:34:1C:3D debug ignore_log=
level initcall_debug 3 kex
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
last_pfn =3D 0x27ffff max_arch_pfn =3D 0x3ffffffff
last_pfn =3D 0x7fe50 max_arch_pfn =3D 0x3ffffffff
init_memory_mapping
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
last_map_addr: 7fe50000 end: 7fe50000
init_memory_mapping
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
last_map_addr: 27ffff000 end: 27ffff000
RAMDISK: 7fd04000 - 7fe4f697
DMI 2.3 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE50780, 005C (r1 HP     A08             2   =D2=04     162E)
ACPI: FACP 7FE50800, 00F4 (r3 HP     A08             2   =D2=04     162E)
ACPI: DSDT 7FE50900, 3F75 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE50100, 0040
ACPI: SPCR 7FE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG 7FE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET 7FE50200, 0038 (r1 HP     A08             2   =D2=04     162E)
ACPI: SPMI 7FE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE50280, 00DE (r1 HP     00000083        2             0)
ACPI: SRAT 7FE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16080
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [0000000000017000 -  0000000000046fff] pages 30
(8 early reservations) =3D=3D> bootmem [0000000000 - 0180000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
08000]
  #2 [0000200000 - 000088c750]    TEXT DATA BSS =3D=3D> [0000200000 - 00008=
8c750]
  #3 [007fd04000 - 007fe4f697]          RAMDISK =3D=3D> [007fd04000 - 007fe=
4f697]
  #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000009f400 - 00001=
00000]
  #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 00000=
0a000]
  #6 [000000a000 - 0000011000]          PGTABLE =3D=3D> [000000a000 - 00000=
11000]
  #7 [0000011000 - 0000016080]       MEMNODEMAP =3D=3D> [0000011000 - 00000=
16080]
Bootmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180003fff]
  bootmap [0000000180004000 -  0000000180023fff] pages 20
(8 early reservations) =3D=3D> bootmem [0180000000 - 027ffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 000088c750]    TEXT DATA BSS
  #3 [007fd04000 - 007fe4f697]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 0000011000]          PGTABLE
  #7 [0000011000 - 0000016080]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] 000f4f80
 [ffffe20000000000-ffffe200053fffff] PMD -> [ffff880028200000-ffff88002b9ff=
fff] on node 0
 [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff880180200000-ffff8801839ff=
fff] on node 1
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048046
  DMA zone: 2151 pages, LIFO batch:0
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 0, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
PERCPU: Allocating 47784 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 2
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2058990
Policy zone: Normal
Kernel command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=
=3D54839@139.185.50.77/eth0,54839@139.185.50.76/00:18:FE:34:1C:3D debug ign=
ore_loglevel initcall_debug 3 kex
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 1004.630 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Node 0: aperture @ c000000 size 64 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 8197540k/10485756k available (3463k kernel code, 188944k reserved, =
1822k data, 392k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D2
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2009.26 BogoMIPS (lpj=3D4018520)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080729
Setting APIC routing to flat
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557900
Detected 12.557 MHz APIC timer.
calling  migration_init+0x0/0x5b
initcall migration_init+0x0/0x5b returned 1 after 0 msecs
initcall migration_init+0x0/0x5b returned with error code 1=20
calling  spawn_ksoftirqd+0x0/0x58
initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0 msecs
calling  init_call_single_data+0x0/0x47
initcall init_call_single_data+0x0/0x47 returned 0 after 0 msecs
calling  spawn_softlockup_task+0x0/0x74
initcall spawn_softlockup_task+0x0/0x74 returned 0 after 0 msecs
calling  relay_init+0x0/0x14
initcall relay_init+0x0/0x14 returned 0 after 0 msecs
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2009.35 BogoMIPS (lpj=3D40=
18704)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 2009.44 BogoMIPS (lpj=3D40=
18884)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 2009.38 BogoMIPS (lpj=3D40=
18764)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (8037.43 BogoMIPS).
khelper used greatest stack depth: 6040 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x1b
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 =
msecs
calling  net_ns_init+0x0/0x15d
net_namespace: 592 bytes
initcall net_ns_init+0x0/0x15d returned 0 after 0 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x41
initcall init_smp_flush+0x0/0x41 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x32
initcall sysctl_init+0x0/0x32 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xbb
initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x12
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
calling  pm_init+0x0/0x34
initcall pm_init+0x0/0x34 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x19
initcall pm_disk_init+0x0/0x19 returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x2c
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 msecs
calling  filelock_init+0x0/0x2e
initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x3f
initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x12
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x12
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x12
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x51
initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
calling  random32_init+0x0/0xcc
initcall random32_init+0x0/0xcc returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x76
initcall cpufreq_core_init+0x0/0x76 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x40
initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
calling  sock_init+0x0/0x59
initcall sock_init+0x0/0x59 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x31
initcall netpoll_init+0x0/0x31 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x14d
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14d returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x41
initcall bdi_class_init+0x0/0x41 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x45
initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x19
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x12
initcall pci_driver_init+0x0/0x12 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x4d
initcall backlight_class_init+0x0/0x4d returned 0 after 0 msecs
calling  tty_class_init+0x0/0x31
initcall tty_class_init+0x0/0x31 returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xc3
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 msecs
calling  register_node_type+0x0/0x6b
initcall register_node_type+0x0/0x6b returned 0 after 0 msecs
calling  enable_pci_io_ecs+0x0/0x2e
initcall enable_pci_io_ecs+0x0/0x2e returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x7ed
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
initcall early_fill_mp_bus_info+0x0/0x7ed returned 0 after 3 msecs
calling  arch_kdebugfs_init+0x0/0x24
initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x77
initcall mtrr_if_init+0x0/0x77 returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x31
initcall ffh_cstate_init+0x0/0x31 returned -1 after 0 msecs
initcall ffh_cstate_init+0x0/0x31 returned with error code -1=20
calling  acpi_pci_init+0x0/0x57
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x57 returned 0 after 0 msecs
calling  init_acpi_device_notify+0x0/0x4b
initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x2f0
initcall dmi_id_init+0x0/0x2f0 returned 0 after 0 msecs
calling  pci_arch_init+0x0/0x4e
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=3Dbfsort.
initcall pci_arch_init+0x0/0x4e returned 0 after 0 msecs
calling  topology_init+0x0/0x73
initcall topology_init+0x0/0x73 returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x3d
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x1e7
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff802358cb>] warn_slowpath+0xae/0xdd
 [<ffffffff8036a6be>] ? number+0x115/0x21f
 [<ffffffff8036574d>] ? __next_cpu+0x19/0x26
 [<ffffffff8022d575>] ? find_busiest_group+0x25b/0x6ee
 [<ffffffff8036aefc>] ? string+0x3d/0xa2
 [<ffffffff80365e02>] ? idr_get_empty_slot+0x161/0x24e
 [<ffffffff8036b2ea>] ? vsnprintf+0x389/0x678
 [<ffffffff802def96>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802aa5bf>] ? ifind+0x3d/0xac
 [<ffffffff802df1bd>] ? sysfs_find_dirent+0x1c/0x31
 [<ffffffff802df1f1>] ? __sysfs_add_one+0x1f/0x7c
 [<ffffffff802df283>] sysfs_add_one+0x35/0x3d
 [<ffffffff802df7d2>] create_dir+0x58/0x93
 [<ffffffff802df845>] sysfs_create_dir+0x38/0x4f
 [<ffffffff80366b8a>] kobject_add_internal+0xce/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
 [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
 [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register th=
ings with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff8036698f>] ? kobject_put+0x47/0x4b
 [<ffffffff80366c08>] kobject_add_internal+0x14c/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
 [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
 [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
initcall param_sysfs_init+0x0/0x1e7 returned 0 after 19 msecs
calling  pm_sysrq_init+0x0/0x19
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 msecs
calling  readahead_init+0x0/0x38
initcall readahead_init+0x0/0x38 returned 0 after 0 msecs
calling  init_bio+0x0/0xc5
initcall init_bio+0x0/0xc5 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x2a
initcall blk_settings_init+0x0/0x2a returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x2a
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x55
initcall genhd_device_init+0x0/0x55 returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x45
initcall pci_slot_init+0x0/0x45 returned 0 after 0 msecs
calling  fbmem_init+0x0/0x91
initcall fbmem_init+0x0/0x91 returned 0 after 0 msecs
calling  acpi_init+0x0/0x230
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 7FE58000, 04F0 (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: MCFG area at 80000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at 80000000 - 8fffffff
initcall acpi_init+0x0/0x230 returned 0 after 22 msecs
calling  acpi_scan_init+0x0/0x11e
initcall acpi_scan_init+0x0/0x11e returned 0 after 7 msecs
calling  acpi_ec_init+0x0/0x61
initcall acpi_ec_init+0x0/0x61 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x28
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:01:03.0: supports D1
pci 0000:01:03.0: supports D2
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: transparent bridge
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:42:08.0: supports D1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 26 msecs
calling  acpi_pci_link_init+0x0/0x48
ACPI: PCI Interrupt Link [LNKW] (IRQs *16)
ACPI: PCI Interrupt Link [LNKX] (IRQs *17)
ACPI: PCI Interrupt Link [LNKY] (IRQs *18)
ACPI: PCI Interrupt Link [LNKZ] (IRQs *19)
ACPI: PCI Interrupt Link [LNU0] (IRQs *22)
ACPI: PCI Interrupt Link [LNU2] (IRQs *23)
ACPI: PCI Interrupt Link [LNKA] (IRQs *54)
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x48 returned 0 after 3 msecs
calling  acpi_power_init+0x0/0x77
initcall acpi_power_init+0x0/0x77 returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x260
initcall acpi_system_init+0x0/0x260 returned 0 after 0 msecs
calling  acpi_cm_sbs_init+0x0/0x8
initcall acpi_cm_sbs_init+0x0/0x8 returned 0 after 0 msecs
calling  pnp_init+0x0/0x20
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall pnp_init+0x0/0x20 returned 0 after 0 msecs
calling  pnpacpi_init+0x0/0x8c
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 7 msecs
calling  misc_init+0x0/0x9f
initcall misc_init+0x0/0x9f returned 0 after 0 msecs
calling  cn_init+0x0/0xee
initcall cn_init+0x0/0xee returned 0 after 0 msecs
calling  phy_init+0x0/0x31
initcall phy_init+0x0/0x31 returned 0 after 0 msecs
calling  init_scsi+0x0/0x91
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 0 msecs
calling  usb_init+0x0/0x122
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x122 returned 0 after 0 msecs
calling  serio_init+0x0/0x89
initcall serio_init+0x0/0x89 returned 0 after 0 msecs
calling  input_init+0x0/0x10e
initcall input_init+0x0/0x10e returned 0 after 3 msecs
calling  rtc_init+0x0/0x71
initcall rtc_init+0x0/0x71 returned 0 after 0 msecs
calling  i2c_init+0x0/0x66
initcall i2c_init+0x0/0x66 returned 0 after 0 msecs
calling  power_supply_class_init+0x0/0x38
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 msecs
calling  hwmon_init+0x0/0x42
initcall hwmon_init+0x0/0x42 returned 0 after 0 msecs
calling  thermal_init+0x0/0x58
initcall thermal_init+0x0/0x58 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x12c
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x12c returned 0 after 0 msecs
calling  proto_init+0x0/0x2e
initcall proto_init+0x0/0x2e returned 0 after 0 msecs
calling  net_dev_init+0x0/0x146
initcall net_dev_init+0x0/0x146 returned 0 after 0 msecs
calling  neigh_init+0x0/0x71
initcall neigh_init+0x0/0x71 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xa6
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 msecs
calling  genl_init+0x0/0xd9
initcall genl_init+0x0/0xd9 returned 0 after 15 msecs
calling  sysctl_init+0x0/0x49
initcall sysctl_init+0x0/0x49 returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x12
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x12 returned 0 after 7 msecs
calling  hpet_late_init+0x0/0x114
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
initcall hpet_late_init+0x0/0x114 returned 0 after 0 msecs
calling  clocksource_done_booting+0x0/0x12
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 msecs
calling  init_pipe_fs+0x0/0x4c
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x47
initcall init_mnt_writers+0x0/0x47 returned 0 after 0 msecs
calling  eventpoll_init+0x0/0x85
initcall eventpoll_init+0x0/0x85 returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x11d
initcall anon_inode_init+0x0/0x11d returned 0 after 0 msecs
calling  acpi_rtc_init+0x0/0xf4
initcall acpi_rtc_init+0x0/0xf4 returned 0 after 0 msecs
calling  acpi_event_init+0x0/0x80
initcall acpi_event_init+0x0/0x80 returned 0 after 19 msecs
calling  pnp_system_init+0x0/0x12
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0x80000000-0x8fffffff could not be reserved
system 00:01: iomem range 0xf7df0000-0xf7df0fff has been reserved
system 00:01: iomem range 0xfdef0000-0xfdef0fff has been reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 3 msecs
calling  chr_dev_init+0x0/0xa1
initcall chr_dev_init+0x0/0xa1 returned 0 after 1 msecs
calling  firmware_class_init+0x0/0x79
initcall firmware_class_init+0x0/0x79 returned 0 after 0 msecs
calling  loopback_init+0x0/0x12
initcall loopback_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_performance_init+0x0/0x12
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_userspace_init+0x0/0x12
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 msecs
calling  init_acpi_pm_clocksource+0x0/0xa4
initcall init_acpi_pm_clocksource+0x0/0xa4 returned 0 after 0 msecs
calling  ssb_modinit+0x0/0x4a
initcall ssb_modinit+0x0/0x4a returned 0 after 0 msecs
calling  pcibios_assign_resources+0x0/0x87
pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
pci 0000:00:09.0:   IO window: 0x1000-0x2fff
pci 0000:00:09.0:   MEM window: 0xf7e00000-0xf7ffffff
pci 0000:00:09.0:   PREFETCH window: 0x000000e8000000-0x000000efffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: disabled
pci 0000:02:00.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:02:00.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:0b.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
pci 0000:04:00.0:   IO window: disabled
pci 0000:04:00.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:04:00.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:0c.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
pci 0000:06:00.0:   IO window: disabled
pci 0000:06:00.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:06:00.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:0d.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:0e.0:   IO window: 0x3000-0x3fff
pci 0000:00:0e.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:0e.0:   PREFETCH window: 0x00000090300000-0x000000903fffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:42:04.0: PCI bridge, secondary bus 0000:43
pci 0000:42:04.0:   IO window: disabled
pci 0000:42:04.0:   MEM window: disabled
pci 0000:42:04.0:   PREFETCH window: disabled
pci 0000:41:00.0: PCI bridge, secondary bus 0000:42
pci 0000:41:00.0:   IO window: 0x4000-0x4fff
pci 0000:41:00.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:41:00.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0c.0: PCI bridge, secondary bus 0000:41
pci 0000:40:0c.0:   IO window: 0x4000-0x4fff
pci 0000:40:0c.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:40:0c.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0d.0: PCI bridge, secondary bus 0000:44
pci 0000:40:0d.0:   IO window: disabled
pci 0000:40:0d.0:   MEM window: disabled
pci 0000:40:0d.0:   PREFETCH window: disabled
pci 0000:40:0e.0: PCI bridge, secondary bus 0000:47
pci 0000:40:0e.0:   IO window: disabled
pci 0000:40:0e.0:   MEM window: disabled
pci 0000:40:0e.0:   PREFETCH window: disabled
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
initcall pcibios_assign_resources+0x0/0x87 returned 0 after 11 msecs
calling  inet_init+0x0/0x204
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x204 returned 0 after 67 msecs
calling  af_unix_init+0x0/0x55
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 0 msecs
calling  populate_rootfs+0x0/0xea
checking if image is initramfs... it is
Freeing initrd memory: 1325k freed
initcall populate_rootfs+0x0/0xea returned 0 after 193 msecs
calling  i8259A_init_sysfs+0x0/0x22
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  vsyscall_init+0x0/0x6c
initcall vsyscall_init+0x0/0x6c returned 0 after 0 msecs
calling  sbf_init+0x0/0xd7
initcall sbf_init+0x0/0xd7 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x22
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  add_rtc_cmos+0x0/0x1d
initcall add_rtc_cmos+0x0/0x1d returned 0 after 0 msecs
calling  cache_sysfs_init+0x0/0x54
initcall cache_sysfs_init+0x0/0x54 returned 0 after 1 msecs
calling  mce_init_device+0x0/0x75
initcall mce_init_device+0x0/0x75 returned 0 after 0 msecs
calling  periodic_mcheck_init+0x0/0x3f
initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x7a
initcall thermal_throttle_init_device+0x0/0x7a returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x40
initcall threshold_init_device+0x0/0x40 returned 0 after 0 msecs
calling  msr_init+0x0/0xe7
initcall msr_init+0x0/0xe7 returned 0 after 0 msecs
calling  cpuid_init+0x0/0xe7
initcall cpuid_init+0x0/0xe7 returned 0 after 0 msecs
calling  microcode_init+0x0/0xb9
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
microcode: CPU2 not a capable Intel processor
microcode: CPU3 not a capable Intel processor
initcall microcode_init+0x0/0xb9 returned 0 after 1 msecs
calling  init_lapic_sysfs+0x0/0x2d
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 msecs
calling  ioapic_init_sysfs+0x0/0x99
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 0 msecs
calling  add_pcspkr+0x0/0x43
initcall add_pcspkr+0x0/0x43 returned 0 after 0 msecs
calling  uv_ptc_init+0x0/0x75
initcall uv_ptc_init+0x0/0x75 returned 0 after 0 msecs
calling  uv_bau_init+0x0/0x5a0
initcall uv_bau_init+0x0/0x5a0 returned 0 after 0 msecs
calling  audit_classes_init+0x0/0xaf
initcall audit_classes_init+0x0/0xaf returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x1f2
initcall init_vdso_vars+0x0/0x1f2 returned 0 after 0 msecs
calling  ia32_binfmt_init+0x0/0x14
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x2cc
initcall sysenter_setup+0x0/0x2cc returned 0 after 0 msecs
calling  init_aout_binfmt+0x0/0x12
initcall init_aout_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  ioresources_init+0x0/0x3c
initcall ioresources_init+0x0/0x3c returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x69
initcall uid_cache_init+0x0/0x69 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xb6
initcall init_posix_timers+0x0/0xb6 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xd4
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x2d
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x2bb
initcall create_proc_profile+0x0/0x2bb returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x22
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 msecs
calling  init_clocksource_sysfs+0x0/0x50
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 msecs
calling  init_timer_list_procfs+0x0/0x2c
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 msecs
calling  init_tstats_procfs+0x0/0x2c
initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 msecs
calling  futex_init+0x0/0x63
initcall futex_init+0x0/0x63 returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x22
initcall proc_dma_init+0x0/0x22 returned 0 after 0 msecs
calling  percpu_modinit+0x0/0x6f
initcall percpu_modinit+0x0/0x6f returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x25
initcall kallsyms_init+0x0/0x25 returned 0 after 0 msecs
calling  snapshot_device_init+0x0/0x12
initcall snapshot_device_init+0x0/0x12 returned 0 after 0 msecs
calling  crash_save_vmcoreinfo_init+0x0/0x42b
initcall crash_save_vmcoreinfo_init+0x0/0x42b returned 0 after 0 msecs
calling  crash_notes_memory_init+0x0/0x3d
initcall crash_notes_memory_init+0x0/0x3d returned 0 after 0 msecs
calling  ikconfig_init+0x0/0x39
initcall ikconfig_init+0x0/0x39 returned 0 after 0 msecs
calling  audit_init+0x0/0x14d
audit: initializing netlink socket (disabled)
type=3D2000 audit(1218672175.859:1): initialized
initcall audit_init+0x0/0x14d returned 0 after 0 msecs
calling  audit_tree_init+0x0/0x49
initcall audit_tree_init+0x0/0x49 returned 0 after 0 msecs
calling  init_kprobes+0x0/0x127
initcall init_kprobes+0x0/0x127 returned 0 after 5 msecs
calling  utsname_sysctl_init+0x0/0x14
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_per_zone_pages_min+0x0/0x53
initcall init_per_zone_pages_min+0x0/0x53 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x1d
initcall pdflush_init+0x0/0x1d returned 0 after 0 msecs
calling  kswapd_init+0x0/0x64
initcall kswapd_init+0x0/0x64 returned 0 after 0 msecs
calling  setup_vmstat+0x0/0x41
initcall setup_vmstat+0x0/0x41 returned 0 after 0 msecs
calling  mm_sysfs_init+0x0/0x29
initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 msecs
calling  procswaps_init+0x0/0x22
initcall procswaps_init+0x0/0x22 returned 0 after 0 msecs
calling  hugetlb_init+0x0/0x2ba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2ba returned 0 after 0 msecs
calling  init_tmpfs+0x0/0xda
initcall init_tmpfs+0x0/0xda returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0xf0
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 5 msecs
calling  fasync_init+0x0/0x2a
initcall fasync_init+0x0/0x2a returned 0 after 0 msecs
calling  aio_setup+0x0/0x6e
initcall aio_setup+0x0/0x6e returned 0 after 0 msecs
calling  inotify_setup+0x0/0x12
initcall inotify_setup+0x0/0x12 returned 0 after 0 msecs
calling  inotify_user_setup+0x0/0xb8
initcall inotify_user_setup+0x0/0xb8 returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x85
initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 msecs
calling  init_mbcache+0x0/0x14
initcall init_mbcache+0x0/0x14 returned 0 after 0 msecs
calling  dnotify_init+0x0/0x2a
initcall dnotify_init+0x0/0x2a returned 0 after 0 msecs
calling  vmcore_init+0x0/0x894
initcall vmcore_init+0x0/0x894 returned 0 after 0 msecs
calling  configfs_init+0x0/0xb3
initcall configfs_init+0x0/0xb3 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x3f
initcall init_devpts_fs+0x0/0x3f returned 0 after 0 msecs
calling  init_ext3_fs+0x0/0x7c
initcall init_ext3_fs+0x0/0x7c returned 0 after 0 msecs
calling  journal_init+0x0/0x99
initcall journal_init+0x0/0x99 returned 0 after 0 msecs
calling  init_ext2_fs+0x0/0x7c
initcall init_ext2_fs+0x0/0x7c returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x12
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_hugetlbfs_fs+0x0/0x98
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 msecs
calling  init_fat_fs+0x0/0x4f
initcall init_fat_fs+0x0/0x4f returned 0 after 0 msecs
calling  init_msdos_fs+0x0/0x12
initcall init_msdos_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_vfat_fs+0x0/0x12
initcall init_vfat_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_iso9660_fs+0x0/0x6c
initcall init_iso9660_fs+0x0/0x6c returned 0 after 0 msecs
calling  init_nfs_fs+0x0/0x10e
initcall init_nfs_fs+0x0/0x10e returned 0 after 0 msecs
calling  init_nfsd+0x0/0xbb
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xbb returned 0 after 0 msecs
calling  init_nlm+0x0/0x22
initcall init_nlm+0x0/0x22 returned 0 after 0 msecs
calling  init_nls_cp437+0x0/0x12
initcall init_nls_cp437+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp850+0x0/0x12
initcall init_nls_cp850+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_ascii+0x0/0x12
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_1+0x0/0x12
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_15+0x0/0x12
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_utf8+0x0/0x25
initcall init_nls_utf8+0x0/0x25 returned 0 after 0 msecs
calling  ipc_init+0x0/0x23
msgmni has been set to 16013
initcall ipc_init+0x0/0x23 returned 0 after 0 msecs
calling  ipc_sysctl_init+0x0/0x14
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_mqueue_fs+0x0/0xc6
initcall init_mqueue_fs+0x0/0xc6 returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0xd
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 msecs
calling  blkcipher_module_init+0x0/0x2a
initcall blkcipher_module_init+0x0/0x2a returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x31
initcall cryptomgr_init+0x0/0x31 returned 0 after 0 msecs
calling  hmac_module_init+0x0/0x12
initcall hmac_module_init+0x0/0x12 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x12
initcall md5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x12
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crypto_cbc_module_init+0x0/0x12
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  des_generic_mod_init+0x0/0x3f
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  cast5_mod_init+0x0/0x12
initcall cast5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  deflate_mod_init+0x0/0x12
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crc32c_mod_init+0x0/0x3f
initcall crc32c_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  crypto_authenc_module_init+0x0/0x12
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  bsg_init+0x0/0x126
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x126 returned 0 after 0 msecs
calling  noop_init+0x0/0x14
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 0 msecs
calling  as_init+0x0/0x14
io scheduler anticipatory registered
initcall as_init+0x0/0x14 returned 0 after 0 msecs
calling  deadline_init+0x0/0x14
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 0 msecs
calling  cfq_init+0x0/0x9d
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x9d returned 0 after 0 msecs
calling  percpu_counter_startup+0x0/0x14
initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
calling  pci_init+0x0/0x35
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:00.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Enabling HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Enabling HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
initcall pci_init+0x0/0x35 returned 0 after 3 msecs
calling  pci_proc_init+0x0/0x6a
initcall pci_proc_init+0x0/0x6a returned 0 after 0 msecs
calling  pcie_portdrv_init+0x0/0x4c
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
pci_express 0000:00:0b.0:pcie01: allocate port service
pci_express 0000:00:0b.0:pcie03: allocate port service
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
pci_express 0000:00:0c.0:pcie01: allocate port service
pci_express 0000:00:0c.0:pcie03: allocate port service
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: found MSI capability
pci_express 0000:00:0d.0:pcie00: allocate port service
pci_express 0000:00:0d.0:pcie01: allocate port service
pci_express 0000:00:0d.0:pcie03: allocate port service
pcieport-driver 0000:00:0e.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: found MSI capability
pci_express 0000:00:0e.0:pcie00: allocate port service
pci_express 0000:00:0e.0:pcie01: allocate port service
pci_express 0000:00:0e.0:pcie03: allocate port service
pcieport-driver 0000:40:0c.0: setting latency timer to 64
pcieport-driver 0000:40:0c.0: found MSI capability
pci_express 0000:40:0c.0:pcie00: allocate port service
pci_express 0000:40:0c.0:pcie01: allocate port service
pci_express 0000:40:0c.0:pcie03: allocate port service
pcieport-driver 0000:40:0d.0: setting latency timer to 64
pcieport-driver 0000:40:0d.0: found MSI capability
pci_express 0000:40:0d.0:pcie00: allocate port service
pci_express 0000:40:0d.0:pcie01: allocate port service
pci_express 0000:40:0d.0:pcie03: allocate port service
pcieport-driver 0000:40:0e.0: setting latency timer to 64
pcieport-driver 0000:40:0e.0: found MSI capability
pci_express 0000:40:0e.0:pcie00: allocate port service
pci_express 0000:40:0e.0:pcie01: allocate port service
pci_express 0000:40:0e.0:pcie03: allocate port service
initcall pcie_portdrv_init+0x0/0x4c returned 0 after 9 msecs
calling  fb_console_init+0x0/0x12b
initcall fb_console_init+0x0/0x12b returned 0 after 0 msecs
calling  rivafb_init+0x0/0x1a5
initcall rivafb_init+0x0/0x1a5 returned 0 after 0 msecs
calling  nvidiafb_init+0x0/0x2b6
initcall nvidiafb_init+0x0/0x2b6 returned 0 after 0 msecs
calling  vt8623fb_init+0x0/0x5f
initcall vt8623fb_init+0x0/0x5f returned 0 after 0 msecs
calling  vesafb_init+0x0/0x235
initcall vesafb_init+0x0/0x235 returned 0 after 0 msecs
calling  acpi_reserve_resources+0x0/0xeb
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 msecs
calling  acpi_ac_init+0x0/0x45
initcall acpi_ac_init+0x0/0x45 returned 0 after 0 msecs
calling  acpi_button_init+0x0/0x5e
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
initcall acpi_button_init+0x0/0x5e returned 0 after 0 msecs
calling  acpi_fan_init+0x0/0x5e
initcall acpi_fan_init+0x0/0x5e returned 0 after 0 msecs
calling  irqrouter_init_sysfs+0x0/0x38
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  acpi_processor_init+0x0/0x10b
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:02: registered as cooling_device2
processor ACPI0007:03: registered as cooling_device3
initcall acpi_processor_init+0x0/0x10b returned 0 after 1 msecs
calling  acpi_container_init+0x0/0x42
initcall acpi_container_init+0x0/0x42 returned 0 after 1 msecs
calling  acpi_thermal_init+0x0/0x83
initcall acpi_thermal_init+0x0/0x83 returned 0 after 0 msecs
calling  rand_initialize+0x0/0x2c
initcall rand_initialize+0x0/0x2c returned 0 after 0 msecs
calling  tty_init+0x0/0x1cd
initcall tty_init+0x0/0x1cd returned 0 after 21 msecs
calling  pty_init+0x0/0x26f
initcall pty_init+0x0/0x26f returned 0 after 0 msecs
calling  raw_init+0x0/0xdd
initcall raw_init+0x0/0xdd returned 0 after 0 msecs
calling  hpet_init+0x0/0x6a
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6a returned 0 after 0 msecs
calling  nvram_init+0x0/0x8a
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x8a returned 0 after 0 msecs
calling  mod_init+0x0/0x1f8
initcall mod_init+0x0/0x1f8 returned -19 after 0 msecs
calling  mod_init+0x0/0xba
initcall mod_init+0x0/0xba returned -19 after 0 msecs
calling  agp_init+0x0/0x26
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 0 msecs
calling  agp_intel_init+0x0/0x29
initcall agp_intel_init+0x0/0x29 returned 0 after 0 msecs
calling  agp_via_init+0x0/0x29
initcall agp_via_init+0x0/0x29 returned 0 after 0 msecs
calling  ipmi_init_msghandler_mod+0x0/0xd
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 0 msecs
calling  init_ipmi_devintf+0x0/0x101
ipmi device interface
initcall init_ipmi_devintf+0x0/0x101 returned 0 after 0 msecs
calling  init_ipmi_si+0x0/0x78a
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
Clocksource tsc unstable (delta =3D 4286114882816 ns)
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IR=
Q 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, =
slave address 0x0, irq 16
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
initcall init_ipmi_si+0x0/0x78a returned 0 after 185 msecs
calling  ipmi_wdog_init+0x0/0x12e
IPMI Watchdog: driver initialized
initcall ipmi_wdog_init+0x0/0x12e returned 0 after 6 msecs
calling  ipmi_poweroff_init+0x0/0x8d
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
initcall ipmi_poweroff_init+0x0/0x8d returned 0 after 52 msecs
calling  hangcheck_init+0x0/0x8a
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0x8a returned 0 after 0 msecs
calling  drm_core_init+0x0/0xf9
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0xf9 returned 0 after 0 msecs
calling  r128_init+0x0/0x1e
initcall r128_init+0x0/0x1e returned 0 after 0 msecs
calling  radeon_init+0x0/0x1e
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
pci 0000:01:03.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
[drm] Initialized radeon 1.29.0 20080528 on minor 0
initcall radeon_init+0x0/0x1e returned 0 after 2 msecs
calling  via_init+0x0/0x23
initcall via_init+0x0/0x23 returned 0 after 0 msecs
calling  cn_proc_init+0x0/0x3d
initcall cn_proc_init+0x0/0x3d returned 0 after 0 msecs
calling  serial8250_init+0x0/0x118
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_init+0x0/0x118 returned 0 after 1 msecs
calling  serial8250_pnp_init+0x0/0x12
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 0 msecs
calling  serial8250_pci_init+0x0/0x1b
initcall serial8250_pci_init+0x0/0x1b returned 0 after 0 msecs
calling  topology_sysfs_init+0x0/0x40
initcall topology_sysfs_init+0x0/0x40 returned 0 after 0 msecs
calling  floppy_init+0x0/0xf14
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
initcall floppy_init+0x0/0xf14 returned -19 after 2875 msecs
calling  brd_init+0x0/0x167
brd: module loaded
initcall brd_init+0x0/0x167 returned 0 after 4 msecs
calling  bnx2_init+0x0/0x1b
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.9 (July 18, 2008)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 48 msecs
calling  net_olddevs_init+0x0/0xa0
initcall net_olddevs_init+0x0/0xa0 returned 0 after 0 msecs
calling  b44_init+0x0/0x63
initcall b44_init+0x0/0x63 returned 0 after 0 msecs
calling  tun_init+0x0/0xa0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0xa0 returned 0 after 0 msecs
calling  init_netconsole+0x0/0x1bc
netconsole: local port 54839
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 54839
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2: eth0: using MSI
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
bnx2: eth0 NIC SerDes Link is Up, 1000 Mbps full duplex
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1bc returned 0 after 4173 msecs
calling  scsi_tgt_init+0x0/0x7f
initcall scsi_tgt_init+0x0/0x7f returned 0 after 0 msecs
calling  raid_init+0x0/0x12
initcall raid_init+0x0/0x12 returned 0 after 0 msecs
calling  spi_transport_init+0x0/0x2e
initcall spi_transport_init+0x0/0x2e returned 0 after 0 msecs
calling  fc_transport_init+0x0/0x4c
initcall fc_transport_init+0x0/0x4c returned 0 after 0 msecs
calling  iscsi_transport_init+0x0/0x148
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x148 returned 0 after 0 msecs
calling  sas_transport_init+0x0/0xbb
initcall sas_transport_init+0x0/0xbb returned 0 after 0 msecs
calling  sas_class_init+0x0/0x31
initcall sas_class_init+0x0/0x31 returned 0 after 0 msecs
calling  init_sd+0x0/0x10a
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0x10a returned 0 after 0 msecs
calling  init_sg+0x0/0x15a
initcall init_sg+0x0/0x15a returned 0 after 0 msecs
calling  mon_init+0x0/0x103
initcall mon_init+0x0/0x103 returned 0 after 0 msecs
calling  i8042_init+0x0/0x3bd
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3bd returned 0 after 2 msecs
calling  serport_init+0x0/0x34
initcall serport_init+0x0/0x34 returned 0 after 0 msecs
calling  serio_raw_init+0x0/0x1b
initcall serio_raw_init+0x0/0x1b returned 0 after 0 msecs
calling  mousedev_init+0x0/0x61
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x61 returned 0 after 0 msecs
calling  evdev_init+0x0/0x12
initcall evdev_init+0x0/0x12 returned 0 after 12 msecs
calling  atkbd_init+0x0/0x27
initcall atkbd_init+0x0/0x27 returned 0 after 0 msecs
calling  psmouse_init+0x0/0x6d
initcall psmouse_init+0x0/0x6d returned 0 after 58 msecs
calling  pcspkr_init+0x0/0x12
input: PC Speaker as /class/input/input1
initcall pcspkr_init+0x0/0x12 returned 0 after 20 msecs
calling  uinput_init+0x0/0x12
initcall uinput_init+0x0/0x12 returned 0 after 0 msecs
calling  cmos_init+0x0/0x30
initcall cmos_init+0x0/0x30 returned 0 after 0 msecs
calling  i2c_dev_init+0x0/0xa6
i2c /dev entries driver
initcall i2c_dev_init+0x0/0xa6 returned 0 after 0 msecs
calling  amd756_init+0x0/0x1b
initcall amd756_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_amd8111_init+0x0/0x1b
initcall i2c_amd8111_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_i801_init+0x0/0x1b
initcall i2c_i801_init+0x0/0x1b returned 0 after 0 msecs
calling  nforce2_init+0x0/0x1b
initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_piix4_init+0x0/0x1b
initcall i2c_piix4_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt586b_init+0x0/0x1b
initcall i2c_vt586b_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt596_init+0x0/0x1b
initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 msecs
calling  coretemp_init+0x0/0x152
initcall coretemp_init+0x0/0x152 returned -19 after 0 msecs
calling  k8temp_init+0x0/0x1b
initcall k8temp_init+0x0/0x1b returned 0 after 0 msecs
calling  sm_via686a_init+0x0/0x1b
initcall sm_via686a_init+0x0/0x1b returned 0 after 0 msecs
calling  vt1211_init+0x0/0x14e
initcall vt1211_init+0x0/0x14e returned -19 after 0 msecs
calling  sm_vt8231_init+0x0/0x1b
initcall sm_vt8231_init+0x0/0x1b returned 0 after 0 msecs
calling  watchdog_init+0x0/0xb4
SoftDog: cannot register miscdev on minor=3D130 (err=3D-16)
initcall watchdog_init+0x0/0xb4 returned -16 after 0 msecs
initcall watchdog_init+0x0/0xb4 returned with error code -16=20
calling  edac_init+0x0/0x9d
EDAC MC: Ver: 2.1.0 Aug 13 2008
initcall edac_init+0x0/0x9d returned 0 after 0 msecs
calling  i5000_init+0x0/0x41
initcall i5000_init+0x0/0x41 returned 0 after 0 msecs
calling  e752x_init+0x0/0x41
initcall e752x_init+0x0/0x41 returned 0 after 0 msecs
calling  i82975x_init+0x0/0xa0
initcall i82975x_init+0x0/0xa0 returned -19 after 0 msecs
calling  cpufreq_stats_init+0x0/0x86
initcall cpufreq_stats_init+0x0/0x86 returned 0 after 0 msecs
calling  cpufreq_gov_powersave_init+0x0/0x12
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x61
initcall cpufreq_gov_dbs_init+0x0/0x61 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x12
initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 msecs
calling  init_ladder+0x0/0x12
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 0 msecs
calling  hid_init+0x0/0x8
initcall hid_init+0x0/0x8 returned 0 after 0 msecs
calling  hid_init+0x0/0x61
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0x61 returned 0 after 0 msecs
calling  sysctl_core_init+0x0/0x25
initcall sysctl_core_init+0x0/0x25 returned 0 after 0 msecs
calling  flow_cache_init+0x0/0x1b3
initcall flow_cache_init+0x0/0x1b3 returned 0 after 0 msecs
calling  sysctl_ipv4_init+0x0/0x4e
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 msecs
calling  ipip_init+0x0/0x71
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x71 returned 0 after 0 msecs
calling  ipgre_init+0x0/0x71
GRE over IPv4 tunneling driver
initcall ipgre_init+0x0/0x71 returned 0 after 0 msecs
calling  init_syncookies+0x0/0x19
initcall init_syncookies+0x0/0x19 returned 0 after 0 msecs
calling  ah4_init+0x0/0x68
initcall ah4_init+0x0/0x68 returned 0 after 0 msecs
calling  esp4_init+0x0/0x68
initcall esp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipcomp4_init+0x0/0x68
initcall ipcomp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipip_init+0x0/0x68
initcall ipip_init+0x0/0x68 returned 0 after 0 msecs
calling  xfrm4_beet_init+0x0/0x17
initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 msecs
calling  tunnel4_init+0x0/0x32
initcall tunnel4_init+0x0/0x32 returned 0 after 0 msecs
calling  xfrm4_transport_init+0x0/0x17
initcall xfrm4_transport_init+0x0/0x17 returned 0 after 0 msecs
calling  xfrm4_mode_tunnel_init+0x0/0x17
initcall xfrm4_mode_tunnel_init+0x0/0x17 returned 0 after 0 msecs
calling  inet_diag_init+0x0/0x69
initcall inet_diag_init+0x0/0x69 returned 0 after 0 msecs
calling  tcp_diag_init+0x0/0x12
initcall tcp_diag_init+0x0/0x12 returned 0 after 0 msecs
calling  bictcp_register+0x0/0x12
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 0 msecs
calling  xfrm_user_init+0x0/0x58
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x58 returned 0 after 0 msecs
calling  packet_init+0x0/0x47
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 0 msecs
calling  ipsec_pfkey_init+0x0/0x8c
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0x8c returned 0 after 0 msecs
calling  init_sunrpc+0x0/0x5d
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall init_sunrpc+0x0/0x5d returned 0 after 0 msecs
calling  init_rpcsec_gss+0x0/0x38
initcall init_rpcsec_gss+0x0/0x38 returned 0 after 0 msecs
calling  init_kerberos_module+0x0/0x2f
initcall init_kerberos_module+0x0/0x2f returned 0 after 0 msecs
calling  init_spkm3_module+0x0/0x2f
initcall init_spkm3_module+0x0/0x2f returned 0 after 0 msecs
calling  powernowk8_init+0x0/0xc2
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 8218 processors (4=
 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
initcall powernowk8_init+0x0/0xc2 returned 0 after 3 msecs
calling  acpi_cpufreq_init+0x0/0xaa
initcall acpi_cpufreq_init+0x0/0xaa returned -16 after 0 msecs
initcall acpi_cpufreq_init+0x0/0xaa returned with error code -16=20
calling  centrino_init+0x0/0x36
initcall centrino_init+0x0/0x36 returned -19 after 0 msecs
calling  cpufreq_p4_init+0x0/0x63
initcall cpufreq_p4_init+0x0/0x63 returned -19 after 0 msecs
calling  hpet_insert_resource+0x0/0x23
initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 msecs
calling  update_mp_table+0x0/0x492
initcall update_mp_table+0x0/0x492 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x40
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x38
initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x4f
initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x42
initcall check_early_ioremap_leak+0x0/0x42 returned 0 after 0 msecs
calling  pat_memtype_list_init+0x0/0x29
initcall pat_memtype_list_init+0x0/0x29 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x23
initcall init_oops_id+0x0/0x23 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3a
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x61
initcall pm_qos_power_init+0x0/0x61 returned 0 after 0 msecs
calling  software_resume+0x0/0x13f
initcall software_resume+0x0/0x13f returned -2 after 0 msecs
initcall software_resume+0x0/0x13f returned with error code -2=20
calling  debugfs_kprobe_init+0x0/0x89
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 msecs
calling  taskstats_init+0x0/0x95
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 0 msecs
calling  random32_reseed+0x0/0x8d
initcall random32_reseed+0x0/0x8d returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x4c
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xa5
initcall acpi_wakeup_device_init+0x0/0xa5 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x55
initcall acpi_sleep_proc_init+0x0/0x55 returned 0 after 0 msecs
calling  seqgen_init+0x0/0xf
initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xe5
initcall scsi_complete_async_scans+0x0/0xe5 returned 0 after 0 msecs
calling  rtc_hctosys+0x0/0x17b
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall rtc_hctosys+0x0/0x17b returned -19 after 0 msecs
calling  edd_init+0x0/0x2f1
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
initcall edd_init+0x0/0x2f1 returned -19 after 0 msecs
calling  memmap_init+0x0/0xa3
initcall memmap_init+0x0/0xa3 returned 0 after 0 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x43
initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x12
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
Freeing unused kernel memory: 392k freed
Write protecting the kernel read-only data: 4728k
calling  uhci_hcd_init+0x0/0xb1 [uhci_hcd]
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> I=
RQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 1
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xb1 [uhci_hcd] returned 0 after 197 msecs
insmod used greatest stack depth: 4928 bytes left
calling  ohci_hcd_mod_init+0x0/0x45 [ohci_hcd]
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> I=
RQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
initcall ohci_hcd_mod_init+0x0/0x45 [ohci_hcd] returned 0 after 154 msecs
calling  ehci_hcd_init+0x0/0x20 [ehci_hcd]
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> I=
RQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
usb 1-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input2
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
initcall ehci_hcd_init+0x0/0x20 [ehci_hcd] returned 0 after 154 msecs
insmod used greatest stack depth: 4880 bytes left
calling  cciss_init+0x0/0x2e [cciss]
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ =
54
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
IP: [<ffffffffa001cb68>] do_cciss_intr+0x627/0xa6c [cciss]
PGD 17eba6067 PUD 17eba7067 PMD 0=20
Oops: 0002 [1] SMP=20
last sysfs file: /sys/block/ram15/dev
CPU 2=20
Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080814 #1
RIP: 0010:[<ffffffffa001cb68>]  [<ffffffffa001cb68>] do_cciss_intr+0x627/0x=
a6c [cciss]
RSP: 0018:ffff88027f66bee8  EFLAGS: 00010007
RAX: 0000000000000000 RBX: ffff88007f840270 RCX: 000000000000000c
RDX: 0000000000000000 RSI: ffff88027e560000 RDI: ffff88027e560000
RBP: ffff88027f66bf18 R08: 0000000000000000 R09: ffff88017fa99e88
R10: 0000000000000000 R11: 000000008022ec53 R12: ffff88027e560000
R13: 0000000000000000 R14: 00000000000001f7 R15: 0000000000000086
FS:  0000000000680850(0000) GS:ffff88017fc02b80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000248 CR3: 000000017eba0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88017fa98000, task ffff88027f63d280)
Stack:  ffff88027f66bee0 ffff88027f64a800 0000000000000000 0000000000000000
 00000000000001f7 0000000000000000 ffff88027f66bf48 ffffffff8026807a
 ffffffff8073a000 00000000000001f7 ffff88027f64a800 ffffffff8073a050
Call Trace:
 <IRQ>  [<ffffffff8026807a>] handle_IRQ_event+0x27/0x57
 [<ffffffff802698dc>] handle_edge_irq+0xed/0x12e
 [<ffffffff8020eaac>] do_IRQ+0xf7/0x16f
 [<ffffffff8020c471>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802122ed>] ? default_idle+0x2b/0x40
 [<ffffffff802124fb>] ? c1e_idle+0xd4/0xdb
 [<ffffffff8055d0bb>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ac61>] ? cpu_idle+0x5f/0x7d
 [<ffffffff80554f4f>] ? start_secondary+0x16c/0x171


Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00 01 00 75 08 49 89 =
84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b 93 48 02 00 00 <48> 89 90 48 0=
2 00 00 48 8b 93 48 02 00 00 48 89 82 40 02 00 00=20
RIP  [<ffffffffa001cb68>] do_cciss_intr+0x627/0xa6c [cciss]
 RSP <ffff88027f66bee8>
CR2: 0000000000000248
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc3-next-20080814 #1

Call Trace:
 <IRQ>  [<ffffffff802356de>] panic+0xa0/0x160
 [<ffffffff8024a586>] ? blocking_notifier_call_chain+0xf/0x11
 [<ffffffff80238231>] do_exit+0x78/0x842
 [<ffffffff803dece5>] ? do_unblank_screen+0x2e/0x12a
 [<ffffffff8055afee>] oops_begin+0x0/0x96
 [<ffffffff8055cf93>] do_page_fault+0x74a/0x7f9
 [<ffffffff8055ac29>] error_exit+0x0/0x51
 [<ffffffffa001cb68>] ? do_cciss_intr+0x627/0xa6c [cciss]
 [<ffffffffa001cf42>] ? do_cciss_intr+0xa01/0xa6c [cciss]
 [<ffffffff8026807a>] handle_IRQ_event+0x27/0x57
 [<ffffffff802698dc>] handle_edge_irq+0xed/0x12e
 [<ffffffff8020eaac>] do_IRQ+0xf7/0x16f
 [<ffffffff8020c471>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802122ed>] ? default_idle+0x2b/0x40
 [<ffffffff802124fb>] ? c1e_idle+0xd4/0xdb
 [<ffffffff8055d0bb>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ac61>] ? cpu_idle+0x5f/0x7d
 [<ffffffff80554f4f>] ? start_secondary+0x16c/0x171

------------[ cut here ]------------
WARNING: at kernel/smp.c:328 smp_call_function_mask+0x40/0x1cb()
Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc3-next-20080814 #1

Call Trace:
 <IRQ>  [<ffffffff802357f6>] warn_on_slowpath+0x58/0x7f
 [<ffffffff80554f4f>] ? start_secondary+0x16c/0x171
 [<ffffffff80554f4f>] ? start_secondary+0x16c/0x171
 [<ffffffff80236323>] ? printk+0x67/0x69
 [<ffffffff8025288d>] smp_call_function_mask+0x40/0x1cb
 [<ffffffff8021d623>] ? stop_this_cpu+0x0/0x1d
 [<ffffffff8020d5af>] ? dump_trace+0x2fb/0x349
 [<ffffffff8020d654>] ? show_trace_log_lvl+0x57/0x63
 [<ffffffff80252a33>] smp_call_function+0x1b/0x1d
 [<ffffffff8021d691>] native_smp_send_stop+0x22/0x30
 [<ffffffff802356f2>] panic+0xb4/0x160
 [<ffffffff8024a586>] ? blocking_notifier_call_chain+0xf/0x11
 [<ffffffff80238231>] do_exit+0x78/0x842
 [<ffffffff803dece5>] ? do_unblank_screen+0x2e/0x12a
 [<ffffffff8055afee>] oops_begin+0x0/0x96
 [<ffffffff8055cf93>] do_page_fault+0x74a/0x7f9
 [<ffffffff8055ac29>] error_exit+0x0/0x51
 [<ffffffffa001cb68>] ? do_cciss_intr+0x627/0xa6c [cciss]
 [<ffffffffa001cf42>] ? do_cciss_intr+0xa01/0xa6c [cciss]
 [<ffffffff8026807a>] handle_IRQ_event+0x27/0x57
 [<ffffffff802698dc>] handle_edge_irq+0xed/0x12e
 [<ffffffff8020eaac>] do_IRQ+0xf7/0x16f
 [<ffffffff8020c471>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802122ed>] ? default_idle+0x2b/0x40
 [<ffffffff802124fb>] ? c1e_idle+0xd4/0xdb
 [<ffffffff8055d0bb>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ac61>] ? cpu_idle+0x5f/0x7d
 [<ffffffff80554f4f>] ? start_secondary+0x16c/0x171

---[ end trace 4eaa2a86a8e2da22 ]---

--Multipart=_Thu__14_Aug_2008_19_46_31_-0700_/ZWuke=0rFKSo/yt--
