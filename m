Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXDZIrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXDZIrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXDZIrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:47:47 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21270 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbXDZIro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:47:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: pcmcia - failed to initialize IDE interface
Date: Thu, 26 Apr 2007 10:48:09 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A4012D6148@stgw002a.ww002.siemens.net>
In-Reply-To: <20070425190753.fb8c272d.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: pcmcia - failed to initialize IDE interface
Thread-Index: AceHqEmPYMhqH9+RSm+Ie3xgpMcxxgANhycQ
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: "lkml" <linux-kernel@vger.kernel.org>
Cc: <linux-mips@linux-mips.org>
X-OriginalArrivalTime: 26 Apr 2007 08:47:27.0451 (UTC) FILETIME=[848B0AB0:01C787DF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# cat /proc/ioports
00102000-00102007 : ide0
0010200e-0010200e : ide0
500000300-5000fffff : PCI IO space

# cat /proc/iomem
10500000-1050ffff : Au1x00 ENET
10520000-10520003 : Au1x00 ENET
11100000-111fffff : serial
11200000-112fffff : serial
14020000-1407ffff : au1xxx-ohci.0
440000000-44fffffff : PCI memory space
  440000000-447ffffff : 0000:00:0c.0
  448000000-448ffffff : 0000:00:0c.0
  449000000-449000fff : 0000:00:0a.0
    449000000-449000fff : ohci_hcd
  449001000-449001fff : 0000:00:0a.1
    449001000-449001fff : ohci_hcd
  449002000-4490020ff : 0000:00:0a.2


# dmesg -s 1000000
Linux version 2.6.20.7 (kh1af478@kh1r558d) (gcc version 3.3.4) #67 Wed
Apr 25 16:56:40 CEST 2007
CPU revision is: 03030200
Siemens SISTORE CX1 Board
(PRId 03030200) @ 324MHZ
BCLK switching enabled!
Determined physical RAM map:
 memory: 08000000 @ 00000000 (usable)
On node 0 totalpages: 32768
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 32512 pages, LIFO batch:7
  Normal zone: 0 pages used for memmap
__request_resource: new=System RAM[0-7ffffff], root=PCI
mem[10000000-fffffffff]
__request_resource: new=Kernel code[100000-3ddcff], root=System
RAM[0-7ffffff]
__request_resource: new=Kernel data[3ddd00-4850bf], root=System
RAM[0-7ffffff]
Built 1 zonelists.  Total pages: 32512
Kernel command line: root=/dev/mtdblock0 rootfstype=jffs2
console=ttyS1,115200 usb_ohci=base:0x14020000,len:0x60000,irq:26
Primary instruction cache 16kB, physically tagged, 4-way, linesize 32
bytes.
Primary data cache 16kB, 4-way, linesize 32 bytes.
Synthesized TLB refill handler (17 instructions).
Synthesized TLB load handler fastpath (34 instructions).
Synthesized TLB store handler fastpath (34 instructions).
Synthesized TLB modify handler fastpath (33 instructions).
PID hash table entries: 512 (order: 9, 2048 bytes)
calculating r4koff... 0004f1a0(324000)
CPU frequency 324.00 MHz
Console: colour dummy device 80x25
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 124928k/131072k available (2935k kernel code, 6092k reserved,
668k data, 148k init, 0k highmem)
Calibrating delay loop... 322.56 BogoMIPS (lpj=161280)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
__request_resource: new=au1xxx-ohci.0[14020000-1407ffff], root=PCI
mem[10000000-fffffffff]
registering PCI controller with io_map_base unset
Generic PHY: Registered new driver
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
__request_resource: new=PCI memory space[440000000-44fffffff], root=PCI
mem[10000000-fffffffff]
__request_resource: new=PCI IO space[500000300-5000fffff], root=PCI
IO[1000-fffffffff]
PCI: Scanning bus 0000:00
PCI: Found 0000:00:0a.0 [1033/0035] 000c03 00
PCI: Found 0000:00:0a.1 [1033/0035] 000c03 00
PCI: Found 0000:00:0a.2 [1033/00e0] 000c03 00
PCI: Found 0000:00:0c.0 [12d5/1000] 000480 00
PCI: Fixups for bus 0000:00
PCI: Bus scan for 0000:00 returning with max=00
__request_resource: new=0000:00:0c.0[440000000-447ffffff], root=PCI
memory space[440000000-44fffffff]
  got res [440000000:447ffffff] bus [40000000:47ffffff] flags 1208 for
BAR 0 of 0000:00:0c.0
PCI: moved device 0000:00:0c.0 resource 0 (1208) to 40000000
__request_resource: new=0000:00:0c.0[448000000-448ffffff], root=PCI
memory space[440000000-44fffffff]
  got res [448000000:448ffffff] bus [48000000:48ffffff] flags 200 for
BAR 1 of 0000:00:0c.0
PCI: moved device 0000:00:0c.0 resource 1 (200) to 48000000
__request_resource: new=0000:00:0a.0[449000000-449000fff], root=PCI
memory space[440000000-44fffffff]
  got res [449000000:449000fff] bus [49000000:49000fff] flags 200 for
BAR 0 of 0000:00:0a.0
PCI: moved device 0000:00:0a.0 resource 0 (200) to 49000000
__request_resource: new=0000:00:0a.1[449001000-449001fff], root=PCI
memory space[440000000-44fffffff]
  got res [449001000:449001fff] bus [49001000:49001fff] flags 200 for
BAR 0 of 0000:00:0a.1
PCI: moved device 0000:00:0a.1 resource 0 (200) to 49001000
__request_resource: new=0000:00:0a.2[449002000-4490020ff], root=PCI
memory space[440000000-44fffffff]
  got res [449002000:4490020ff] bus [49002000:490020ff] flags 200 for
BAR 0 of 0000:00:0a.2
PCI: moved device 0000:00:0a.2 resource 0 (200) to 49002000
PCI: fixup irq: (0000:00:0a.0) got 2
PCI: fixup irq: (0000:00:0a.1) got 5
PCI: fixup irq: (0000:00:0a.2) got 6
PCI: fixup irq: (0000:00:0c.0) got 1
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 4096 bind 2048)
TCP reno registered
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
JFFS2 version 2.2. (NAND) (C) 2001-2006 Red Hat, Inc.
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Calling quirk 8027fe64 for 0000:00:0a.0
PCI: Calling quirk 80312674 for 0000:00:0a.0
PCI: Calling quirk 8027fe64 for 0000:00:0a.1
PCI: Calling quirk 80312674 for 0000:00:0a.1
PCI: Calling quirk 8027fe64 for 0000:00:0a.2
PCI: Calling quirk 80312674 for 0000:00:0a.2
PCI: Calling quirk 8027fe64 for 0000:00:0c.0
PCI: Calling quirk 80312674 for 0000:00:0c.0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
disabled
__request_resource: new=serial[11100000-111fffff], root=PCI
mem[10000000-fffffffff]
serial8250.9: ttyS0 at MMIO 0x11100000 (irq = 0) is a 16550A
__request_resource: new=serial[11200000-112fffff], root=PCI
mem[10000000-fffffffff]
serial8250.9: ttyS1 at MMIO 0x11200000 (irq = 8) is a 16550A
__request_resource: new=serial[11400000-114fffff], root=PCI
mem[10000000-fffffffff]
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
__request_resource: new=Au1x00 ENET[10500000-1050ffff], root=PCI
mem[10000000-fffffffff]
__request_resource: new=Au1x00 ENET[10520000-10520003], root=PCI
mem[10000000-fffffffff]
au1000_eth version 1.6 Pete Popov <ppopov@embeddedalley.com>
eth0: Au1xx0 Ethernet found at 0x10500000, irq 27
au1000_eth_mii: probed
eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=0:04, irq=-1)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
CX1 NOR Flash: probing 16-bit flash bus
CX1 NOR Flash: Found 1 x16 devices at 0x0 in 16-bit bank
 Amd/Fujitsu Extended Query Table at 0x0040
CX1 NOR Flash: CFI does not contain boot bank location. Assuming top.
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
Creating 5 MTD partitions on "CX1 NOR Flash":
0x00000000-0x05000000 : "Root FS"
0x05000000-0x07000000 : "Data FS"
0x07000000-0x07c00000 : "Update FS"
0x07c00000-0x07d00000 : "YAMON"
0x07d00000-0x07fc0000 : "raw kernel"
au1x_board_init
cx1_socket_init
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
(PCI)
PCI: Enabling device 0000:00:0a.0 (0000 -> 0002)
__request_resource: new=ohci_hcd[449000000-449000fff], root=PCI
mem[10000000-fffffffff]
__request_resource: new=ohci_hcd[449000000-449000fff], root=PCI memory
space[440000000-44fffffff]
__request_resource: new=ohci_hcd[449000000-449000fff],
root=0000:00:0a.0[449000000-449000fff]
PCI: Enabling bus mastering for device 0000:00:0a.0
PCI: Setting latency timer of device 0000:00:0a.0 to 64
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0a.0: irq 2, io mem 0x449000000
cx1_pcmcia_configure_socket: bad Vpp 33
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
PCI: Enabling device 0000:00:0a.1 (0000 -> 0002)
__request_resource: new=ohci_hcd[449001000-449001fff], root=PCI
mem[10000000-fffffffff]
__request_resource: new=ohci_hcd[449001000-449001fff], root=PCI memory
space[440000000-44fffffff]
__request_resource: new=ohci_hcd[449001000-449001fff],
root=0000:00:0a.1[449001000-449001fff]
PCI: Enabling bus mastering for device 0000:00:0a.1
PCI: Setting latency timer of device 0000:00:0a.1 to 64
ohci_hcd 0000:00:0a.1: OHCI Host Controller
ohci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.1: irq 5, io mem 0x449001000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
i8042.c: i8042 controller selftest failed. (0xf != 0x55)
i8042: probe of i8042 failed with error -5
cx1_pcmcia_configure_socket: bad Vpp 33
cx1_pcmcia_configure_socket: bad Vpp 33
Trying to free nonexistent resource <0000000000000060-000000000000006f>
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
pcmcia: ide-cs: invalid hash for product string "TS2GCF120": is
0xf54a91c8, should be 0x969aa4f2
pcmcia: see Documentation/pcmcia/devicetable.txt for details
Time: MIPS clocksource has been installed.
VFS: Mounted root (jffs2 filesystem) readonly.
Freeing unused kernel memory: 148k freed
pccard: PCMCIA card inserted into slot 0
pcmcia: registering new device pcmcia0.0
ide_attach()
ide_config(0x812a4400)
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
__request_resource: new=ide0[102000-102007], root=PCI IO[1000-fffffffff]
Probing IDE interface ide0...
probing for hda: present=0, media=32, probetype=ATA
Algorithmics/MIPS FPU Emulator v1.5
hda: TRANSCEND, CFA DISK drive
probing for hdb: present=0, media=32, probetype=ATA
probing for hdb: present=0, media=32, probetype=ATAPI
calling ide_default_irq(102000)
ide0: Disabled unable to get IRQ 35.
ide0: failed to initialize IDE interface
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
No module found in object
__request_resource: new=ide0[10200e-10200e], root=PCI IO[1000-fffffffff]
ide0: I/O resource 0x10200E-0x10200E not free.
ide0: ports already in use, skipping probe
ide-cs: ide_register() at 0x102000 & 0x10200e, irq 35 failed
ide_release(0x812a4400)
eth0: link up (100/Full)
eth0: Pass all multicast
------------------------------------------------------------------------
-

I added some printk() only for debugging raisons (for example in
__request_resource, as you can see)

Best regards,
Fabrice Aeschbacher

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Donnerstag, 26. April 2007 04:08
> To: Aeschbacher, Fabrice
> Cc: lkml; linux-mips@linux-mips.org
> Subject: Re: pcmcia - failed to initialize IDE interface
> 
> On Wed, 25 Apr 2007 15:27:26 +0200 "Aeschbacher, Fabrice" 
> <Fabrice.Aeschbacher@siemens.com> wrote:
> 
> > Hi,
> > 
> > [kernel 2.6.20.7, arch=mips, processor=amd au1550]
> > 
> > I'm trying to install a 2.6 kernel on an Alchemy au1550, and having 
> > problem with the pcmcia socket, where I plugged a 
> CompactFlash card. 
> > The card seems to be recognized by the kernel, appears in 
> > /sys/bus/pcmcia/devices, but not in /proc/bus/pccard, and I can't 
> > access the device (/dev/hda).
> > 
> > The relevant console messages:
> > ----------------------------------------------------------------
> > pccard: PCMCIA card inserted into slot 0
> > pcmcia: registering new device pcmcia0.0
> > hda: SanDisk SDCFB-64, CFA DISK drive
> > ide0: Disabled unable to get IRQ 35.
> > ide0: failed to initialize IDE interface
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide0: I/O resource 0x10200E-0x10200E not free.
> > ide0: ports already in use, skipping probe
> > ide-cs: ide_register() at 0x102000 & 0x10200e, irq 35 failed
> > ----------------------------------------------------------------
> > 
> > Here is the relevant part of the kernel config:
> > CONFIG_IDE=y
> > CONFIG_IDE_GENERIC=y
> > CONFIG_BLK_DEV_IDE=y
> > CONFIG_BLK_DEV_IDECS=y
> > CONFIG_PCCARD=y
> > CONFIG_PCMCIA_DEBUG=y
> > CONFIG_PCMCIA=y
> > CONFIG_PCMCIA_AU1X00=y
> > 
> 
> (cc'ed linux-mips)
> 
> Perhaps /proc/ioports will tell us where the conflict lies.
> 
> The output of `dmesg -s 1000000' might also be needed.
> 
