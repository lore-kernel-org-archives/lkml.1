Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbYDKU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbYDKU2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbYDKU2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:28:07 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:41959 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758942AbYDKU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:28:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=KS1FZZyjeNwDLF/XT8t8Fjp15oOzTYBAe7vLAI/ZK556sJq0lmfDEPyGYQCM/1mcOmTZ3YzkbXF12P8mHsoJUxp1LssQcyNZdRAM1NHRs9AfrnNJ9R/sB3v03beBSAlIUL1UFheabsJKK7MXY0DGnuw+yaly0KJfVmEmO0f4Tqw=;
X-YMail-OSG: C3pE.fEVM1lIdCuf3ilEnKIV.rHCR.oOaJop3kk7
Date: Fri, 11 Apr 2008 13:28:01 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FFB03A.8060305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <628754.88392.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Snook <csnook@redhat.com> wrote:

> Marc Perkel wrote:
> > I was just wondering if there were any known
> issues
> > with AMD quad core phenom clock drift problems?
> I';m
> > running a 2.6.24 kernel and it's losing time. I
> > remember the first dual core AMD chips had a lot
> of
> > clock issues.
> > 
> > If this is something new let me know what
> information
> > to check and post to this list.
> 
> When reporting clock problems, please post dmesg. 
> This has all the 
> interesting timekeeping-related log messages from
> the kernel.  Please 
> also describe the drift quantitatively.
> 
> -- Chris
> 

OK - thanks Chris.

The drift is small. It loses a few seconds every hour.
And it might not be kernel related. I just remembered
the early dual core days when this took months to get
right. I'm running several dual core computers and the
only one drifting is the quad. All are running the
same OS and kernel.

Initializing cgroup subsys cpuset
Linux version 2.6.24-ovz004.1
(root@centos4-build.vzlin.sw.ru) (gcc version 3.4.6
20060404 (Red Hat 3.4.6-3)) #1 SMP Tue Mar 25 16:23:06
MSK 2008
Command line: ro root=LABEL=/ vga=1 pci=nommconf
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00
(usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000
(reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000
(reserved)
 BIOS-e820: 0000000000100000 - 00000000cffa0000
(usable)
 BIOS-e820: 00000000cffa0000 - 00000000cffae000 (ACPI
data)
 BIOS-e820: 00000000cffae000 - 00000000cffd0000 (ACPI
NVS)
 BIOS-e820: 00000000cffd0000 - 00000000d0000000
(reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000
(reserved)
 BIOS-e820: 0000000100000000 - 0000000220000000
(usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200
used
Entering add_active_range(0, 256, 851872) 1 entries of
3200 used
Entering add_active_range(0, 1048576, 2228224) 2
entries of 3200 used
end_pfn_map = 2228224
DMI present.
ACPI: RSDP 000FB500, 0014 (r0 ACPIAM)
ACPI: RSDT CFFA0000, 003C (r1 032108 RSDT1622 20080321
MSFT       97)
ACPI: FACP CFFA0200, 0084 (r1 032108 FACP1622 20080321
MSFT       97)
ACPI: DSDT CFFA05C0, 6DFD (r1  A0896 A0896001        1
INTL 20051117)
ACPI: FACS CFFAE000, 0040
ACPI: APIC CFFA0390, 006C (r1 032108 APIC1622 20080321
MSFT       97)
ACPI: MCFG CFFA0400, 003C (r1 032108 OEMMCFG  20080321
MSFT       97)
ACPI: OEMB CFFAE040, 0071 (r1 032108 OEMB1622 20080321
MSFT       97)
ACPI: HPET CFFA73C0, 0038 (r1 032108 OEMHPET  20080321
MSFT       97)
ACPI: SSDT CFFA7400, 0544 (r1 A_M_I_ POWERNOW        1
AMD         1)
No NUMA configuration found
Faking a node at 0000000000000000-0000000220000000
Entering add_active_range(0, 0, 158) 0 entries of 3200
used
Entering add_active_range(0, 256, 851872) 1 entries of
3200 used
Entering add_active_range(0, 1048576, 2228224) 2
entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000220000000
 [ffffe20000000000-ffffe200001fffff] PMD
->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD
->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD
->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD
->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD
->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD
->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD
->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD
->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD
->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD
->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD
->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD
->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD
->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD
->ffff810004600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD
->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD
->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD
->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD
->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD
->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD
->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD
->ffff810006200000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD
->ffff810006600000 on node 0
 [ffffe20002c00000-ffffe20002dfffff] PMD
->ffff810006a00000 on node 0
 [ffffe20002e00000-ffffe20002ffffff] PMD
->ffff810006e00000 on node 0
 [ffffe20003000000-ffffe200031fffff] PMD
->ffff810007200000 on node 0
 [ffffe20003200000-ffffe200033fffff] PMD
->ffff810007600000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD
->ffff810007a00000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD
->ffff810007e00000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD
->ffff810008200000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD
->ffff810008600000 on node 0
 [ffffe20004800000-ffffe200049fffff] PMD
->ffff810008a00000 on node 0
 [ffffe20004a00000-ffffe20004bfffff] PMD
->ffff810008e00000 on node 0
 [ffffe20004c00000-ffffe20004dfffff] PMD
->ffff810009200000 on node 0
 [ffffe20004e00000-ffffe20004ffffff] PMD
->ffff810009600000 on node 0
 [ffffe20005000000-ffffe200051fffff] PMD
->ffff810009a00000 on node 0
 [ffffe20005200000-ffffe200053fffff] PMD
->ffff810009e00000 on node 0
 [ffffe20005400000-ffffe200055fffff] PMD
->ffff81000a200000 on node 0
 [ffffe20005600000-ffffe200057fffff] PMD
->ffff81000a600000 on node 0
 [ffffe20005800000-ffffe200059fffff] PMD
->ffff81000aa00000 on node 0
 [ffffe20005a00000-ffffe20005bfffff] PMD
->ffff81000ae00000 on node 0
 [ffffe20005c00000-ffffe20005dfffff] PMD
->ffff81000b200000 on node 0
 [ffffe20005e00000-ffffe20005ffffff] PMD
->ffff81000b600000 on node 0
 [ffffe20006000000-ffffe200061fffff] PMD
->ffff81000ba00000 on node 0
 [ffffe20006200000-ffffe200063fffff] PMD
->ffff81000be00000 on node 0
 [ffffe20006400000-ffffe200065fffff] PMD
->ffff81000c200000 on node 0
 [ffffe20006600000-ffffe200067fffff] PMD
->ffff81000c600000 on node 0
 [ffffe20006800000-ffffe200069fffff] PMD
->ffff81000ca00000 on node 0
 [ffffe20006a00000-ffffe20006bfffff] PMD
->ffff81000ce00000 on node 0
 [ffffe20006c00000-ffffe20006dfffff] PMD
->ffff81000d200000 on node 0
 [ffffe20006e00000-ffffe20006ffffff] PMD
->ffff81000d600000 on node 0
 [ffffe20007000000-ffffe200071fffff] PMD
->ffff81000da00000 on node 0
 [ffffe20007200000-ffffe200073fffff] PMD
->ffff81000de00000 on node 0
 [ffffe20007400000-ffffe200075fffff] PMD
->ffff81000e200000 on node 0
 [ffffe20007600000-ffffe200077fffff] PMD
->ffff81000e600000 on node 0
 [ffffe20007800000-ffffe200079fffff] PMD
->ffff81000ea00000 on node 0
 [ffffe20007a00000-ffffe20007bfffff] PMD
->ffff81000ee00000 on node 0
 [ffffe20007c00000-ffffe20007dfffff] PMD
->ffff81000f200000 on node 0
 [ffffe20007e00000-ffffe20007ffffff] PMD
->ffff81000f600000 on node 0
 [ffffe20008000000-ffffe200081fffff] PMD
->ffff81000fa00000 on node 0
 [ffffe20008200000-ffffe200083fffff] PMD
->ffff81000fe00000 on node 0
 [ffffe20008400000-ffffe200085fffff] PMD
->ffff810010200000 on node 0
 [ffffe20008600000-ffffe200087fffff] PMD
->ffff810010600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2228224
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   851872
    0:  1048576 ->  2228224
On node 0 totalpages: 2031422
  DMA zone: 64 pages used for memmap
  DMA zone: 1313 pages reserved
  DMA zone: 2621 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 831456 pages, LIFO batch:31
  Normal zone: 18432 pages used for memmap
  Normal zone: 1161216 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000]
gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl
dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low
level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8300 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region:
000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region:
000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region:
00000000000a0000 - 00000000000e4000
swsusp: Registered nosave memory region:
00000000000e4000 - 0000000000100000
swsusp: Registered nosave memory region:
00000000cffa0000 - 00000000cffae000
swsusp: Registered nosave memory region:
00000000cffae000 - 00000000cffd0000
swsusp: Registered nosave memory region:
00000000cffd0000 - 00000000d0000000
swsusp: Registered nosave memory region:
00000000d0000000 - 00000000ff700000
swsusp: Registered nosave memory region:
00000000ff700000 - 0000000100000000
Allocating PCI resources starting at d4000000 (gap:
d0000000:2f700000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 42224 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.
 Total pages: 1995293
Policy zone: Normal
Kernel command line: ro root=LABEL=/ vga=1
pci=nommconf
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
hpet clockevent registered
TSC calibrated against HPET
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2300.941 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 14000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 14000000
Memory: 7923908k/8912896k available (2448k kernel
code, 201780k reserved, 1425k data, 336k init)
SLUB: Genslabs=12, HWalign=64, Order=0-1,
MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine..
4607.72 BogoMIPS (lpj=2303860)
Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10,
4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Page beancounter hash is 1048576 entries.
Using local APIC timer interrupts.
APIC timer calibration result 12505124
Detected 12.505 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine..
4602.18 BogoMIPS (lpj=2301094)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine..
4602.08 BogoMIPS (lpj=2301040)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine..
4602.08 BogoMIPS (lpj=2301043)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
Brought up 4 CPUs
net_namespace: 144 bytes
Time: 18:05:40  Date: 04/11/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
Error attaching device data
Error attaching device data
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 12 14
15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14
15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14
15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14
15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14
15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14
15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 *11 12 14
15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14
15) *0, disabled.
ACPI Warning (tbutils-0217): Incorrect checksum in
table [OEMB] -  3A, should be 2D [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
DMAR:No DMAR devices found
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 14000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP
aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
system 00:01: iomem range 0x0-0x0 could not be
reserved
system 00:01: iomem range 0x0-0x0 could not be
reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has
been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff could
not be reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been
reserved
system 00:0b: ioport range 0x40b-0x40b has been
reserved
system 00:0b: ioport range 0x4d6-0x4d6 has been
reserved
system 00:0b: ioport range 0xc00-0xc01 has been
reserved
system 00:0b: ioport range 0xc14-0xc14 has been
reserved
system 00:0b: ioport range 0xc50-0xc51 has been
reserved
system 00:0b: ioport range 0xc52-0xc52 has been
reserved
system 00:0b: ioport range 0xc6c-0xc6c has been
reserved
system 00:0b: ioport range 0xc6f-0xc6f has been
reserved
system 00:0b: ioport range 0xcd0-0xcd1 has been
reserved
system 00:0b: ioport range 0xcd2-0xcd3 has been
reserved
system 00:0b: ioport range 0xcd4-0xcd5 has been
reserved
system 00:0b: ioport range 0xcd6-0xcd7 has been
reserved
system 00:0b: ioport range 0xcd8-0xcdf has been
reserved
system 00:0b: ioport range 0xb00-0xb3f has been
reserved
system 00:0b: ioport range 0x800-0x89f has been
reserved
system 00:0b: ioport range 0xb20-0xb2f has been
reserved
system 00:0b: ioport range 0x900-0x90f has been
reserved
system 00:0b: ioport range 0x910-0x91f has been
reserved
system 00:0b: ioport range 0xfe00-0xfefe has been
reserved
system 00:0b: iomem range 0xffb80000-0xffbfffff could
not be reserved
system 00:0b: iomem range 0xfec10000-0xfec1001f has
been reserved
system 00:0c: ioport range 0x230-0x23f has been
reserved
system 00:0c: ioport range 0x290-0x29f has been
reserved
system 00:0c: ioport range 0xa20-0xa2f has been
reserved
system 00:0c: ioport range 0xa30-0xa3f has been
reserved
system 00:0d: iomem range 0xe0000000-0xefffffff has
been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be
reserved
system 00:0e: iomem range 0xc0000-0xcffff has been
reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be
reserved
system 00:0e: iomem range 0x100000-0xcfffffff could
not be reserved
system 00:0e: iomem range 0xfec00000-0xffffffff could
not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: fbd00000-fbefffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:06.0
  IO window: e000-efff
  MEM window: fbf00000-fbffffff
  PREFETCH window: faf00000-faffffff
PCI: Bridge: 0000:00:14.4
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 18 (level,
low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:06.0 to
64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576
bytes)
TCP: Hash tables configured (established 524288 bind
65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3236k freed
VDSO: variable vdso_jiffies broken
VDSO: variable vdso_vgetcpu_mode broken
VDSO: variable vdso_vsyscall_gtod_data broken
audit: initializing netlink socket (disabled)
audit(1207937139.687:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096
bytes)
Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:05.0
PCI: Setting latency timer of device 0000:00:06.0 to
64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [P001] (supports 8 throttling states)
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K
size 4096 blocksize
input: Macintosh mouse button emulation as
/devices/virtual/input/input0
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core
driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 4:236:89
Freeing unused kernel memory: 336k freed
ACPI: PCI Interrupt 0000:00:12.2[B] -> GSI 17 (level,
low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered,
assigned bus number 1
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff000
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:13.2[B] -> GSI 19 (level,
low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered,
assigned bus number 2
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcfa800
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host
Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level,
low) -> IRQ 16
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered,
assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfe000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 16 (level,
low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered,
assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfd000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level,
low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered,
assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfc000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 18 (level,
low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered,
assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfb000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:14.5[C] -> GSI 18 (level,
low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered,
assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcf9000
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type
methods
libata version 3.00 loaded.
ahci 0000:00:11.0: version 3.0
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 22 (level,
low) -> IRQ 22
ahci 0000:00:11.0: controller can't do 64bit DMA,
forcing 32bit
ahci 0000:00:11.0: controller can't do PMP, turning
off CAP_PMP
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3
Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: ncq sntf ilck pm led clo pio
slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfbcff800 port
0xfbcff900 irq 2302
ata2: SATA max UDMA/133 abar m1024@0xfbcff800 port
0xfbcff980 irq 2302
ata3: SATA max UDMA/133 abar m1024@0xfbcff800 port
0xfbcffa00 irq 2302
ata4: SATA max UDMA/133 abar m1024@0xfbcff800 port
0xfbcffa80 irq 2302
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: ST3750330AS, AD14, max UDMA/133
ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ
(depth 31/32)
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3750330AS  
   AD14 PQ: 0 ANSI: 5
sd 3:0:0:0: [sda] 1465149168 512-byte hardware sectors
(750156 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sda] 1465149168 512-byte hardware sectors
(750156 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 3:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 3:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as
/devices/virtual/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as
/devices/virtual/input/input2
ACPI: Power Button (CM) [PWRB]
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level,
low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to
64
eth0: RTL8168c/8111c at 0xffffc20001f56000,
00:1f:c6:20:af:f8, XID 3c2000c0 IRQ 2301
shpchp: Standard Hot Plug PCI Controller Driver
version: 0.4
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level,
low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:14.1 to
64
ACPI: PCI interrupt for device 0000:00:14.1 disabled
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level,
low) -> IRQ 16
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma
0xff00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma
0xff08 irq 15
input: PC Speaker as
/devices/platform/pcspkr/input/input3
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level,
low) -> IRQ 16
ALSA sound/pci/hda/hda_intel.c:727: codec_mask = 0x1
hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS...
ALSA sound/pci/hda/hda_codec.c:2760: autoconfig:
line_outs=4 (0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:2764:    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2768:    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2776:    inputs:
mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x0,
aux=0x0
md: md0 stopped.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02)
initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 8032492k swap on /dev/sda3.  Priority:1
extents:1 across:8032492k



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
