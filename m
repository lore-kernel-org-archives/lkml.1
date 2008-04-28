Return-Path: <linux-kernel-owner+w=401wt.eu-S966048AbYD1Puq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966048AbYD1Puq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936479AbYD1Pqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:46:48 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:59813 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463AbYD1Pqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:46:45 -0400
Date: Mon, 28 Apr 2008 11:46:44 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
In-Reply-To: <48140ACF.4000500@goop.org>
Message-ID: <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net> <48140ACF.4000500@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Apr 2008, Jeremy Fitzhardinge wrote:
> Gerhard Mack wrote:
> > I havn't enabled compat VDSO at the kernel command line or otherwise.
> > Something broke with this option.   
> 
> Yes, you might be on to something.  I think I've been seeing that message when
> I wouldn't expect to.  I'll double-check.  Could you send your complete dmesg
> output?
> 
Of course

Linux version 2.6.25 (root@fd) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 PREEMPT Thu Apr 24 13:07:50 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffe2800 (usable)
 BIOS-e820: 000000001ffe2800 - 0000000020000000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fee00000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Entering add_active_range(0, 0, 131042) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131042
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131042
On node 0 totalpages: 131042
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125955 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FDE50, 0014 (r0 DELL  )
ACPI: RSDT 000FDE64, 0028 (r1 DELL    CPi R   27D40107 ASL        61)
ACPI: FACP 000FDE90, 0074 (r1 DELL    CPi R   27D40107 ASL        61)
ACPI: DSDT FFFE4000, 314E (r1 INT430 SYSFexxx     1001 MSFT  100000E)
ACPI: FACS 1FFFF800, 0040
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 30000000 (gap: 20000000:deda0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130019
Kernel command line: root=/dev/sda3 ro 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01402000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1196.541 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514436k/524168k available (3019k kernel code, 9232k reserved, 1134k data, 188k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffe2000   ( 511 MB)
      .init : 0xc0512000 - 0xc0541000   ( 188 kB)
      .data : 0xc03f2d3a - 0xc050e90c   (1134 kB)
      .text : 0xc0100000 - 0xc03f2d3a   (3019 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2395.98 BogoMIPS (lpj=1197992)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 Mobile CPU 1.80GHz stepping 04
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
net_namespace: 536 bytes
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfbfee, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *11
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
ACPI: Power Resource [PADA] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
 00:04: mem resource (0xfa000000-0xfbffffff) overlaps 0000:00:1e.0 BAR 8 (0xf4000000-0xfbffffff), disabling
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:00: iomem range 0x0-0x9fbff could not be reserved
system 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xcffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1ffeffff could not be reserved
system 00:00: iomem range 0x1fff0000-0x1fffffff could not be reserved
system 00:00: iomem range 0xfeda0000-0xfedfffff could not be reserved
system 00:00: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
system 00:02: ioport range 0x808-0x80f has been reserved
system 00:03: ioport range 0x806-0x807 has been reserved
system 00:03: ioport range 0x810-0x85f has been reserved
system 00:03: ioport range 0x860-0x87f has been reserved
system 00:03: ioport range 0x880-0x8bf has been reserved
system 00:03: ioport range 0x8c0-0x8df has been reserved
system 00:03: ioport range 0x8e0-0x8ff has been reserved
system 00:04: ioport range 0xf000-0xf0fe has been reserved
system 00:04: ioport range 0xf100-0xf1fe has been reserved
system 00:04: ioport range 0xf200-0xf2fe has been reserved
system 00:04: ioport range 0xf400-0xf4fe has been reserved
system 00:04: ioport range 0xf500-0xf5fe has been reserved
system 00:04: ioport range 0xf600-0xf6fe has been reserved
system 00:04: ioport range 0xf800-0xf8fe has been reserved
system 00:04: ioport range 0xf900-0xf9fe has been reserved
system 00:04: ioport range 0xfa00-0xfafe has been reserved
system 00:04: ioport range 0xfc00-0xfcfe has been reserved
system 00:04: ioport range 0xfd00-0xfdfe has been reserved
system 00:04: ioport range 0xfe00-0xfefe has been reserved
system 00:09: ioport range 0x900-0x91f has been reserved
system 00:09: ioport range 0x3f0-0x3f1 has been reserved
system 00:0f: ioport range 0xbf40-0xbf5f has been reserved
system 00:10: iomem range 0xfebffc00-0xfebfffff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: 0xfc000000-0xfdffffff
  PREFETCH window: 0x00000000d8000000-0x00000000e7ffffff
PCI: Bus 3, cardbus bridge: 0000:02:01.0
  IO window: 0x0000e000-0x0000e0ff
  IO window: 0x0000e400-0x0000e4ff
  PREFETCH window: 0x30000000-0x33ffffff
  MEM window: 0xf4000000-0xf7ffffff
PCI: Bus 7, cardbus bridge: 0000:02:01.1
  IO window: 0x0000e800-0x0000e8ff
  IO window: 0x00001000-0x000010ff
  PREFETCH window: 0x34000000-0x37ffffff
  MEM window: 0x3c000000-0x3fffffff
PCI: Bridge: 0000:00:1e.0
  IO window: e000-ffff
  MEM window: 0xf4000000-0xfbffffff
  PREFETCH window: 0x0000000030000000-0x0000000039ffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Enabling device 0000:02:01.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Enabling device 0000:02:01.1 (0000 -> 0003)
ACPI: PCI Interrupt 0000:02:01.1[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
ACPI: AC Adapter [AC] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
Switched to high resolution mode on CPU 0
ACPI: Battery Slot [BAT1] (battery present)
input: Lid Switch as /class/input/input0
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SBTN]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM] (28 C)
Non-volatile memory driver v1.2
Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
Intel 82802 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
loop: module loaded
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
3c59x: Donald Becker and others.
0000:02:00.0: 3Com PCI 3c905C Tornado at e0816c00.
ACPI: PCI Interrupt 0000:02:03.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
ath5k_pci 0000:02:03.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112A multiband radio found (0x36)
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
ata1.00: ATA-6: TOSHIBA MK8025GAS, KA020U, max UDMA/100
ata1.00: 156301488 sectors, multi 8: LBA 
ata1.01: ATAPI: MATSHITADVD-RAM UJ-820S, 1.70, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8025GA KA02 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: CD-ROM            MATSHITA DVD-RAM UJ-820S  1.70 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sr 0:0:1:0: Attached scsi generic sg1 type 5
Yenta: CardBus bridge found at 0000:02:01.0 [1028:00d5]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:01.0, mfunc 0x05033002, devctl 0x64
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0xe000 - 0xffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x39ffffff
Yenta: CardBus bridge found at 0000:02:01.1 [1028:00d5]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:01.1, mfunc 0x05033002, devctl 0x64
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0xe000 - 0xffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x39ffffff
usbmon: debugfs is not available
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000bf80
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.2: irq 11, io base 0x0000bf20
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:1f.5 to 64
Marking TSC unstable due to: TSC halts in idle.
input: DualPoint Stick as /class/input/input4
input: AlpsPS/2 ALPS DualPoint TouchPad as /class/input/input5
intel8x0_measure_ac97_clock: measured 50259 usecs
intel8x0: clocking to 48000
ALSA device list:
  #0: Intel 82801CA-ICH3 with CS4205 at irq 5
Netfilter messages via NETLINK v0.30.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
Using IPI Shortcut mode
registered taskstats version 1
rtc_cmos 00:07: setting system clock to 2008-04-28 15:31:40 UTC (1209396700)
UDF-fs: No VRS found
XFS mounting filesystem sda3
Ending clean XFS mount for filesystem: sda3
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 188k freed
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
udev: renamed network interface wlan0 to ath0
input: Video Bus as /class/input/input6
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Adding 1951856k swap on /dev/sda1.  Priority:-1 extents:1 across:1951856k
eth0:  setting full-duplex.
eth0: no IPv6 routers present
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
spurious 8259A interrupt: IRQ7.

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
