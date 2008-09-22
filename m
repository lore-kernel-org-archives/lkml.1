Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbYIVMXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbYIVMXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYIVMW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:22:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64715 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYIVMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:22:56 -0400
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27-rc6-mm1] Boot hangs while initializing SCSI disk.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200809190200.m8J20Rt4030923@www262.sakura.ne.jp>
	<20080918192125.fce21649.akpm@linux-foundation.org>
In-Reply-To: <20080918192125.fce21649.akpm@linux-foundation.org>
Message-Id: <200809222122.BDF51502.OHMSOOJVLQFtFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 22 Sep 2008 21:22:52 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried with different config.

Using http://I-love.SAKURA.ne.jp/tmp/config-2.6.27-rc6-mm1-2 ,
I got below output.

----------------------------------------
Linux version 2.6.27-rc6-mm1 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #6 SMP Mon Sep 22 13:31:47 JST 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
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
RAMDISK: 3fb35000 - 3fee0000
Allocated new RAMDISK: 01186000 - 01531000
Move RAMDISK from 000000003fb35000 - 000000003fedffff to 01186000 - 01530fff
DMI present.
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 3FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 3FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 3FEFFFC0, 0040
ACPI: APIC 3FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
140MB HIGHMEM available.
883MB LOWMEM available.
  mapped low ram: 0 - 373fe000
  low ram: 00000000 - 373fe000
  bootmap 00009000 - 0000fe80
(9 early reservations) ==> bootmem [0000000000 - 00373fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 000116f8c8]    TEXT DATA BSS ==> [0000400000 - 000116f8c8]
  #4 [0001170000 - 0001186000]    INIT_PG_TABLE ==> [0001170000 - 0001186000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0001186000 - 0001531000]      NEW RAMDISK ==> [0001186000 - 0001531000]
  #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
found SMP MP-table at [c00f6cd0] 000f6cd0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000373fe
  HighMem  0x000373fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fef0
    0: 0x0003ff00 -> 0x00040000
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
PERCPU: Allocating 1212416 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255886
Kernel command line: root=/dev/sda1 ro console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1992.960 MHz processor.
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
 memory used by lock dependency info: 2463 kB
 per task-struct memory footprint: 1920 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1002260k/1048576k available (2819k kernel code, 45512k reserved, 4180k data, 1464k init, 143304k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc58000 - 0xfffff000   (3740 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
      .init : 0xc0ada000 - 0xc0c48000   (1464 kB)
      .data : 0xc06c0c19 - 0xc0ad5d1c   (4180 kB)
      .text : 0xc0400000 - 0xc06c0c19   (2819 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
kmemtrace: early init successful.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3985.92 BogoMIPS (lpj=1992960)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080729
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 14129 hash entries in 55 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.37 BogoMIPS (lpj=1995185)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7976.29 BogoMIPS).
khelper used greatest stack depth: 2980 bytes left
net_namespace: 912 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=2
PCI: Using configuration type 1 for base access
khelper used greatest stack depth: 2960 bytes left
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:505 sysfs_add_one+0x48/0x66()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc6-mm1 #6
 [<c0432b67>] warn_slowpath+0x50/0x6f
 [<c0453c3a>] ? trace_hardirqs_off_caller+0x3e/0xe0
 [<c0453ce7>] ? trace_hardirqs_off+0xb/0xd
 [<c0408bf8>] ? native_sched_clock+0xb8/0xcf
 [<c0452b20>] ? check_chain_key+0xc0/0x1e4
 [<c04bdaf0>] ? ifind+0x99/0xa3
 [<c0455e25>] ? __lock_release+0x4b/0x51
 [<c04bdaf0>] ? ifind+0x99/0xa3
 [<c053de16>] ? _raw_spin_unlock+0x96/0xba
 [<c04f40ea>] ? sysfs_find_dirent+0x25/0x3b
 [<c04f3deb>] ? __sysfs_add_one+0x27/0xa9
 [<c04f3eb5>] sysfs_add_one+0x48/0x66
 [<c04f41c2>] create_dir+0x46/0x8a
 [<c04f4262>] sysfs_create_dir+0x41/0x55
 [<c0535047>] create_dir+0x13/0x33
 [<c0535345>] kobject_add_internal+0x117/0x177
 [<c053548e>] kobject_add_varg+0x36/0x3e
 [<c05354fd>] kobject_init_and_add+0x22/0x27
 [<c0aefad2>] kernel_param_sysfs_setup+0xa5/0xee
 [<c0aefbe8>] param_sysfs_builtin+0xcd/0x13c
 [<c0aefc9e>] param_sysfs_init+0x47/0x4b
 [<c040112a>] _stext+0x42/0x10e
 [<c0aefc57>] ? param_sysfs_init+0x0/0x4b
 [<c042afaa>] ? wake_up_process+0xf/0x11
 [<c04428f6>] ? start_workqueue_thread+0x22/0x25
 [<c04429fb>] ? __create_workqueue_key+0x102/0x19a
 [<c0ada8ed>] do_initcalls+0x89/0xb4
 [<c0ada961>] ? kernel_init+0x0/0x8e
 [<c0ada939>] do_basic_setup+0x21/0x23
 [<c0ada9b4>] kernel_init+0x53/0x8e
 [<c0404ae7>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc6-mm1 #6
 [<c0535395>] kobject_add_internal+0x167/0x177
 [<c053548e>] kobject_add_varg+0x36/0x3e
 [<c05354fd>] kobject_init_and_add+0x22/0x27
 [<c0aefad2>] kernel_param_sysfs_setup+0xa5/0xee
 [<c0aefbe8>] param_sysfs_builtin+0xcd/0x13c
 [<c0aefc9e>] param_sysfs_init+0x47/0x4b
 [<c040112a>] _stext+0x42/0x10e
 [<c0aefc57>] ? param_sysfs_init+0x0/0x4b
 [<c042afaa>] ? wake_up_process+0xf/0x11
 [<c04428f6>] ? start_workqueue_thread+0x22/0x25
 [<c04429fb>] ? __create_workqueue_key+0x102/0x19a
 [<c0ada8ed>] do_initcalls+0x89/0xb4
 [<c0ada961>] ? kernel_init+0x0/0x8e
 [<c0ada939>] do_basic_setup+0x21/0x23
 [<c0ada9b4>] kernel_init+0x53/0x8e
 [<c0404ae7>] kernel_thread_helper+0x7/0x10
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:11.0: transparent bridge
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
tracer: 211 pages allocated for 16384 entries of 52 bytes
   actual entries 16458
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:11.0: PCI bridge, secondary bus 0000:02
pci 0000:00:11.0:   IO window: 0x2000-0x2fff
pci 0000:00:11.0:   MEM window: disabled
pci 0000:00:11.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:11.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
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
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
debug: unmapping init memory c1186000..c1531000
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1222090593.601:1): initialized
Testing tracer sched_switch: PASSED
Testing tracer sysprof: PASSED
Testing tracer ftrace: PASSED
Testing dynamic ftrace: PASSED
Testing tracer irqsoff: PASSED
Testing tracer wakeup: PASSED
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1678
cryptomgr_test used greatest stack depth: 2476 bytes left
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 0) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: IDE port disabled
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1058-0x105f
hda: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hda: UDMA/33 mode selected
ide0 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-floppy driver 1.00
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
kmemtrace: fully up.
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 3756KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-done.
VFS: Mounted root (cramfs filesystem) readonly.
mount used greatest stack depth: 2420 bytes left
linuxrc used greatest stack depth: 2068 bytes left
debug: unmapping init memory c0ada000..c0c48000
Write protecting the kernel read-only data: 2228k
Testing CPA: undo c06c1000-c08ee000
Testing CPA: write protecting again
initrd-tools: 0.1.81.1
mount: unknown filesystem type 'devfs'
BUG: sleeping function called from invalid context at mm/memory.c:3060
in_atomic(): 0, irqs_disabled(): 1, pid: 430, name: modprobe
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c0431186>] copy_process+0x24c/0xbac
softirqs last  enabled at (0): [<c0431186>] copy_process+0x24c/0xbac
softirqs last disabled at (0): [<00000000>] 0x0
Pid: 430, comm: modprobe Tainted: G        W 2.6.27-rc6-mm1 #6
 [<c042fbcb>] __might_sleep+0xdf/0xe4
 [<c041ae24>] ? ftrace_test_p6nop+0x0/0xa
 [<c0494148>] might_fault+0x1a/0x76
 [<c047e3b6>] ? time_hardirqs_off+0x4a/0xea
 [<c041acf2>] ftrace_modify_code+0x19/0xfc
 [<c041ae24>] ? ftrace_test_p6nop+0x0/0xa
 [<c0453c3a>] ? trace_hardirqs_off_caller+0x3e/0xe0
 [<c0477036>] ftrace_code_disable+0x31/0x19c
 [<c041ae24>] ? ftrace_test_p6nop+0x0/0xa
 [<c0477501>] __ftrace_update_code+0xe3/0x1d3
 [<c0478205>] ftrace_convert_nops+0x49/0x6c
 [<c047823d>] ftrace_init_module+0x15/0x17
 [<c045f34e>] load_module+0x962/0xae5
 [<c045f543>] sys_init_module+0x46/0x19c
 [<c0403cfa>] syscall_call+0x7/0xb
 =======================
BUG: unable to handle kernel paging request at c08837b8
IP: [<c04a5b13>] kmem_cache_create+0xa8/0x486
*pde = 34ff0163 *pte = 00883161 
Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: scsi_mod(+)

Pid: 430, comm: modprobe Tainted: G        W (2.6.27-rc6-mm1 #6)
EIP: 0060:[<c04a5b13>] EFLAGS: 00010246 CPU: 0
EIP is at kmem_cache_create+0xa8/0x486
EAX: f4b8c000 EBX: c08837b8 ECX: 00000000 EDX: 00000000
ESI: f55a56c0 EDI: 00000068 EBP: f4b8cf1c ESP: f4b8cef8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 430, ti=f4b8c000 task=f5746830 task.ti=f4b8c000)
Stack: 00000000 c0000000 00000000 00000000 f90940a4 00000038 f90aa600 080529e0 
       b8038f40 f4b8cf38 f86050a1 00000000 00000000 f90aa600 080529e0 b8038f40 
       f4b8cf44 f8605009 f90aa600 f4b8cfa0 c040112a 00000000 f8605000 00000000 
Call Trace:
 [<f86050a1>] ? scsi_init_queue+0x1b/0x126 [scsi_mod]
 [<f8605009>] ? init_scsi+0x9/0x86 [scsi_mod]
 [<c040112a>] ? _stext+0x42/0x10e
 [<f8605000>] ? init_scsi+0x0/0x86 [scsi_mod]
 [<c047ebb6>] ? stack_trace_call+0x4e/0x171
 [<c0404b06>] ? ftrace_call+0x5/0x8
 [<c045f5a3>] ? sys_init_module+0xa6/0x19c
 [<c0403cfa>] ? syscall_call+0x7/0xb
 =======================
Code: c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 <c0> c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 c0 
EIP: [<c04a5b13>] kmem_cache_create+0xa8/0x486 SS:ESP 0068:f4b8cef8
---[ end trace 4eaa2a86a8e2da22 ]---
note: modprobe[430] exited with preempt_count 1
Segmentation fault
CPA self-test:
 4k 15358 large 206 gb 0 x 15564[c0000000-f73fd000] miss 0
 4k 194558 large 31 gb 0 x 194589[c0000000-f73fd000] miss 0
 4k 194558 large 31 gb 0 x 194589[c0000000-f73fd000] miss 0
ok.
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_mode_sense
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_device_get
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_setup_blk_pc_cmnd
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_print_result
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_get_sense_info_fld
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol sdev_evt_send_simple
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsicam_bios_param
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_command_normalize_sense
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_test_unit_ready
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_block_when_processing_errors
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_register_driver
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_ioctl
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_nonblockable_ioctl
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_show_sense_hdr
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_device_put
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_logging_level
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_show_result
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_setup_fs_cmnd
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_execute_req
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_mode_select
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_print_sense
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_show_extd_sense
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_prep_return
sd_mod: gave up waiting for init of module scsi_mod.
sd_mod: Unknown symbol scsi_set_medium_removal
FATAL: Error inserting sd_mod (/lib/modules/2.6.27-rc6-mm1/kernel/drivers/scsi/sd_mod.ko): Unknown symbol in module, or unknown parameter (see dmesg)
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
FATAL: Could not open '/lib/modules/2.6.27-rc6-mm1/kernel/drivers/net/pcnet32.ko': No such file or directory
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
----------------------------------------

Different messages, but may be something related
because loading kernel modules is failing.

Next, I chose CONFIG_FTRACE=n and retried.
Using http://I-love.SAKURA.ne.jp/tmp/config-2.6.27-rc6-mm1-3 ,
I got below output.

----------------------------------------
Linux version 2.6.27-rc6-mm1 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #7 SMP Mon Sep 22 14:45:43 JST 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
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
RAMDISK: 3fb48000 - 3fee0000
Allocated new RAMDISK: 0115e000 - 014f6000
Move RAMDISK from 000000003fb48000 - 000000003fedffff to 0115e000 - 014f5fff
DMI present.
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 3FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 3FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 3FEFFFC0, 0040
ACPI: APIC 3FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
140MB HIGHMEM available.
883MB LOWMEM available.
  mapped low ram: 0 - 373fe000
  low ram: 00000000 - 373fe000
  bootmap 00009000 - 0000fe80
(9 early reservations) ==> bootmem [0000000000 - 00373fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 0001147048]    TEXT DATA BSS ==> [0000400000 - 0001147048]
  #4 [0001148000 - 000115e000]    INIT_PG_TABLE ==> [0001148000 - 000115e000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [000115e000 - 00014f6000]      NEW RAMDISK ==> [000115e000 - 00014f6000]
  #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
found SMP MP-table at [c00f6cd0] 000f6cd0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000373fe
  HighMem  0x000373fe -> 0x00040000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003fef0
    0: 0x0003ff00 -> 0x00040000
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
PERCPU: Allocating 1212416 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255886
Kernel command line: root=/dev/sda1 ro console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1992.963 MHz processor.
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
 memory used by lock dependency info: 2463 kB
 per task-struct memory footprint: 1920 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1002516k/1048576k available (2732k kernel code, 45276k reserved, 4114k data, 1460k init, 143304k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc58000 - 0xfffff000   (3740 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
      .init : 0xc0ab4000 - 0xc0c21000   (1460 kB)
      .data : 0xc06ab3e5 - 0xc0aafc1c   (4114 kB)
      .text : 0xc0400000 - 0xc06ab3e5   (2732 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
kmemtrace: early init successful.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3985.92 BogoMIPS (lpj=1992963)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080729
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.12 BogoMIPS (lpj=1995061)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7976.04 BogoMIPS).
khelper used greatest stack depth: 2944 bytes left
net_namespace: 912 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=2
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:505 sysfs_add_one+0x43/0x61()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc6-mm1 #7
 [<c0432484>] warn_slowpath+0x4b/0x64
 [<c045230e>] ? trace_hardirqs_off_caller+0x3e/0xe0
 [<c04523bb>] ? trace_hardirqs_off+0xb/0xd
 [<c0408894>] ? native_sched_clock+0xb8/0xcf
 [<c04511f4>] ? check_chain_key+0xc0/0x1e4
 [<c04b6c61>] ? ifind+0x94/0x9e
 [<c04544f9>] ? __lock_release+0x4b/0x51
 [<c04b6c61>] ? ifind+0x94/0x9e
 [<c05331ae>] ? _raw_spin_unlock+0x96/0xba
 [<c04eb874>] ? sysfs_find_dirent+0x20/0x36
 [<c04eb58e>] ? __sysfs_add_one+0x22/0xa4
 [<c04eb653>] sysfs_add_one+0x43/0x61
 [<c04eb942>] create_dir+0x41/0x85
 [<c04eb9d8>] sysfs_create_dir+0x3c/0x50
 [<c052a49b>] create_dir+0x13/0x33
 [<c052a799>] kobject_add_internal+0x117/0x177
 [<c052a8e2>] kobject_add_varg+0x36/0x3e
 [<c052a951>] kobject_init_and_add+0x22/0x27
 [<c0ac9a5e>] kernel_param_sysfs_setup+0xa5/0xee
 [<c0ac9b74>] param_sysfs_builtin+0xcd/0x13c
 [<c0ac9c2a>] param_sysfs_init+0x47/0x4b
 [<c0401125>] _stext+0x3d/0x109
 [<c0ac9be3>] ? param_sysfs_init+0x0/0x4b
 [<c042a9f2>] ? wake_up_process+0xf/0x11
 [<c0441864>] ? start_workqueue_thread+0x1d/0x20
 [<c0441964>] ? __create_workqueue_key+0xfd/0x195
 [<c0ab48e8>] do_initcalls+0x89/0xb4
 [<c0ab495c>] ? kernel_init+0x0/0x8e
 [<c0ab4934>] do_basic_setup+0x21/0x23
 [<c0ab49af>] kernel_init+0x53/0x8e
 [<c0404a17>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc6-mm1 #7
 [<c052a7e9>] kobject_add_internal+0x167/0x177
 [<c052a8e2>] kobject_add_varg+0x36/0x3e
 [<c052a951>] kobject_init_and_add+0x22/0x27
 [<c0ac9a5e>] kernel_param_sysfs_setup+0xa5/0xee
 [<c0ac9b74>] param_sysfs_builtin+0xcd/0x13c
 [<c0ac9c2a>] param_sysfs_init+0x47/0x4b
 [<c0401125>] _stext+0x3d/0x109
 [<c0ac9be3>] ? param_sysfs_init+0x0/0x4b
 [<c042a9f2>] ? wake_up_process+0xf/0x11
 [<c0441864>] ? start_workqueue_thread+0x1d/0x20
 [<c0441964>] ? __create_workqueue_key+0xfd/0x195
 [<c0ab48e8>] do_initcalls+0x89/0xb4
 [<c0ab495c>] ? kernel_init+0x0/0x8e
 [<c0ab4934>] do_basic_setup+0x21/0x23
 [<c0ab49af>] kernel_init+0x53/0x8e
 [<c0404a17>] kernel_thread_helper+0x7/0x10
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:11.0: transparent bridge
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
tracer: 211 pages allocated for 16384 entries of 52 bytes
   actual entries 16458
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:11.0: PCI bridge, secondary bus 0000:02
pci 0000:00:11.0:   IO window: 0x2000-0x2fff
pci 0000:00:11.0:   MEM window: disabled
pci 0000:00:11.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
pci 0000:00:11.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
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
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
debug: unmapping init memory c115e000..c14f6000
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1222095151.674:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1678
cryptomgr_test used greatest stack depth: 2932 bytes left
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 0) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: IDE port disabled
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1058-0x105f
hda: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hda: UDMA/33 mode selected
ide0 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-floppy driver 1.00
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
kmemtrace: fully up.
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 3680KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/done.
VFS: Mounted root (cramfs filesystem) readonly.
mount used greatest stack depth: 2420 bytes left
linuxrc used greatest stack depth: 2068 bytes left
debug: unmapping init memory c0ab4000..c0c21000
Write protecting the kernel text: 2736k
Testing CPA: Reverting c0400000-c06ac000
Testing CPA: write protecting again
Write protecting the kernel read-only data: 2168k
Testing CPA: undo c06ac000-c08ca000
Testing CPA: write protecting again
initrd-tools: 0.1.81.1
mount: unknown filesystem type 'devfs'
PANIC: double fault, gdt at c2d09000 [255 bytes]
double fault, tss at c2e2c080
eip = c06a9026, esp = f44f9f64
eax = f44f8dc0, ebx = 00000000, ecx = c090ad44, edx = 00000001
esi = c041eea9, edi = f53749f0
----------------------------------------

So, I haven't succeeded to boot...

I'm using Debian Sarge (i386) on VMware.
