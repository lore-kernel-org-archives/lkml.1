Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXD0Srq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXD0Srq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbXD0Srq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:47:46 -0400
Received: from host67-238-dynamic.19-87-r.retail.telecomitalia.it ([87.19.238.67]:59555
	"EHLO srv01.nuovanetmore.it" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757018AbXD0Srl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:47:41 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 14:47:39 EDT
Message-ID: <55875.172.20.1.1.1177699628.squirrel@srv01.nuovanetmore.it>
Date: Fri, 27 Apr 2007 20:47:08 +0200 (CEST)
Subject: Problem:  2.6.21 won't boot
From: "Riccardo Ricci" <rricci@nuovanetmore.it>
To: linux-kernel@vger.kernel.org
Cc: torvalds@woody.linux-foundation.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 1 (Highest)
Importance: High
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to everyone,
i've compiled kernel 2.6.21 on my debian PIII 650 / 256MB / Dell Latitude
J650GT. With 2.6.20.8 all works very good, with 2.6.21 don't boot... While
booting it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9
10 11 12 14 15).

With 2.6.20.8 here is output of dmesg:

Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387f9ff 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium III (Coppermine) stepping 03
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 0820)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfc0ae, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
0000:00:07.1: cannot adjust BAR0 (not I/O)
0000:00:07.1: cannot adjust BAR1 (not I/O)
0000:00:07.1: cannot adjust BAR2 (not I/O)
0000:00:07.1: cannot adjust BAR3 (not I/O)
PCI quirk: region 0800-083f claimed by PIIX4 ACPI
PCI quirk: region 0840-084f claimed by PIIX4 SMB
PIIX4 devres B PIO at 00e0-00e7
PIIX4 devres C PIO at 0850-085f
PIIX4 devres G PIO at 0280-0287
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15) ACPI:
PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15) ACPI: PCI
Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15) ACPI:
PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: Power Resource [PADA] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
irda_init()
NET: Registered protocol family 23
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:02: ioport range 0x800-0x805 could not be reserved
pnp: 00:02: ioport range 0x808-0x80f could not be reserved
pnp: 00:03: ioport range 0x806-0x807 has been reserved
pnp: 00:03: ioport range 0x850-0x853 has been reserved
pnp: 00:03: ioport range 0x856-0x85f has been reserved
pnp: 00:03: ioport range 0x810-0x83f has been reserved
pnp: 00:03: ioport range 0x840-0x84f has been reserved
pnp: 00:03: ioport range 0x600-0x67f has been reserved
pnp: 00:03: ioport range 0x680-0x6ff has been reserved
pnp: 00:04: ioport range 0xf000-0xf0fe has been reserved
pnp: 00:04: ioport range 0xf100-0xf1fe has been reserved
pnp: 00:04: ioport range 0xf200-0xf2fe has been reserved
pnp: 00:04: ioport range 0xf400-0xf4fe has been reserved
pnp: 00:04: ioport range 0xf500-0xf5fe has been reserved
pnp: 00:04: ioport range 0xf600-0xf6fe has been reserved
pnp: 00:04: ioport range 0xf800-0xf8fe has been reserved
pnp: 00:04: ioport range 0xf900-0xf9fe has been reserved
pnp: 00:09: ioport range 0x3f0-0x3f1 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: fc000000-feffffff
  PREFETCH window: 30000000-300fffff
PCI: Bus 2, cardbus bridge: 0000:00:03.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:03.1
  IO window: 00001800-000018ff
  IO window: 00001c00-00001cff
  PREFETCH window: 28000000-2bffffff
  MEM window: 2c000000-2fffffff
PCI: Enabling device 0000:00:03.0 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKD] -> GSI 11 (level, low)
-> IRQ 11
PCI: Enabling device 0000:00:03.1 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKD] -> GSI 11 (level, low)
-> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 8192 bind 4096)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers); looks
like an initrd
Freeing initrd memory: 3836k freed
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk> apm:
BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, security attributes, realtime, large block numbers, no
debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery absent)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Thermal Zone [THM] (35 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
i8k: unable to get SMM BIOS version
Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf4000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 1
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
NET3 PLIP version 2.4-parport gniibe@mri.co.jp
plip0: Parallel port at 0x378, using IRQ 7.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit
encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California. SLIP
linefill/keepalive option.
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin
<proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin
<proski@gnu.org>, et al)
found SMC SuperIO Chip (devid=0x09 rev=08 base=0x03f0): FDC37N958FR
smsc_ircc_present: can't get sir_base of 0x2f8
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio ide1:
BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: IBM-DJSA-220, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SAMSUNG CD-ROM SN-124, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 39070080 sectors (20003 MB) w/1874KiB Cache, CHS=38760/16/63,
UDMA(33) hda: cache flushes not supported
 hda: hda1 hda2 < hda5 hda6 >
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Yenta: CardBus bridge found at 0000:00:03.0 [1028:00bb]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:03.0, mfunc 0x01261222, devctl 0x66
Yenta: ISA IRQ mask 0x0438, PCI irq 11
Socket status: 30000020
Yenta: CardBus bridge found at 0000:00:03.1 [1028:00bb]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:03.1, mfunc 0x01261222, devctl 0x66
Yenta: ISA IRQ mask 0x0438, PCI irq 11
Socket status: 30000006
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
(PCI) USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low)
-> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000dce0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbmouse
drivers/usb/input/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for GSM
modem (1-port)
usbcore: registered new interface driver option
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7.1
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
pccard: CardBus card inserted into slot 0
xircom_tulip_cb.c derived from tulip.c:v0.91 4/14/99 becker@scyld.com
 unofficial 2.4.x kernel port, version 0.92, June 27, 2006
PCI: Enabling device 0000:02:00.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKD] -> GSI 11 (level, low)
-> IRQ 11
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: Xircom Cardbus Adapter rev 3 at 0x1000, 00:10:A4:0C:7B:A1, IRQ 11.
eth0:  MII transceiver #0 config 3100 status 7809 advertising 01e1. PCI:
Enabling device 0000:02:00.1 (0000 -> 0003)
ACPI: PCI Interrupt 0000:02:00.1[A] -> Link [LNKD] -> GSI 11 (level, low)
-> IRQ 11
0000:02:00.1: ttyS2 at I/O 0x1080 (irq = 11) is a 16550A
input: DualPoint Stick as /class/input/input2
input: AlpsPS/2 ALPS DualPoint TouchPad as /class/input/input3
i2c /dev entries driver
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09
09:56:17 2007 UTC).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKB] -> GSI 5 (level, low)
-> IRQ 5
ALSA device list:
  #0: ESS Maestro3 PCI at 0xd800, irq 5
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
IrCOMM protocol (Dag Brattli)
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
Using IPI Shortcut mode
ACPI: (supports S0 S1 S3 S4 S5)
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 3836KiB [1 disk] into ram disk... <6>Time: tsc
clocksource has been installed.
<6>Time: acpi_pm clocksource has been installed.
done.
VFS: Mounted root (cramfs filesystem) readonly.
Freeing unused kernel memory: 252k freed
ReiserFS: hda6: warning: sh-2021: reiserfs_fill_super: can not find
reiserfs on hda6
VFS: Can't find ext3 filesystem on dev hda6.
VFS: Can't find an ext2 filesystem on dev hda6.
FAT: bogus number of FAT structure
VFS: Can't find a valid FAT filesystem on dev hda6.
FAT: bogus number of FAT structure
VFS: Can't find a valid FAT filesystem on dev hda6.
Unable to identify CD-ROM format.
VFS: Can't find a romfs filesystem on dev hda6.
UDF-fs: No VRS found
Filesystem "hda6": Disabling barriers, not supported by the underlying
device XFS mounting filesystem hda6
Ending clean XFS mount for filesystem: hda6
cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x280-0x287
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x200-0x207 0x280-0x287
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0xa00-0xaff: clean.
Adding 979924k swap on /dev/hda5.  Priority:-1 extents:1 across:979924k
Filesystem "hda6": Disabling barriers, not supported by the underlying
device device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.comfuse init (API version 7.8)
pcmcia: Detected deprecated PCMCIA ioctl usage from process: discover.
pcmcia: This interface will soon be removed from the kernel; please expect
breakage unless you upgrade to new tools.
pcmcia: see
http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
cs: warning: no high memory space available!
NET: Registered protocol family 15
sirdev_get_instance - ttyS1
irtty_open - ttyS1: irda line discipline opened
irlap_change_speed(), setting speed to 9600
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: Link is up, running at 100Mbit half-duplex
eth0: no IPv6 routers present

----------------------------------------------------

lspci -vvv

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host
bridge (rev 03)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 32
        Region 0: Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW-
Rate=<none>

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP
bridge (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fc000000-feffffff
        Prefetchable memory behind bridge: 30000000-300fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+

00:03.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Dell Unknown device 00bb
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 30100000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 20000000-23fff000 (prefetchable)
        Memory window 1: 24000000-27fff000
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
        16-bit legacy interface ports at 0001

00:03.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Dell Unknown device 00bb
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 30101000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
        Memory window 0: 28000000-2bfff000 (prefetchable)
        Memory window 1: 2c000000-2ffff000
        I/O window 0: 00001800-000018ff
        I/O window 1: 00001c00-00001cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
(prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
        Region 4: I/O ports at 0860 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
(prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at dce0 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 9

00:08.0 Multimedia audio controller: ESS Technology ES1983S Maestro-3i PCI
Audio Accelerator (rev 10)
        Subsystem: Dell Unknown device 00bb
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at d800 [size=256]
        Region 1: Memory at faffe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility P/M
AGP 2x (rev 64) (prog-if 00 [VGA])
        Subsystem: Dell Latitude CPx
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at ec00 [size=256]
        Region 2: Memory at fcfff000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 30000000 [disabled] [size=128K]
        Capabilities: [50] AGP version 1.0
                Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW-
Rate=<none>
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Ethernet controller: Xircom Cardbus Ethernet 10/100 (rev 03)
        Subsystem: Xircom Cardbus Ethernet 10/100
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (5000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 1000 [size=128]
        Region 1: Memory at 24000000 (32-bit, non-prefetchable) [size=2K]
        Region 2: Memory at 24000800 (32-bit, non-prefetchable) [size=2K]
        [virtual] Expansion ROM at 20000000 [disabled] [size=16K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

02:00.1 Serial controller: Xircom Cardbus Ethernet + 56k Modem (rev 03)
(prog-if 02 [16550])
        Subsystem: Xircom CBEM56G-100 Ethernet + 56k Modem
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 1080 [size=8]
        Region 1: Memory at 24001000 (32-bit, non-prefetchable) [size=2K]
        Region 2: Memory at 24001800 (32-bit, non-prefetchable) [size=2K]
        [virtual] Expansion ROM at 20004000 [disabled] [size=16K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

----------------------------------------------------------------

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 3
cpu MHz         : 647.242
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
pat pse36 mmx fxsr sse
bogomips        : 1295.46
clflush size    : 32

------------------------------------------------------------------

cat /proc/modules
af_key 34416 2 - Live 0xd09d2000
fuse 46548 1 - Live 0xd0996000
dm_snapshot 17856 0 - Live 0xd0927000
dm_mirror 22164 0 - Live 0xd0920000
dm_mod 58604 2 dm_snapshot,dm_mirror, Live 0xd0910000
joydev 9824 0 - Live 0xd0865000
tsdev 7712 0 - Live 0xd085d000
evdev 10016 1 - Live 0xd083b000

-----------------------------------------------------------------------

cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0022-0022 : ACPI PM2_CNT_BLK
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:07.1
  0170-0177 : ide1
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:07.1
  0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f0-03f1 : pnp 00:09
03f2-03f5 : floppy
03f6-03f6 : 0000:00:07.1
  03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0600-067f : pnp 00:03
0680-06ff : pnp 00:03
0778-077a : parport0
0800-083f : 0000:00:07.3
  0800-0803 : ACPI PM1a_EVT_BLK
  0806-0807 : pnp 00:03
  0808-080b : ACPI PM_TMR
  080c-080f : ACPI GPE0_BLK
  0810-083f : pnp 00:03
    0810-0815 : ACPI CPU throttle
0840-084f : 0000:00:07.3
  0840-084f : pnp 00:03
    0840-0847 : piix4_smbus
0850-0853 : pnp 00:03
0854-0855 : ACPI PM1a_CNT_BLK
0856-085f : pnp 00:03
0860-086f : 0000:00:07.1
  0860-0867 : ide0
  0868-086f : ide1
0cf8-0cff : PCI conf1
1000-10ff : PCI CardBus #02
  1000-107f : 0000:02:00.0
    1000-107f : eth0
  1080-1087 : 0000:02:00.1
    1080-1087 : serial
1400-14ff : PCI CardBus #02
1800-18ff : PCI CardBus #06
1c00-1cff : PCI CardBus #06
d800-d8ff : 0000:00:08.0
  d800-d8ff : Maestro3
dce0-dcff : 0000:00:07.2
  dce0-dcff : uhci_hcd
e000-efff : PCI Bus #01
  ec00-ecff : 0000:01:00.0
f000-f0fe : motherboard
  f000-f0fe : pnp 00:04
f100-f1fe : motherboard
  f100-f1fe : pnp 00:04
f200-f2fe : motherboard
  f200-f2fe : pnp 00:04
f400-f4fe : motherboard
  f400-f4fe : pnp 00:04
f500-f5fe : motherboard
  f500-f5fe : pnp 00:04
f600-f6fe : motherboard
  f600-f6fe : pnp 00:04
f800-f8fe : motherboard
  f800-f8fe : pnp 00:04
f900-f9fe : motherboard
  f900-f9fe : pnp 00:04
fa00-fafe : motherboard
fc00-fcfe : motherboard
fd00-fdfe : motherboard
fe00-fefe : motherboard

--------------------------------------------------------------------

cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cffff : Video ROM
000f0000-000fffff : System ROM
00100000-0ffdafff : System RAM
  00100000-0057adc0 : Kernel code
  0057adc1-006c628f : Kernel data
0ffdb000-0fffffff : reserved
100a0000-100fffff : reserved
20000000-23ffffff : PCI CardBus #02
  20000000-20003fff : 0000:02:00.0
  20004000-20007fff : 0000:02:00.1
24000000-27ffffff : PCI CardBus #02
  24000000-240007ff : 0000:02:00.0
    24000000-240007ff : eth0
  24000800-24000fff : 0000:02:00.0
    24000800-24000fff : eth0
  24001000-240017ff : 0000:02:00.1
  24001800-24001fff : 0000:02:00.1
28000000-2bffffff : PCI CardBus #06
2c000000-2fffffff : PCI CardBus #06
30000000-300fffff : PCI Bus #01
  30000000-3001ffff : 0000:01:00.0
30100000-30100fff : 0000:00:03.0
  30100000-30100fff : yenta_socket
30101000-30101fff : 0000:00:03.1
  30101000-30101fff : yenta_socket
f4000000-f7ffffff : 0000:00:00.0
faffe000-faffffff : 0000:00:08.0
  faffe000-faffffff : Maestro3
fc000000-feffffff : PCI Bus #01
  fcfff000-fcffffff : 0000:01:00.0
  fd000000-fdffffff : 0000:01:00.0
ffe00000-ffffffff : reserved

-- 
Riccardo Ricci

