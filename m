Return-Path: <linux-kernel-owner+w=401wt.eu-S934980AbZKYUP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbZKYUP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZKYUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:15:55 -0500
Received: from borg.medozas.de ([188.40.89.202]:57897 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbZKYUPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:15:53 -0500
Date: Wed, 25 Nov 2009 21:15:57 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: sparclinux@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: oops in proc_tid_stat
Message-ID: <alpine.LSU.2.00.0911252112080.22230@obet.zrqbmnf.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



something seems to have blown up just under me. Maybe someone can make sense of
the debug trace.

thanks,
Jan

PROMLIB: Sun IEEE Boot Prom 'OBP 4.29.0.a 2008/09/15 11:59'
PROMLIB: Root node compatible: sun4v
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.31.1-56.fc12.sparc64 (mockbuild@korolev.ausil.us) (gcc version 4.4.1 20091010 (Red Hat 4.4.1-21) (GCC) ) #1 SMP Wed Oct 14 21:52:21 CDT 2009
console [earlyprom0] enabled
ARCH: SUN4V
Ethernet address: 00:14:4f:e1:d1:24
Kernel: Using 3 locked TLB entries for main kernel image.
Remapping the kernel... done.
OF stdout device is: /virtual-devices@100/console@1
PROM: Built device tree with 67275 bytes of memory.
MDESC: Size is 32544 bytes.
PLATFORM: banner-name [SPARC Enterprise T1000]
PLATFORM: name [SUNW,SPARC-Enterprise-T1000]
PLATFORM: hostid [84e1d124]
PLATFORM: serial# [00ab4130]
PLATFORM: stick-frequency [3b9aca00]
PLATFORM: mac-address [144fe1d124]
PLATFORM: watchdog-resolution [1000 ms]
PLATFORM: watchdog-max-timeout [31536000000 ms]
PLATFORM: max-cpus [32]
Top of RAM: 0x1ffdbc000, Total RAM: 0x1f79ac000
Memory hole size: 132MB
[0000000200000000-fffff80009400000] page_structs=131072 node=0 entry=0/0
[0000000200000000-fffff80009800000] page_structs=131072 node=0 entry=1/0
[0000000200000000-fffff80009c00000] page_structs=131072 node=0 entry=2/0
[0000000200900000-fffff8000a000000] page_structs=131072 node=0 entry=3/0
[0000000200900000-fffff8000a400000] page_structs=131072 node=0 entry=4/0
[0000000201200000-fffff8000a800000] page_structs=131072 node=0 entry=5/0
[0000000201200000-fffff8000ac00000] page_structs=131072 node=0 entry=6/0
[0000000201b00000-fffff8000b000000] page_structs=131072 node=0 entry=7/0
[0000000201b00000-fffff8000b400000] page_structs=131072 node=0 entry=8/0
[0000000202400000-fffff8000b800000] page_structs=131072 node=0 entry=9/0
[0000000202400000-fffff8000bc00000] page_structs=131072 node=0 entry=10/0
[0000000202400000-fffff8000c000000] page_structs=131072 node=0 entry=11/0
[0000000202d00000-fffff8000c400000] page_structs=131072 node=0 entry=12/0
[0000000202d00000-fffff8000cc00000] page_structs=131072 node=0 entry=13/0
[0000000203600000-fffff8000d000000] page_structs=131072 node=0 entry=14/0
[0000000203600000-fffff8000d400000] page_structs=131072 node=0 entry=15/0
[0000000203f00000-fffff8000d800000] page_structs=131072 node=0 entry=16/0
[0000000203f00000-fffff8000dc00000] page_structs=131072 node=0 entry=17/0
Zone PFN ranges:
  Normal   0x00004200 -> 0x000ffede
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00004200 -> 0x000ffec5
    0: 0x000ffecd -> 0x000ffede
On node 0 totalpages: 1031382
  Normal zone: 9065 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 1022317 pages, LIFO batch:15
Booting Linux...
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1022317
Policy zone: Normal
Kernel command line: ro root=UUID=792531e6-1ddf-4c43-a1e9-995477d2b2a9 selinux=0 console=ttyS0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Memory: 8161624k available (4400k kernel code, 2264k data, 280k init) [fffff80000000000,00000001ffdbc000]
SLUB: Genslabs=15, HWalign=32, Order=0-3, MinObjects=0, CPUs=32, Nodes=16
Hierarchical RCU implementation.
NR_IRQS:255
clocksource: mult[10000] shift[16]
clockevent: mult[80000000] shift[31]
Console: colour dummy device 80x25
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 36 of 36 active objects replaced
Calibrating delay using timer specific routine.. 2003.12 BogoMIPS (lpj=10015634)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 10, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 9, 4194304 bytes)
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
ftrace: allocating 16127 entries in 32 pages
Brought up 24 CPUs
sizeof(vma)=176 bytes
sizeof(page)=72 bytes
sizeof(inode)=768 bytes
sizeof(dentry)=216 bytes
sizeof(ext3inode)=1024 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=240 bytes
sizeof(task_struct)=5904 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-3 level SIBLING
  groups: 0 1 2 3
  domain 1: span 0-23 level CPU
   groups: 0-3 4-7 8-11 12-15 16-19 20-23
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU1 attaching sched-domain:
 domain 0: span 0-3 level SIBLING
  groups: 1 2 3 0
  domain 1: span 0-23 level CPU
   groups: 0-3 4-7 8-11 12-15 16-19 20-23
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU2 attaching sched-domain:
 domain 0: span 0-3 level SIBLING
  groups: 2 3 0 1
  domain 1: span 0-23 level CPU
   groups: 0-3 4-7 8-11 12-15 16-19 20-23
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU3 attaching sched-domain:
 domain 0: span 0-3 level SIBLING
  groups: 3 0 1 2
  domain 1: span 0-23 level CPU
   groups: 0-3 4-7 8-11 12-15 16-19 20-23
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU4 attaching sched-domain:
 domain 0: span 4-7 level SIBLING
  groups: 4 5 6 7
  domain 1: span 0-23 level CPU
   groups: 4-7 8-11 12-15 16-19 20-23 0-3
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU5 attaching sched-domain:
 domain 0: span 4-7 level SIBLING
  groups: 5 6 7 4
  domain 1: span 0-23 level CPU
   groups: 4-7 8-11 12-15 16-19 20-23 0-3
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU6 attaching sched-domain:
 domain 0: span 4-7 level SIBLING
  groups: 6 7 4 5
  domain 1: span 0-23 level CPU
   groups: 4-7 8-11 12-15 16-19 20-23 0-3
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU7 attaching sched-domain:
 domain 0: span 4-7 level SIBLING
  groups: 7 4 5 6
  domain 1: span 0-23 level CPU
   groups: 4-7 8-11 12-15 16-19 20-23 0-3
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU8 attaching sched-domain:
 domain 0: span 8-11 level SIBLING
  groups: 8 9 10 11
  domain 1: span 0-23 level CPU
   groups: 8-11 12-15 16-19 20-23 0-3 4-7
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU9 attaching sched-domain:
 domain 0: span 8-11 level SIBLING
  groups: 9 10 11 8
  domain 1: span 0-23 level CPU
   groups: 8-11 12-15 16-19 20-23 0-3 4-7
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU10 attaching sched-domain:
 domain 0: span 8-11 level SIBLING
  groups: 10 11 8 9
  domain 1: span 0-23 level CPU
   groups: 8-11 12-15 16-19 20-23 0-3 4-7
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU11 attaching sched-domain:
 domain 0: span 8-11 level SIBLING
  groups: 11 8 9 10
  domain 1: span 0-23 level CPU
   groups: 8-11 12-15 16-19 20-23 0-3 4-7
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU12 attaching sched-domain:
 domain 0: span 12-15 level SIBLING
  groups: 12 13 14 15
  domain 1: span 0-23 level CPU
   groups: 12-15 16-19 20-23 0-3 4-7 8-11
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU13 attaching sched-domain:
 domain 0: span 12-15 level SIBLING
  groups: 13 14 15 12
  domain 1: span 0-23 level CPU
   groups: 12-15 16-19 20-23 0-3 4-7 8-11
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU14 attaching sched-domain:
 domain 0: span 12-15 level SIBLING
  groups: 14 15 12 13
  domain 1: span 0-23 level CPU
   groups: 12-15 16-19 20-23 0-3 4-7 8-11
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU15 attaching sched-domain:
 domain 0: span 12-15 level SIBLING
  groups: 15 12 13 14
  domain 1: span 0-23 level CPU
   groups: 12-15 16-19 20-23 0-3 4-7 8-11
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU16 attaching sched-domain:
 domain 0: span 16-19 level SIBLING
  groups: 16 17 18 19
  domain 1: span 0-23 level CPU
   groups: 16-19 20-23 0-3 4-7 8-11 12-15
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU17 attaching sched-domain:
 domain 0: span 16-19 level SIBLING
  groups: 17 18 19 16
  domain 1: span 0-23 level CPU
   groups: 16-19 20-23 0-3 4-7 8-11 12-15
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU18 attaching sched-domain:
 domain 0: span 16-19 level SIBLING
  groups: 18 19 16 17
  domain 1: span 0-23 level CPU
   groups: 16-19 20-23 0-3 4-7 8-11 12-15
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU19 attaching sched-domain:
 domain 0: span 16-19 level SIBLING
  groups: 19 16 17 18
  domain 1: span 0-23 level CPU
   groups: 16-19 20-23 0-3 4-7 8-11 12-15
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU20 attaching sched-domain:
 domain 0: span 20-23 level SIBLING
  groups: 20 21 22 23
  domain 1: span 0-23 level CPU
   groups: 20-23 0-3 4-7 8-11 12-15 16-19
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU21 attaching sched-domain:
 domain 0: span 20-23 level SIBLING
  groups: 21 22 23 20
  domain 1: span 0-23 level CPU
   groups: 20-23 0-3 4-7 8-11 12-15 16-19
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU22 attaching sched-domain:
 domain 0: span 20-23 level SIBLING
  groups: 22 23 20 21
  domain 1: span 0-23 level CPU
   groups: 20-23 0-3 4-7 8-11 12-15 16-19
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
CPU23 attaching sched-domain:
 domain 0: span 20-23 level SIBLING
  groups: 23 20 21 22
  domain 1: span 0-23 level CPU
   groups: 20-23 0-3 4-7 8-11 12-15 16-19
   domain 2: span 0-23 level NODE
    groups: 0-23 (__cpu_power = 6144)
ldc.c:v1.1 (July 22, 2008)
ldc: Domaining disabled.
regulator: core version 0.5
NET: Registered protocol family 16
VIO: Adding device channel-devices
VIO: Adding device vldc-port-0-0
VIO: Adding device vldc-port-0-1
VIO: Adding device vldc-port-0-2
VIO: Adding device vldc-port-1-0
VIO: Adding device vldc-port-3-0
VIO: Adding device vldc-port-3-8
VIO: Adding device ds-1
VIO: Adding device ds-0
Testing NMI watchdog ... OK.
pci_sun4v: Registered hvapi major[1] minor[0]
/pci@780: SUN4V PCI Bus Module
/pci@780: On NUMA node -1
/pci@780: PCI IO[e810000000] MEM[ea00000000]
/pci@780: MSI Queue first[0] num[36] count[128] devino[0x18]
/pci@780: MSI first[0] num[256] mask[0xff] width[32]
/pci@780: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
/pci@780: MSI queues at RA [00000001f9e00000]
PCI: Scanning PBM /pci@780
/pci@7c0: SUN4V PCI Bus Module
/pci@7c0: On NUMA node -1
/pci@7c0: PCI IO[f010000000] MEM[f200000000]
/pci@7c0: MSI Queue first[0] num[36] count[128] devino[0x18]
/pci@7c0: MSI first[0] num[256] mask[0xff] width[32]
/pci@7c0: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
/pci@7c0: MSI queues at RA [00000001f9e80000]
PCI: Scanning PBM /pci@7c0
pci 0001:02:00.0: PME# supported from D0 D3hot D3cold
pci 0001:02:00.0: PME# disabled
pci 0001:03:04.0: PME# supported from D3hot
pci 0001:03:04.0: PME# disabled
pci 0001:03:04.1: PME# supported from D3hot
pci 0001:03:04.1: PME# disabled
pci 0001:04:01.0: PME# supported from D3hot D3cold
pci 0001:04:01.0: PME# disabled
pci 0001:04:01.1: PME# supported from D3hot D3cold
pci 0001:04:01.1: PME# disabled
pci 0001:04:02.0: supports D1 D2
ds.c:v1.0 (Jul 11, 2007)
bio: create slab <bio-0> at 0
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 22
Switched to high resolution mode on CPU 18
Switched to high resolution mode on CPU 14
Switched to high resolution mode on CPU 10
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 23
Switched to high resolution mode on CPU 19
Switched to high resolution mode on CPU 15
Switched to high resolution mode on CPU 11
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 20
Switched to high resolution mode on CPU 16
Switched to high resolution mode on CPU 12
Switched to high resolution mode on CPU 8
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 21
Switched to high resolution mode on CPU 17
Switched to high resolution mode on CPU 13
Switched to high resolution mode on CPU 9
Switched to high resolution mode on CPU 5
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 8, 2097152 bytes)
TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 2097152 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 3429k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1.760:1): initialized
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
msgmni has been set to 15947
cryptomgr_test used greatest stack depth: 12288 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
f027a19c: ttyS0 at I/O 0x0 (irq = 1) is a SUN4V HCONS
console handover: boot [earlyprom0] -> real [ttyHV0]
f0287068: ttyS1 at MMIO 0xf820c2c000 (irq = 18) is a ST16650V2
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
mice: PS/2 mouse device common for all mice
rtc-sun4v rtc-sun4v: rtc core: registered sun4v as rtc0
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
rtc-sun4v rtc-sun4v: setting system clock to 2009-11-25 12:36:36 UTC (1259152596)
Initalizing network drop monitor service
plymouthd used greatest stack depth: 11808 bytes left
console_init used greatest stack depth: 11152 bytes left
plymouth used greatest stack depth: 32 bytes left
Fusion MPT base driver 3.04.10
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.10
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1064 A3, FwRev=010a0000h, Ports=1, MaxQ=511, IRQ=25
mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x1221000000000000
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HDS7216S AB8A PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 67 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5
sd 0:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udev: starting version 145
tg3.c:v3.99 (April 20, 2009)
PCI: Enabling device: (0001:03:04.0), cmd 2
tg3 0001:03:04.0: PME# disabled
eth0: Tigon3 [partno(BCM95714) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:14:4f:e1:d1:24
eth0: attached PHY is 5714 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth0: dma_rwctrl[76148000] dma_mask[32-bit]
PCI: Enabling device: (0001:03:04.1), cmd 2
tg3 0001:03:04.1: PME# disabled
eth1: Tigon3 [partno(BCM95714) rev 9003] (PCIX:133MHz:64-bit) MAC address 00:14:4f:e1:d1:25
eth1: attached PHY is 5714 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth1: dma_rwctrl[76148000] dma_mask[32-bit]
PCI: Enabling device: (0001:04:01.0), cmd 2
tg3 0001:04:01.0: PME# disabled
eth2: Tigon3 [partno(BCM95704) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:14:4f:e1:d1:26
eth2: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth2: dma_rwctrl[769f8000] dma_mask[32-bit]
PCI: Enabling device: (0001:04:01.1), cmd 2
tg3 0001:04:01.1: PME# disabled
eth3: Tigon3 [partno(BCM95704) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:14:4f:e1:d1:27
eth3: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth3: dma_rwctrl[769f8000] dma_mask[32-bit]
device-mapper: multipath: version 1.1.0 loaded
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
tg3 0001:03:04.0: PME# disabled
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
cc1 used greatest stack depth: 8 bytes left
Unable to handle kernel NULL pointer dereference
tsk->{mm,active_mm}->context = 00000000000005d6
tsk->{mm,active_mm}->pgd = fffff801f13c6000
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
htop(3168): Oops [#1]
TSTATE: 0000000011001603 TPC: 000000000056d358 TNPC: 000000000056d35c Y: 00000000    Not tainted
TPC: <do_task_stat+0xa8/0x5e4>
g0: 0000000000000008 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000000
g4: fffff801bb2a8c40 g5: 0000000100930000 g6: fffff801d0a00000 g7: 0000000000000001
o0: 0000000000da2000 o1: 0000000000000001 o2: fffff801f5c82460 o3: fffff801db855d80
o4: 00000000000633e0 o5: 0000000000023dd8 sp: fffff801d0a03001 ret_pc: 000000000056d334
RPC: <do_task_stat+0x84/0x5e4>
l0: fffff801f5b21540 l1: fffffffffffffffd l2: fffff801f5c82460 l3: 0000000000000000
l4: fffff801cc92ef00 l5: 0000000000000001 l6: 0000000000002048 l7: 000000000051b230
i0: fffff801f7a7a630 i1: 0000000000a14200 i2: fffff801f5c82460 i3: fffff801db855d80
i4: 0000000000000000 i5: 0000000000023dd8 i6: fffff801d0a03311 i7: 000000000056d8e0
I7: <proc_tid_stat+0x1c/0x30>
Disabling lock debugging due to kernel taint
Caller[000000000056d8e0]: proc_tid_stat+0x1c/0x30
Caller[000000000056a3e4]: proc_single_show+0x44/0x7c
Caller[0000000000534738]: seq_read+0x1d0/0x400
Caller[000000000051b0e8]: vfs_read+0x74/0x148
Caller[000000000051b264]: SyS_read+0x34/0x64
Caller[0000000000406254]: linux_sparc_syscall32+0x34/0x40
Caller[00000000f7ca1a8c]: 0xf7ca1a8c
Instruction DUMP: c077a79f  c25ee008  c2586028 <e6586070> c2586088  c277a79f  9210001b  7ffecad6  9007a7e7 
Unable to handle kernel NULL pointer dereference
tsk->{mm,active_mm}->context = 00000000000012c5
tsk->{mm,active_mm}->pgd = fffff801dc35c000
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
htop(11416): Oops [#2]
TSTATE: 0000000011001603 TPC: 000000000056d358 TNPC: 000000000056d35c Y: 00000000    Tainted: G      D   
TPC: <do_task_stat+0xa8/0x5e4>
g0: 0000000000000008 g1: 0000000000000000 g2: 0000000000000001 g3: 0000000000000000
g4: fffff801b9b91760 g5: 0000000100130000 g6: fffff801e3034000 g7: 0000000000000002
o0: 0000000000daa000 o1: 0000000000000001 o2: fffff801f5c82460 o3: fffff801db855d80
o4: 00000000000649d8 o5: 0000000000023dd8 sp: fffff801e3037001 ret_pc: 000000000056d334
RPC: <do_task_stat+0x84/0x5e4>
l0: fffff801f5b21540 l1: fffffffffffffffd l2: fffff801f5c82460 l3: 0000000000000000
l4: fffff801cc92ef00 l5: 0000000000000001 l6: 0000000000002048 l7: 000000000051b230
i0: fffff801f93697b8 i1: 0000000000a14200 i2: fffff801f5c82460 i3: fffff801db855d80
i4: 0000000000000000 i5: 0000000000023dd8 i6: fffff801e3037311 i7: 000000000056d8e0
I7: <proc_tid_stat+0x1c/0x30>
Caller[000000000056d8e0]: proc_tid_stat+0x1c/0x30
Caller[000000000056a3e4]: proc_single_show+0x44/0x7c
Caller[0000000000534738]: seq_read+0x1d0/0x400
Caller[000000000051b0e8]: vfs_read+0x74/0x148
Caller[000000000051b264]: SyS_read+0x34/0x64
Caller[0000000000406254]: linux_sparc_syscall32+0x34/0x40
Caller[00000000f7cc5a8c]: 0xf7cc5a8c
Instruction DUMP: c077a79f  c25ee008  c2586028 <e6586070> c2586088  c277a79f  9210001b  7ffecad6  9007a7e7 
[died and force rebooted]
