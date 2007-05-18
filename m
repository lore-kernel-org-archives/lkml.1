Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbXERJq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbXERJq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXERJqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:46:50 -0400
Received: from smtp814.mail.ird.yahoo.com ([217.146.188.74]:45297 "HELO
	smtp814.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753078AbXERJqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:46:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type;
  b=nlFNfegok1OjJM1G4wzwrQh5zyGgRyxWONSIvF6khWTOqF39yNqppqNaX70p4GyArG2m4jKFuRAJ+kV487xyR+8KeoIJyYL7UbRwqHMy/u2Dnjffc42vT8C3N25pZxfzqKlKZCeu06w1fkwY+T7rXlWIwcBVc0ZTqD+IU1qQagc=  ;
X-YMail-OSG: bCMffqMVM1nFUxjXOyv5qh49.bt6F4a3FavnogtYBG14p1qT5quzq4uBitQNgdory6Tpcp7oXA--
Message-ID: <464D7603.7010308@btinternet.com>
Date: Fri, 18 May 2007 10:46:43 +0100
From: Francis Russell <FrancisRussell@btinternet.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: pata_via appears to incorrectly detects 40-pin cable
References: <990930.5739.qm@web86408.mail.ird.yahoo.com> <20070518013955.41df5765@the-village.bc.nu>
In-Reply-To: <20070518013955.41df5765@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------000405020008080404020105"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000405020008080404020105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


> Does the laptop actually have 80 wire cables - did you see UDMA100
> actually being used. If so can you send me an lspci -vxx and a dmesg.
> Probably we need to add it to the list of devices using short 40 wire
> cable tricks

I have been using UDMA5/ATA100 for months, although this was set by a 
hdparm init.d script. Disabling the script, performing a cold reset and 
booting into a 2.6.21 kernel with the old ATA system enabled, hdparm -i 
indicated the HD was using UDMA5. I'm assuming that this means the old 
drivers do not limit to ATA33 unless there is a better I can check this.

I removed the laptop's hard drive. It fits into a cradle which is 
inserted into the laptop. There is no form of cable or adapter that is 
placed on the HD's connector. It just plugs directly into a socket 
inside the laptop when the cradle is inserted.

I hope this is enough information. I've included the output of dmesg and 
lspci -vxx.

Francis


--------------000405020008080404020105
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

0x342
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2004.618 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1294252k/1309632k available (2072k kernel code, 14224k reserved, 714k data, 196k init, 392128k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03bc000 - 0xc03ed000   ( 196 kB)
      .data : 0xc030618f - 0xc03b8b94   ( 714 kB)
      .text : 0xc0100000 - 0xc030618f   (2072 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4011.25 BogoMIPS (lpj=2005626)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Mobile AMD Athlon 64 Processor 3000+ stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd64c, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 4000-407f claimed by vt8235 PM
PCI quirk: region 8100-810f claimed by vt8235 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *5, disabled.
ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *9, disabled.
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *11, disabled.
ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *5, disabled.
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:05: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:05: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:05: iomem range 0xffee0000-0xffefffff has been reserved
pnp: 00:06: ioport range 0x600-0x60f has been reserved
pnp: 00:06: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:06: ioport range 0xfe10-0xfe11 has been reserved
pnp: 00:06: ioport range 0xfe00-0xfe00 has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: d0100000-d01fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bus 2, cardbus bridge: 0000:00:07.0
  IO window: 00001c00-00001cff
  IO window: 00003000-000030ff
  PREFETCH window: 60000000-63ffffff
  MEM window: 64000000-67ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x37 set to 0x80
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
vesafb: framebuffer at 0xd8000000, mapped to 0xf8880000, using 5742k, total 131072k
vesafb: mode is 1400x1050x16, linelength=2800, pages=44
vesafb: protected mode interface info at c000:56ac
vesafb: pmi: set display start = c00c571a, set palette = c00c5754
vesafb: pmi: ports = 2010 2016 2054 2038 203c 205c 2000 2004 20b0 20b2 20b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 175x65
fb0: VESA VGA frame buffer device
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
tg3.c:v3.76 (May 5, 2007)
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 17 (level, low) -> IRQ 16
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:c0:9f:67:01:5f
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
pata_via 0000:00:11.1: version 0.3.1
ACPI: Unable to derive IRQ for device 0000:00:11.1
ACPI: PCI Interrupt 0000:00:11.1[A]: no GSI
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011860 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011868 irq 15
ata1.00: ata_hpa_resize 1: sectors = 195371568, hpa_sectors = 195371568
ata1.00: ATA-6: HTS721010G9AT00, MCZOA51A, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: ata_hpa_resize 1: sectors = 195371568, hpa_sectors = 195371568
ata1.00: configured for UDMA/33
Switched to high resolution mode on CPU 0
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9AT00  MCZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-835S  GQM5 PQ: 0 ANSI: 5
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
ACPI: PCI Interrupt 0000:00:07.1[B] -> GSI 18 (level, low) -> IRQ 17
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[d0015000-d00157ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
irda_init()
NET: Registered protocol family 23
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 18
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 18, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda caddy
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:10.1[B] -> GSI 21 (level, low) -> IRQ 18
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 18, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kmprq
ipw2200: Copyright(c) 2003-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:10.2[C] -> GSI 21 (level, low) -> IRQ 18
usb 1-1: new full speed USB device using uhci_hcd and address 2
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 18, io base 0x00001840
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00c09f0000304fb1]
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
sd 0:0:0:0: Attached scsi generic sg0 type 0
hub 1-1:1.0: USB hub found
sr 1:0:0:0: Attached scsi generic sg1 type 5
hub 1-1:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 21 (level, low) -> IRQ 18
ehci_hcd 0000:00:10.3: EHCI Host Controller
ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:10.3: irq 18, io mem 0xd0015800
ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
usb 1-1: USB disconnect, address 2
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 256M @ 0xe0000000
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 19 (level, low) -> IRQ 19
ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006
input: SynPS/2 Synaptics TouchPad as /class/input/input2
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 1.
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
ipw2200: Detected geography ZZE (13 802.11bg channels, 19 802.11a channels)
IrDA: Registered device irda0
nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
ACPI: PCI Interrupt 0000:00:11.6[C] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.6 to 64
usb 4-1: new high speed USB device using ehci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 4 ports detected
Yenta: CardBus bridge found at 0000:00:07.0 [1025:0057]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:07.0, mfunc 0x007c1b22, devctl 0x44
Yenta: ISA IRQ mask 0x0a70, PCI irq 16
Socket status: 30000086
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.5 to 64
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ata1.00: ata_hpa_resize 1: sectors = 195371568, hpa_sectors = 195371568
ata1.00: ata_hpa_resize 1: sectors = 195371568, hpa_sectors = 195371568
ata1.00: configured for UDMA/33
ata1: EH complete
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Adding 1566328k swap on /dev/sda3.  Priority:-1 extents:1 across:1566328k
EXT3 FS on sda4, internal journal
loop: module loaded
fuse init (API version 7.8)
ACPI: CPU0 (power states: C1[C1] C2[C2])
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
powernow-k8: Found 1 Mobile AMD Athlon 64 Processor 3000+ processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0xe
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x17
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
usb-storage: device scan complete
scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0 ANSI: 2
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
ieee80211_crypt: registered algorithm 'TKIP'
ACPI: Battery Slot [BAT1] (battery present)
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
ACPI: Thermal Zone [THRM] (52 C)
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
PM: Writing back config space on device 0000:00:0b.0 at offset b (was 3ed173b, writing 571025)
PM: Writing back config space on device 0000:00:0b.0 at offset 3 (was 0, writing 4010)
PM: Writing back config space on device 0000:00:0b.0 at offset 2 (was 2000000, writing 2000003)
PM: Writing back config space on device 0000:00:0b.0 at offset 1 (was 2b00000, writing 2b00006)
PM: Writing back config space on device 0000:00:0b.0 at offset 0 (was 3ed173b, writing 169c14e4)
Clocksource tsc unstable (delta = -72354138 ns)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 21
[drm] Initialized radeon 1.27.0 20060524 on minor 0
agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
eth1: no IPv6 routers present


--------------000405020008080404020105
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge (rev 01)
	Subsystem: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge
	Flags: bus master, 66MHz, medium devsel, latency 8
	Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [80] AGP version 3.5
	Capabilities: [c0] HyperTransport: Slave or Primary Interface
	Capabilities: [68] Power Management version 2
	Capabilities: [58] HyperTransport: Interrupt Discovery and Configuration
00: 06 11 88 31 06 00 30 22 01 00 00 06 00 08 00 00
10: 08 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 88 31
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 South] (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: d8000000-dfffffff
	Capabilities: [80] Power Management version 2
00: 06 11 88 b1 07 00 30 02 00 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 20 20 20 02
20: 10 d0 10 d0 00 d8 f0 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 0c 00

00:07.0 CardBus bridge: Texas Instruments PCI4510 PC card Cardbus Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 168, IRQ 16
	Memory at 68000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 60000000-63fff000 (prefetchable)
	Memory window 1: 64000000-67fff000
	I/O window 0: 00001c00-00001cff
	I/O window 1: 00003000-000030ff
	16-bit legacy interface ports at 0001
00: 4c 10 44 ac 07 00 10 02 02 00 07 06 10 a8 82 00
10: 00 00 00 68 a0 00 00 02 00 02 05 b0 00 00 00 60
20: 00 f0 ff 63 00 00 00 64 00 f0 ff 67 00 1c 00 00
30: fc 1c 00 00 00 30 00 00 fc 30 00 00 ff 01 c0 05
40: 25 10 57 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.1 FireWire (IEEE 1394): Texas Instruments PCI4510 IEEE-1394 Controller (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64, IRQ 17
	Memory at d0015000 (32-bit, non-prefetchable) [size=2K]
	Memory at d0010000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
00: 4c 10 29 80 16 00 10 02 00 10 00 0c 10 40 80 00
10: 00 50 01 d0 00 00 01 d0 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 02 03 04

00:09.0 Network controller: Intel Corporation PRO/Wireless 2915ABG Network Connection (rev 05)
	Subsystem: Intel Corporation Unknown device 1001
	Flags: bus master, medium devsel, latency 64, IRQ 19
	Memory at d0014000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
00: 86 80 23 42 16 00 90 02 05 00 80 02 10 40 00 00
10: 00 40 01 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 01 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 03 18

00:0b.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 Gigabit Ethernet (rev 03)
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
00: e4 14 9c 16 06 00 b0 02 03 00 00 02 10 40 00 00
10: 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 07 00 00 00 25 10 57 00
30: 00 00 00 00 48 00 00 00 00 00 00 00 09 01 40 00

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64, IRQ 18
	I/O ports at 1800 [size=32]
	Capabilities: [80] Power Management version 2
00: 06 11 38 30 17 00 10 02 80 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 18 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 01 00 00

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64, IRQ 18
	I/O ports at 1820 [size=32]
	Capabilities: [80] Power Management version 2
00: 06 11 38 30 17 00 10 02 80 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 18 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 02 00 00

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64, IRQ 18
	I/O ports at 1840 [size=32]
	Capabilities: [80] Power Management version 2
00: 06 11 38 30 17 00 10 02 80 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 18 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 03 00 00

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64, IRQ 18
	Memory at d0015800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
00: 06 11 04 31 17 00 10 02 82 20 03 0c 10 40 00 00
10: 00 58 01 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 04 00 00

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00

00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, medium devsel, latency 64
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at 1860 [size=16]
	Capabilities: [c0] Power Management version 2
00: 06 11 71 05 05 00 90 02 06 8a 01 01 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 18 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 01 00 00

00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: medium devsel, IRQ 20
	I/O ports at 1000 [size=256]
	Capabilities: [c0] Power Management version 2
00: 06 11 59 30 01 00 10 02 50 00 01 04 00 00 00 00
10: 01 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0b 03 00 00

00:11.6 Communication controller: VIA Technologies, Inc. AC'97 Modem Controller (rev 80)
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: medium devsel, IRQ 20
	I/O ports at 1400 [size=256]
	Capabilities: [d0] Power Management version 2
00: 06 11 68 30 01 00 10 02 80 00 80 07 00 00 00 00
10: 01 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 d0 00 00 00 00 00 00 00 0b 03 00 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel
00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.0 VGA compatible controller: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] (prog-if 00 [VGA])
	Subsystem: Acer Incorporated [ALI] Unknown device 0057
	Flags: bus master, 66MHz, medium devsel, latency 66, IRQ 21
	Memory at d8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 2000 [size=256]
	Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 3.0
	Capabilities: [50] Power Management version 2
00: 02 10 50 4e 07 00 b0 02 00 00 00 03 10 42 00 00
10: 08 00 00 d8 01 20 00 00 00 00 10 d0 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 25 10 57 00
30: 00 00 00 00 58 00 00 00 00 00 00 00 05 01 08 00



--------------000405020008080404020105--
