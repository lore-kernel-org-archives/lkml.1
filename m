Return-Path: <linux-kernel-owner+w=401wt.eu-S935577AbXGQTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935577AbXGQTCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935106AbXGQTBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:01:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19612 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbXGQTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=uAvR0Jh+IwK2vKNhQCaRNvMoPIosHwDICFvsIo+DZqE0Yfmk2REvHCPCTpa7Njyq1UYrsNpqgZPkS4VCL1WMprwv+5JqptkFBAmVhB6Z1NJ7dcN0kLhWADNMLZUIUjSgQ0cS7E8DjzxVB8pvkU5o3YQvggBeIsG1APutOMPJYZQ=
From: Christoph Pfister <christophpfister@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Date: Tue, 17 Jul 2007 21:01:06 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200707132249.26106.christophpfister@gmail.com> <200707132304.30795.christophpfister@gmail.com> <d120d5000707160749r1084ab4ex8d2c4e89e6134d41@mail.gmail.com>
In-Reply-To: <d120d5000707160749r1084ab4ex8d2c4e89e6134d41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yHRnGSFvMJ3JgE+"
Message-Id: <200707172101.06878.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yHRnGSFvMJ3JgE+
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Dmitry,

Am Montag, 16. Juli 2007 16:49 schrieb Dmitry Torokhov:
> Hi Christoph,
>
> On 7/13/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> > Am Freitag, 13. Juli 2007 22:49 schrieb Christoph Pfister:
> > > Hi,
> > >
> > > After a kernel update I recognised that my keyboard sometimes didn't
> > > work after booting up. I found out that the issue appeared quite
> > > reliably after a cold reboot and not pressing any key (for example not
> > > selecting stuff at the bootloader) till the machine fully booted up.
> > > Because git head (4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4) didn't
> > > solve the problem I did a bisect and your commit was found to be the
> > > culprit (the second last build succeeded 5 of 5 times during my tests
> > > and the last build failed 2 of 3 times).
> > >
> > > Can anybody please shade light on this?
> > >
> > > Thanks,
> > >
> > > Christoph
> >
> > Forgot to mention dmesg: "input: AT Translated Set 2 keyboard
> > as /class/input/input0" is shown in both (working / failing) cases (no
> > additional / related lines nearby).
>
> Could you please boot with "i8042.debug log_buf_len=131072" and send
> me full dmesg?

Yep, attached (cold reboot, not pressing any keys, 2.6.21).

> Thanks!

Thanks for taking care of it =)

Christoph

--Boundary-00=_yHRnGSFvMJ3JgE+
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.21-2-686 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Wed Jul 11 03:53:02 UTC 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 000000001fff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fff0000 size: 0000000000003000 end: 000000001fff3000 type: 4
copy_e820_map() start: 000000001fff3000 size: 000000000000d000 end: 0000000020000000 type: 3
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F7470, 0014 (r0 AV18  )
ACPI: RSDT 1FFF3000, 0028 (r1 AV18   AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1FFF3040, 0074 (r1 AV18   AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1FFF30C0, 24A4 (r1 AV18   AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 1FFF0000, 0040
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Built 1 zonelists.  Total pages: 130033
Kernel command line: root=/dev/hda1 vga=791 i8042.debug log_buf_len=131072
log_buf_len: 131072
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0142a000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 997.502 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 514760k/524224k available (1661k kernel code, 8852k reserved, 636k data, 212k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc0345000 - 0xc037a000   ( 212 kB)
      .data : 0xc029f5e5 - 0xc033e834   ( 636 kB)
      .text : 0xc0100000 - 0xc029f5e5   (1661 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1997.19 BogoMIPS (lpj=3994386)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 1e20)
CPU0: Intel Pentium III (Coppermine) stepping 06
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb450, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: e8000000-e9ffffff
  PREFETCH window: e4000000-e7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1305k freed
audit: initializing netlink socket (disabled)
audit(1184697868.240:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Disabling Via external APIC routing
vesafb: framebuffer at 0xe4000000, mapped to 0xe0880000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: protected mode interface info at c000:4d22
vesafb: pmi: set display start = c00c4d90, set palette = c00c4dca
vesafb: pmi: ports = 9010 9016 9054 9038 903c 905c 9000 9004 90b0 90b2 90b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 67 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 76 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 5a <- i8042 (return) [1]
drivers/input/serio/i8042.c: a7 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 76 <- i8042 (return) [1]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: f0 <- i8042 (return) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 56 <- i8042 (return) [1]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: a4 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [1]
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [2]
Freeing unused kernel memory: 212k freed
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [2]
drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [3]
drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [3]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [3]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [3]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [4]
drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [4]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [5]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [5]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6]
drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [6]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6]
input: AT Translated Set 2 keyboard as /class/input/input0
drivers/input/serio/i8042.c: d4 -> i8042 (command) [7]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [7]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12, timeout) [10]
drivers/input/serio/i8042.c: d4 -> i8042 (command) [12]
drivers/input/serio/i8042.c: ed -> i8042 (parameter) [12]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12, timeout) [17]
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xa000-0xa007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xa008-0xa00f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: HDS722512VLAT20, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: LITE-ON DVDRW SOHW-1693S, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.20 loaded.
hda: max request size: 512KiB
hda: 241254720 sectors (123522 MB) w/1794KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2
ReiserFS: hda1: found reiserfs format "3.6" with standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda1: checking transaction log (hda1)
ReiserFS: hda1: Using r5 hash to sort names
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 5, io base 0x0000a400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 5, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
Linux agpgart interface v0.102 (c) Dave Jones
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
uhci_hcd 0000:00:0c.0: UHCI Host Controller
uhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:0c.0: irq 5, io base 0x0000c000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
parport_pc: VIA parallel port: io=0x378, irq=7
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.1[B] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:0c.1: UHCI Host Controller
uhci_hcd 0000:00:0c.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:0c.1: irq 11, io base 0x0000c400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new low speed USB device using uhci_hcd and address 2
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new full speed USB device using uhci_hcd and address 3
drivers/input/serio/i8042.c: Interrupt 12, without any data [2017]
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.2[C] -> Link [LNKB] -> GSI 12 (level, low) -> IRQ 12
ehci_hcd 0000:00:0c.2: EHCI Host Controller
ehci_hcd 0000:00:0c.2: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:0c.2: irq 12, io mem 0xeb010000
ehci_hcd 0000:00:0c.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 4 ports detected
input: PC Speaker as /class/input/input1
usb 1-2: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:07.5 to 64
drivers/input/serio/i8042.c: d4 -> i8042 (command) [2196]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [2196]
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001bc00.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
usbcore: registered new interface driver hiddev
input: Logitech USB Trackball as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB Trackball] on usb-0000:00:07.2-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver cxacru
cxacru 1-2:1.0: found firmware cxacru-fw.bin
Adding 996020k swap on /dev/hda2.  Priority:-1 extents:1 across:996020k
ATM dev 0: ADSL line: attempting to activate
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
Time: acpi_pm clocksource has been installed.
ATM dev 0: ADSL line: channel analysis
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
ATM dev 0: ADSL line: up (768 kb/s down | 128 kb/s up)
drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [11293]
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered

--Boundary-00=_yHRnGSFvMJ3JgE+--
