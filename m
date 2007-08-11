Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXHKKEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXHKKEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 06:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXHKKEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 06:04:34 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:45124 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbXHKKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 06:04:29 -0400
From: Frederik Himpe <fhimpe@telenet.be>
Organization: Linux
To: linux-kernel@vger.kernel.org
Subject: pata_ali exceptions (timeout)
Date: Sat, 11 Aug 2007 12:03:34 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, arvidjaar@mail.ru
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2lYvGINOxWrYb+N"
Message-Id: <200708111203.34965.fhimpe@telenet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2lYvGINOxWrYb+N
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm using a Linux 2.6.22.2 kernel. When the pata_ali driver loads and disks 
are detected, the system appears to hang for some time, and there are 
exceptions/timeouts in the dmesg log.

The hardware is a Compaq Evo N1020v laptop computer.

I attach the output of dmesg and lspci -vvxx

I suppose this is the same problem as discussed earlier in these threads?
http://lkml.org/lkml/2006/6/20/309
http://www.opensubscriber.com/message/linux-ide%40vger.kernel.org/7326463.html

-- 
Frederik Himpe

--Boundary-00=_2lYvGINOxWrYb+N
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.22-5mdv (lcapitulino@n5.mandriva.com) (gcc version 4.2.1 20070802 (prerelease) (4.2.1-4mdv2008.0)) #1 SMP Fri Aug 10 16:44:23 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000df70000 (usable)
 BIOS-e820: 000000000df70000 - 000000000df7f000 (ACPI data)
 BIOS-e820: 000000000df7f000 - 000000000df80000 (ACPI NVS)
 BIOS-e820: 000000000df80000 - 000000000e000000 (reserved)
 BIOS-e820: 000000001df80000 - 000000001e000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
223MB LOWMEM available.
Entering add_active_range(0, 0, 57200) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    57200
  HighMem     57200 ->    57200
early_node_map[1] active PFN ranges
    0:        0 ->    57200
On node 0 totalpages: 57200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 414 pages used for memmap
  Normal zone: 52690 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F6BC0, 0014 (r0 PTLTD )
ACPI: RSDT 0DF7A60A, 002C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 0DF7EF64, 0074 (r1 COMPAQ 0818      6040000 ATI     F4240)
ACPI: DSDT 0DF7A636, 492E (r1 COMPAQ     0818  6040000 MSFT  100000E)
ACPI: FACS 0DF7FFC0, 0040
ACPI: BOOT 0DF7EFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
Allocating PCI resources starting at 20000000 (gap: 1e000000:e1f80000)
Built 1 zonelists.  Total pages: 56754
Kernel command line: BOOT_IMAGE=desktop_2.6.22.5-mdv root=/dev/sda6 splash=silent vga=788
bootsplash: silent mode.
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (011ca000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 2388.368 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 221752k/228800k available (2141k kernel code, 6356k reserved, 697k data, 280k init, 0k highmem, 0k BadRAM)
virtual kernel memory layout:
    fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xce800000 - 0xff7fe000   ( 783 MB)
    lowmem  : 0xc0000000 - 0xcdf70000   ( 223 MB)
      .init : 0xc03cc000 - 0xc0412000   ( 280 kB)
      .data : 0xc03177a7 - 0xc03c5c84   ( 697 kB)
      .text : 0xc0100000 - 0xc03177a7   (2141 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4780.90 BogoMIPS (lpj=9561818)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebf9ff 00000000 00000000 00000000 00000400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: bfebf9ff 00000000 00000000 0000b080 00000400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
Early unpacking initramfs... done
ACPI: Core revision 20070126
ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
ACPI: setting ELCR to 0200 (from 0c20)
CPU0: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 07
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd86e, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 8000-803f claimed by ali7101 ACPI
PCI quirk: region 8040-805f claimed by ali7101 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNK0] (IRQs *5 6)
ACPI: PCI Interrupt Link [LNK1] (IRQs 8 10) *11
ACPI: PCI Interrupt Link [LNK2] (IRQs *10 12)
ACPI: PCI Interrupt Link [LNK3] (IRQs 6 7 *11 13)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs *5)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
ACPI: RTC can wake from S4
pnp: 00:07: ioport range 0x40b-0x40b has been reserved
pnp: 00:07: ioport range 0x480-0x48f has been reserved
pnp: 00:07: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:07: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:07: ioport range 0x8000-0x807f could not be reserved
pnp: 00:08: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:08: iomem range 0xdc000-0xdffff has been reserved
pnp: 00:08: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:08: iomem range 0x100000-0xdffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f0300000-f03fffff
  PREFETCH window: f8000000-fbffffff
PCI: Bus 2, cardbus bridge: 0000:00:0a.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNK2] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 98304 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 731k freed
Simple Boot Flag at 0x38 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1186825090.296:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Activating ISA DMA hang workarounds.
Boot video device is 0000:01:05.0
vesafb: framebuffer at 0xf8000000, mapped to 0xce880000, using 3750k, total 32704k
vesafb: mode is 800x600x16, linelength=1600, pages=33
vesafb: protected mode interface info at c000:51c9
vesafb: pmi: set display start = c00c525d, set palette = c00c52a9
vesafb: pmi: ports = a010 a016 a054 a038 a03c a05c a000 a004 a0b0 a0b2 a0b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 32000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 280k freed
SCSI subsystem initialized
libata version 2.21 loaded.
ACPI: Unable to derive IRQ for device 0000:00:10.0
ACPI: PCI Interrupt 0000:00:10.0[A]: no GSI
PCI: Setting latency timer of device 0000:00:10.0 to 64
scsi0 : pata_ali
scsi1 : pata_ali
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00018080 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00018088 irq 15
ata1.00: ATA-6: FUJITSU MHS2040AT  D, 3003, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4240N, 0110, max MWDMA2
Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006
input: SynPS/2 Synaptics TouchPad as /class/input/input1
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHS2040A 3003 PQ: 0 ANSI: 5
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
         res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA2
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
         res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA2
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
         res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA2
ata2: EH complete
ata2.00: limiting speed to MWDMA1:PIO4
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 96 in
         res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA1
ata2: EH complete
scsi scan: 96 byte inquiry failed.  Consider BLIST_INQUIRY_36 for this device
scsi 1:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4240N 0110 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
SGI XFS with ACLs, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda6
Ending clean XFS mount for filesystem: sda6
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:0a.1[A] -> Link [LNK2] -> GSI 10 (level, low) -> IRQ 10
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  MMIO=[f0018000-f00187ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Linux agpgart interface v0.102 (c) Dave Jones
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
8139too Fast Ethernet driver 0.9.28
eth1394: eth0: IPv4 over IEEE 1394 (fw-host0)
agpgart: Detected Ati IGP330/340/345/350/M chipset
agpgart: AGP aperture is 64M @ 0xf4000000
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LNK3] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 11, io mem 0xf0016000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:13.1[B] -> Link [LNK3] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: irq 11, io mem 0xf0017000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000802719dd8d66e]
8139too 0000:00:0b.0: This (id 10ec:8139 rev 20) is an enhanced 8139C+ chip
8139too 0000:00:0b.0: Use the "8139cp" driver for improved performance and stability.
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNK1] -> GSI 10 (level, low) -> IRQ 10
8139too 0000:00:0b.0: unknown chip version, assuming RTL-8139
8139too 0000:00:0b.0: TxConfig = 0x74800000
eth0: RealTek RTL8139 at 0xcec88800, 00:08:02:d8:d5:b9, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139'
ACPI: PCI Interrupt 0000:00:13.2[C] -> Link [LNK3] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
ehci_hcd 0000:00:13.2: irq 11, io mem 0xf0018c00
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 5 ports detected
Yenta: CardBus bridge found at 0000:00:0a.0 [0e11:0056]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:0a.0, mfunc 0x01001c00, devctl 0x64
Yenta: ISA IRQ mask 0x00b8, PCI irq 10
Socket status: 30000020
ACPI: PCI Interrupt Link [LNK7] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNK7] -> GSI 5 (level, low) -> IRQ 5
pccard: CardBus card inserted into slot 0
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
bcm43xx driver
AC'97 1 does not respond - RESET
AC'97 1 access is not valid [0xffffffff], removing mixer.
ali mixer 1 creating error.
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK2] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:02:00.0 to 64
bcm43xx: Chip ID 0x4306, rev 0x3
bcm43xx: Number of cores: 5
bcm43xx: Core 0: ID 0x800, rev 0x4, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0x5, vendor 0x4243
bcm43xx: Core 2: ID 0x80d, rev 0x2, vendor 0x4243
bcm43xx: Core 3: ID 0x807, rev 0x2, vendor 0x4243
bcm43xx: Core 4: ID 0x804, rev 0x9, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 2, Type 2, Revision 2
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio turned off
bcm43xx: Radio turned off
Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro 5050 PCI Audio, version 0.14.10j-2.6, 16:37:15 Aug 10 2007
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 128 in
         res 40/00:03:00:00:20/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA1
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 128 in
         res 40/00:03:00:00:20/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA1
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 128 in
         res 40/00:03:00:00:20/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA1
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 128 in
         res 40/00:03:00:00:20/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for MWDMA1
ata2: EH complete
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNK0] enabled at IRQ 5
ACPI: PCI Interrupt 0000:01:05.0[A] -> Link [LNK0] -> GSI 5 (level, low) -> IRQ 5
[drm] Initialized radeon 1.27.0 20060524 on minor 0
input: PC Speaker as /class/input/input2
Capability LSM initialized
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Non-volatile memory driver v1.2
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Adding 248968k swap on /dev/sda7.  Priority:-1 extents:1 across:248968k
XFS mounting filesystem sda9
Ending clean XFS mount for filesystem: sda9
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
XFS mounting filesystem sda10
Ending clean XFS mount for filesystem: sda10
NTFS driver 2.1.28 [Flags: R/O DEBUG MODULE].
NTFS-fs warning (device sda1): parse_options(): Option iocharset is deprecated. Please use option nls=<charsetname> in the future.
NTFS volume version 3.1.
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
loop: module loaded
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
No dock devices found.
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input4
ACPI: Sleep Button (FF) [SLPF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input6
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /class/input/input7
ACPI: Lid Switch [LID]
Module len 120974 truncated
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
ACPI: Thermal Zone [TZ0] (37 C)
ACPI: Invalid passive threshold
ACPI: Thermal Zone [TZ1] (-273 C)
ACPI: Video Device [VGA_AGP] (multi-head: yes  rom: no  post: no)
NET: Registered protocol family 17
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: Radio enabled by hardware
bcm43xx: Chip initialized
bcm43xx: 30-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
ieee80211_crypt: registered algorithm 'WEP'
bcm43xx: set security called, .active_key = 0, .level = 1, .enabled = 1, .encrypt = 1, .auth_mode = 0
SoftMAC: Open Authentication completed with 00:15:f2:0a:ab:43
SoftMAC: invalid iw_mode!
SoftMAC: invalid iw_mode!
spurious 8259A interrupt: IRQ7.
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
Module len 120974 truncated
SoftMAC: Open Authentication completed with 00:15:f2:0a:ab:43
ieee80211_crypt: registered algorithm 'CCMP'
bcm43xx: set security called, .active_key = 0, .level = 4, .enabled = 1, .encrypt = 1
bcm43xx: set security called, .enabled = 1, .encrypt = 1
Module len 120974 truncated
Module len 120974 truncated
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:05.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] writeback test succeeded in 1 usecs

--Boundary-00=_2lYvGINOxWrYb+N
Content-Type: text/plain;
  charset="utf-8";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: ATI Technologies Inc RS200/RS200M AGP Bridge [IGP 340M] (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at f4000000 (32-bit, prefetchable) [size=64M]
	Region 1: Memory at f0600000 (32-bit, prefetchable) [size=4K]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
00: 02 10 b2 ca 06 00 30 22 02 00 00 06 00 40 00 00
10: 08 00 00 f4 08 00 60 f0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 340M] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: f0300000-f03fffff
	Prefetchable memory behind bridge: f8000000-fbffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
00: 02 10 10 70 07 00 20 02 00 00 04 06 00 63 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 44 a1 a1 20 22
20: 30 f0 30 f0 00 f8 f0 fb 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 0c 00

00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link Controller Audio Device (rev 02)
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
	Latency: 64 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at 8400 [size=256]
	Region 1: Memory at f0014000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: b9 10 51 54 07 00 90 c2 02 00 01 04 00 40 00 00
10: 01 84 00 00 00 40 01 f0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 02 18

00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+]
	Subsystem: ALi Corporation ALi M1533 Aladdin IV/V ISA Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [a0] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: b9 10 33 15 0f 00 10 02 00 00 01 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 33 15
30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00

00:0a.0 CardBus bridge: Texas Instruments PCI4410 PC card Cardbus Controller (rev 02)
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ffbfe000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 24000000-27fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
00: 4c 10 41 ac 07 00 10 02 02 00 07 06 08 a8 82 00
10: 00 e0 bf ff a0 00 00 02 00 02 05 b0 00 00 00 20
20: 00 f0 ff 23 00 00 00 24 00 f0 ff 27 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 0a 01 00 05
40: 11 0e 56 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0a.1 FireWire (IEEE 1394): Texas Instruments PCI4410 FireWire Controller (rev 02) (prog-if 10 [OHCI])
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f0018000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at f0010000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 4c 10 17 80 16 00 10 02 02 10 00 0c 08 40 80 00
10: 00 80 01 f0 00 00 01 f0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 0a 01 03 04

00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 20)
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at 9000 [size=256]
	Region 1: Memory at f0018800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: ec 10 39 81 17 00 90 02 20 00 00 02 08 40 00 00
10: 01 90 00 00 00 88 01 f0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 20 40

00:0c.0 Communication controller: Conexant HSF 56k HSFi Modem (rev 01)
	Subsystem: Compaq Computer Corporation Unknown device 8d89
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=64K]
	Region 1: I/O ports at 8090 [size=8]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: f1 14 00 2f 03 00 90 02 01 00 80 07 00 40 00 00
10: 00 00 00 f0 91 80 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 89 8d
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00

00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4) (prog-if fa)
	Subsystem: ALi Corporation M5229 IDE
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 0
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at 8080 [size=16]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: b9 10 29 52 05 00 90 02 c4 fa 01 01 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 80 00 00 00 00 00 00 00 00 00 00 b9 10 29 52
30: 00 00 00 00 60 00 00 00 00 00 00 00 00 01 02 04

00:11.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
	Subsystem: ALi Corporation M7101 Power Management Controller [PMU]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: b9 10 01 71 00 00 00 02 00 00 80 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 01 71
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0016000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 33 10 35 00 16 00 10 02 41 10 03 0c 08 40 80 00
10: 00 60 01 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 01 2a

00:13.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at f0017000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 33 10 35 00 16 00 10 02 41 10 03 0c 08 40 00 00
10: 00 70 01 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 01 2a

00:13.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 132 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f0018c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 33 10 e0 00 16 00 10 02 02 20 03 0c 20 84 00 00
10: 00 8c 01 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 03 10 22

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon IGP 330M/340M/350M (prog-if 00 [VGA])
	Subsystem: Compaq Computer Corporation Unknown device 0056
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at a000 [size=256]
	Region 2: Memory at f0300000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at f0320000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=16 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 02 10 37 43 87 02 b0 02 00 00 00 03 08 42 00 00
10: 08 00 00 f8 01 a0 00 00 00 00 30 f0 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e 56 00
30: 00 00 00 00 58 00 00 00 00 00 00 00 05 01 08 00

02:00.0 Network controller: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller (rev 03)
	Subsystem: ASUSTeK Computer Inc. WL-100G
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at 24000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
00: e4 14 20 43 06 00 10 00 03 00 80 02 00 40 00 00
10: 00 00 00 24 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 81 10 00 00 43 10 0f 10
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00


--Boundary-00=_2lYvGINOxWrYb+N--
