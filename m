Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbYISGHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbYISGHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 02:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYISGHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 02:07:25 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50342 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYISGHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 02:07:23 -0400
Message-Id: <200809190607.m8J67EI9086315@www262.sakura.ne.jp>
Subject: Re: [2.6.27-rc6-mm1] Boot hangs while initializing SCSI disk.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Sep 2008 15:07:14 +0900
References: <200809190200.m8J20Rt4030923@www262.sakura.ne.jp> <20080918192125.fce21649.akpm@linux-foundation.org>
In-Reply-To: <20080918192125.fce21649.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> hm.  I don't _think_ we've merged anything since then which might have
> fixed it, but heaven knows what's been going on in linux-next.
> 
> I'll try to get rc6-mm2 or rc7-mm1 out soon - please retest that?
Yes.

I tried 2.6.27-rc5-mm1 and it also failed but different messages.

---------- Fedora 9 (2.6.27-rc5-mm1) ----------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27-rc5-mm1 (root@tomoyo) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Fri Sep 19 14:52:23 JST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
 BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
last_pfn = 0x40000 max_arch_pfn = 0x100000
RAMDISK: 37d93000 - 37fef9dd
Allocated new RAMDISK: 00b8d000 - 00de99dd
Move RAMDISK from 0000000037d93000 - 0000000037fef9dc to 00b8d000 - 00de99dc
DMI present.
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 3FEFAB68, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FEFEF14, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 3FEFAB98, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 3FEFFFC0, 0040
ACPI: APIC 3FEFEF88, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
136MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00009000 - 0000ff00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000200000 - 0000b88f0c]    TEXT DATA BSS ==> [0000200000 - 0000b88f0c]
  #4 [0000b89000 - 0000b8d000]    INIT_PG_TABLE ==> [0000b89000 - 0000b8d000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0000b8d000 - 0000de99dd]      NEW RAMDISK ==> [0000b8d000 - 0000de99dd]
  #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
found SMP MP-table at [c00f6cd0] 000f6cd0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fef0
    0: 0x0003ff00 -> 0x00040000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000
PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000
PM: Registered nosave memory: 00000000000cc000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
PERCPU: Allocating 32768 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258702
Kernel command line: ro root=UUID=07f36661-b30f-4ff9-8fee-f0e6325e872a console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: Unable to calibrate against PIT
TSC: using PMTIMER reference calibration
Detected 1994.991 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
 per task-struct memory footprint: 1152 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1021268k/1048576k available (3551k kernel code, 26504k reserved, 1887k data, 292k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0757000 - 0xc07a0000   ( 292 kB)
      .data : 0xc0577c9d - 0xc074fb04   (1887 kB)
      .text : 0xc0200000 - 0xc0577c9d   (3551 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.98 BogoMIPS (lpj=1994991)
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20080729
ioremap: invalid physical address 3fefab98
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:139 __ioremap_caller+0x60/0x269()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27-rc5-mm1 #1
 [<c057167f>] ? printk+0xf/0x18
 [<c0222853>] warn_on_slowpath+0x41/0x63
 [<c023e7b1>] ? trace_hardirqs_off+0xb/0xd
 [<c0573d60>] ? _spin_unlock_irqrestore+0x2f/0x3c
 [<c0222eba>] ? release_console_sem+0x197/0x1c4
 [<c023faa7>] ? trace_hardirqs_on+0xb/0xd
 [<c023faa7>] ? trace_hardirqs_on+0xb/0xd
 [<c057167f>] ? printk+0xf/0x18
 [<c0215b7a>] __ioremap_caller+0x60/0x269
 [<c0236a3c>] ? down_timeout+0x34/0x3b
 [<c0215e43>] ioremap_nocache+0x10/0x12
 [<c055a9d1>] ? acpi_os_map_memory+0x11/0x1a
 [<c055a9d1>] acpi_os_map_memory+0x11/0x1a
 [<c0348a03>] acpi_tb_verify_table+0x20/0x4d
 [<c034832a>] acpi_load_tables+0x3b/0x18e
 [<c0773020>] acpi_early_init+0x5d/0xeb
 [<c07578bf>] start_kernel+0x2fd/0x307
 [<c0757080>] __init_begin+0x80/0x88
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
ACPI Exception (tbxface-0627): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080729]
ACPI: Unable to load the System Description Tables
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Brought up 1 CPUs
Total of 1 processors activated (3989.98 BogoMIPS).
khelper used greatest stack depth: 7220 bytes left
net_namespace: 876 bytes
Time: 14:55:59  Date: 09/19/08
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=2
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x2a/0x36()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
 [<c02227f3>] warn_slowpath+0x4b/0x6a
 [<c0316606>] ? idr_get_empty_slot+0x12a/0x1d9
 [<c0573d8a>] ? _spin_unlock+0x1d/0x20
 [<c029625b>] ? ifind+0x83/0x8d
 [<c02c4a3c>] ? sysfs_find_dirent+0x16/0x27
 [<c02c4bd0>] sysfs_add_one+0x2a/0x36
 [<c02c50fc>] create_dir+0x43/0x87
 [<c02c516d>] sysfs_create_dir+0x2d/0x41
 [<c0573d8a>] ? _spin_unlock+0x1d/0x20
 [<c031710d>] kobject_add_internal+0xb7/0x158
 [<c0317259>] kobject_add_varg+0x35/0x41
 [<c031747d>] kobject_init_and_add+0x20/0x22
 [<c076a34f>] kernel_param_sysfs_setup+0x4c/0x99
 [<c076a487>] param_sysfs_init+0xeb/0x13e
 [<c0201125>] _stext+0x3d/0x104
 [<c076a39c>] ? param_sysfs_init+0x0/0x13e
 [<c021e510>] ? wake_up_process+0xf/0x11
 [<c02300dc>] ? start_workqueue_thread+0x1d/0x20
 [<c02303bb>] ? __create_workqueue_key+0xf9/0x1ee
 [<c0757379>] kernel_init+0x197/0x1fe
 [<c07571e2>] ? kernel_init+0x0/0x1fe
 [<c0204817>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
 [<c031719c>] kobject_add_internal+0x146/0x158
 [<c0317259>] kobject_add_varg+0x35/0x41
 [<c031747d>] kobject_init_and_add+0x20/0x22
 [<c076a34f>] kernel_param_sysfs_setup+0x4c/0x99
 [<c076a487>] param_sysfs_init+0xeb/0x13e
 [<c0201125>] _stext+0x3d/0x104
 [<c076a39c>] ? param_sysfs_init+0x0/0x13e
 [<c021e510>] ? wake_up_process+0xf/0x11
 [<c02300dc>] ? start_workqueue_thread+0x1d/0x20
 [<c02303bb>] ? __create_workqueue_key+0xf9/0x1ee
 [<c0757379>] kernel_init+0x197/0x1fe
 [<c07571e2>] ? kernel_init+0x0/0x1fe
 [<c0204817>] kernel_thread_helper+0x7/0x10
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: Interpreter disabled.
pnp: PnP ACPI: disabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:11.0: transparent bridge
PCI: bridge 0000:00:11.0 io port: [2000, 2fff]
pci 0000:00:07.0: PIIX/ICH IRQ router [8086:7110]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:11.0: PCI bridge, secondary bus 0000:02
pci 0000:00:11.0:   IO window: 0x2000-0x2fff
pci 0000:00:11.0:   MEM window: disabled
pci 0000:00:11.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:11.0: can't find IRQ for PCI INT A; probably buggy MP table
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [0, 0]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [2000, 2fff]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [50000000, 500fffff]
bus: 02 index 3 io port: [0, ffff]
bus: 02 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2418k freed
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
USB Universal Host Controller Interface driver v3.0
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1221836158.532:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1728
cryptomgr_test used greatest stack depth: 6972 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ioremap: invalid physical address 3fefef88
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 0) is a 16550A
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
sky2 driver version 1.22
console [netcon0] enabled
netconsole: network logging started
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1050 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1058 irq 15
ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi generic sg0 type 5
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, native irqs
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
modprobe used greatest stack depth: 6896 bytes left
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18rc1.
ALSA device list:
  No soundcards found.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 8:820:940
Freeing unused kernel memory: 292k freed
Write protecting the kernel text: 3552k
Write protecting the kernel read-only data: 1468k
Red Hat nash version 6.0.52 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block dFusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
modprobe used greatest stack depth: 6560 bytes left
evice nodes.
Loading mptbase module
Loading mptscsih module
Fusion MPT SPI Host driver 3.04.07
Loading mptspi mioremap: invalid physical address e8800000
mptbase: ioc0: ERROR - : ERROR - Unable to map adapter memory!
odule
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuprootinput: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input2
: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Mount failed for selinuxfs on /selinux:  No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Booting has failed.

