Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYGNIJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYGNIJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYGNIJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:09:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:48951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753541AbYGNIJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:09:18 -0400
X-Authenticated: #23500402
X-Provags-ID: V01U2FsdGVkX1+aZXlpxpGaebtNUo60+ewOcGkoXv5PlBf0rIFAGZ
	4F9lbca4VhBRpr
Date: Mon, 14 Jul 2008 10:09:14 +0200
From: Andre Prendel <andre_prendel@gmx.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andre Prendel <andre_prendel@gmx.de>, kernel-testers@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI Error under 2.6.26-rc*
Message-ID: <20080714080914.GA4965@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag> <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt> <1215739682.1617.32.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215739682.1617.32.camel@rzhang-dt>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 09:28:02AM +0800, Zhang Rui wrote:
> On Fri, 2008-07-11 at 09:20 +0800, Zhang Rui wrote:
> > On Fri, 2008-07-11 at 04:55 +0800, Rafael J. Wysocki wrote:
> > > [Adding CCs.]
> > > 
> > > On Wednesday, 9 of July 2008, Andre Prendel wrote:
> > > > Hi,
> > > >
> > > > I have had some ACPI Problems working under the 2.6.26-rc's in the
> > > last weeks.
> > > > Power off does not work well. "System halted" is the last output,
> > > but power is
> > > > not switch off. The lastest stable kernel (2.6.25.10) works fine for
> > > me. After
> > > > that I tried 2.6.26-rc1 and the error occurs. AFAIR I had these
> > > problems with
> > > > all 2.6.26-rc's until 2.6.26-rc8-git4. I did not tested newer ones.
> > > >
> > > > Dmesg output is attached.
> > > >
> > > > Andre
> > > >
> > > > ----------------------------------
> > > > [    0.000000] Linux version 2.6.26-rc1 (andre@ubuntu) (gcc version
> > > 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #8 SMP Tue Jul 8
> > > 22:28:14 CEST 2008
> > > > [    0.000000] BIOS-provided physical RAM map:
> > > > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00
> > > (usable)
> > > > [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000
> > > (reserved)
> > > > [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000
> > > (reserved)
> > > > [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000
> > > (usable)
> > > > [    0.000000]  BIOS-e820: 0000000021ff0000 - 0000000021ff8000 (ACPI
> > > data)
> > > > [    0.000000]  BIOS-e820: 0000000021ff8000 - 0000000022000000 (ACPI
> > > NVS)
> > > > [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000
> > > (reserved)
> > > > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
> > > (reserved)
> > > > [    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000
> > > (reserved)
> > > > [    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000
> > > (reserved)
> > > > [    0.000000] x86: PAT support disabled.
> > > > [    0.000000] 511MB LOWMEM available.
> > > > [    0.000000] Entering add_active_range(0, 0, 131056) 0 entries of
> > > 256 used
> > > > [    0.000000] Zone PFN ranges:
> > > > [    0.000000]   DMA             0 ->     4096
> > > > [    0.000000]   Normal       4096 ->   131056
> > > > [    0.000000] Movable zone start PFN for each node
> > > > [    0.000000] early_node_map[1] active PFN ranges
> > > > [    0.000000]     0:        0 ->   131056
> > > > [    0.000000] On node 0 totalpages: 131056
> > > > [    0.000000]   DMA zone: 32 pages used for memmap
> > > > [    0.000000]   DMA zone: 0 pages reserved
> > > > [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> > > > [    0.000000]   Normal zone: 991 pages used for memmap
> > > > [    0.000000]   Normal zone: 125969 pages, LIFO batch:31
> > > > [    0.000000]   Movable zone: 0 pages used for memmap
> > > > [    0.000000] DMI 2.3 present.
> > > > [    0.000000] ACPI: RSDP 000FA340, 0014 (r0 AMI   )
> > > > [    0.000000] ACPI:      21FF0000, 0000 (r0
> > > 0             0)
> > > > [    0.000000] ACPI Error (tbutils-0472): Invalid length 0x0 in
> > > RSDT/XSDT [20080321]
> > 
> > Please attach the acpidump output using the latest pmtools at
> > http://www.lesswatts.org/patches/linux_acpi/
> > 
> Please also attach the dmesg output of a working kernel.

Hello Rui,

that's quite strange. Booting the system to get an acpidump I have
looked at the dmesg output and there is no ACPI Error like the one
above. There is only an ACPI Exeption.

[...]
Jul 13 22:00:18 ubuntu kernel: [    0.104111] ACPI: Core revision 20080321
Jul 13 22:00:18 ubuntu kernel: [    0.104259] ACPI Exception
(tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI
tables [20080321]
[...]

Booting again I found the error again

[...]
Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI Error
(tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20080321]
[...]

and acpidump says:
root@ubuntu:/home/andre/src/acpi/pmtools-20071116/acpidump#
./acpidumpACPI tables were not found. If you know location of RSD PTR
table (from dmesg, etc), supply it with either --addr or -a option

Linux 2.6.25.10 always works.

I attach all the dmesg outputs and hope this helps.

May be the BIOS is a bit buggy. It is an AMIBIOS from 2001.
 
> > thanks,
> > rui

Thanks,
Andre

----------------------------------
dmesg 2.6.25.10 (working)
----------------------------------
Linux version 2.6.25.10-default (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #5 Tue Jul 8 21:21:58 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
 BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131056
On node 0 totalpages: 131056
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125969 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000FA340, 0014 (r0 AMI   )
ACPI: RSDT 1FFF0000, 0028 (r1 AMIINT SiS735XX     1000 MSFT  100000B)
ACPI: FACP 1FFF0030, 0074 (r1 AMIINT SiS735XX     1000 MSFT  100000B)
ACPI: DSDT 1FFF0100, 33C2 (r1    SiS      735      100 MSFT  100000D)
ACPI: FACS 1FFF8000, 0040
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130033
Kernel command line: root=/dev/mapper/lvm--sdb-root ro
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01402000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1659.681 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511576k/524224k available (1639k kernel code, 12036k reserved, 753k data, 216k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa7000 - 0xfffff000   ( 352 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc035a000 - 0xc0390000   ( 216 kB)
      .data : 0xc0299fd4 - 0xc03566a0   ( 753 kB)
      .text : 0xc0100000 - 0xc0299fd4   (1639 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3320.81 BogoMIPS (lpj=6641635)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) XP 2000+ stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c20)
net_namespace: 540 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: Enabling SiS 96x SMBus
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 7 10 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xcde00000-0xcfefffff
  PREFETCH window: 0x00000000c5c00000-0x00000000cdcfffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4484k freed
Machine check exception polling timer started.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1215982615.656:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
NET: Registered protocol family 1
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 216k freed
fuse init (API version 7.9)
ACPI: ACPI0007:00 is registered as cooling_device0
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:02.2[D] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:02.2: OHCI Host Controller
ohci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.2: irq 10, io mem 0xcfffe000
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
USB Universal Host Controller Interface driver v3.0
input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
SIS5513: IDE controller (0x1039:0x5513 rev 0xd0) at  PCI slot 0000:00:02.5
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS735 ATA 100 (2nd gen) controller
    ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L060AVV207-0, ATA DISK drive
hdb: IC35L060AVV207-0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TSSTcorpCD-R/RW SH-R522C, ATAPI CD/DVD-ROM drive
hdd: TSSTcorpDVD-ROM TS-H352A, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
8139cp 0000:00:0d.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:00:0d.0: Try the "8139too" driver instead.
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
eth0: RealTek RTL8139 at 0xe0876f00, 00:10:b5:11:4a:b0, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139C'
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:13.0: UHCI Host Controller
uhci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:13.0: irq 11, io base 0x0000cc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.2[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:13.2: irq 10, io mem 0xcfffde00
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:02.3[A] -> Link [LNKH] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd 0000:00:02.3: OHCI Host Controller
ohci_hcd 0000:00:02.3: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:02.3: irq 5, io mem 0xcffff000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:13.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:13.1: UHCI Host Controller
uhci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:13.1: irq 11, io base 0x0000d000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hda: max request size: 512KiB
hda: 120103200 sectors (61492 MB) w/1821KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 >
hdb: max request size: 512KiB
hdb: 120103200 sectors (61492 MB) w/1821KiB Cache, CHS=16383/255/63
hdb: cache flushes supported
 hdb: hdb1 hdb2
hdc: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X DVD-ROM drive, 512kB Cache
hub 3-0:1.0: unable to enumerate USB device on port 3
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
eth0: link down
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
Linux agpgart interface v0.103
agpgart: Detected SiS chipset - id:1845
agpgart: AGP aperture is 64M @ 0xd0000000
input: Power Button (FF) as /class/input/input2
sis630_smbus 0000:00:02.0: SIS630 comp. bus not detected, module not inserted.
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt 0000:00:02.7[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
IT8705 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
intel8x0_measure_ac97_clock: measured 55826 usecs
intel8x0: clocking to 48000
loop: module loaded
lp0: using parport0 (interrupt-driven).
Adding 1048568k swap on /dev/mapper/lvm--sdb-swap.  Priority:-1 extents:1 across:1048568k
EXT3 FS on dm-1, internal journal
usb 3-1: new high speed USB device using ehci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
USB Mass Storage support registered.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
scsi 0:0:0:0: Direct-Access     WDC WD40 0UE-22HCT0       0811 PQ: 0 ANSI: 0
usb-storage: device scan complete
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
sd 0:0:0:0: [sda] Test WP failed, assume Write Enabled
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda:<6>ppdev: user-space parallel port driver
 sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0

----------------------------------
acpidump 2.6.26-rc1 (ACPI Exception)
----------------------------------

Jul 13 22:00:18 ubuntu syslogd 1.4.1#21ubuntu3: restart.
Jul 13 22:00:18 ubuntu kernel: Inspecting /boot/System.map-2.6.26-rc1
Jul 13 22:00:18 ubuntu kernel: Loaded 30176 symbols from /boot/System.map-2.6.26-rc1.
Jul 13 22:00:18 ubuntu kernel: Symbols match kernel version 2.6.26.
Jul 13 22:00:18 ubuntu kernel: No module symbols loaded - kernel modules not enabled. 
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Linux version 2.6.26-rc1 (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #8 SMP Tue Jul 8 22:28:14 CEST 2008
Jul 13 22:00:18 ubuntu kernel: [    0.000000] BIOS-provided physical RAM map:
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 000000002fff0000 - 000000002fff8000 (ACPI data)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 000000002fff8000 - 0000000030000000 (ACPI NVS)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
Jul 13 22:00:18 ubuntu kernel: [    0.000000] x86: PAT support disabled.
Jul 13 22:00:18 ubuntu kernel: [    0.000000] 511MB LOWMEM available.
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Zone PFN ranges:
Jul 13 22:00:18 ubuntu kernel: [    0.000000]   DMA             0 ->     4096
Jul 13 22:00:18 ubuntu kernel: [    0.000000]   Normal       4096 ->   131056
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Movable zone start PFN for each node
Jul 13 22:00:18 ubuntu kernel: [    0.000000] early_node_map[1] active PFN ranges
Jul 13 22:00:18 ubuntu kernel: [    0.000000]     0:        0 ->   131056
Jul 13 22:00:18 ubuntu kernel: [    0.000000] DMI 2.3 present.
Jul 13 22:00:18 ubuntu kernel: [    0.000000] ACPI: RSDP 000FA340, 0014 (r0 AMI   )
Jul 13 22:00:18 ubuntu kernel: [    0.000000] ACPI:      2FFF0000, 80000000 (r0                        0             0)
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Allocating PCI resources starting at 40000000 (gap: 30000000:cec00000)
Jul 13 22:00:18 ubuntu kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Jul 13 22:00:18 ubuntu kernel: [    0.000000] PERCPU: Allocating 39184 bytes of per cpu data
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130033
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Kernel command line: root=/dev/mapper/lvm--sdb-root ro
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Enabling fast FPU save and restore... done.
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Initializing CPU#0
Jul 13 22:00:18 ubuntu kernel: [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.000000] Detected 1659.680 MHz processor.
Jul 13 22:00:18 ubuntu kernel: [    0.004000] Console: colour VGA+ 80x25
Jul 13 22:00:18 ubuntu kernel: [    0.004000] console [tty0] enabled
Jul 13 22:00:18 ubuntu kernel: [    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.004000] Memory: 501880k/524224k available (2364k kernel code, 21736k reserved, 1107k data, 248k init, 0k highmem)
Jul 13 22:00:18 ubuntu kernel: [    0.004000] virtual kernel memory layout:
Jul 13 22:00:18 ubuntu kernel: [    0.004000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000]       .init : 0xc046b000 - 0xc04a9000   ( 248 kB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000]       .data : 0xc034f1e1 - 0xc0464040   (1107 kB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000]       .text : 0xc0100000 - 0xc034f1e1   (2364 kB)
Jul 13 22:00:18 ubuntu kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul 13 22:00:18 ubuntu kernel: [    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Jul 13 22:00:18 ubuntu kernel: [    0.084007] Calibrating delay using timer specific routine.. 3321.02 BogoMIPS (lpj=6642044)
Jul 13 22:00:18 ubuntu kernel: [    0.084161] Security Framework initialized
Jul 13 22:00:18 ubuntu kernel: [    0.084234] SELinux:  Disabled at boot.
Jul 13 22:00:18 ubuntu kernel: [    0.084314] Mount-cache hash table entries: 512
Jul 13 22:00:18 ubuntu kernel: [    0.084592] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
Jul 13 22:00:18 ubuntu kernel: [    0.084665] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 13 22:00:18 ubuntu kernel: [    0.084737] CPU: L2 Cache: 256K (64 bytes/line)
Jul 13 22:00:18 ubuntu kernel: [    0.084815] Checking 'hlt' instruction... OK.
Jul 13 22:00:18 ubuntu kernel: [    0.100347] SMP alternatives: switching to UP code
Jul 13 22:00:18 ubuntu kernel: [    0.104042] Freeing SMP alternatives: 11k freed
Jul 13 22:00:18 ubuntu kernel: [    0.104111] ACPI: Core revision 20080321
Jul 13 22:00:18 ubuntu kernel: [    0.104259] ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080321]
Jul 13 22:00:18 ubuntu kernel: [    0.104588] weird, boot CPU (#0) not listedby the BIOS.
Jul 13 22:00:18 ubuntu kernel: [    0.104656] SMP motherboard not detected.
Jul 13 22:00:18 ubuntu kernel: [    0.104723] Local APIC not detected. Using dummy APIC emulation.
Jul 13 22:00:18 ubuntu kernel: [    0.104791] SMP disabled
Jul 13 22:00:18 ubuntu kernel: [    0.104939] Brought up 1 CPUs
Jul 13 22:00:18 ubuntu kernel: [    0.105003] Total of 1 processors activated (3321.02 BogoMIPS).
Jul 13 22:00:18 ubuntu kernel: [    0.105470] net_namespace: 644 bytes
Jul 13 22:00:18 ubuntu kernel: [    0.105788] NET: Registered protocol family 16
Jul 13 22:00:18 ubuntu kernel: [    0.106060] No dock devices found.
Jul 13 22:00:18 ubuntu kernel: [    0.107539] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
Jul 13 22:00:18 ubuntu kernel: [    0.107611] PCI: Using configuration type 1 for base access
Jul 13 22:00:18 ubuntu kernel: [    0.107680] Setting up standard PCI resources
Jul 13 22:00:18 ubuntu kernel: [    0.109342] ACPI: Interpreter disabled.
Jul 13 22:00:18 ubuntu kernel: [    0.109412] Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 13 22:00:18 ubuntu kernel: [    0.109524] pnp: PnP ACPI: disabled
Jul 13 22:00:18 ubuntu kernel: [    0.109824] SCSI subsystem initialized
Jul 13 22:00:18 ubuntu kernel: [    0.110115] PCI: Probing PCI hardware
Jul 13 22:00:18 ubuntu kernel: [    0.110389] pci 0000:00:02.0: Enabling SiS 96x SMBus
Jul 13 22:00:18 ubuntu kernel: [    0.111813] PCI: Using IRQ router SIS [1039/0018] at 0000:00:02.0
Jul 13 22:00:18 ubuntu kernel: [    0.111905] PCI: Found IRQ 11 for device 0000:00:02.1
Jul 13 22:00:18 ubuntu kernel: [    0.111987] PCI: Sharing IRQ 11 with 0000:00:13.1
Jul 13 22:00:18 ubuntu kernel: [    0.112307] NET: Registered protocol family 8
Jul 13 22:00:18 ubuntu kernel: [    0.112374] NET: Registered protocol family 20
Jul 13 22:00:18 ubuntu kernel: [    0.113075] PCI: Bridge: 0000:00:01.0
Jul 13 22:00:18 ubuntu kernel: [    0.113141]   IO window: disabled.
Jul 13 22:00:18 ubuntu kernel: [    0.113209]   MEM window: 0xcde00000-0xcfefffff
Jul 13 22:00:18 ubuntu kernel: [    0.113278]   PREFETCH window: 0x00000000c5c00000-0x00000000cdcfffff
Jul 13 22:00:18 ubuntu kernel: [    0.113376] NET: Registered protocol family 2
Jul 13 22:00:18 ubuntu kernel: [    0.113557] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.113911] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.114271] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
Jul 13 22:00:18 ubuntu kernel: [    0.114612] TCP: Hash tables configured (established 16384 bind 16384)
Jul 13 22:00:18 ubuntu kernel: [    0.114684] TCP reno registered
Jul 13 22:00:18 ubuntu kernel: [    0.114888] NET: Registered protocol family 1
Jul 13 22:00:18 ubuntu kernel: [    0.115127] checking if image is initramfs... it is
Jul 13 22:00:18 ubuntu kernel: [    1.445757] Freeing initrd memory: 12959k freed
Jul 13 22:00:18 ubuntu kernel: [    1.446360] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
Jul 13 22:00:18 ubuntu kernel: [    1.446924] audit: initializing netlink socket (disabled)
Jul 13 22:00:18 ubuntu kernel: [    1.447015] type=2000 audit(1215986400.444:1): initialized
Jul 13 22:00:18 ubuntu kernel: [    1.456677] VFS: Disk quotas dquot_6.5.1
Jul 13 22:00:18 ubuntu kernel: [    1.456864] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul 13 22:00:18 ubuntu kernel: [    1.457295] msgmni has been set to 1005 for ipc namespace c0442b40
Jul 13 22:00:18 ubuntu kernel: [    1.457527] io scheduler noop registered
Jul 13 22:00:18 ubuntu kernel: [    1.457594] io scheduler anticipatory registered
Jul 13 22:00:18 ubuntu kernel: [    1.457661] io scheduler deadline registered
Jul 13 22:00:18 ubuntu kernel: [    1.457739] io scheduler cfq registered (default)
Jul 13 22:00:18 ubuntu kernel: [    1.490761] Real Time Clock Driver v1.12ac
Jul 13 22:00:18 ubuntu kernel: [    1.490941] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 13 22:00:18 ubuntu kernel: [    1.491190] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 13 22:00:18 ubuntu kernel: [    1.491445] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 13 22:00:18 ubuntu kernel: [    1.493693] brd: module loaded
Jul 13 22:00:18 ubuntu kernel: [    1.493819] Driver 'sd' needs updating - please use bus_type methods
Jul 13 22:00:18 ubuntu kernel: [    1.494168] scsi0 : pata_sis
Jul 13 22:00:18 ubuntu kernel: [    1.494461] scsi1 : pata_sis
Jul 13 22:00:18 ubuntu kernel: [    1.494593] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jul 13 22:00:18 ubuntu kernel: [    1.494666] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jul 13 22:00:18 ubuntu kernel: [    1.680809] ata1.00: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
Jul 13 22:00:18 ubuntu kernel: [    1.680883] ata1.00: 120103200 sectors, multi 16: LBA48 
Jul 13 22:00:18 ubuntu kernel: [    1.681341] ata1.01: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
Jul 13 22:00:18 ubuntu kernel: [    1.681412] ata1.01: 120103200 sectors, multi 16: LBA48 
Jul 13 22:00:18 ubuntu kernel: [    1.704621] ata1.00: configured for UDMA/100
Jul 13 22:00:18 ubuntu kernel: [    1.728639] ata1.01: configured for UDMA/100
Jul 13 22:00:18 ubuntu kernel: [    1.892451] ata2.00: ATAPI: TSSTcorpCD-R/RW SH-R522C, TS04, max UDMA/33
Jul 13 22:00:18 ubuntu kernel: [    1.892539] ata2.01: ATAPI: TSSTcorpDVD-ROM TS-H352A, TS03, max UDMA/33
Jul 13 22:00:18 ubuntu kernel: [    1.908338] ata2.00: configured for UDMA/33
Jul 13 22:00:18 ubuntu kernel: [    1.924328] ata2.01: configured for UDMA/33
Jul 13 22:00:18 ubuntu kernel: [    1.924564] scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
Jul 13 22:00:18 ubuntu kernel: [    1.924899] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:00:18 ubuntu kernel: [    1.924991] sd 0:0:0:0: [sda] Write Protect is off
Jul 13 22:00:18 ubuntu kernel: [    1.925088] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:00:18 ubuntu kernel: [    1.925253] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:00:18 ubuntu kernel: [    1.925339] sd 0:0:0:0: [sda] Write Protect is off
Jul 13 22:00:18 ubuntu kernel: [    1.925433] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:00:18 ubuntu kernel: [    1.925527]  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul 13 22:00:18 ubuntu kernel: [    1.965700]  sda3: <minix: sda6 sda7 sda8 >
Jul 13 22:00:18 ubuntu kernel: [    1.966443] sd 0:0:0:0: [sda] Attached SCSI disk
Jul 13 22:00:18 ubuntu kernel: [    1.966625] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul 13 22:00:18 ubuntu kernel: [    1.966795] scsi 0:0:1:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
Jul 13 22:00:18 ubuntu kernel: [    1.967053] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:00:18 ubuntu kernel: [    1.967144] sd 0:0:1:0: [sdb] Write Protect is off
Jul 13 22:00:18 ubuntu kernel: [    1.967241] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:00:18 ubuntu kernel: [    1.967394] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:00:18 ubuntu kernel: [    1.967480] sd 0:0:1:0: [sdb] Write Protect is off
Jul 13 22:00:18 ubuntu kernel: [    1.967575] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:00:18 ubuntu kernel: [    1.967669]  sdb: sdb1 sdb2
Jul 13 22:00:18 ubuntu kernel: [    1.977108] sd 0:0:1:0: [sdb] Attached SCSI disk
Jul 13 22:00:18 ubuntu kernel: [    1.977279] sd 0:0:1:0: Attached scsi generic sg1 type 0
Jul 13 22:00:18 ubuntu kernel: [    1.978726] scsi 1:0:0:0: CD-ROM            TSSTcorp CD-R/RW SH-R522C TS04 PQ: 0 ANSI: 5
Jul 13 22:00:18 ubuntu kernel: [    1.978999] scsi 1:0:0:0: Attached scsi generic sg2 type 5
Jul 13 22:00:18 ubuntu kernel: [    1.979538] scsi 1:0:1:0: CD-ROM            TSSTcorp DVD-ROM TS-H352A TS03 PQ: 0 ANSI: 5
Jul 13 22:00:18 ubuntu kernel: [    1.979800] scsi 1:0:1:0: Attached scsi generic sg3 type 5
Jul 13 22:00:18 ubuntu kernel: [    1.980086] PNP: No PS/2 controller found. Probing ports directly.
Jul 13 22:00:18 ubuntu kernel: [    1.980446] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 13 22:00:18 ubuntu kernel: [    1.980519] serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 13 22:00:18 ubuntu kernel: [    1.980787] mice: PS/2 mouse device common for all mice
Jul 13 22:00:18 ubuntu kernel: [    1.981154] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Jul 13 22:00:18 ubuntu kernel: [    1.981809] TCP cubic registered
Jul 13 22:00:18 ubuntu kernel: [    1.981905] Using IPI No-Shortcut mode
Jul 13 22:00:18 ubuntu kernel: [    1.982665] Freeing unused kernel memory: 248k freed
Jul 13 22:00:18 ubuntu kernel: [    2.010364] input: AT Translated Set 2 keyboard as /class/input/input0
Jul 13 22:00:18 ubuntu kernel: [    2.208694] fuse init (API version 7.9)
Jul 13 22:00:18 ubuntu kernel: [    2.225286] thermal: Unknown symbol acpi_processor_set_thermal_limit
Jul 13 22:00:18 ubuntu kernel: [    3.236759] Uniform Multi-Platform E-IDE driver
Jul 13 22:00:18 ubuntu kernel: [    3.236840] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jul 13 22:00:18 ubuntu kernel: [    3.284586] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Jul 13 22:00:18 ubuntu kernel: [    3.306971] 8139too Fast Ethernet driver 0.9.28
Jul 13 22:00:18 ubuntu kernel: [    3.307828] PCI: Found IRQ 10 for device 0000:00:0d.0
Jul 13 22:00:18 ubuntu kernel: [    3.307909] PCI: Sharing IRQ 10 with 0000:00:02.7
Jul 13 22:00:18 ubuntu kernel: [    3.307982] PCI: Sharing IRQ 10 with 0000:00:13.2
Jul 13 22:00:18 ubuntu kernel: [    3.308661] eth0: RealTek RTL8139 at 0xe083cf00, 00:10:b5:11:4a:b0, IRQ 10
Jul 13 22:00:18 ubuntu kernel: [    3.365325] usbcore: registered new interface driver usbfs
Jul 13 22:00:18 ubuntu kernel: [    3.365431] usbcore: registered new interface driver hub
Jul 13 22:00:18 ubuntu kernel: [    3.379135] usbcore: registered new device driver usb
Jul 13 22:00:18 ubuntu kernel: [    3.382652] Driver 'sr' needs updating - please use bus_type methods
Jul 13 22:00:18 ubuntu kernel: [    3.389771] PCI: Found IRQ 10 for device 0000:00:13.2
Jul 13 22:00:18 ubuntu kernel: [    3.389876] PCI: Sharing IRQ 10 with 0000:00:02.7
Jul 13 22:00:18 ubuntu kernel: [    3.389944] PCI: Sharing IRQ 10 with 0000:00:0d.0
Jul 13 22:00:18 ubuntu kernel: [    3.390036] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jul 13 22:00:18 ubuntu kernel: [    3.390144] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
Jul 13 22:00:18 ubuntu kernel: [    3.390297] ehci_hcd 0000:00:13.2: irq 10, io mem 0xcfffde00
Jul 13 22:00:18 ubuntu kernel: [    3.392621] sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
Jul 13 22:00:18 ubuntu kernel: [    3.392705] Uniform CD-ROM driver Revision: 3.20
Jul 13 22:00:18 ubuntu kernel: [    3.400235] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
Jul 13 22:00:18 ubuntu kernel: [    3.400538] usb usb1: configuration #1 chosen from 1 choice
Jul 13 22:00:18 ubuntu kernel: [    3.400642] hub 1-0:1.0: USB hub found
Jul 13 22:00:18 ubuntu kernel: [    3.400718] hub 1-0:1.0: 4 ports detected
Jul 13 22:00:18 ubuntu kernel: [    3.406073] sr1: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
Jul 13 22:00:18 ubuntu kernel: [    3.664557] kjournald starting.  Commit interval 5 seconds
Jul 13 22:00:18 ubuntu kernel: [    3.664647] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:00:18 ubuntu kernel: [    3.744264] usb 1-1: new high speed USB device using ehci_hcd and address 2
Jul 13 22:00:18 ubuntu kernel: [    3.877727] usb 1-1: configuration #1 chosen from 1 choice
Jul 13 22:00:18 ubuntu kernel: [    9.883339] eth0: link down
Jul 13 22:00:18 ubuntu kernel: [   11.018244] NET: Registered protocol family 10
Jul 13 22:00:18 ubuntu kernel: [   11.018778] lo: Disabled Privacy Extensions
Jul 13 22:00:18 ubuntu kernel: [   11.019324] ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul 13 22:00:18 ubuntu kernel: [   11.788983] Linux agpgart interface v0.103
Jul 13 22:00:18 ubuntu kernel: [   11.946545] agpgart: Detected SiS chipset - id:1845
Jul 13 22:00:18 ubuntu kernel: [   11.951174] agpgart: AGP aperture is 64M @ 0xd0000000
Jul 13 22:00:18 ubuntu kernel: [   12.216579] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
Jul 13 22:00:18 ubuntu kernel: [   12.515478] Initializing USB Mass Storage driver...
Jul 13 22:00:18 ubuntu kernel: [   12.519688] scsi2 : SCSI emulation for USB Mass Storage devices
Jul 13 22:00:18 ubuntu kernel: [   12.520178] usbcore: registered new interface driver usb-storage
Jul 13 22:00:18 ubuntu kernel: [   12.520251] USB Mass Storage support registered.
Jul 13 22:00:18 ubuntu kernel: [   12.545827] PCI: Found IRQ 10 for device 0000:00:02.7
Jul 13 22:00:18 ubuntu kernel: [   12.545920] PCI: Sharing IRQ 10 with 0000:00:0d.0
Jul 13 22:00:18 ubuntu kernel: [   12.545992] PCI: Sharing IRQ 10 with 0000:00:13.2
Jul 13 22:00:18 ubuntu kernel: [   12.860811] intel8x0_measure_ac97_clock: measured 55895 usecs
Jul 13 22:00:18 ubuntu kernel: [   12.860888] intel8x0: clocking to 48000
Jul 13 22:00:18 ubuntu kernel: [   13.040779] input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
Jul 13 22:00:18 ubuntu kernel: [   13.471151] loop: module loaded
Jul 13 22:00:18 ubuntu kernel: [   13.582947] Adding 1048568k swap on /dev/mapper/lvm--sdb-swap.  Priority:-1 extents:1 across:1048568k
Jul 13 22:00:18 ubuntu kernel: [   14.095419] EXT3 FS on dm-1, internal journal
Jul 13 22:00:18 ubuntu kernel: [   16.503407] kjournald starting.  Commit interval 5 seconds
Jul 13 22:00:18 ubuntu kernel: [   16.503664] EXT3 FS on sdb1, internal journal
Jul 13 22:00:18 ubuntu kernel: [   16.503671] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:00:18 ubuntu kernel: [   16.533815] kjournald starting.  Commit interval 5 seconds
Jul 13 22:00:18 ubuntu kernel: [   16.534097] EXT3 FS on dm-2, internal journal
Jul 13 22:00:18 ubuntu kernel: [   16.534103] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:00:18 ubuntu kernel: [   17.535287] scsi 2:0:0:0: Direct-Access     WDC WD40 0UE-22HCT0       0811 PQ: 0 ANSI: 0
Jul 13 22:00:18 ubuntu kernel: [   17.557183] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
Jul 13 22:00:18 ubuntu kernel: [   17.583370] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
Jul 13 22:00:18 ubuntu kernel: [   17.605174] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
Jul 13 22:00:18 ubuntu kernel: [   17.631297] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
Jul 13 22:00:18 ubuntu kernel: [   17.631389]  sdc: sdc1
Jul 13 22:00:18 ubuntu kernel: [   17.645391] sd 2:0:0:0: [sdc] Attached SCSI disk
Jul 13 22:00:18 ubuntu kernel: [   17.645462] sd 2:0:0:0: Attached scsi generic sg4 type 0
Jul 13 22:00:18 ubuntu kernel: [   18.652503] powernow_k7: Unknown symbol acpi_processor_notify_smm
Jul 13 22:00:18 ubuntu kernel: [   18.652566] powernow_k7: Unknown symbol acpi_processor_unregister_performance
Jul 13 22:00:18 ubuntu kernel: [   18.652675] powernow_k7: Unknown symbol acpi_processor_register_performance
Jul 13 22:00:18 ubuntu kernel: [   18.669960] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
Jul 13 22:00:18 ubuntu kernel: [   18.670023] acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
Jul 13 22:00:18 ubuntu kernel: [   18.670230] acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
Jul 13 22:00:18 ubuntu kernel: [   18.670313] acpi_cpufreq: Unknown symbol acpi_processor_register_performance
Jul 13 22:00:22 ubuntu dhcdbd: Started up.
Jul 13 22:07:12 ubuntu exiting on signal 15

----------------------------------
acpidump 2.6.26-rc1 (ACPI Error)
----------------------------------

Jul 13 22:10:50 ubuntu syslogd 1.4.1#21ubuntu3: restart.
Jul 13 22:10:50 ubuntu kernel: Inspecting /boot/System.map-2.6.26-rc1
Jul 13 22:10:50 ubuntu kernel: Loaded 30176 symbols from /boot/System.map-2.6.26-rc1.
Jul 13 22:10:50 ubuntu kernel: Symbols match kernel version 2.6.26.
Jul 13 22:10:50 ubuntu kernel: No module symbols loaded - kernel modules not enabled. 
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Linux version 2.6.26-rc1 (andre@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #8 SMP Tue Jul 8 22:28:14 CEST 2008
Jul 13 22:10:50 ubuntu kernel: [    0.000000] BIOS-provided physical RAM map:
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000021ff0000 - 0000000021ff8000 (ACPI data)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 0000000021ff8000 - 0000000022000000 (ACPI NVS)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
Jul 13 22:10:50 ubuntu kernel: [    0.000000] x86: PAT support disabled.
Jul 13 22:10:50 ubuntu kernel: [    0.000000] 511MB LOWMEM available.
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Zone PFN ranges:
Jul 13 22:10:50 ubuntu kernel: [    0.000000]   DMA             0 ->     4096
Jul 13 22:10:50 ubuntu kernel: [    0.000000]   Normal       4096 ->   131056
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Movable zone start PFN for each node
Jul 13 22:10:50 ubuntu kernel: [    0.000000] early_node_map[1] active PFN ranges
Jul 13 22:10:50 ubuntu kernel: [    0.000000]     0:        0 ->   131056
Jul 13 22:10:50 ubuntu kernel: [    0.000000] DMI 2.3 present.
Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI: RSDP 000FA340, 0014 (r0 AMI   )
Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI:      21FF0000, 0000 (r0                        0             0)
Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI Error (tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20080321]
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Allocating PCI resources starting at 30000000 (gap: 22000000:dcc00000)
Jul 13 22:10:50 ubuntu kernel: [    0.000000] SMP: Allowing 0 CPUs, 0 hotplug CPUs
Jul 13 22:10:50 ubuntu kernel: [    0.000000] PERCPU: Allocating 39184 bytes of per cpu data
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130033
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Kernel command line: root=/dev/mapper/lvm--sdb-root ro
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Enabling fast FPU save and restore... done.
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Initializing CPU#0
Jul 13 22:10:50 ubuntu kernel: [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.000000] Detected 1659.680 MHz processor.
Jul 13 22:10:50 ubuntu kernel: [    0.004000] Console: colour VGA+ 80x25
Jul 13 22:10:50 ubuntu kernel: [    0.004000] console [tty0] enabled
Jul 13 22:10:50 ubuntu kernel: [    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.004000] Memory: 501880k/524224k available (2364k kernel code, 21736k reserved, 1107k data, 248k init, 0k highmem)
Jul 13 22:10:50 ubuntu kernel: [    0.004000] virtual kernel memory layout:
Jul 13 22:10:50 ubuntu kernel: [    0.004000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000]       .init : 0xc046b000 - 0xc04a9000   ( 248 kB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000]       .data : 0xc034f1e1 - 0xc0464040   (1107 kB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000]       .text : 0xc0100000 - 0xc034f1e1   (2364 kB)
Jul 13 22:10:50 ubuntu kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul 13 22:10:50 ubuntu kernel: [    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Jul 13 22:10:50 ubuntu kernel: [    0.084007] Calibrating delay using timer specific routine.. 3321.02 BogoMIPS (lpj=6642041)
Jul 13 22:10:50 ubuntu kernel: [    0.084161] Security Framework initialized
Jul 13 22:10:50 ubuntu kernel: [    0.084235] SELinux:  Disabled at boot.
Jul 13 22:10:50 ubuntu kernel: [    0.084316] Mount-cache hash table entries: 512
Jul 13 22:10:50 ubuntu kernel: [    0.084594] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
Jul 13 22:10:50 ubuntu kernel: [    0.084667] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 13 22:10:50 ubuntu kernel: [    0.084739] CPU: L2 Cache: 256K (64 bytes/line)
Jul 13 22:10:50 ubuntu kernel: [    0.084818] Checking 'hlt' instruction... OK.
Jul 13 22:10:50 ubuntu kernel: [    0.100347] SMP alternatives: switching to UP code
Jul 13 22:10:50 ubuntu kernel: [    0.104043] Freeing SMP alternatives: 11k freed
Jul 13 22:10:50 ubuntu kernel: [    0.104111] ACPI: Core revision 20080321
Jul 13 22:10:50 ubuntu kernel: [    0.104259] ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080321]
Jul 13 22:10:50 ubuntu kernel: [    0.104587] weird, boot CPU (#0) not listedby the BIOS.
Jul 13 22:10:50 ubuntu kernel: [    0.104656] SMP motherboard not detected.
Jul 13 22:10:50 ubuntu kernel: [    0.104722] Local APIC not detected. Using dummy APIC emulation.
Jul 13 22:10:50 ubuntu kernel: [    0.104791] SMP disabled
Jul 13 22:10:50 ubuntu kernel: [    0.104937] Brought up 1 CPUs
Jul 13 22:10:50 ubuntu kernel: [    0.105001] Total of 1 processors activated (3321.02 BogoMIPS).
Jul 13 22:10:50 ubuntu kernel: [    0.105470] net_namespace: 644 bytes
Jul 13 22:10:50 ubuntu kernel: [    0.105787] NET: Registered protocol family 16
Jul 13 22:10:50 ubuntu kernel: [    0.106059] No dock devices found.
Jul 13 22:10:50 ubuntu kernel: [    0.107539] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
Jul 13 22:10:50 ubuntu kernel: [    0.107612] PCI: Using configuration type 1 for base access
Jul 13 22:10:50 ubuntu kernel: [    0.107680] Setting up standard PCI resources
Jul 13 22:10:50 ubuntu kernel: [    0.109342] ACPI: Interpreter disabled.
Jul 13 22:10:50 ubuntu kernel: [    0.109412] Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 13 22:10:50 ubuntu kernel: [    0.109524] pnp: PnP ACPI: disabled
Jul 13 22:10:50 ubuntu kernel: [    0.109823] SCSI subsystem initialized
Jul 13 22:10:50 ubuntu kernel: [    0.110115] PCI: Probing PCI hardware
Jul 13 22:10:50 ubuntu kernel: [    0.110388] pci 0000:00:02.0: Enabling SiS 96x SMBus
Jul 13 22:10:50 ubuntu kernel: [    0.111811] PCI: Using IRQ router SIS [1039/0018] at 0000:00:02.0
Jul 13 22:10:50 ubuntu kernel: [    0.111902] PCI: Found IRQ 11 for device 0000:00:02.1
Jul 13 22:10:50 ubuntu kernel: [    0.111985] PCI: Sharing IRQ 11 with 0000:00:13.1
Jul 13 22:10:50 ubuntu kernel: [    0.112307] NET: Registered protocol family 8
Jul 13 22:10:50 ubuntu kernel: [    0.112374] NET: Registered protocol family 20
Jul 13 22:10:50 ubuntu kernel: [    0.113073] PCI: Bridge: 0000:00:01.0
Jul 13 22:10:50 ubuntu kernel: [    0.113139]   IO window: disabled.
Jul 13 22:10:50 ubuntu kernel: [    0.113208]   MEM window: 0xcde00000-0xcfefffff
Jul 13 22:10:50 ubuntu kernel: [    0.113277]   PREFETCH window: 0x00000000c5c00000-0x00000000cdcfffff
Jul 13 22:10:50 ubuntu kernel: [    0.113375] NET: Registered protocol family 2
Jul 13 22:10:50 ubuntu kernel: [    0.113557] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.113911] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.114271] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
Jul 13 22:10:50 ubuntu kernel: [    0.114612] TCP: Hash tables configured (established 16384 bind 16384)
Jul 13 22:10:50 ubuntu kernel: [    0.114684] TCP reno registered
Jul 13 22:10:50 ubuntu kernel: [    0.114887] NET: Registered protocol family 1
Jul 13 22:10:50 ubuntu kernel: [    0.115126] checking if image is initramfs... it is
Jul 13 22:10:50 ubuntu kernel: [    1.445759] Freeing initrd memory: 12959k freed
Jul 13 22:10:50 ubuntu kernel: [    1.446362] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
Jul 13 22:10:50 ubuntu kernel: [    1.446926] audit: initializing netlink socket (disabled)
Jul 13 22:10:50 ubuntu kernel: [    1.447019] type=2000 audit(1215987032.444:1): initialized
Jul 13 22:10:50 ubuntu kernel: [    1.456683] VFS: Disk quotas dquot_6.5.1
Jul 13 22:10:50 ubuntu kernel: [    1.456870] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul 13 22:10:50 ubuntu kernel: [    1.457299] msgmni has been set to 1005 for ipc namespace c0442b40
Jul 13 22:10:50 ubuntu kernel: [    1.457529] io scheduler noop registered
Jul 13 22:10:50 ubuntu kernel: [    1.457596] io scheduler anticipatory registered
Jul 13 22:10:50 ubuntu kernel: [    1.457662] io scheduler deadline registered
Jul 13 22:10:50 ubuntu kernel: [    1.457740] io scheduler cfq registered (default)
Jul 13 22:10:50 ubuntu kernel: [    1.491046] Real Time Clock Driver v1.12ac
Jul 13 22:10:50 ubuntu kernel: [    1.491226] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 13 22:10:50 ubuntu kernel: [    1.491477] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 13 22:10:50 ubuntu kernel: [    1.491724] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 13 22:10:50 ubuntu kernel: [    1.493967] brd: module loaded
Jul 13 22:10:50 ubuntu kernel: [    1.494094] Driver 'sd' needs updating - please use bus_type methods
Jul 13 22:10:50 ubuntu kernel: [    1.494429] scsi0 : pata_sis
Jul 13 22:10:50 ubuntu kernel: [    1.494722] scsi1 : pata_sis
Jul 13 22:10:50 ubuntu kernel: [    1.494855] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jul 13 22:10:50 ubuntu kernel: [    1.494928] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jul 13 22:10:50 ubuntu kernel: [    1.680832] ata1.00: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
Jul 13 22:10:50 ubuntu kernel: [    1.680904] ata1.00: 120103200 sectors, multi 16: LBA48 
Jul 13 22:10:50 ubuntu kernel: [    1.681389] ata1.01: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
Jul 13 22:10:50 ubuntu kernel: [    1.681461] ata1.01: 120103200 sectors, multi 16: LBA48 
Jul 13 22:10:50 ubuntu kernel: [    1.704616] ata1.00: configured for UDMA/100
Jul 13 22:10:50 ubuntu kernel: [    1.728643] ata1.01: configured for UDMA/100
Jul 13 22:10:50 ubuntu kernel: [    1.892451] ata2.00: ATAPI: TSSTcorpCD-R/RW SH-R522C, TS04, max UDMA/33
Jul 13 22:10:50 ubuntu kernel: [    1.892539] ata2.01: ATAPI: TSSTcorpDVD-ROM TS-H352A, TS03, max UDMA/33
Jul 13 22:10:50 ubuntu kernel: [    1.900337] ata2.00: configured for UDMA/33
Jul 13 22:10:50 ubuntu kernel: [    1.916328] ata2.01: configured for UDMA/33
Jul 13 22:10:50 ubuntu kernel: [    1.916559] scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
Jul 13 22:10:50 ubuntu kernel: [    1.916884] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:10:50 ubuntu kernel: [    1.916976] sd 0:0:0:0: [sda] Write Protect is off
Jul 13 22:10:50 ubuntu kernel: [    1.917074] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:10:50 ubuntu kernel: [    1.917238] sd 0:0:0:0: [sda] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:10:50 ubuntu kernel: [    1.917324] sd 0:0:0:0: [sda] Write Protect is off
Jul 13 22:10:50 ubuntu kernel: [    1.917417] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:10:50 ubuntu kernel: [    1.917512]  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul 13 22:10:50 ubuntu kernel: [    1.949029]  sda3: <minix: sda6 sda7 sda8 >
Jul 13 22:10:50 ubuntu kernel: [    1.949769] sd 0:0:0:0: [sda] Attached SCSI disk
Jul 13 22:10:50 ubuntu kernel: [    1.949950] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul 13 22:10:50 ubuntu kernel: [    1.950118] scsi 0:0:1:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0 ANSI: 5
Jul 13 22:10:50 ubuntu kernel: [    1.950374] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:10:50 ubuntu kernel: [    1.950464] sd 0:0:1:0: [sdb] Write Protect is off
Jul 13 22:10:50 ubuntu kernel: [    1.950559] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:10:50 ubuntu kernel: [    1.950710] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493 MB)
Jul 13 22:10:50 ubuntu kernel: [    1.950795] sd 0:0:1:0: [sdb] Write Protect is off
Jul 13 22:10:50 ubuntu kernel: [    1.950889] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 13 22:10:50 ubuntu kernel: [    1.950984]  sdb: sdb1 sdb2
Jul 13 22:10:50 ubuntu kernel: [    1.960128] sd 0:0:1:0: [sdb] Attached SCSI disk
Jul 13 22:10:50 ubuntu kernel: [    1.960301] sd 0:0:1:0: Attached scsi generic sg1 type 0
Jul 13 22:10:50 ubuntu kernel: [    1.961783] scsi 1:0:0:0: CD-ROM            TSSTcorp CD-R/RW SH-R522C TS04 PQ: 0 ANSI: 5
Jul 13 22:10:50 ubuntu kernel: [    1.962055] scsi 1:0:0:0: Attached scsi generic sg2 type 5
Jul 13 22:10:50 ubuntu kernel: [    1.962596] scsi 1:0:1:0: CD-ROM            TSSTcorp DVD-ROM TS-H352A TS03 PQ: 0 ANSI: 5
Jul 13 22:10:50 ubuntu kernel: [    1.962858] scsi 1:0:1:0: Attached scsi generic sg3 type 5
Jul 13 22:10:50 ubuntu kernel: [    1.963141] PNP: No PS/2 controller found. Probing ports directly.
Jul 13 22:10:50 ubuntu kernel: [    1.963525] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 13 22:10:50 ubuntu kernel: [    1.963597] serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 13 22:10:50 ubuntu kernel: [    1.963868] mice: PS/2 mouse device common for all mice
Jul 13 22:10:50 ubuntu kernel: [    1.964256] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Jul 13 22:10:50 ubuntu kernel: [    1.964914] TCP cubic registered
Jul 13 22:10:50 ubuntu kernel: [    1.965010] Using IPI No-Shortcut mode
Jul 13 22:10:50 ubuntu kernel: [    1.965764] Freeing unused kernel memory: 248k freed
Jul 13 22:10:50 ubuntu kernel: [    1.993758] input: AT Translated Set 2 keyboard as /class/input/input0
Jul 13 22:10:50 ubuntu kernel: [    2.192566] fuse init (API version 7.9)
Jul 13 22:10:50 ubuntu kernel: [    2.209112] thermal: Unknown symbol acpi_processor_set_thermal_limit
Jul 13 22:10:50 ubuntu kernel: [    3.269318] Uniform Multi-Platform E-IDE driver
Jul 13 22:10:50 ubuntu kernel: [    3.269399] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jul 13 22:10:50 ubuntu kernel: [    3.308930] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Jul 13 22:10:50 ubuntu kernel: [    3.327634] 8139too Fast Ethernet driver 0.9.28
Jul 13 22:10:50 ubuntu kernel: [    3.327767] PCI: Found IRQ 10 for device 0000:00:0d.0
Jul 13 22:10:50 ubuntu kernel: [    3.327848] PCI: Sharing IRQ 10 with 0000:00:02.7
Jul 13 22:10:50 ubuntu kernel: [    3.327922] PCI: Sharing IRQ 10 with 0000:00:13.2
Jul 13 22:10:50 ubuntu kernel: [    3.328563] eth0: RealTek RTL8139 at 0xe082af00, 00:10:b5:11:4a:b0, IRQ 10
Jul 13 22:10:50 ubuntu kernel: [    3.387333] usbcore: registered new interface driver usbfs
Jul 13 22:10:50 ubuntu kernel: [    3.387434] usbcore: registered new interface driver hub
Jul 13 22:10:50 ubuntu kernel: [    3.398286] usbcore: registered new device driver usb
Jul 13 22:10:50 ubuntu kernel: [    3.402862] Driver 'sr' needs updating - please use bus_type methods
Jul 13 22:10:50 ubuntu kernel: [    3.411574] sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
Jul 13 22:10:50 ubuntu kernel: [    3.411659] Uniform CD-ROM driver Revision: 3.20
Jul 13 22:10:50 ubuntu kernel: [    3.416064] PCI: Found IRQ 10 for device 0000:00:13.2
Jul 13 22:10:50 ubuntu kernel: [    3.416155] PCI: Sharing IRQ 10 with 0000:00:02.7
Jul 13 22:10:50 ubuntu kernel: [    3.416224] PCI: Sharing IRQ 10 with 0000:00:0d.0
Jul 13 22:10:50 ubuntu kernel: [    3.416314] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jul 13 22:10:50 ubuntu kernel: [    3.416420] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
Jul 13 22:10:50 ubuntu kernel: [    3.416571] ehci_hcd 0000:00:13.2: irq 10, io mem 0xcfffde00
Jul 13 22:10:50 ubuntu kernel: [    3.418219] sr1: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
Jul 13 22:10:50 ubuntu kernel: [    3.428251] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
Jul 13 22:10:50 ubuntu kernel: [    3.428570] usb usb1: configuration #1 chosen from 1 choice
Jul 13 22:10:50 ubuntu kernel: [    3.428673] hub 1-0:1.0: USB hub found
Jul 13 22:10:50 ubuntu kernel: [    3.428753] hub 1-0:1.0: 4 ports detected
Jul 13 22:10:50 ubuntu kernel: [    3.605872] kjournald starting.  Commit interval 5 seconds
Jul 13 22:10:50 ubuntu kernel: [    3.605962] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:10:50 ubuntu kernel: [    3.772257] usb 1-1: new high speed USB device using ehci_hcd and address 2
Jul 13 22:10:50 ubuntu kernel: [    3.905784] usb 1-1: configuration #1 chosen from 1 choice
Jul 13 22:10:50 ubuntu kernel: [    9.571878] eth0: link down
Jul 13 22:10:50 ubuntu kernel: [   10.711434] NET: Registered protocol family 10
Jul 13 22:10:50 ubuntu kernel: [   10.711966] lo: Disabled Privacy Extensions
Jul 13 22:10:50 ubuntu kernel: [   10.712509] ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul 13 22:10:50 ubuntu kernel: [   11.436931] Linux agpgart interface v0.103
Jul 13 22:10:50 ubuntu kernel: [   11.584322] agpgart: Detected SiS chipset - id:1845
Jul 13 22:10:50 ubuntu kernel: [   11.598679] agpgart: AGP aperture is 64M @ 0xd0000000
Jul 13 22:10:50 ubuntu kernel: [   11.960979] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
Jul 13 22:10:50 ubuntu kernel: [   12.264938] Initializing USB Mass Storage driver...
Jul 13 22:10:50 ubuntu kernel: [   12.269153] scsi2 : SCSI emulation for USB Mass Storage devices
Jul 13 22:10:50 ubuntu kernel: [   12.269667] usbcore: registered new interface driver usb-storage
Jul 13 22:10:50 ubuntu kernel: [   12.269740] USB Mass Storage support registered.
Jul 13 22:10:50 ubuntu kernel: [   12.345305] PCI: Found IRQ 10 for device 0000:00:02.7
Jul 13 22:10:50 ubuntu kernel: [   12.345398] PCI: Sharing IRQ 10 with 0000:00:0d.0
Jul 13 22:10:50 ubuntu kernel: [   12.345470] PCI: Sharing IRQ 10 with 0000:00:13.2
Jul 13 22:10:50 ubuntu kernel: [   12.660798] intel8x0_measure_ac97_clock: measured 55884 usecs
Jul 13 22:10:50 ubuntu kernel: [   12.660875] intel8x0: clocking to 48000
Jul 13 22:10:50 ubuntu kernel: [   12.812879] input: ImPS/2 Logitech Wheel Mouse as /class/input/input1
Jul 13 22:10:50 ubuntu kernel: [   13.220607] loop: module loaded
Jul 13 22:10:50 ubuntu kernel: [   13.332340] Adding 1048568k swap on /dev/mapper/lvm--sdb-swap.  Priority:-1 extents:1 across:1048568k
Jul 13 22:10:50 ubuntu kernel: [   13.803268] EXT3 FS on dm-1, internal journal
Jul 13 22:10:50 ubuntu kernel: [   16.219425] kjournald starting.  Commit interval 5 seconds
Jul 13 22:10:50 ubuntu kernel: [   16.219680] EXT3 FS on sdb1, internal journal
Jul 13 22:10:50 ubuntu kernel: [   16.219687] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:10:50 ubuntu kernel: [   16.249832] kjournald starting.  Commit interval 5 seconds
Jul 13 22:10:50 ubuntu kernel: [   16.250114] EXT3 FS on dm-2, internal journal
Jul 13 22:10:50 ubuntu kernel: [   16.250120] EXT3-fs: mounted filesystem with ordered data mode.
Jul 13 22:10:50 ubuntu kernel: [   17.279427] scsi 2:0:0:0: Direct-Access     WDC WD40 0UE-22HCT0       0811 PQ: 0 ANSI: 0
Jul 13 22:10:50 ubuntu kernel: [   17.301185] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
Jul 13 22:10:50 ubuntu kernel: [   17.327475] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
Jul 13 22:10:50 ubuntu kernel: [   17.349155] sd 2:0:0:0: [sdc] 78140160 512-byte hardware sectors (40008 MB)
Jul 13 22:10:50 ubuntu kernel: [   17.375431] sd 2:0:0:0: [sdc] Test WP failed, assume Write Enabled
Jul 13 22:10:50 ubuntu kernel: [   17.375522]  sdc: sdc1
Jul 13 22:10:50 ubuntu kernel: [   17.389437] sd 2:0:0:0: [sdc] Attached SCSI disk
Jul 13 22:10:50 ubuntu kernel: [   17.389505] sd 2:0:0:0: Attached scsi generic sg4 type 0
Jul 13 22:10:50 ubuntu kernel: [   18.342582] powernow_k7: Unknown symbol acpi_processor_notify_smm
Jul 13 22:10:50 ubuntu kernel: [   18.342644] powernow_k7: Unknown symbol acpi_processor_unregister_performance
Jul 13 22:10:50 ubuntu kernel: [   18.342753] powernow_k7: Unknown symbol acpi_processor_register_performance
Jul 13 22:10:50 ubuntu kernel: [   18.363176] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
Jul 13 22:10:50 ubuntu kernel: [   18.363238] acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
Jul 13 22:10:50 ubuntu kernel: [   18.363445] acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
Jul 13 22:10:50 ubuntu kernel: [   18.363528] acpi_cpufreq: Unknown symbol acpi_processor_register_performance
Jul 13 22:10:54 ubuntu dhcdbd: Started up.
Jul 13 22:16:35 ubuntu kernel: [  363.646217] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
Jul 13 22:16:35 ubuntu kernel: [  363.646289] acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
Jul 13 22:16:35 ubuntu kernel: [  363.646497] acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
Jul 13 22:16:35 ubuntu kernel: [  363.646579] acpi_cpufreq: Unknown
symbol acpi_processor_register_performance
