Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYG2UrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYG2UrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYG2UrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:47:11 -0400
Received: from andesite.resot.net ([217.175.160.141]:44279 "EHLO
	andesite.ool.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYG2UrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:47:07 -0400
X-Greylist: delayed 731 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 16:47:05 EDT
Date: 29 Jul 2008 22:58:49 -0000
Message-ID: <20080729225849.17094.qmail@andesite.ool.fr>
From: "w.landgraf" <w.landgraf@ool.fr>
To: linux-kernel@vger.kernel.org
Subject: correction: kernel problem report
References: 
In-Reply-To: 
X-IPAddress: 217.175.173.230
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my kernel bug / problem /crash-during-reboot report 
occured the mistake that, instead of the corresponding 
2.6.27-rc1 dmesg, I included that dmesg of 2.6.26 what Im 
continuing to use. Here the corresponding 2.6.27-rc1 dmesg:

Werner Landgraf
werner@copaya.yi.org 
=============================================
Linux version 2.6.27-rc1-i486-1sys (root@werner) (gcc 
version 4.2.4) #1 SMP Tue Jul 29 12:13:34 GFT 2008
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
last_pfn = 0xbfee0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
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
2174MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(8 early reservations) ==> bootmem [0000000000 - 
0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
  #3 [0000100000 - 0000afbea0]    TEXT DATA BSS ==> 
[0000100000 - 0000afbea0]
  #4 [0000afc000 - 0000b00000]    INIT_PG_TABLE ==> 
[0000afc000 - 0000b00000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> 
[000009f000 - 0000100000]
  #6 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
  #7 [0000008000 - 000000f000]          BOOTMAP ==> 
[0000008000 - 000000f000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5440] 000f5440
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x000bfee0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bfee0
On node 0 totalpages: 786047
free_area_init_node: node 0, pgdat c097c200, node_mem_map 
c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 552418 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is ISA   
I/O APIC #2 Version 17 at 0xFEC00000.
Int: type 0, pol 3, trig 3, bus 00, IRQ 04, APIC ID 2, APIC 
INT 0a
Int: type 0, pol 3, trig 3, bus 00, IRQ 08, APIC ID 2, APIC 
INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 2, APIC 
INT 05
Int: type 0, pol 3, trig 3, bus 01, IRQ 18, APIC ID 2, APIC 
INT 0a
Int: type 0, pol 3, trig 3, bus 00, IRQ 1c, APIC ID 2, APIC 
INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 15, APIC ID 2, APIC 
INT 05
Int: type 0, pol 3, trig 3, bus 02, IRQ 00, APIC ID 2, APIC 
INT 0a
Int: type 0, pol 3, trig 3, bus 01, IRQ 20, APIC ID 2, APIC 
INT 0b
Int: type 0, pol 3, trig 3, bus 03, IRQ 00, APIC ID 2, APIC 
INT 05
Int: type 0, pol 3, trig 3, bus 00, IRQ 20, APIC ID 2, APIC 
INT 0a
Int: type 0, pol 3, trig 3, bus 00, IRQ 21, APIC ID 2, APIC 
INT 0b
Int: type 3, pol 0, trig 0, bus 05, IRQ 00, APIC ID 2, APIC 
INT 00
Int: type 0, pol 0, trig 0, bus 05, IRQ 01, APIC ID 2, APIC 
INT 01
Int: type 0, pol 0, trig 0, bus 05, IRQ 00, APIC ID 2, APIC 
INT 02
Int: type 0, pol 0, trig 0, bus 05, IRQ 03, APIC ID 2, APIC 
INT 03
Int: type 0, pol 0, trig 0, bus 05, IRQ 04, APIC ID 2, APIC 
INT 04
Int: type 0, pol 0, trig 0, bus 05, IRQ 06, APIC ID 2, APIC 
INT 06
Int: type 0, pol 0, trig 0, bus 05, IRQ 07, APIC ID 2, APIC 
INT 07
Int: type 0, pol 1, trig 1, bus 05, IRQ 08, APIC ID 2, APIC 
INT 08
Int: type 0, pol 0, trig 0, bus 05, IRQ 09, APIC ID 2, APIC 
INT 09
Int: type 0, pol 0, trig 0, bus 05, IRQ 0c, APIC ID 2, APIC 
INT 0c
Int: type 0, pol 0, trig 0, bus 05, IRQ 0d, APIC ID 2, APIC 
INT 0d
Int: type 0, pol 0, trig 0, bus 05, IRQ 0e, APIC ID 2, APIC 
INT 0e
Int: type 0, pol 0, trig 0, bus 05, IRQ 0f, APIC ID 2, APIC 
INT 0f
Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, 
APIC LINT 00
Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, 
APIC LINT 01
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
Allocating PCI resources starting at c0000000 (gap: 
bff00000:30100000)
PERCPU: Allocating 40368 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 779905
Kernel command line: BOOT_IMAGE=2627rc1 ro root=802 4 
root=/dev/sda2 devfs=nomount noapic nolapic acpi=ht
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 2511.394 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
Memory: 3107532k/3144576k available (6677k kernel code, 
35780k reserved, 2411k data, 580k init, 2227072k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc09eb000 - 0xc0a7c000   ( 580 kB)
      .data : 0xc078549b - 0xc09e0160   (2411 kB)
      .text : 0xc0100000 - 0xc078549b   (6677 kB)
Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
Calibrating delay loop (skipped), value calculated using 
timer frequency.. <6>5022.78 BogoMIPS (lpj=10045576)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Failure registering Root Plug module with the kernel
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using C1E aware idle routine
Checking 'hlt' instruction... OK.
BIOS bug, local APIC #0 not detected!...
... forcing use of dummy APIC emulation.(tell your hw 
vendor)
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (5022.78 BogoMIPS).
net_namespace: 792 bytes
Booting paravirtualized kernel on bare hardware
xor: automatically using best checksumming function: 
pIII_sse
   pIII_sse  :  7578.000 MB/sec
xor: using function: pIII_sse (7578.000 MB/sec)
NET: Registered protocol family 16
EISA bus registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 
0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
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
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:05.0: PME# supported from D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:07.0: supports D1
pci 0000:00:07.0: supports D2
pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:01:06.0: supports D1
pci 0000:01:06.0: supports D2
pci 0000:01:06.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:06.0: PME# disabled
pci 0000:00:04.0: transparent bridge
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.1: supports D1
pci 0000:02:00.1: supports D2
Pre-1.1 PCIe device detected, disable ASPM for 
0000:00:09.0. It can be enabled forcedly 
with 'pcie_aspm=force'
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
Pre-1.1 PCIe device detected, disable ASPM for 
0000:00:0b.0. It can be enabled forcedly 
with 'pcie_aspm=force'
pci 0000:00:00.0: default IRQ router [10de/03ea]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread 
F7830000 could not acquire Mutex [1] [20080609]
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
pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
pci 0000:00:04.0:   IO window: 0xb000-0xbfff
pci 0000:00:04.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:00:04.0:   PREFETCH window: 
0x000000fde00000-0x000000fdefffff
pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
pci 0000:00:09.0:   IO window: 0xa000-0xafff
pci 0000:00:09.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:09.0:   PREFETCH window: 
0x000000e0000000-0x000000efffffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0b.0:   IO window: 0x8000-0x9fff
pci 0000:00:0b.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:0b.0:   PREFETCH window: 
0x000000fdb00000-0x000000fdbfffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: 0x7000-0x7fff
pci 0000:00:0c.0:   MEM window: 0xfda00000-0xfdafffff
pci 0000:00:0c.0:   PREFETCH window: 
0x000000fd900000-0x000000fd9fffff
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
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
type=2000 audit(1217336289.075:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/W].
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, large 
block numbers, no debug enabled
SGI XFS Quota Management subsystem
GFS2 (built Jul 29 2008 11:36:47) installed
msgmni has been set to 1721
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
pcieport-driver 0000:00:09.0: setting latency timer to 64
pcieport-driver 0000:00:09.0: found MSI capability
pci_express 0000:00:09.0:pcie00: allocate port service
pci_express 0000:00:09.0:pcie03: allocate port service
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
pci_express 0000:00:0b.0:pcie03: allocate port service
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
pci_express 0000:00:0c.0:pcie03: allocate port service
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
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
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
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x03ec rev 
0xa2)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. 
Enabling workaround.
amd74xx 0000:00:06.0: not 100% native mode: will probe irqs 
later
    ide0: BM-DMA at 0xf000-0xf007
Probing IDE interface ide0...
hdb: HL-DT-ST DVDRAM GSA-H44N, ATAPI CD/DVD-ROM drive
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 
0x03)
pci 0000:03:00.1: enabling device (0000 -> 0001)
pci 0000:03:00.1: can't find IRQ for PCI INT B; please try 
using pci=biosirq
jmicron 0000:03:00.1: bad irq (0): will probe later
pci 0000:03:00.1: setting latency timer to 64
    ide1: BM-DMA at 0x8c00-0x8c07
    ide2: BM-DMA at 0x8c08-0x8c0f
Probing IDE interface ide1...
Probing IDE interface ide2...
ide1: disabled, no IRQ
ide1: failed to initialize IDE interface
ide2: disabled, no IRQ
ide2: failed to initialize IDE interface
jmicron 0000:03:00.1: IDE controller (0x197b:0x2363 rev 
0x03)
JMicron IDE 0000:03:00.1: BAR 0: can't reserve I/O region 
[0x9c00-0x9c07]
jmicron 0000:03:00.1: can't reserve resources
JMicron IDE: probe of 0000:03:00.1 failed with error -16
ide_generic: please use "probe_mask=0x3f" module parameter 
for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hdb: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB 
Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 1.00
Loading iSCSI transport class v2.0-870.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2456]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 
loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address 
and IRQ using iobase= and irq= options<6>QLogic Fibre 
Channel HBA Driver: 8.02.01-k6
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
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
v2.26.02.011.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 
(April 24, 2007)
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:03:00.0: version 3.0
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 
0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part 
ahci 0000:03:00.0: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfdcfe000 port 
0xfdcfe100 irq 5
ata2: SATA max UDMA/133 abar m8192@0xfdcfe000 port 
0xfdcfe180 irq 5
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
sata_nv 0000:00:08.0: version 3.5
sata_nv 0000:00:08.0: setting latency timer to 64
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
enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 4:0:0:0: [sda] Attached SCSI disk
sata_nv 0000:00:08.1: setting latency timer to 64
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
pata_acpi 0000:03:00.1: BAR 0: can't reserve I/O region 
[0x9c00-0x9c07]
pata_acpi 0000:03:00.1: failed to request/iomap BARs for 
port 0 (errno=-16)
pata_acpi 0000:03:00.1: BAR 2: can't reserve I/O region 
[0x9400-0x9407]
pata_acpi 0000:03:00.1: failed to request/iomap BARs for 
port 1 (errno=-16)
pata_acpi 0000:03:00.1: no available native port
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  
MMIO=[fdfff000-fdfff7ff]  Max Packet=[2048]  IR/IT 
contexts=[4/8]
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not 
supported
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
usb usb1: Manufacturer: Linux 2.6.27-rc1-i486-1sys ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller 
(OHCI) Driver
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 2
ohci_hcd 0000:00:02.0: irq 11, io mem 0xfe02f000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-5: new high speed USB device using ehci_hcd and 
address 3
usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-rc1-i486-1sys ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
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
raid6: int32x1    934 MB/s
raid6: int32x2   1000 MB/s
raid6: int32x4    957 MB/s
raid6: int32x8    682 MB/s
raid6: mmxx1     2059 MB/s
raid6: mmxx2     3742 MB/s
raid6: sse1x1    2058 MB/s
raid6: sse1x2    3382 MB/s
raid6: sse2x1    3394 MB/s
raid6: sse2x2    4751 MB/s
raid6: using algorithm sse2x2 (4751 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) 
initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Jul 29 2008
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
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
register_blkdev: cannot get major 3 for hd
input: AT Translated Set 2 keyboard as /class/input/input1
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 580k freed
ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[0011d800016acd4f]
fuse init (API version 7.9)
EXT3 FS on sda2, internal journal
parport_pc 00:0d: reported by Plug and Play BIOS
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
lp0: console ready
PPP generic driver version 2.4.2
NET: Registered protocol family 24
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
pci 0000:02:00.0: setting latency timer to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
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

