Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbXGPAU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbXGPAU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXGPAUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:20:50 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:55084 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756054AbXGPAUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:20:49 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=ZzyNellEqSlMMgJVG5Fh4B7GcdhBuuEy055EhSZjccEbqk+yeFWbggn3WYmyCEb4JGtdXdvaQw8syMZEDmsIWg==  ;
Date: Mon, 16 Jul 2007 09:19:28 +0900 (JST)
Message-Id: <20070716.091928.111205836.takada@mbf.nifty.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: i386: pata_cs5520 does not work
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <20070715183924.0a6c992b@the-village.bc.nu>
References: <20070716.014115.193701589.takada@mbf.nifty.com>
	<20070715183924.0a6c992b@the-village.bc.nu>
X-Mailer: Mew version 5.1 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Jul_16_09_19_28_2007_000)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Mon_Jul_16_09_19_28_2007_000)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: i386: pata_cs5520 does not work
Date: Sun, 15 Jul 2007 18:39:24 +0100

> On Mon, 16 Jul 2007 01:41:15 +0900 (JST)
> TAKADA Yoshihito <takada@mbf.nifty.com> wrote:
> 
> > Hi.
> > I update to 2.6.22.1 from 2.6.21.5. And PC cannot mount /.
> > It seems pata_cs5520 does not find IDE controller.
> > (I don't have serial cable for CS5520 board now. I cannt read
> > boot messages.)
> > 2.6.21 is OK.
> > In 2.6.22, IDE driver is OK.
> > Is any information necessary?
> 
> I'll take a look at this next week. Can you send me a dmesg of the
> working case and an lspci -vvxxx

Thanks. attached 2 dmesgs(2.6.21 with pata_cs5520, 2.6.22 with IDE) and output of lspci.



----Next_Part(Mon_Jul_16_09_19_28_2007_000)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dmesg-2.6.21"

Linux version 2.6.21.5-ss2 (bee@mpc101) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #2 PREEMPT Wed Jun 27 11:01:48 JST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 0000000005c80000 end: 0000000005d80000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000005d80000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
93MB LOWMEM available.
Entering add_active_range(0, 0, 23936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    23936
early_node_map[1] active PFN ranges
    0:        0 ->    23936
On node 0 totalpages: 23936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 155 pages used for memmap
  Normal zone: 19685 pages, LIFO batch:3
DMI not present or invalid.
Allocating PCI resources starting at 10000000 (gap: 05d80000:fa270000)
Built 1 zonelists.  Total pages: 23749
Kernel command line: ro root=/dev/sda2 5
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 199.746 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 90184k/95744k available (1866k kernel code, 5104k reserved, 743k data, 140k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffd000 - 0xfffff000   (   8 kB)
    vmalloc : 0xc6800000 - 0xffffb000   ( 919 MB)
    lowmem  : 0xc0000000 - 0xc5d80000   (  93 MB)
      .init : 0xc0390000 - 0xc03b3000   ( 140 kB)
      .data : 0xc02d2afd - 0xc038c934   ( 743 kB)
      .text : 0xc0100000 - 0xc02d2afd   (1866 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 403.39 BogoMIPS (lpj=672636)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 00808131 01818131 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 00808131 01818131 00000000 00000000 00000000 00000000 00000000
Working around Cyrix MediaGX virtual DMA bugs.
Enable Memory-Write-back mode on Cyrix/NSC processor.
Enable Memory access reorder on Cyrix/NSC processor.
Enable Incrementor on Cyrix/NSC processor.
CPU: After all inits, caps: 00808131 00818131 00000000 00000001 00000000 00000000 00000000
CPU: Cyrix MediaGXtm MMXtm Enhanced stepping 02
Checking 'hlt' instruction... OK.
Device driver platform lacks bus and class support for being resumed.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb9a0, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
USB driver usbfs lacks resume support.
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Device driver pci0000:00 lacks bus and class support for being resumed.
PCI: Using IRQ router default [1078/0001] at 0000:00:00.0
Time: tsc clocksource has been installed.
PCI: Bus 1, cardbus bridge: 0000:00:01.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 10000000-13ffffff
  MEM window: 14000000-17ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
checking if image is initramfs... it is
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1184538063.539:1): initialized
io scheduler noop registered
io scheduler deadline registered (default)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Clocksource tsc unstable (delta = -137554893 ns)
Time: pit clocksource has been installed.
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
Device driver isa lacks bus and class support for being resumed.
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Device driver lo lacks bus and class support for being resumed.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
ata1: PATA max PIO4 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00015000 irq 14
scsi0 : pata_cs5520
Device driver host0 lacks bus and class support for being resumed.
ata1.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max UDMA/100
ata1.00: 58605120 sectors, multi 16: LBA 
ata1.00: configured for PIO4
Device driver target0:0:0 lacks bus and class support for being resumed.
scsi 0:0:0:0: Direct-Access     ATA      IC25N030ATCS04-0 CA3O PQ: 0 ANSI: 5
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
Yenta: CardBus bridge found at 0000:00:01.0 [0000:0000]
Yenta: ISA IRQ mask 0x0eb8, PCI irq 15
Socket status: 30000820
Device driver pcmcia_socket0 lacks bus and class support for being resumed.
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 15, io mem 0xe0000000
Device driver usbdev1.1_ep00 lacks bus and class support for being resumed.
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Device driver usbdev1.1_ep81 lacks bus and class support for being resumed.
Initializing USB Mass Storage driver...
usb 1-1: new full speed USB device using ohci_hcd and address 2
Device driver usbdev1.2_ep00 lacks bus and class support for being resumed.
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
pccard: CardBus card inserted into slot 0
Device driver usbdev1.2_ep81 lacks bus and class support for being resumed.
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
USB driver hiddev lacks resume support.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Suspend v2.2.10
Suspend2 Userspace Storage Manager support registered.
Suspend2 Basic User Interface support registered.
Suspend2 Compressor support registered.
Suspend2 Block I/O support registered.
Suspend2 Swap Allocator support registered.
No storage allocator is currently active. Rechecking whether we can use one.
Suspend2: SwapAllocator: Signature found.
Suspend2: Resuming enabled.
Suspend2: Normal swapspace found.
Synaptics Touchpad, model: 1, fw: 4.6, id: 0xb5aa1, caps: 0x804710/0x0
input: SynPS/2 Synaptics TouchPad as /class/input/input1
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
8139too Fast Ethernet driver 0.9.28
PCI: Enabling device 0000:01:00.0 (0000 -> 0003)
PCI: Setting latency timer of device 0000:01:00.0 to 64
Device driver eth0 lacks bus and class support for being resumed.
eth0: RealTek RTL8139 at 0x1000, 00:90:99:48:a0:30, IRQ 15
eth0:  Identified 8139 chip type 'RTL-8139C'
cs: IO port probe 0x100-0x3af: excluding 0x1f0-0x1f7 0x378-0x37f 0x398-0x39f
cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3ff 0x480-0x48f 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
sd 0:0:0:0: Attached scsi generic sg0 type 0
Adding 265032k swap on /dev/sda1.  Priority:-1 extents:1 across:265032k

----Next_Part(Mon_Jul_16_09_19_28_2007_000)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dmesg-2.6.22"

Linux version 2.6.22.1-ss2 (bee@celeron) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-13)) #7 PREEMPT Mon Jul 16 01:29:15 JST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000005d80000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
93MB LOWMEM available.
Entering add_active_range(0, 0, 23936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    23936
early_node_map[1] active PFN ranges
    0:        0 ->    23936
On node 0 totalpages: 23936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 155 pages used for memmap
  Normal zone: 19685 pages, LIFO batch:3
DMI not present or invalid.
Allocating PCI resources starting at 10000000 (gap: 05d80000:fa270000)
Built 1 zonelists.  Total pages: 23749
Kernel command line: ro root=/dev/hda2 resume2=swap:/dev/hda1 5
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 199.745 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 89932k/95744k available (2033k kernel code, 5360k reserved, 804k data, 144k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffd000 - 0xfffff000   (   8 kB)
    vmalloc : 0xc6800000 - 0xffffb000   ( 919 MB)
    lowmem  : 0xc0000000 - 0xc5d80000   (  93 MB)
      .init : 0xc03c8000 - 0xc03ec000   ( 144 kB)
      .data : 0xc02fc7bd - 0xc03c5ba4   ( 804 kB)
      .text : 0xc0100000 - 0xc02fc7bd   (2033 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 401.39 BogoMIPS (lpj=2006979)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 00808131 01818131 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 00808131 01818131 00000000 00000000 00000000 00000000 00000000
Working around Cyrix MediaGX virtual DMA bugs.
Enable Memory-Write-back mode on Cyrix/NSC processor.
Enable Memory access reorder on Cyrix/NSC processor.
Enable Incrementor on Cyrix/NSC processor.
CPU: After all inits, caps: 00808131 00818131 00000000 00000001 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Cyrix MediaGXtm MMXtm Enhanced stepping 02
Checking 'hlt' instruction... OK.
Device driver platform lacks bus and class support for being resumed.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb9a0, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
USB driver usbfs lacks resume support.
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Device driver pci0000:00 lacks bus and class support for being resumed.
PCI: Using IRQ router default [1078/0001] at 0000:00:00.0
Time: tsc clocksource has been installed.
PCI: Bus 1, cardbus bridge: 0000:00:01.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 10000000-13ffffff
  MEM window: 14000000-17ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
checking if image is initramfs... it is
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1184537602.310:1): initialized
io scheduler noop registered
io scheduler deadline registered (default)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250.0: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
Device driver isa lacks bus and class support for being resumed.
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
Device driver lo lacks bus and class support for being resumed.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Cyrix 5520: IDE controller at PCI slot 0000:00:12.0
    ide0: BM-DMA at 0x5000-0x5007, BIOS settings: hda:pio, hdb:DMA
    ide1: BM-DMA at 0x5008-0x500f, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
hda: IC25N030ATCS04-0, ATA DISK drive
Device driver ide0 lacks bus and class support for being resumed.
Clocksource tsc unstable (delta = -110575101 ns)
Time: pit clocksource has been installed.
PIO clocking = 4
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
PCI driver Cyrix_IDE lacks driver specific resume support.
PCI driver PCI_IDE lacks driver specific resume support.
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 58605120 sectors (30005 MB) w/1768KiB Cache, CHS=58140/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3
Yenta: CardBus bridge found at 0000:00:01.0 [0000:0000]
Yenta: ISA IRQ mask 0x0eb8, PCI irq 15
Socket status: 30000820
Device driver pcmcia_socket0 lacks bus and class support for being resumed.
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 15, io mem 0xe0000000
Device driver usbdev1.1_ep00 lacks bus and class support for being resumed.
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Device driver usbdev1.1_ep81 lacks bus and class support for being resumed.
Initializing USB Mass Storage driver...
usb 1-1: new full speed USB device using ohci_hcd and address 2
Device driver usbdev1.2_ep00 lacks bus and class support for being resumed.
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
pccard: CardBus card inserted into slot 0
Device driver usbdev1.2_ep81 lacks bus and class support for being resumed.
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
USB driver hiddev lacks resume support.
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Suspend v2.2.10
Suspend2 Userspace Storage Manager support registered.
Suspend2 Basic User Interface support registered.
Suspend2 Compressor support registered.
Suspend2 Block I/O support registered.
Suspend2 Swap Allocator support registered.
No storage allocator is currently active. Rechecking whether we can use one.
Suspend2: SwapAllocator: Signature found.
Suspend2: Resuming enabled.
Suspend2: Normal swapspace found.
Synaptics Touchpad, model: 1, fw: 4.6, id: 0xb5aa1, caps: 0x804710/0x0
input: SynPS/2 Synaptics TouchPad as /class/input/input1
ReiserFS: hda2: found reiserfs format "3.6" with standard journal
ReiserFS: hda2: using ordered data mode
ReiserFS: hda2: journal params: device hda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda2: checking transaction log (hda2)
ReiserFS: hda2: Using r5 hash to sort names
8139too Fast Ethernet driver 0.9.28
PCI: Enabling device 0000:01:00.0 (0000 -> 0003)
PCI: Setting latency timer of device 0000:01:00.0 to 64
Device driver eth0 lacks bus and class support for being resumed.
eth0: RealTek RTL8139 at 0x1000, 00:90:99:48:a0:30, IRQ 15
eth0:  Identified 8139 chip type 'RTL-8139C'
cs: IO port probe 0x100-0x3af: excluding 0x378-0x37f 0x398-0x39f
cs: IO port probe 0x3e0-0x4ff: excluding 0x480-0x48f 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
Adding 265032k swap on /dev/hda1.  Priority:-1 extents:1 across:265032k
PIO clocking = 4

----Next_Part(Mon_Jul_16_09_19_28_2007_000)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=lspci-vvxxx

00:00.0 Host bridge: Cyrix Corporation PCI Master
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
00: 78 10 01 00 07 00 80 02 00 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 CardBus bridge: Ricoh Co Ltd RL5c475
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at 18000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=01, subordinate=04, sec-latency=176
	Memory window 0: 10000000-13fff000 (prefetchable)
	Memory window 1: 14000000-17fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
00: 80 11 75 04 07 00 10 02 00 00 07 06 00 a8 02 00
10: 00 00 00 18 dc 00 00 02 00 01 04 b0 00 00 00 10
20: 00 f0 ff 13 00 00 00 14 00 f0 ff 17 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 0f 01 00 05
40: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:12.0 ISA bridge: Cyrix Corporation 5520 [Cognac]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 0: I/O ports at 3000 [size=128]
	Region 1: I/O ports at 4000 [size=32]
	Region 2: I/O ports at 5000 [size=16]
	Region 3: Memory at 40010000 (32-bit, non-prefetchable) [size=4K]
00: 78 10 02 00 0f 00 80 02 00 00 01 06 00 40 00 00
10: 01 30 00 00 01 40 00 00 01 50 00 00 00 00 01 40
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 USB Controller: Compaq Computer Corporation ZFMicro Chipset USB (rev 04) (prog-if 10 [OHCI])
	Subsystem: Compaq Computer Corporation ZFMicro Chipset USB
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=4K]
00: 11 0e f8 a0 07 00 80 02 04 10 03 0c 08 40 00 00
10: 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 11 0e f8 a0
30: 00 00 00 00 00 00 00 00 00 00 00 00 0f 01 00 50

01:00.0 Ethernet controller: Allied Telesyn International RTL81xx Fast Ethernet (rev 10)
	Subsystem: Allied Telesyn International RTL81xx Fast Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at 1000 [size=256]
	Region 1: Memory at 14000000 (32-bit, non-prefetchable) [size=512]
	Capabilities: <access denied>
00: 59 12 17 a1 07 00 90 02 10 00 00 02 00 40 00 00
10: 01 10 00 00 00 00 00 14 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 02 01 00 00 59 12 17 a1
30: 00 00 00 00 50 00 00 00 00 00 00 00 0f 01 20 40


----Next_Part(Mon_Jul_16_09_19_28_2007_000)----
