Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbYG2VDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbYG2VDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYG2VDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:03:07 -0400
Received: from andesite.resot.net ([217.175.160.141]:46750 "EHLO
	andesite.ool.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYG2VDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:03:03 -0400
Date: 29 Jul 2008 22:49:24 -0000
Message-ID: <20080729224924.13112.qmail@andesite.ool.fr>
From: "w.landgraf" <w.landgraf@ool.fr>
To: linux-kernel@vger.kernel.org
Subject: kernel error
References: 
In-Reply-To: 
X-IPAddress: 217.175.173.230
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel people  want to be considered as serious 
but not as clowns like meanwhile happening with many open 
projects, then they should stop to hindering their own 
queues of informations and error reports (blacklisting 
people's e-mails)   wl
============================================
Hi. This is the qmail-send program at ool.fr.
I'm afraid I wasn't able to deliver your message to the 
following addresses.
This is a permanent error; I've given up. Sorry it didn't 
work out.

<linux-kernel@vger.kernel.org>:
209.132.176.167 does not like recipient.
Remote host said: 451 4.7.1 Hello [217.175.160.71], for 
recipient address <linux-kernel@vger.kernel.org>
the policy analysis reported: Greylisted, see 
http://isg.ee.ethz.ch/tools/postgrey/help/vger.kernel.org.html
Giving up on 209.132.176.167.
I'm not going to try again; this message has been in the 
queue too long.

--- Below this line is a copy of the message.

Return-Path: <werner@copaya.yi.org>
Received: (qmail 11589 invoked by uid 503); 29 Jul 2008 
18:36:50 -0000
Received: from 217.175.173.230 by smtpgpe (envelope-from 
<werner@copaya.yi.org>,
uid 102) with qmail-scanner-2.01st 
 (clamdscan: 0.93/7269. spamassassin: 3.2.3. perlscan: 
2.01st.  
 Clear:RC:1(217.175.173.230):SA:0(1.7/5.0):. 
 Processed in 2.410474 secs); 29 Jul 2008 18:36:50 -0000
X-Spam-Status: No, hits=1.7 required=5.0
X-Spam-Level: +
Received: from 173-230.us.ool.fr (HELO 
monkey.is-a-geek.net) ([217.175.173.230])
          (envelope-sender <werner@copaya.yi.org>)
          by smtpgpe.ool.fr (qmail-ldap-1.03) with SMTP
          for <linux-kernel@vger.kernel.org>; 29 Jul 2008 
18:36:47 -0000
Received: from monkey.is-a-geek.net (localhost [127.0.0.1])
        by monkey.is-a-geek.net (8.14.2/8.14.2) with ESMTP 
id m6TIGjGB016552
        for <linux-kernel@vger.kernel.org>; Tue, 29 Jul 
2008 15:16:45 -0300
Received: (from werner@localhost)
        by monkey.is-a-geek.net (8.14.2/8.13.4/Submit) id 
m6TIGgTp016545;
        Tue, 29 Jul 2008 15:16:42 -0300
X-Authentication-Warning: monkey.is-a-geek.net: werner set 
sender to werner@copaya.yi.org
using -f
From: "werner" <werner@copaya.yi.org>
Subject: problems with 2.6.27-rc1
To: linux-kernel@vger.kernel.org
Cc: 
X-Originating-IP: 217.175.173.230
X-Mailer: Usermin 1.350
Message-Id: <1217355401.16341@copaya.yi.org>
Date: Tue, 29 Jul 2008 15:16:42 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1217355402"

This is a multi-part message in MIME format.

--bound1217355402
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Problem with kernel 2.6.27-rc1 on shutdown


The problem occurs rather independently of the 
configuration, also with the configuration
taken from 2.6.26 with make menuconfig + exit.  (i compiled 
the kernel 3x with the
same problems)


Besides of the crash at shutdown reported below, during 
running, occured the following
problems, with the config taken from 2.6.26 as explained:

/ PS2 mouse not detected , but USB mouse is detected
/ eth0, eth1 not dound
/ in the midnight commander, instead the lines are other 
characters (i.e. the grafic
card driver dont work correctly)  
/ another compilation crashed with any wifi-thing 4965 
problem, I disabled that manually
within the config file after by menuconfig it re-connected 
it automatically but now
it compiled successful

below crash report and dmesg

config I send as a next mail, because its big

Werner Landgraf
werner@sys-linux.yi.org
werner@copaya.yi.org




=======================================

BUG unable to handlekernel null pointer derefense at 4
IP c046fad7 device_shutdown +0x27/0x80

pde=0   Oops=0 [#1] smp'

modules linked in: ipv6 ifconn l2pcp bluetooth savage 
radeon drm via_agp agpart pppoe
pppox ppp-? slhc lp parport-pc parport fuse

EIP 60:  c06fad7  EFLAGS 10292 EIP is at device-shutdon 
+0x27/0x80
EAX 0 EBX fffffffff84  ECX fffffff  edx 0  ESI 1 ED1:  
b7f84ff4  EBP f733b000 (or
f7336000)  ESP f7337e98  DS:  07b  ES 07b  FS 0d8 
GS 33  SS  68

stack:
01381a6 (or ...b)  kernel-restat 0x26/0x70
39df69 (or ..b9)  segurity-capable 0x9 0x10
784649  lock kernel 0x19/0x30
fee???? (i cannot more read my own writings ...)  ...
c0138348  sys_reboot 0x148/0x1b0
1027b5 _swich-to 0x85/0x160
138348  sys-rebot 0x148/0x1b0
1027b5 sitch_to 0x95/0x160
f783317c
f78557cc (or 700)
f5dfea80
12570f  finish task switch 0x1f/0xb0
f5dfea80
f7832f40
f7851880
f7832f40
c07832f40
c07827c1  schedule 0x251 0x7e0
c01439dc  get??????? 0x30/0xf0  (or 0x3c ...)
f7337f00
2a62a
f7337f00
976340
28143d4
e704bc3
   50
   
   next list continues:
   
 c0784431 spin_???_irq?? 0x31/0x50
 140cc0 lock_hrtimer_base 0x20/0x50
 140d7c ??timer_try_to_???? 0x3c/0x80
 7835a8  do_nanostep 0x78 0xa0
 140f7c hrtimer_nostep 0x5c/0xd0
 140a80 htimer_weekup 0x0/0x20
 141048 sys_nostep 0x58 0x60
 103a32 sys_call_call_call 0x7/0xb  (ou ..0x6)
 
 code  b6 c0 c3 90 86 (or 8b) 15 50 c7 ad c0 53 86 (or 8b) 
4a 04 83 e9 7c 8d 41 7c
86 99 80 000000 39 d0 74 44 83 eb 7o (ou 7c) 
 eb 7c eb 1b 90 89 c8 ff d2 8d 43 7c <8b> 93 80 0 0 0 3b 05 
50 c7 ad c0 74 29 (ou
2a) 89 d9 8d 5a 84 8b 81
 
 segmention fault /sbin/reboot
 
 
 
 dmesg:  
 
 
 Linux version 2.6.26-i486-1sys (root@darkstar) (gcc 
version 4.2.4) #1 SMP Tue Jul
15 00:23:56 GFT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfee0000 (usable)
 BIOS-e820: 00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
 BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
 BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00f5440] 000f5440
Entering add_active_range(0, 0, 1048576) 0 entries of 256 
used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000F6FD0, 0024 (r2 Nvidia)
ACPI: XSDT BFEE30C0, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        
0)
ACPI: FACP BFEEB840, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        
0)
ACPI: DSDT BFEE3240, 8581 (r1 NVIDIA ASUSACPI     1000 MSFT  
3000000)
ACPI: FACS BFEE0000, 0040
ACPI: MCFG BFEEBA40, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        
0)
ACPI: APIC BFEEB980, 007C (r1 Nvidia ASUSACPI 42302E31 AWRD        
0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000 Product ID: PROD00000000 
<6>MPTABLE: Product ID: PROD00000000
<6>MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at c0000000 (gap: 
bff00000:30100000)
PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 40744 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 1040384
Kernel command line: BOOT_IMAGE=2626 ro root=802 4 
root=/dev/sda2 devfs=nomount noapic
nolapic acpi=ht
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
Detected 2511.403 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
Memory: 3099680k/4194304k available (6598k kernel code, 
43768k reserved, 2302k data,
528k init, 2227072k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe13000 - 0xfffff000   (1968 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc09be000 - 0xc0a42000   ( 528 kB)
      .data : 0xc077191b - 0xc09b1240   (2302 kB)
      .text : 0xc0100000 - 0xc077191b   (6598 kB)
Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 5028.04 
BogoMIPS (lpj=10056096)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module 
capability
Capability LSM initialized as secondary
Failure registering Root Plug module with the kernel
selinux_register_security:  There is already a secondary 
security module registered.
Failure registering Root Plug  module with primary security 
module.
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ 
stepping 02
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5023.08 
BogoMIPS (lpj=10046171)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ 
stepping 02
Brought up 2 CPUs
Total of 2 processors activated (10051.13 BogoMIPS).
net_namespace: 660 bytes
Booting paravirtualized kernel on bare hardware
xor: automatically using best checksumming function: 
pIII_sse
   pIII_sse  :  7299.000 MB/sec
xor: using function: pIII_sse (7299.000 MB/sec)
NET: Registered protocol family 16
EISA bus registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 
0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 
0xc00fc6b0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc6e0, dseg 
0xf0000
PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by 
driver
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:04.0
PCI: Using IRQ router default [10de/03ea] at 0000:00:00.0
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread 
F7C30000 could not acquire
Mutex [1] [20080321]
system 00:07: iomem range 0x0-0x9ffff could not be reserved
system 00:07: iomem range 
0xfffffffffffe0000-0xffffffffffffffff has been reserved
system 00:07: iomem range 
0xfffffffffec00000-0xfffffffffec0ffff has been reserved
system 00:07: iomem range 
0xfffffffffee00000-0xfffffffffeefffff has been reserved
system 00:07: iomem range 
0xfffffffffefff000-0xfffffffffefff3ff has been reserved
system 00:07: iomem range 0x100000-0xffffff could not be 
reserved
system 00:08: iomem range 0xf0000-0xf3fff could not be 
reserved
system 00:08: iomem range 0xf4000-0xf7fff could not be 
reserved
system 00:08: iomem range 0xf8000-0xfffff could not be 
reserved
system 00:08: iomem range 0xd2800-0xd3fff has been reserved
PCI: Bridge: 0000:00:04.0
  IO window: b000-bfff
  MEM window: 0xfdf00000-0xfdffffff
  PREFETCH window: 0x00000000fde00000-0x00000000fdefffff
PCI: Bridge: 0000:00:09.0
  IO window: a000-afff
  MEM window: 0xfdd00000-0xfddfffff
  PREFETCH window: 0x00000000e0000000-0x00000000efffffff
PCI: Bridge: 0000:00:0b.0
  IO window: 8000-9fff
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff
PCI: Bridge: 0000:00:0c.0
  IO window: 7000-7fff
  MEM window: 0xfda00000-0xfdafffff
  PREFETCH window: 0x00000000fd900000-0x00000000fd9fffff
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)
TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(1217337211.276:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/W].
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, large 
block numbers, no debug enabled
SGI XFS Quota Management subsystem
GFS2 (built Jul 14 2008 23:47:51) installed
msgmni has been set to 1705
SELinux:  Registering netfilter hooks
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:04.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Enabling HT MSI Mapping
pci 0000:00:07.0: Enabling HT MSI Mapping
pci 0000:00:08.0: Enabling HT MSI Mapping
pci 0000:00:08.1: Enabling HT MSI Mapping
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:02:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
Allocate Port Service[0000:00:09.0:pcie03]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xe0000000, mapped to 0xf8d00000, 
using 3072k, total 16384k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: protected mode interface info at c000:a2da
vesafb: pmi: set display start = c00ca362, set palette = 
c00ca41e
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 0) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
input: Macintosh mouse button emulation 
as /class/input/input0
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; 
override with idebus=xx
NFORCE-MCP61: 0000:00:06.0 (rev a2) UDMA133 controller
NFORCE-MCP61: IDE controller (0x10de:0x03ec rev 0xa2) at  
PCI slot 0000:00:06.0
NFORCE-MCP61: not 100% native mode: will probe irqs later
NFORCE-MCP61: BIOS didn't set cable bits correctly. 
Enabling workaround.
NFORCE-MCP61: IDE port disabled
    ide0: BM-DMA at 0xf000-0xf007
Probing IDE interface ide0...
hdb: HL-DT-ST DVDRAM GSA-H44N, ATAPI CD/DVD-ROM drive
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
JMB: IDE controller (0x197b:0x2363 rev 0x03) at  PCI slot 
0000:03:00.1
pci 0000:03:00.1: enabling device (0000 -> 0001)
PCI: No IRQ known for interrupt pin B of device 
0000:03:00.1. Please try using pci=biosirq.
JMB: bad irq (0): will probe later
PCI: Setting latency timer of device 0000:03:00.1 to 64
    ide1: BM-DMA at 0x8c00-0x8c07
    ide2: BM-DMA at 0x8c08-0x8c0f
Probing IDE interface ide1...
Probing IDE interface ide2...
ide1: DISABLED, NO IRQ
ide1: failed to initialize IDE interface
ide2: DISABLED, NO IRQ
ide2: failed to initialize IDE interface
ide_generic: please use "probe_mask=0x3f" module parameter 
for probing all legacy
ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hdb: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB 
Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 1.00
register_blkdev: cannot get major 3 for hd
Loading iSCSI transport class v2.0-869.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2456]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 
loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address 
and IRQ using iobase=
and irq= options<6>QLogic Fibre Channel HBA Driver: 
8.02.01-k4
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.6
Copyright(c) 2004-2008 Emulex.  All rights reserved.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get 
problems load
        with "disable_clustering=1" and report to 
maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux 
v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux 
v2.26.02.010.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 
(April 24, 2007)
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
st: Version 20080224, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:03:00.0: version 3.0
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 
0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part 
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfdcfe000 port 
0xfdcfe100 irq 5
ata2: SATA max UDMA/133 abar m8192@0xfdcfe000 port 
0xfdcfe180 irq 5
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
sata_nv 0000:00:08.0: version 3.5
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 
irq 10
ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 
irq 10
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01104, max UDMA7
ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 
0/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  
1AA0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO
or FUA
sd 4:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO
or FUA
 sda: sda1 sda2 sda3 sda4
sd 4:0:0:0: [sda] Attached SCSI disk
PCI: Setting latency timer of device 0000:00:08.1 to 64
scsi6 : sata_nv
scsi7 : sata_nv
ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 
irq 11
ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 
irq 11
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-H66N, CB00, max 
UDMA/100
ata5.00: configured for UDMA/100
ata6: SATA link down (SStatus 0 SControl 300)
scsi 6:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H66N  
CB00 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
sr 6:0:0:0: Attached scsi CD-ROM sr0
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  
MMIO=[fdfff000-fdfff7ff]  Max
Packet=[2048]  IR/IT contexts=[4/8]
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 
0000:00:02.1
ehci_hcd 0000:00:02.1: irq 5, io mem 0xfe02e000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
usb usb1: New USB device found, idVendor=1d6b, 
idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-i486-1sys ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller 
(OHCI) Driver
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 2
ohci_hcd 0000:00:02.0: irq 11, io mem 0xfe02f000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26-i486-1sys ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usb 1-5: new high speed USB device using ehci_hcd and 
address 3
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: New USB device found, idVendor=0bda, 
idProduct=8187
usb 1-5: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
usb 1-5: Product: RTL8187_Wireless
usb 1-5: Manufacturer: Manufacturer_Realtek_RTL8187_
usb 1-5: SerialNumber: 0015AF2347F2
usb 2-2: new full speed USB device using ohci_hcd and 
address 2
ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[0011d800016acd4f]
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: New USB device found, idVendor=03f0, 
idProduct=0c17
usb 2-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
usb 2-2: Product: hp LaserJet 1010
usb 2-2: Manufacturer: Hewlett-Packard
usb 2-2: SerialNumber: 00CNFD758052
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 
1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
input: AT Translated Set 2 keyboard as /class/input/input1
raid6: int32x1    940 MB/s
raid6: int32x2   1000 MB/s
raid6: int32x4    950 MB/s
raid6: int32x8    689 MB/s
raid6: mmxx1     2048 MB/s
raid6: mmxx2     3750 MB/s
raid6: sse1x1    2050 MB/s
raid6: sse1x2    3407 MB/s
raid6: sse2x1    3409 MB/s
raid6: sse2x2    4777 MB/s
raid6: using algorithm sse2x2 (4777 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Jul 14 2008
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
registered taskstats version 1
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 528k freed
sd 4:0:0:0: Attached scsi generic sg0 type 0
sr 6:0:0:0: Attached scsi generic sg1 type 5
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
memory length for this resource is less than required
isp1760: probe of 0000:00:07.0 failed with error -12
usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 
vid 0x03F0 pid 0x0C17
usbcore: registered new interface driver usblp
forcedeth: Reverse Engineered nForce ethernet driver. 
Version 0.61.
PCI: Setting latency timer of device 0000:00:07.0 to 64
8139too Fast Ethernet driver 0.9.28
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
phy0: Selected rate control algorithm 'pid'
phy0: hwaddr 00:15:af:23:47:f2, rtl8187 V1 + rtl8225z2
usbcore: registered new interface driver rtl8187
forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x50ef @ 1, 
addr 00:1d:60:19:59:cc
forcedeth 0000:00:07.0: highdma pwrctl mgmt timirq gbit 
lnktim msi desc-v3
PCI: Setting latency timer of device 0000:00:05.0 to 64
hda_codec: Unknown model for AD1988, trying auto-probe from 
BIOS...
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
parport_pc 00:0d: reported by Plug and Play BIOS
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
eth1: RealTek RTL8139 at 0xbc00, 00:50:fc:4d:75:d4, IRQ 11
eth1:  Identified 8139 chip type 'RTL-8139C'
fuse init (API version 7.9)
EXT3 FS on sda2, internal journal
lp0: using parport0 (interrupt-driven).
lp0: console ready
PPP generic driver version 2.4.2
NET: Registered protocol family 24
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
PCI: Setting latency timer of device 0000:02:00.0 to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Atheros(R) L2 Ethernet Driver - version 2.0.4
Copyright (c) 2007 Atheros Corporation.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running 
e2fsck is recommended
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
  
  .....
  
  
  
  
  
  
  

--bound1217355402--
