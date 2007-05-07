Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXEGMUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXEGMUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbXEGMUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:20:03 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:42924 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXEGMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:19:59 -0400
Message-ID: <463F196C.9070501@linux.vnet.ibm.com>
Date: Mon, 07 May 2007 17:49:56 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, srinivasa@in.ibm.com
Subject: kernel expection generated with 2.6.21-mm1 kernel boot up
Content-Type: multipart/mixed;
 boundary="------------070000070002000900080403"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070000070002000900080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I tried compiling and booting up with 2.6.21-mm1 kernel
on the following machine

Architecture      :    PPC64
CPU Type           :    POWER5 (gr)
Machine Type    :    CHRP IBM,9117-570
Base OS              :    Fedora Core 5

the kernel enters the xmon state after an exception as following
Red Hat nash version 5.0.32 starting

Mounting proc filesystem

Mounting sysfs filesystem

Creating /dev

Creating initial device nodes

Setting up hotplug.

Creating block device nodes.

Loading jbd.ko module

Unable to handle kernel paging request for data at address 0x0083a680

Faulting instruction address: 0xc0000000000cc5e4

cpu 0x1: Vector: 300 (Data Access) at [c000000005373320]

   pc: c0000000000cc5e4: .slab_free+0x6c/0x424

   lr: c00000000002fa70: .pgtable_free_tlb+0xd0/0x140

   sp: c0000000053735a0

  msr: 8000000000009032

  dar: 83a680

dsisr: 40000000

 current = 0xc000000009408790

 paca    = 0xc0000000004b2700

   pid   = 295, comm = init

enter ? for help

[c000000005373650] c00000000002fa70 .pgtable_free_tlb+0xd0/0x140

[c0000000053736f0] c0000000000b0f40 .free_pgd_range+0x23c/0x3c4

[c0000000053737f0] c0000000000b13cc .free_pgtables+0x100/0x134

[c0000000053738a0] c0000000000b29f0 .exit_mmap+0xcc/0x15c

[c000000005373950] c000000000057808 .mmput+0x78/0x170

[c0000000053739f0] c0000000000d9c38 .flush_old_exec+0x750/0xa74

[c000000005373ad0] c000000000012ef0 .load_elf_binary+0x5f8/0x1a18

[c000000005373c30] c0000000000d8a2c .search_binary_handler+0x124/0x304

[c000000005373ce0] c00000000011728c .compat_do_execve+0x1d0/0x328

[c000000005373d90] c000000000016428 .compat_sys_execve+0x74/0xf8

[c000000005373e30] c00000000000872c syscall_exit+0x0/0x40

--- Exception: c01 (System Call) at 00000000100d9358

SP (ff8b79e0) is in userspace

1:mon>

Attached and console log and config file.

Thanks,
Kamalesh Babulal.


--------------070000070002000900080403
Content-Type: text/plain;
 name="boot_message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot_message"

Linux version 2.6.21-mm1-autokern1 (root@gekko-lp2.ltc.austin.ibm.com) (gcc version 4.1.0 20060304 (Red Hat 4.1.0-3)) #1 SMP Mon May 7 00:13:58 CDT 2007

[boot]0012 Setup Arch

Node 0 active with no memory

EEH: PCI Enhanced I/O Error Handling Enabled

PPC64 nvram contains 7168 bytes

Zone PFN ranges:

  DMA             0 ->  1048576

  Normal    1048576 ->  1048576

Movable zone start PFN for each node

early_node_map[1] active PFN ranges

    1:        0 ->  1048576

Could not find start_pfn for node 0

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

Node 0 active with no memory

[boot]0015 Setup Done

Built 2 zonelists, mobility grouping on.  Total pages: 1034240

Kernel command line: ro console=hvc0 autobench_args: root=/dev/sda7 ABAT:1178515939 

[boot]0020 XICS Init

[boot]0021 XICS Done

PID hash table entries: 4096 (order: 12, 32768 bytes)

Console: colour dummy device 80x25

console handover: boot [udbg0] -> real [hvc0]

Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)

Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)

freeing bootmem node 1

Memory: 4114076k/4194304k available (4728k kernel code, 80228k reserved, 892k data, 577k bss, 260k init)

SLUB: Genslabs=18, HWalign=128, Order=0-4, MinObjects=16, Processors=4, Nodes=16

Security Framework v1.0.0 initialized

SELinux:  Initializing.

selinux_register_security:  Registering secondary module capability

Capability LSM initialized as secondary

Mount-cache hash table entries: 256

Processor 1 found.

Processor 2 found.

Processor 3 found.

Brought up 4 CPUs

migration_cost=4,3

NET: Registered protocol family 16

IOMMU table initialized, virtual merging enabled

usbcore: registered new interface driver usbfs

usbcore: registered new interface driver hub

usbcore: registered new device driver usb

NET: Registered protocol family 2

IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)

TCP established hash table entries: 524288 (order: 11, 12582912 bytes)

TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)

TCP: Hash tables configured (established 524288 bind 65536)

TCP reno registered

checking if image is initramfs... it is

Freeing initrd memory: 1300k freed

scan-log-dump not implemented on this system

audit: initializing netlink socket (disabled)

audit(1178516185.644:1): initialized

Total HugeTLB memory allocated, 0

VFS: Disk quotas dquot_6.5.1

Dquot-cache hash table entries: 512 (order 0, 4096 bytes)

JFS: nTxBlock = 8192, nTxLock = 65536

io scheduler noop registered

io scheduler anticipatory registered (default)

io scheduler deadline registered

io scheduler cfq registered

pci_hotplug: PCI Hot Plug PCI Core version: 0.5

rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1

rpaphp: Slot [0000:00:02.4](PCI location=U7879.001.DQD0T7T-P1-C5) registered

Generic RTC Driver v1.07

[drm] Initialized drm 1.1.0 20060810

Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled

RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2

ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx

ide-floppy driver 0.99.newide

usbmon: debugfs is not available

mice: PS/2 mouse device common for all mice

async_tx: api initialized (sync-only)

xor: measuring software checksumming speed

   8regs     :  6091.000 MB/sec

   8regs_prefetch:  5169.000 MB/sec

   32regs    :  6744.000 MB/sec

   32regs_prefetch:  4828.000 MB/sec

xor: using function: 32regs (6744.000 MB/sec)

usbcore: registered new interface driver hiddev

usbcore: registered new interface driver usbhid

drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver

TCP cubic registered

Initializing XFRM netlink socket

NET: Registered protocol family 1

NET: Registered protocol family 17

Freeing unused kernel memory: 260k freed

Red Hat nash version 5.0.32 starting

Mounting proc filesystem

Mounting sysfs filesystem

Creating /dev

Creating initial device nodes

Setting up hotplug.

Creating block device nodes.

Loading jbd.ko module

Unable to handle kernel paging request for data at address 0x0083a680

Faulting instruction address: 0xc0000000000cc5e4

cpu 0x1: Vector: 300 (Data Access) at [c000000005373320]

    pc: c0000000000cc5e4: .slab_free+0x6c/0x424

    lr: c00000000002fa70: .pgtable_free_tlb+0xd0/0x140

    sp: c0000000053735a0

   msr: 8000000000009032

   dar: 83a680

 dsisr: 40000000

  current = 0xc000000009408790

  paca    = 0xc0000000004b2700

    pid   = 295, comm = init

enter ? for help

[c000000005373650] c00000000002fa70 .pgtable_free_tlb+0xd0/0x140

[c0000000053736f0] c0000000000b0f40 .free_pgd_range+0x23c/0x3c4

[c0000000053737f0] c0000000000b13cc .free_pgtables+0x100/0x134

[c0000000053738a0] c0000000000b29f0 .exit_mmap+0xcc/0x15c

[c000000005373950] c000000000057808 .mmput+0x78/0x170

[c0000000053739f0] c0000000000d9c38 .flush_old_exec+0x750/0xa74

[c000000005373ad0] c000000000012ef0 .load_elf_binary+0x5f8/0x1a18

[c000000005373c30] c0000000000d8a2c .search_binary_handler+0x124/0x304

[c000000005373ce0] c00000000011728c .compat_do_execve+0x1d0/0x328

[c000000005373d90] c000000000016428 .compat_sys_execve+0x74/0xf8

[c000000005373e30] c00000000000872c syscall_exit+0x0/0x40

--- Exception: c01 (System Call) at 00000000100d9358

SP (ff8b79e0) is in userspace

1:mon>

--------------070000070002000900080403
Content-Type: application/x-bzip;
 name="dotconfig.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dotconfig.bz2"

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
QD0nwUQ=
--------------070000070002000900080403--
