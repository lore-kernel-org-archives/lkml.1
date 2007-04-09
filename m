Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbXDIRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbXDIRhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXDIRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:37:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbXDIRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:37:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.21-rc6-mm1
Date: Mon, 9 Apr 2007 19:40:52 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org,
       "Adam Belay" <abelay@novell.com>
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lqnGGs81FKUL2ba"
Message-Id: <200704091940.53439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lqnGGs81FKUL2ba
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 9 April 2007 18:14, Pallipadi, Venkatesh wrote:
> 
> >-----Original Message-----
> >From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> >Sent: Monday, April 09, 2007 9:08 AM
> >To: Andrew Morton
> >Cc: linux-kernel@vger.kernel.org; randy.dunlap@oracle.com; 
> >lenb@kernel.org; Pallipadi, Venkatesh
> >Subject: Re: 2.6.21-rc6-mm1
> >
> >On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
> >> 
> >> 
> >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
> >.6.21-rc6/2.6.21-rc6-mm1/
> >> 
> >> 
> >> - Lots of x86 updates
> >> 
> >> - This is a 25MB diff against mainline, which is rather large.
> >
> >The cpuidle thing tends to hang my x86-64 machines on boot.
> >
> 
> Hi Rafael,
> 
> At what point during boot does it hang?

When mounting the root filesystem.  It hangs completely, even the magic SysRq
doesn't work

> Can you send me the last few messages before the hang.

Freeing unused kernel memory: 240k freed
Write protecting the kernel read-only data: 4356k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
ACPI: Invalid PBLK length [0]
cpuidle: driver acpi_idle failed to attach to cpu 0
cpuidle: using driver acpi_idle
ACPI: Thermal Zone [THRM] (59 C)
ACPI: Fan [FN00] (on)
Attempting manual resume
swsusp: Resume From Partition 22:3
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdc6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

> And full dmesg when cpuidle is not configured will help as well.

Attached.

Greetings,
Rafael

--Boundary-00=_lqnGGs81FKUL2ba
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.log"

Linux version 2.6.21-rc6-mm1 (rafael@asus) (gcc version 4.1.2 20061115 (pre=
release) (SUSE Linux)) #2 SMP Mon Apr 9 15:53:49 CEST 2007
Command line: root=3D/dev/hdc6 vga=3D792 selinux=3D0 noapic resume=3D/dev/h=
dc3 console=3DttyS0,57600 console=3Dtty0 earlyprintk=3Dserial,ttyS0,57600 d=
ebug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005ff40000 (usable)
 BIOS-e820: 000000005ff40000 - 000000005ff50000 (ACPI data)
 BIOS-e820: 000000005ff50000 - 0000000060000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 393024) 1 entries of 256 used
end_pfn_map =3D 1043969
DMI 2.3 present.
ACPI: RSDP 000F76E0, 0014 (r0 ACPIAM)
ACPI: RSDT 5FF40000, 002C (r1 A M I  OEMRSDT   5000425 MSFT       97)
ACPI: FACP 5FF40200, 0081 (r1 A M I  OEMFACP   5000425 MSFT       97)
ACPI: DSDT 5FF40400, 6383 (r1  L5DK8 L5DK8014       14 INTL  2002026)
ACPI: FACS 5FF50000, 0040
ACPI: OEMB 5FF50040, 0041 (r1 A M I  OEMBIOS   5000425 MSFT       97)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 393024) 1 entries of 256 used
sizeof(struct page) =3D 160
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   393024
On node 0 totalpages: 392927
Node 0 memmap at 0xffff810001000000 size 62914560 first pfn 0xffff810001000=
000
  DMA zone: 160 pages used for memmap
  DMA zone: 2333 pages reserved
  DMA zone: 1506 pages, LIFO batch:0
  DMA32 zone: 15192 pages used for memmap
  DMA32 zone: 373736 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
Intel MultiProcessor Specification v1.1
MPTABLE: OEM ID: ASUSTeK  MPTABLE: Product ID: L5D          MPTABLE: APIC a=
t: 0xFEE00000
Processor #0 (Bootup-CPU)
I/O APIC #1 at 0xFEC00000.
Setting APIC routing to flat
Processors: 1
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 70000000 (gap: 60000000:9ec00000)
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 35392 bytes of per cpu data
Built 1 zonelists.  Total pages: 375242
Kernel command line: root=3D/dev/hdc6 vga=3D792 selinux=3D0 noapic resume=
=3D/dev/hdc3 console=3DttyS0,57600 console=3Dtty0 earlyprintk=3Dserial,ttyS=
0,57600 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 1795.406 MHz processor.
Console: colour dummy device 80x25
console handover: boot [earlyserP=12"=80=FF=FF=FF=FF0] -> real [tty0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
=2E.. MAX_LOCKDEP_SUBCLASSES:    8
=2E.. MAX_LOCK_DEPTH:          30
=2E.. MAX_LOCKDEP_KEYS:        2048
=2E.. CLASSHASH_SIZE:           1024
=2E.. MAX_LOCKDEP_ENTRIES:     8192
=2E.. MAX_LOCKDEP_CHAINS:      16384
=2E.. CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ e8000000 size 128 MB
Memory: 1492736k/1572096k available (2761k kernel code, 78644k reserved, 18=
69k data, 236k init)
Calibrating delay using timer specific routine.. 3594.03 BogoMIPS (lpj=3D71=
88074)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
SMP alternatives: switching to UP code
=46reeing SMP alternatives: 25k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c20)
Using local APIC timer interrupts.
result 12468103
Detected 12.468 MHz APIC timer.
Brought up 1 CPUs
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0F03:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0510:00
PM: Adding info for acpi:PNP0400:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:ATK0100:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:08
PM: Adding info for acpi:PNP0C0F:09
PM: Adding info for acpi:PNP0C0F:0a
PM: Adding info for acpi:PNP0C0F:0b
PM: Adding info for acpi:PNP0C0F:0c
PM: Adding info for acpi:PNP0C0F:0d
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:thermal:01
PM: Adding info for acpi:PNP0C0B:00
PM: Adding info for acpi:power_resource:00
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
0000:00:08.0: cannot adjust BAR0 (not I/O)
0000:00:08.0: cannot adjust BAR1 (not I/O)
0000:00:08.0: cannot adjust BAR2 (not I/O)
0000:00:08.0: cannot adjust BAR3 (not I/O)
PCI: Bus #04 (-#07) is hidden behind  bridge #02 (-#04) (try 'pci=3Dassign-=
busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:01.1
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:02.2
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:08.0
PM: Adding info for pci:0000:00:0a.0
PM: Adding info for pci:0000:00:0b.0
PM: Adding info for pci:0000:00:18.0
PM: Adding info for pci:0000:00:18.1
PM: Adding info for pci:0000:00:18.2
PM: Adding info for pci:0000:00:18.3
PM: Adding info for pci:0000:02:00.0
PM: Adding info for pci:0000:02:01.0
PM: Adding info for pci:0000:02:01.1
PM: Adding info for pci:0000:02:01.2
PM: Adding info for pci:0000:02:01.3
PM: Adding info for pci:0000:02:01.4
PM: Adding info for pci:0000:02:02.0
PM: Adding info for pci:0000:01:00.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUS0] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUS1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUS2] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LKLN] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LAUI] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LKMO] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LKSM] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LTID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disable=
d.
ACPI: PCI Interrupt Link [LATA] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: Power Resource [GFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 128M @ 0xe8000000
ACPI: RTC can wake from S4
pnp: 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:06: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:06: iomem range 0xff780000-0xff7bffff has been reserved
pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0c: iomem range 0x100000-0x5fffffff could not be reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
Time: tsc clocksource has been installed.
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PCI: Failed to allocate mem resource #10:4000000@100000000 for 0000:02:01.0
PCI: Failed to allocate mem resource #10:4000000@100000000 for 0000:02:01.1
PCI: Bus 3, cardbus bridge: 0000:02:01.0
  IO window: 0000b000-0000b0ff
  IO window: 0000b400-0000b4ff
  PREFETCH window: 70000000-73ffffff
PCI: Bus 4, cardbus bridge: 0000:02:01.1
  IO window: 0000b800-0000b8ff
  IO window: 0000bc00-0000bcff
  PREFETCH window: 74000000-77ffffff
PCI: Bridge: 0000:00:0a.0
  IO window: b000-dfff
  MEM window: f8a00000-feafffff
  PREFETCH window: 70000000-77ffffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f6900000-f89fffff
  PREFETCH window: c6800000-e67fffff
PCI: Setting latency timer of device 0000:00:0a.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNKA] -> GSI 9 (level, low) ->=
 IRQ 9
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:01.1[B] -> Link [LNKB] -> GSI 11 (level, low) -=
> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
=46reeing initrd memory: 4378k freed
PM: Adding info for No Bus:mcelog
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
audit: initializing netlink socket (disabled)
audit(1176137535.744:1): initialized
No parameters - using defaults.
  1   1   1   1   1 s   1/1    403453    461321    674042   1213094    6011=
75
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
PM: Adding info for platform:vesafb.0
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000100000, using 6144=
k, total 65536k
vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D1
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
PM: Adding info for No Bus:fb0
PM: Adding info for No Bus:vtcon1
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
PM: Adding info for platform:serial8250
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Removing info for No Bus:ttyS0
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
PM: Adding info for No Bus:ttyS0
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
PM: Adding info for No Bus:lo
PM: Adding info for No Bus:input0
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
NFORCE3-150: IDE controller at PCI slot 0000:00:08.0
NFORCE3-150: chipset revision 165
NFORCE3-150: not 100% native mode: will probe irqs later
NFORCE3-150: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-150: 0000:00:08.0 (rev a5) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:pio, hdb:DMA
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hdb: TOSHIBA DVD-ROM SD-R2512, ATAPI CD/DVD-ROM drive
PM: Adding info for No Bus:ide0
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
PM: Adding info for ide:0.1
Probing IDE interface ide1...
hdc: SAMSUNG HM100JC, ATA DISK drive
PM: Adding info for No Bus:ide1
ide1 at 0x170-0x177,0x376 on irq 15
PM: Adding info for ide:1.0
hdc: max request size: 512KiB
hdc: 195371568 sectors (100030 MB) w/8192KiB Cache, CHS=3D16383/255/63, UDM=
A(100)
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3 hdc4 < hdc5 hdc6 hdc7 hdc8 hdc9 hdc10 >
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for No Bus:mice
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
PM: Adding info for serio:serio2
PM: Adding info for serio:serio3
PM: Adding info for serio:serio4
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
PM: Adding info for No Bus:input1
input: AT Translated Set 2 keyboard as /class/input/input1
PM: Adding info for No Bus:input2
input: PC Speaker as /class/input/input2
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x926eb1, caps: 0x804719/0x0
PM: Adding info for No Bus:input3
input: SynPS/2 Synaptics TouchPad as /class/input/input3
PM: Adding info for No Bus:mouse1
async_tx: api initialized (sync-only)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  5755.000 MB/sec
xor: using function: generic_sse (5755.000 MB/sec)
TCP cubic registered
NET: Registered protocol family 1
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ processors (version =
2.00.00)
powernow-k8:    0 : fid 0x0 (800 MHz), vid 0x12
powernow-k8:    1 : fid 0x8 (1600 MHz), vid 0x6
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x2
swsusp: Resume From Partition /dev/hdc3
PM: Checking swsusp image.
PM: Resume from disk failed.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
=46reeing unused kernel memory: 236k freed
Write protecting the kernel read-only data: 4346k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
spurious 8259A interrupt: IRQ7.
ACPI: Invalid PBLK length [0]
ACPI: Thermal Zone [THRM] (52 C)
ACPI: Fan [FN00] (on)
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
swsusp: Resume From Partition 22:3
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdc6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
PM: Adding info for platform:parport_pc.956
PM: Removing info for platform:parport_pc.956
PM: Adding info for platform:parport_pc.888
PM: Removing info for platform:parport_pc.888
PM: Adding info for platform:parport_pc.632
PM: Removing info for platform:parport_pc.632
lp0: using parport0 (interrupt-driven).
PM: Adding info for No Bus:event0
PM: Adding info for No Bus:event1
PM: Adding info for No Bus:event2
PM: Adding info for No Bus:event3
PM: Adding info for No Bus:i2c-0
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
i2c-adapter i2c-0: adapter [SMBus nForce2 adapter at 5000] registered
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
PM: Adding info for No Bus:i2c-1
i2c-adapter i2c-1: adapter [SMBus nForce2 adapter at 5040] registered
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5040
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUS2] -> GSI 5 (level, low) ->=
 IRQ 5
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
PM: Adding info for No Bus:timer
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: reset hcs_params 0x102486 dbg=3D1 cc=3D2 pcc=3D4 !pp=
c ports=3D6
ehci_hcd 0000:00:02.2: reset portroute 0 0 1 1 1 0=20
ehci_hcd 0000:00:02.2: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:02.2: park 0
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: supports USB remote wakeup
ehci_hcd 0000:00:02.2: irq 5, io mem 0xfebfdc00
ehci_hcd 0000:00:02.2: reset command 080b02 park=3D3 ithresh=3D8 period=3D1=
024 Reset HALT
ehci_hcd 0000:00:02.2: init command 010009 (park)=3D0 ithresh=3D1 period=3D=
256 RUN
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
sk98lin: driver has been replaced by the skge driver and is scheduled for r=
emoval
ieee80211_crypt: registered algorithm 'NULL'
PM: Adding info for No Bus:rtc0
rtc_cmos: dev (254:0)
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:02: i/o registers already in use
usb usb1: default language 0x0409
PM: Removing info for No Bus:rtc0
rtc_cmos: probe of 00:02 failed with error -16
usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.21-rc6-mm1 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.2
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.=
com>
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hdb: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:02.2: GetStatus port 3 status 001403 POWER sig=3Dk CSC CON=
NECT
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 11 (level, low) -=
> IRQ 11
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
bcm43xx driver
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: irq 11, io mem 0xfebfb000
ohci_hcd 0000:00:02.0: resetting from state 'reset', control =3D 0x600
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:02.2: port 3 low speed --> companion
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0080
ohci_hcd 0000:00:02.0: roothub.a 01001203 POTPGT=3D1 NOCP NPS NDP=3D3(3)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
ehci_hcd 0000:00:02.2: GetStatus port 3 status 003002 POWER OWNER sig=3Dse0=
 CSC
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0008
usb usb2: default language 0x0409
usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.21-rc6-mm1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: no over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 11 (level, low) -=
> IRQ 11
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: created debug files
ohci_hcd 0000:00:02.1: irq 11, io mem 0xfebfc000
ohci_hcd 0000:00:02.1: resetting from state 'reset', control =3D 0x600
ohci_hcd 0000:00:02.1: OHCI controller state
ohci_hcd 0000:00:02.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.1: control 0x683 RWE RWC HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.1: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.1: intrstatus 0x00000044 RHSC SF
ohci_hcd 0000:00:02.1: intrenable 0x8000000a MIE RD WDH
ohci_hcd 0000:00:02.1: hcca frame #007a
ohci_hcd 0000:00:02.1: roothub.a 01001203 POTPGT=3D1 NOCP NPS NDP=3D3(3)
ohci_hcd 0000:00:02.1: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.1: roothub.portstatus [0] 0x00010301 CSC LSDA PPS CCS
ohci_hcd 0000:00:02.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.1: roothub.portstatus [2] 0x00000100 PPS
usb usb3: default language 0x0409
usb usb3: new device found, idVendor=3D0000, idProduct=3D0000
usb usb3: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.21-rc6-mm1 ohci_hcd
usb usb3: SerialNumber: 0000:00:02.1
PM: Adding info for usb:usb3
usb usb3: uevent
usb usb3: usb_probe_device
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
PM: Adding info for usb:3-0:1.0
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: no over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00010301 CSC =
LSDA PPS CCS
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
PM: Adding info for No Bus:eth0
eth0: Yukon Gigabit Ethernet 10/100/1000Base-T Adapter
      PrefPort:A  RlmtMode:Check Link State
ACPI: PCI Interrupt 0000:02:01.2[C] -> Link [LNKC] -> GSI 10 (level, low) -=
> IRQ 10
ACPI: PCI Interrupt Link [LAUI] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LAUI] -> GSI 10 (level, low) -=
> IRQ 10
PM: Adding info for ieee1394:fw-host0
PCI: Setting latency timer of device 0000:00:06.0 to 64
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=3D[10]  MMIO=3D[feafd000-feafd=
7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00100303 PRSC=
 LSDA PPS PES CCS
usb 3-1: new low speed USB device using ohci_hcd and address 2
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00100303 PRSC=
 LSDA PPS PES CCS
usb 3-1: skipped 1 descriptor after interface
usb 3-1: default language 0x0409
usb 3-1: new device found, idVendor=3D046d, idProduct=3Dc016
usb 3-1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1: Product: Optical USB Mouse
usb 3-1: Manufacturer: Logitech
PM: Adding info for usb:3-1
usb 3-1: uevent
ohci_hcd 0000:00:02.0: auto-stop root hub
usb 3-1: usb_probe_device
PM: Adding info for No Bus:usbdev3.2_ep00
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
PM: Adding info for usb:3-1:1.0
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
PM: Adding info for No Bus:usbdev3.2_ep81
PM: Adding info for No Bus:usbdev3.2
drivers/usb/core/inode.c: creating file '002'
hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0002
usbcore: registered new interface driver hiddev
usbhid 3-1:1.0: usb_probe_interface
usbhid 3-1:1.0: usb_probe_interface - got id
intel8x0_measure_ac97_clock: measured 107238 usecs
intel8x0: clocking to 48000
PM: Adding info for No Bus:input4
input: Logitech Optical USB Mouse as /class/input/input4
PM: Adding info for No Bus:pcmC0D2p
PM: Adding info for No Bus:pcmC0D1c
PM: Adding info for No Bus:mouse2
PM: Adding info for No Bus:event4
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:02.1=
=2D1
usbcore: registered new interface driver usbhid
PM: Adding info for ac97:0-0:ALC650F
PM: Adding info for No Bus:controlC0
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Yenta: CardBus bridge found at 0000:02:01.0 [1043:1854]
Yenta: ISA IRQ mask 0x0018, PCI irq 9
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0xb000 - 0xdfff
pcmcia: parent PCI bridge Memory window: 0xf8a00000 - 0xfeafffff
pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x77ffffff
PM: Adding info for No Bus:pcmcia_socket0
Yenta: CardBus bridge found at 0000:02:01.1 [1043:1854]
Yenta: ISA IRQ mask 0x0018, PCI irq 11
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #04 to #07
pcmcia: parent PCI bridge I/O window: 0xb000 - 0xdfff
pcmcia: parent PCI bridge Memory window: 0xf8a00000 - 0xfeafffff
pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x77ffffff
PM: Adding info for No Bus:pcmcia_socket1
ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKB] -> GSI 11 (level, low) -=
> IRQ 11
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
PM: Adding info for No Bus:eth1
PM: Adding info for ieee1394:00e018000319b175
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e018000319b175]
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdc5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: hdc9: found reiserfs format "3.6" with standard journal
ReiserFS: hdc9: using ordered data mode
ReiserFS: hdc9: journal params: device hdc9, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hdc9: checking transaction log (hdc9)
ReiserFS: hdc9: Using r5 hash to sort names
ReiserFS: hdc10: found reiserfs format "3.6" with standard journal
ReiserFS: hdc10: using ordered data mode
ReiserFS: hdc10: journal params: device hdc10, size 8192, journal first blo=
ck 18, max trans len 1024, max batch 900, max commit age 30, max trans age =
30
ReiserFS: hdc10: checking transaction log (hdc10)
ReiserFS: hdc10: Using r5 hash to sort names
ReiserFS: hdc7: found reiserfs format "3.6" with standard journal
ReiserFS: hdc7: using ordered data mode
ReiserFS: hdc7: journal params: device hdc7, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hdc7: checking transaction log (hdc7)
ReiserFS: hdc7: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdc8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2104504k swap on /dev/hdc3.  Priority:-1 extents:1 across:2104504k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
ACPI: AC Adapter [AC0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:input5
input: Power Button (FF) as /class/input/input5
PM: Adding info for No Bus:event5
ACPI: Power Button (FF) [PWRF]
PM: Adding info for No Bus:input6
input: Sleep Button (CM) as /class/input/input6
PM: Adding info for No Bus:event6
ACPI: Sleep Button (CM) [SLPB]
PM: Adding info for No Bus:input7
input: Lid Switch as /class/input/input7
PM: Adding info for No Bus:event7
PM: Adding info for No Bus:seq
ACPI: Lid Switch [LID]
PM: Adding info for No Bus:mixer
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:input8
input: Power Button (CM) as /class/input/input8
PM: Adding info for No Bus:event8
ACPI: Power Button (CM) [PWRB]
PM: Adding info for No Bus:adsp
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
Asus Laptop ACPI Extras version 0.30
  L5D model detected, supported
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
ADDRCONF(NETDEV_UP): eth0: link is not ready
NET: Registered protocol family 17
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
eth0: network connection up using port A
    speed:           100
    autonegotiation: yes
    duplex mode:     full
    flowctrl:        symmetric
    irq moderation:  disabled
    scatter-gather:  disabled
    tx-checksum:     disabled
    rx-checksum:     disabled
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
audit(1176130406.837:2): audit_backlog_limit=3D256 old=3D64 by auid=3D42949=
67295 res=3D1
audit(1176130406.857:3): audit_pid=3D4912 old=3D0 by auid=3D4294967295
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
Time: acpi_pm clocksource has been installed.
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3


--Boundary-00=_lqnGGs81FKUL2ba--
