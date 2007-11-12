Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXKLSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXKLSIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXKLSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:08:39 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:51869 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXKLSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:08:37 -0500
From: Bernd Strieder <strieder@informatik.uni-kl.de>
Organization: TU Kaiserlautern
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86_64 SATA DVD drive + libata trouble
Date: Mon, 12 Nov 2007 19:08:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <fa.8uxz0HU0qK8mBG2Y3elfa/Plk4k@ifi.uio.no> <47360321.2060803@shaw.ca>
In-Reply-To: <47360321.2060803@shaw.ca>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XaJOHEIHGmfzz8W"
Message-Id: <200711121908.23111.strieder@informatik.uni-kl.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XaJOHEIHGmfzz8W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

sorry for the large amount of files in my last mail, which will be 
outdated by this mail. Had I only read a little bit further on the 
bugzilla page.

Robert Hancock wrote:
> There is a known problem with ATAPI devices on CK804 chipsets
> which have memory above the 4GB mark, being debugged here:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=351451

There is a second patch on this bugzilla page which I did not see 
in the first place.

https://bugzilla.redhat.com/attachment.cgi?id=254191

This patch gives me a working 2.6.24-rc1-git10 kernel WITH adma and 
with the full 8GB of RAM. See the attached dmesg text file below.

>
> If you are running into that one you can workaround it for now
> by passing the adma=0 parameter to the sata_nv module (not sure
> how this would be done on Suse's setup) or pass sata_nv.adma=0
> on the kernel command line if sata_nv is built into the kernel.
> If that does help, I could ask you to test patches :-)

Obviously there is no need for more patches to get the drive 
working. I will probably just use that working kernel after some 
testing. And if I get to know that the patch gets upstream, then I 
will probably use 2.6.24 when it is finished.

If there are more patches to test on this problem please let me 
hear. Now I have a setup that makes testing a patch taking a lot 
less time than before.

Thanks for the help,

Bernd Strieder


--Boundary-00=_XaJOHEIHGmfzz8W
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.2.6.24-rc1-git10-patch2Hancock-noadma=0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.2.6.24-rc1-git10-patch2Hancock-noadma=0"

Linux version 2.6.24-rc1-git10-default (root@euklid) (gcc version 4.2.1 (SUSE Linux)) #1 SMP Mon Nov 12 15:55:37 CET 2007
Command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000da000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff00000 (usable)
 BIOS-e820: 000000007ff00000 - 000000007ff11000 (ACPI data)
 BIOS-e820: 000000007ff11000 - 000000007ff80000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000280000000 (usable)
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2621440) 2 entries of 3200 used
end_pfn_map = 2621440
DMI present.
ACPI: RSDP 000F78C0, 0014 (r0 PTLTD )
ACPI: RSDT 7FF0B188, 0040 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF10A3E, 0074 (r1 NVIDIA CK8S      6040000 PTL_    F4240)
ACPI: DSDT 7FF0B1C8, 5876 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 7FF11FC0, 0040
ACPI: SRAT 7FF10AB2, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SPCR 7FF10BC2, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: MCFG 7FF10C12, 003C (r1 PTLTD    MCFG    6040000             0)
ACPI: APIC 7FF10C4E, 009E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF10CEC, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7FF10D14, 02EC (r1 PTLTD  POWERNOW  6040000  LTP        1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 154) 1 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-180000000
Entering add_active_range(0, 0, 154) 2 entries of 3200 used
Entering add_active_range(0, 256, 524032) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
Entering add_active_range(1, 1572864, 2621440) 3 entries of 3200 used
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-0000000280000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2621440
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      154
    0:      256 ->   524032
    0:  1048576 ->  1572864
    1:  1572864 ->  2621440
On node 0 totalpages: 1048218
  DMA zone: 56 pages used for memmap
  DMA zone: 1028 pages reserved
  DMA zone: 2910 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505656 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xc0000000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xc0000000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xc0001000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xc0001000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xc4000000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xc4000000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30240 bytes of per cpu data
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2059926
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent 3
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2009.259 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 8e000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 8166248k/10485760k available (2035k kernel code, 220928k reserved, 951k data, 292k init)
Calibrating delay using timer specific routine.. 4021.00 BogoMIPS (lpj=8042019)
Security Framework initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 757 Objects with 95 Devices 280 Methods 29 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 12 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
APIC timer calibration result 12557886
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.55 BogoMIPS (lpj=8037106)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4018.55 BogoMIPS (lpj=8037109)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4018.55 BogoMIPS (lpj=8037115)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
Brought up 4 CPUs
CPU0 attaching sched-domain:
 domain 0: span 03
  groups: 01 02
  domain 1: span 0f
   groups: 03 0c
CPU1 attaching sched-domain:
 domain 0: span 03
  groups: 02 01
  domain 1: span 0f
   groups: 03 0c
CPU2 attaching sched-domain:
 domain 0: span 0c
  groups: 04 08
  domain 1: span 0f
   groups: 0c 03
CPU3 attaching sched-domain:
 domain 0: span 0c
  groups: 08 04
  domain 1: span 0f
   groups: 0c 03
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e07fffff
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 00:19
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:....................................................................................
Initialized 24/29 Regions 2/2 Fields 29/29 Buffers 29/41 Packages (778 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 101 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:10)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LSI1] (IRQs 52 53 54 55) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:00: iomem range 0xfefff000-0xfeffffff has been reserved
system 00:02: ioport range 0x8000-0x807f has been reserved
system 00:02: ioport range 0x8080-0x80ff has been reserved
system 00:02: ioport range 0x8400-0x847f has been reserved
system 00:02: ioport range 0x8480-0x84ff has been reserved
system 00:02: ioport range 0x8800-0x887f has been reserved
system 00:02: ioport range 0x8880-0x88ff has been reserved
system 00:02: ioport range 0xa000-0xa03f has been reserved
system 00:02: ioport range 0xa040-0xa07f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@93000000 for 0000:02:00.0
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: 91000000-92ffffff
  PREFETCH window: a0000000-bfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:10:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:0b.0
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: c2000000-c3ffffff
PCI: Bridge: 0000:80:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 7454k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1194888408.988:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:02:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0a.0 subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0b.0 subordinate bus.
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie01]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
AER service couldn't init device 0000:00:0e.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xa0000000, mapped to 0xffffc20002400000, using 5120k, total 131072k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
NET: Registered protocol family 1
registered taskstats version 1
Freeing unused kernel memory: 292k freed
SCSI subsystem initialized
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
ACPI: PCI Interrupt 0000:12:04.0[A] -> GSI 28 (level, low) -> IRQ 28
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xc0100000, IRQ: 28.
3w-9xxx: scsi0: Firmware FE9X 3.04.00.005, BIOS BE9X 3.04.00.002, Ports: 8.
scsi 0:0:0:0: Direct-Access     AMCC     9550SXU-8L DISK  3.04 PQ: 0 ANSI: 3
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0x90001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
hub 1-0:1.0: 10 ports detected
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0x90000000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 2-1: new low speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-1/2-1:1.0/input/input1
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
rtc_cmos: probe of 00:06 failed with error -16
libata version 3.00 loaded.
input: Power Button (FF) as /devices/virtual/input/input2
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0a.0 to 64
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input3
ACPI: Power Button (CM) [PWRB]
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:e0:81:78:bf:48
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 20 (level, high) -> IRQ 20
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi1 : sata_nv
scsi2 : sata_nv
ata1: SATA max UDMA/133 cmd 0x1c40 ctl 0x1c34 bmdma 0x1c10 irq 20
ata2: SATA max UDMA/133 cmd 0x1c38 ctl 0x1c30 bmdma 0x1c18 irq 20
ata1: SATA link down (SStatus 0 SControl 310)
ata2: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi3 : sata_nv
scsi4 : sata_nv
ata3: SATA max UDMA/133 cmd 0x1c58 ctl 0x1c4c bmdma 0x1c20 irq 23
ata4: SATA max UDMA/133 cmd 0x1c50 ctl 0x1c48 bmdma 0x1c28 irq 23
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203B, SB00, max UDMA/100
ata3.00: configured for UDMA/100
ata4: SATA link down (SStatus 0 SControl 310)
scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203B  SB00 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
scsi 3:0:0:0: Attached scsi generic sg1 type 5
i2c-adapter i2c-0: nForce2 SMBus adapter at 0xa000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0xa040
pata_amd 0000:00:06.0: version 0.3.9
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi5 : pata_amd
scsi6 : pata_amd
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 55
ACPI: PCI Interrupt 0000:80:0a.0[A] -> Link [LMAC] -> GSI 55 (level, high) -> IRQ 55
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LACI] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:80:0a.0 to 64
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 54809 usecs
intel8x0: clocking to 46979
forcedeth 0000:80:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:78:bf:49
forcedeth 0000:80:0a.0: highdma csum timirq gbit lnktim desc-v3
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
powernow-k8: Found 2 Dual Core AMD Opteron(tm) Processor 270 processors (4 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Clocksource tsc unstable (delta = -104028719 ns)
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
audit(1194888425.330:2): audit_backlog_limit=320 old=64 by auid=4294967295 res=1
audit(1194888425.826:3): audit_pid=3163 old=0 by auid=4294967295

--Boundary-00=_XaJOHEIHGmfzz8W--
