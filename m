Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZBFRzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZBFRzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZBFRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:55:24 -0500
Received: from mx2.compro.net ([216.54.166.4]:47419 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZBFRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:55:16 -0500
X-IronPort-AV: E=Sophos;i="4.37,392,1231131600"; 
   d="txt'?scan'208";a="3360041"
Message-ID: <498C7980.2060309@compro.net>
Date: Fri, 06 Feb 2009 12:55:12 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: markh@compro.net
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net>
In-Reply-To: <498C44FA.1010106@compro.net>
Content-Type: multipart/mixed;
 boundary="------------060903000404020005000706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060903000404020005000706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

> Borislav Petkov wrote:
>> Ok, here are two things you could try:
>>
>> Disable CONFIG_HIGH_RES_TIMERS (high resolution timers support in
>> "Processor type and features"), boot with "apic=debug" and send me the
>> output. I'd like to see how the lapic timer gets programmed. It would
>> be better for that exercise to get the latest stable kernel, 2.6.28.3,
>> imho.
>>
>> The other thing you could do is get x86info tools from here:
>> http://www.codemonkey.org.uk/projects/x86info/. However, get either a
>> daily snapshot or a checkout from the git repository and build it on
>> your system. Then do
>>
>> x86info -a > x86info.txt
>>
>> lsmsr -V3 -a > lsmsr.txt
>>
>> and send me those text files - we might be able to get a clue what's going on
>> from them.

Ok, attached is the bootlog.txt, x86info.txt, and lsmsr.txt

Thanks
Mark

--------------060903000404020005000706
Content-Type: text/plain;
 name="bootlog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bootlog.txt"

BIOS EBDA/lowmem at: 0009f000/0009f000





















































Initializing cgroup subsys cpuset
Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Fri Feb 9
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
 BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
 BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
DMI 2.5 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0xbffe0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
RAMDISK: 375a8000 - 37fef479
Allocated new RAMDISK: 004a7000 - 00eee479
Move RAMDISK from 00000000375a8000 - 0000000037fef478 to 004a7000 - 00eee478
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 0044 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: HPET BFFE8E40, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE8E80, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
2183MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004a3c54]    TEXT DATA BSS ==> [0000100000 - 00004a3c54]
  #4 [00004a4000 - 00004a7000]    INIT_PG_TABLE ==> [00004a4000 - 00004a7000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [00004a7000 - 0000eee479]      NEW RAMDISK ==> [00004a7000 - 0000eee479]
  #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f3f00] 000f3f00
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000bffe0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bffe0
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 36864 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
Kernel command line: root=/dev/sda5 hwprobe=-modules.pata apm=off selinux=0 noresume splash=silent apic=debug console=ttyS0,19200n8 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3360.372 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3104320k/3145600k available (1835k kernel code, 39920k reserved, 1095k data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02caf27 - 0xc03dcc4c   (1095 kB)
      .text : 0xc0100000 - 0xc02caf27   (1835 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 6720.74 BogoMIPS (lpj=13441488)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting ID: f000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1312574
... PM timer delta = 357950
... PM timer result ok
..... delta 1312574
..... mult: 56371100
..... calibration result: 840047
..... CPU clock speed is 3360.0779 MHz.
..... host bus clock speed is 210.0047 MHz.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 6720.40 BogoMIPS (lpj=13440808)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
masked ExtINT on CPU#2
Calibrating delay using timer specific routine.. 6720.39 BogoMIPS (lpj=13440799)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
masked ExtINT on CPU#3
Calibrating delay using timer specific routine.. 6720.41 BogoMIPS (lpj=13440821)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (26881.95 BogoMIPS).
net_namespace: 776 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:14.4: transparent bridge
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 3: can't allocate resource

... APIC ID:      00000000 (0)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000


... APIC ID:      01000000 (1)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000


... APIC ID:      02000000 (2)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000


... APIC ID:      03000000 (3)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000

testing the IO APIC.......................

.................................... done.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: mem resource (0xf0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x1fffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x100000-0xbffdffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:0d: iomem range 0xfed00000-0xfed000ff has been reserved
system 00:0d: iomem range 0xbffe0000-0xbfffffff could not be reserved
system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0xd000-0xdfff
pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x000000dfffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0xc000-0xcfff
pci 0000:00:04.0:   MEM window: 0xfdb00000-0xfdbfffff
pci 0000:00:04.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
pci 0000:00:06.0:   IO window: 0xb000-0xbfff
pci 0000:00:06.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:00:06.0:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
pci 0000:00:07.0:   IO window: 0xe000-0xefff
pci 0000:00:07.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:07.0:   PREFETCH window: 0x000000fdc00000-0x000000fdcfffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
pci 0000:00:14.4:   IO window: 0xa000-0xafff
pci 0000:00:14.4:   MEM window: 0xfd900000-0xfd9fffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fd800000-0x000000fd8fffff
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
bus: 01 index 2 mmio: [0xc0000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xc000-0xcfff]
bus: 02 index 1 mmio: [0xfdb00000-0xfdbfffff]
bus: 02 index 2 mmio: [0xfda00000-0xfdafffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xb000-0xbfff]
bus: 03 index 1 mmio: [0xfdf00000-0xfdffffff]
bus: 03 index 2 mmio: [0xfde00000-0xfdefffff]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0xe000-0xefff]
bus: 04 index 1 mmio: [0xfdd00000-0xfddfffff]
bus: 04 index 2 mmio: [0xfdc00000-0xfdcfffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xa000-0xafff]
bus: 05 index 1 mmio: [0xfd900000-0xfd9fffff]
bus: 05 index 2 mmio: [0xfd800000-0xfd8fffff]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 10525k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1233922326.136:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1717
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport-driver 0000:00:02.0: found MSI capability
pcieport-driver 0000:00:04.0: found MSI capability
pcieport-driver 0000:00:06.0: found MSI capability
pcieport-driver 0000:00:07.0: found MSI capability
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 276k freed
doing fast boot
Boot logging started on /dev/ttSCSI subsystem initialized
yS0(/dev/consolepata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
) at Fri Feb  6 pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
12:12:07 2009
scsi0 : pata_jmicron
scsi1 : pata_jmicron
FATAL: Module prata1: PATA max UDMA/100 cmd 0xbf00 ctl 0xbe00 bmdma 0xbb00 irq 19
ata2: PATA max UDMA/100 cmd 0xbd00 ctl 0xbc00 bmdma 0xbb08 irq 19
ocessor not found.
FATAL: Module thermal not found.
logips2pp: Detected unknown logitech mouse model 11
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
ata3: softreset failed (device not ready)
ata3: failed due to HW bug, retry pmp=0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: configured for UDMA/133
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: configured for UDMA/133
ata5: softreset failed (device not ready)
ata5: failed due to HW bug, retry pmp=0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe100 irq 18
ata8: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe180 irq 18
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
Uniform Multi-Platform E-IDE driver
atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf900-0xf907
hda: ST3120023A, ATA DISK drive
hdb: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
hda: UDMA/100 mode selected
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
aic7xxx 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

FATAL: Module fan not found.
BIOS EDD facility v0.16 2004-Jun-25, 4 devices found
sky2 driver version 1.22
sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 5
sky2 0000:04:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
sky2 eth0: addr 00:e0:4d:7a:8c:ee
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Creating device nodes with udev
Driver 'sd' needs updating - please use bus_type methods
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ohci_hcd 0000:00:13.0: OHCI Host Controller
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
usb 1-1: new full speed USB device using ohci_hcd and address 2
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28.3-250Hz ehci_hcd
usb usb2: SerialNumber: 0000:00:13.5
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
hub 1-0:1.0: unable to enumerate USB device on port 1
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=03f0, idProduct=5111
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Photosmart 3200 series
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: MY5B98310Z045K
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb usb4: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 2-2: New USB device found, idVendor=0424, idProduct=2504
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb6: SerialNumber: 0000:00:13.4
Waiting for device /dev/sda5 to appear:  ok
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
fsck 1.40.8 (13-Mar-2008)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda5
/dev/sda5: Superblock last write time is in the future.  FIXED.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda5: clean, 340719/3280320 files, 4444849/6554512 blocks
fsck succeeded. Mounting root device read-write.
Mounting root /dev/sda5
INIT: version 2.86 booting
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc                                              done
Mounting sysfs at /sys                                                done
Mounting debugfs at /sys/kernel/debug                                 done
Initializing /dev                                                     done
Mounting devpts at /dev/pts                                           done
                                                                      done
Starting udevd: sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ide-cd driver 5.00
ide-cd: hdb: ATAPI 32X DVD-ROM DVD-R CD-R/RW<6>Linux agpgart interface v0.103
 drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:0f:09:1b
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Illegal request -- (Sense key=0x05)
  Logical block address out of range -- (asc=0x21, ascq=0x00)
  The failed "Read 10" packet command was:
  "28 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Illegal request -- (Sense key=0x05)
  Logical block address out of range -- (asc=0x21, ascq=0x00)
  The failed "Read 10" packet command was:
  "28 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
IT8718 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x5111
usbcore: registered new interface driver usblp
0000:02:00.0: eth1: MAC: 1, PHY: 4, PBA No: d50854-003
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
ppdev: user-space parallel port driver
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
                                                                      done
Loading required kernel modules                                       done
Activating swap-devices in /etc/fstabAdding 8393952k swap on /dev/sda2.  Priority:-1 extents:1 across:8393952k
...                                                                   done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
mount: according to mtab, /dev/sda5 is already mounted on /

Setting up the hardware clock                                         done
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Activating device mapper...
                                                                      done
Checking file systems...
fsck 1.40.8 (13-Mar-2008)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/sda1
/dev/sda1: clean, 131/131616 files, 88873/263056 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda6
/dev/sda6: clean, 84117/5903072 files, 2654384/11797726 blocks
[/sbin/fsck.ext3 (1) -- /local] fsck.ext3 -a /dev/sda7
/dev/sda7: clean, 364115/8536064 files, 10489587/17040940 blocks
[/sbin/fsck.ext3 (1) -- /usr/local] fsck.ext3 -a /dev/sda8
/dev/sda8: clean, 10011/656000 files, 560507/1311297 blocks
[/sbin/fsck.ext3 (1) -- /usr/src] fsck.ext3 -a /dev/sda9
/dev/sda9: clean, 1203258/6557152 files, 11314704/13109032 blocks
[/sbin/fsck.ext3 (1) -- /misc] fsck.ext3 -a /dev/sda10
/dev/sda10: clean, 13/12992512 files, 455787/25967056 blocks
[/sbin/fsck.ext3 (1) -- /lcrs] fsck.ext3 -a /dev/hda1
/dev/hda1: clean, 32325/14663680 files, 24187969/29302552 blocks
[/sbin/fsck.ext3 (1) -- /compro] fsck.ext3 -a /dev/sdc1
/dev/sdc1: clean, 1261027/39075840 files, 12160814/78142160 blocks    done
oop: module loaded
5h                                                                    done
Mokjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
unting local file systems...
proc on /proc typekjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
 proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernekjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
l/debug type debugfs (rw)
udev on /dev type tmpkjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fs (rw)
devpts on /dev/pts type devpts (rw,modekjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
=0620,gid=5)
/dev/sda1 on /boot type ext3 (rw,acl,user_xattr)
/dev/sda6 on /hokjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
me type ext3 (rw,acl,user_xattr)kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

/dev/sda7 on /local type ext3 (rw,acl,user_xatkjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tr)
/dev/sda8 on /usr/local type ext3 (rw,acl,user_xattr)
/dev/sda9 on /usr/src type ext3 (rw,acl,user_xattr)
/dev/sda10 on /misc type ext3 (rw,acl,user_xattr)
/dev/hda1 on /lcrs type ext3 (rw)
/dev/sdc1 on /compro type ext3 (rw,acl,user_xattr)                    done
Retry device configuration:                                           done
Configuring serial ports...
/dev/ttyS0 at 0x03f8 (irq = 4) is a 16550A
Configured serial ports                                               done
Setting current sysctl status from /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
fs.inotify.max_user_watches = 65536
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.all.promote_secondaries = 1
                                                                      done
fuse init (API version 7.10)
Loading fuse module                                                   done
Mounting fuse control filesystem                                      done
scsi 9:0:0:0: Direct-Access     HP       Photosmart 3210  1.00 PQ: 0 ANSI: 2
sd 9:0:0:0: [sdd] Attached SCSI removable disk
Mounting securitsd 9:0:0:0: Attached scsi generic sg3 type 0
yfs on /sys/kernel/security                                           done
ls: cannot access /sys/module/apparmor: No such file or directory
ls: cannot access /sys/module/apparmor: No such file or directory
Loading AppArmor module                                               failed
Enabling syn flood protection                                         done
Disabling IP forwarding                                               done
                                                                      done
Creating /var/log/boot.msg                                            done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Activating remaining swap-devices in /etc/fstab...                    done
Setting up hostname 'harley'                                          done
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
                                                                      done
System Boot Control: The system has been                              set up
Failed features:                                                             boot.apparmor
Skipped features:                                                                boot.cycle
System Boot Control: Running /etc/init.d/boot.local
kernel.shmmax = 81943040                                              done
INIT: Entering runlevel: 5
Boot logging started on /dev/ttyS0(/dev/console) at Fri Feb  6 12:12:43 2009
Master Resource Control: previous runlevel: N, switching to runlevel: 5
Starting resource manager                                             done
acpid: starting up

Starting acpid                                                        done
acpid: 1 rule loaded

Starting D-Bus daemonStarting syslog services                         done
Initializing random number generator                                  done
                                                                      done
Starting ConsoleKit                                                   done
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Loading CPUFreq modules (CPUFreqip6_tables: (C) 2000-2006 Netfilter Core Team
 not supported)
Starting HAL daemonip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Starting Firewall Initialization (phase 1 of 2)                       done
cdrom: This disc doesn't have any tracks I recognize!
                                                                      done
Setting up network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8                                 done
    eth0      device: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 13)
    eth0      IP address: 10.10.10.100/24                             done
    eth1      device: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
    eth1      IP address: 192.168.10.100/24                           done
Waiting for mandatory devices:  eth2 eth3 __NSC__
19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
    eth2                                No interface found            failed
    eth3                                No interface found            failed
Setting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .  .  failed
Starting service kdm                                                  done
Mount CIFS File Systems                                               unused
Starting RPC portmap daemon                                           done
VMware Server is installed, but it has not been (correctly) configured
for the running kernel. To (re-)configure it, invoke the
following command: /usr/bin/vmware-config.pl.

Starting auditd                                                       done
Starting cupsd                                                        done
Starting SSH daemon                                                   done
Starting Avahi daemon.                                                done
Starting Avahi DNS Configuration daemon                               done
Loading keymap i386/qwerty/us.map.gz                                  done
Loading compose table latin1.add                                      done
Start Unicode mode                                                    done
Loading console font lat9w-16.psfu  -m trivial G0:loadable            done
ntpd: time set -0.245441s
Starting network time protocol daemon (NTPD)                          done
Starting Name Service Cache Daemon                                    done
Starting mail service (Postfix)                                       done
Starting CRON daemon                                                  done
Starting Firewall Initialization (phase 2 of 2) SuSEfirewall2: Warning: no default firewall zone defined, assuming 'ext'
                                                                      done
                                                                      done

--------------060903000404020005000706
Content-Type: text/plain;
 name="x86info.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86info.txt"

x86info v1.23.  Dave Jones 2001-2009
Feedback to <davej@redhat.com>.

Found 4 CPUs
MP Table:
#	APIC ID	Version	State		Family	Model	Step	Flags
#	 0	 0x11	 BSP, usable	 6	 8	 6	 0xfbff
#	 1	 0x11	 AP, usable	 6	 8	 6	 0xfbff
#	 2	 0x11	 AP, usable	 6	 8	 6	 0xfbff
#	 3	 0x11	 AP, usable	 6	 8	 6	 0xfbff

--------------------------------------------------------------------------
CPU #1
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron (RB-C2)
Processor name string: AMD Phenom(tm) II X4 940 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check disabled
 Instruction cache check disabled
 Bus unit check disabled
 Load/Store unit check disabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 10000000
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   10110000 01100000 10001000 00000000
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    00000000 00000000 00000000 00000000
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   10010111 01111100 10001100 10111111
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00000000 00000000
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   01011000 00001100 00101001 11100001
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000000
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   00110001 11110111 00100000 10010100
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 10000000 00000001 00000010
MC4STATUS: 00000000 00000000 00000000 10000010
MC4ADDR:   11111111 11111000 00000001 11110000
MC4MISC:   00000001 00000000 00000000 00000000

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000000
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   00000001 00000000 00001010 00010011
MC5MISC:   00000000 00000000 00001100 11001101

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Something went wrong reading MSR_PSTATE_CUR_LIMIT
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 00040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001a86 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 30343920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:


Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x0000000100000006
MTRRphysMask2 (0x205): 0x0000ffffc0000800
MTRRphysBase3 (0x206): 0x0000000000000000
MTRRphysMask3 (0x207): 0x0000000000000000
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0000000000000000
MTRRfix4K_F8000 0x26f: 0x0000000000000000
MTRRdefType (0x2ff): 0x0000000000000c00


4154503.75GHz processor (estimate).

--------------------------------------------------------------------------
CPU #2
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron (RB-C2)
Processor name string: AMD Phenom(tm) II X4 940 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check disabled
 Instruction cache check disabled
 Bus unit check disabled
 Load/Store unit check disabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   10111111 11111001 01001000 10100011
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    00000000 00000000 00000000 00000000
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   00100011 10011110 10000000 00001100
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00000000 00000000
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   11111100 00100010 10000110 01000000
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000000
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   01010011 01110111 11101111 11001111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   00000001 00000000 00000000 00000000

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000000
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   10111011 11001110 10011111 10111000
MC5MISC:   00000000 00000000 00000010 01111111

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Something went wrong reading MSR_PSTATE_CUR_LIMIT
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 01040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001a86 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 30343920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:


Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x0000000100000006
MTRRphysMask2 (0x205): 0x0000ffffc0000800
MTRRphysBase3 (0x206): 0x0000000000000000
MTRRphysMask3 (0x207): 0x0000000000000000
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0000000000000000
MTRRfix4K_F8000 0x26f: 0x0000000000000000
MTRRdefType (0x2ff): 0x0000000000000c00


3.40GHz processor (estimate).

--------------------------------------------------------------------------
CPU #3
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron (RB-C2)
Processor name string: AMD Phenom(tm) II X4 940 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check disabled
 Instruction cache check disabled
 Bus unit check disabled
 Load/Store unit check disabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   00010110 10111000 10101010 10100101
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    00000000 00000000 00000000 00000000
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   00001011 10000001 01010000 00000100
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00000000 00000000
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   01001100 00111110 01011001 01010101
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000000
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   11000011 11101101 11000010 11101010
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   00000001 00000000 00000000 00000000

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000000
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   11110111 10101010 10010100 01000000
MC5MISC:   00000000 00000000 00000000 11111110

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Something went wrong reading MSR_PSTATE_CUR_LIMIT
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 03040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001a86 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 30343920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:


Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x0000000100000006
MTRRphysMask2 (0x205): 0x0000ffffc0000800
MTRRphysBase3 (0x206): 0x0000000000000000
MTRRphysMask3 (0x207): 0x0000000000000000
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0000000000000000
MTRRfix4K_F8000 0x26f: 0x0000000000000000
MTRRdefType (0x2ff): 0x0000000000000c00


4154503.75GHz processor (estimate).

--------------------------------------------------------------------------
CPU #4
EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
CPU Model: Quad-Core Opteron (RB-C2)
Processor name string: AMD Phenom(tm) II X4 940 Processor
Number of reporting banks : 6

MCG_CTL:
 Data cache check disabled
 Instruction cache check disabled
 Bus unit check disabled
 Load/Store unit check disabled

           31       23       15       7 
Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
MC0ADDR:   11010111 11111000 10010011 00111000
MC0MISC:   00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    00000000 00000000 00000000 00000000
MC1STATUS: 00000000 00000000 00000000 00000000
MC1ADDR:   11111111 11111111 11111111 11111111
MC1MISC:   00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00000000 00000000
MC2STATUS: 00000000 00000000 00000000 00000000
MC2ADDR:   00001001 11001011 01000001 01000000
MC2MISC:   00000000 00000000 00000000 00000000

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000000
MC3STATUS: 00000000 00000000 00000000 00000000
MC3ADDR:   10101111 11101001 11111110 11111111
MC3MISC:   00000000 00000000 00000000 00000000

Bank: 4 (0x410)
MC4CTL:    00000000 00000000 00000000 00000000
MC4STATUS: 00000000 00000000 00000000 00000000
MC4ADDR:   00000000 00000000 00000000 00000000
MC4MISC:   00000001 00000000 00000000 00000000

Bank: 5 (0x414)
MC5CTL:    00000000 00000000 00000000 00000000
MC5STATUS: 00000000 00000000 00000000 00000000
MC5ADDR:   10010110 11011101 11100110 11100010
MC5MISC:   00000000 00000000 00000101 01110110

PowerNOW! Technology information
Available features:
	Temperature sensing diode present.
	Thermal Trip
	Thermal Monitoring
	Software Thermal Control
	100MHz multiplier control
	Hardware P-state control
	invariant TSC

Something went wrong reading MSR_PSTATE_CUR_LIMIT
Monitor/Mwait: min/max line size 64/64, ecx bit 0 support, enumeration extension
SVM: revision 1, 64 ASIDs, np, lbrVirt, SVMLock, NRIPSave
Address Size: 48 bits virtual, 48 bits physical
The physical package has 4 of 4 possible cores implemented.
eax in: 0x00000000, eax = 00000005 ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x00000001, eax = 00100f42 ebx = 02040800 ecx = 00802009 edx = 178bfbff
eax in: 0x00000002, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000003, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000004, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x00000005, eax = 00000040 ebx = 00000040 ecx = 00000003 edx = 00000000

eax in: 0x80000000, eax = 8000001b ebx = 68747541 ecx = 444d4163 edx = 69746e65
eax in: 0x80000001, eax = 00100f42 ebx = 10001a86 ecx = 000037ff edx = efd3fbff
eax in: 0x80000002, eax = 20444d41 ebx = 6e656850 ecx = 74286d6f edx = 4920296d
eax in: 0x80000003, eax = 34582049 ebx = 30343920 ecx = 6f725020 edx = 73736563
eax in: 0x80000004, eax = 0000726f ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000005, eax = ff30ff10 ebx = ff30ff20 ecx = 40020140 edx = 40020140
eax in: 0x80000006, eax = 20800000 ebx = 42004200 ecx = 02008140 edx = 0030b140
eax in: 0x80000007, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 000001f9
eax in: 0x80000008, eax = 00003030 ebx = 00000000 ecx = 00002003 edx = 00000000
eax in: 0x80000009, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000a, eax = 00000001 ebx = 00000040 ecx = 00000000 edx = 0000000f
eax in: 0x8000000b, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000c, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000d, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000e, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000000f, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000010, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000011, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000012, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000013, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000014, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000015, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000016, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000017, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000018, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x80000019, eax = f0300000 ebx = 60100000 ecx = 00000000 edx = 00000000
eax in: 0x8000001a, eax = 00000003 ebx = 00000000 ecx = 00000000 edx = 00000000
eax in: 0x8000001b, eax = 0000001f ebx = 00000000 ecx = 00000000 edx = 00000000

L1 Data TLB (2M/4M):        Fully associative. 48 entries.
L1 Instruction TLB (2M/4M): Fully associative. 16 entries.
L1 Data TLB (4K):           Fully associative. 48 entries.
L1 Instruction TLB (4K):    Fully associative. 32 entries.
L1 Data cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L1 Instruction cache:
	Size: 64Kb	2-way associative. 
	lines per tag=1	line size=64 bytes.
L2 Data TLB (2M/4M):        2-way associative. 128 entries.
L2 Instruction TLB (2M/4M): Disabled. 0 entries.
L2 Data TLB (4K):           4-way associative. 512 entries.
L2 Instruction TLB (4K):    4-way associative. 512 entries.
L2 cache:
	Size: 512Kb	16-way associative. 
	lines per tag=1	line size=64 bytes.
L3 (shared) cache:
	Size: 6144Kb	48-way associative. 
	lines per tag=1	line size=64 bytes.

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflsh mmx fxsr sse sse2 ht sse3 mwait cmpxchg16b popcnt
Extended feature flags:


Connector type: Socket AM2r2

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000ffff80000800
MTRRphysBase1 (0x202): 0x0000000080000006
MTRRphysMask1 (0x203): 0x0000ffffc0000800
MTRRphysBase2 (0x204): 0x0000000100000006
MTRRphysMask2 (0x205): 0x0000ffffc0000800
MTRRphysBase3 (0x206): 0x0000000000000000
MTRRphysMask3 (0x207): 0x0000000000000000
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0000000000000000
MTRRfix4K_F0000 0x26e: 0x0000000000000000
MTRRfix4K_F8000 0x26f: 0x0000000000000000
MTRRdefType (0x2ff): 0x0000000000000c00


4154503.75GHz processor (estimate).

--------------------------------------------------------------------------

--------------060903000404020005000706
Content-Type: text/plain;
 name="lsmsr.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsmsr.txt"

LSMCAaddr            = 0x0000ba0a31f72094
  ADDR=0xba0a31f72094
LSMCAstatus          = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  UECC=0
  CECC=0
  SYND=0
  PCC=0
  ADDRV=0
  MISCV=0
  EN=0
  UC=0
  OVER=0
  VAL=0
TSC                  = 0x000001ef841dd91e
  TSC=0x1ef841dd91e
APIC_BASE            = 0x00000000fee00900
  BSC=0x1
  ApicEn=0x1
  ApicBar=0xfee00
EBL_CR_POWERON       = 0x0000000000000000
  ClusterID=0
MTRRcap              = 0x0000000000000508
  MtrrCapVCnt=0x8
  MtrrCapFix=0x1
  MtrrCapWc=0x1
SYSENTER_CS          = 0x0000000000000060
  SYSENTER_CS=0x60
SYSENTER_ESP         = 0x00000000c2816580
  SYSENTER_ESP=0xc2816580
SYSENTER_EIP         = 0x00000000c0103868
  SYSENTER_EIP=0xc0103868
MCG_CAP              = 0x0000000000000106
  Count=0x6
  MCG_CTL_P=0x1
MCG_STAT             = 0x0000000000000000
  RIPV=0
  EIPV=0
  MCIP=0
MCG_CTL              = 0x0000000000000000
  DCE=0
  ICE=0
  BUE=0
  LSE=0
  NBE=0
  FRE=0
DBG_CTL_MSR          = 0x0000000000000000
  LBR=0
  BTF=0
  PB0=0
  PB1=0
  PB2=0
  PB3=0
BR_FROM              = 0xffffc79ce797b9f5
  LastBranchFromIP=0xffffc79ce797b9f5
BR_TO                = 0x00000000fe9fffef
  LastBranchToIP=0xfe9fffef
LastExceptionFromIP  = 0x0000000000000000
  LastIntFromIP=0
LastExceptionToIP    = 0x0000000000000000
  LastIntToIP=0
MTRRphysBase0        = 0x0000000000000006
  MemType=0x6
  PhyBase=0
MTRRphysMask0        = 0x0000ffff80000800
  Valid=0x1
  PhysMask=0xffff80000
MTRRphysBase1        = 0x0000000080000006
  MemType=0x6
  PhyBase=0x80000
MTRRphysMask1        = 0x0000ffffc0000800
  Valid=0x1
  PhysMask=0xffffc0000
MTRRphysBase2        = 0x0000000100000006
  MemType=0x6
  PhyBase=0x100000
MTRRphysMask2        = 0x0000ffffc0000800
  Valid=0x1
  PhysMask=0xffffc0000
MTRRphysBase3        = 0x0000000000000000
  MemType=0
  PhyBase=0
MTRRphysMask3        = 0x0000000000000000
  Valid=0
  PhysMask=0
MTRRphysBase4        = 0x0000000000000000
  MemType=0
  PhyBase=0
MTRRphysMask4        = 0x0000000000000000
  Valid=0
  PhysMask=0
MTRRphysBase5        = 0x0000000000000000
  MemType=0
  PhyBase=0
MTRRphysMask5        = 0x0000000000000000
  Valid=0
  PhysMask=0
MTRRphysBase6        = 0x0000000000000000
  MemType=0
  PhyBase=0
MTRRphysMask6        = 0x0000000000000000
  Valid=0
  PhysMask=0
MTRRphysBase7        = 0x0000000000000000
  MemType=0
  PhyBase=0
MTRRphysMask7        = 0x0000000000000000
  Valid=0
  PhysMask=0
MTRRfix64K_00000     = 0x0606060606060606
  0xxxxType=0x6
  1xxxxType=0x6
  2xxxxType=0x6
  3xxxxType=0x6
  4xxxxType=0x6
  5xxxxType=0x6
  6xxxxType=0x6
  7xxxxType=0x6
MTRRfix16K_80000     = 0x0606060606060606
  80xxxType=0x6
  84xxxType=0x6
  88xxxType=0x6
  8CxxxType=0x6
  90xxxType=0x6
  94xxxType=0x6
  98xxxType=0x6
  9CxxxType=0x6
MTRRfix16K_A0000     = 0x0000000000000000
  A0xxxType=0
  A4xxxType=0
  A8xxxType=0
  ACxxxType=0
  B0xxxType=0
  B4xxxType=0
  B8xxxType=0
  BCxxxType=0
MTRRfix4K_C0000      = 0x0505050505050505
  C0xxxType=0x5
  C1xxxType=0x5
  C2xxxType=0x5
  C3xxxType=0x5
  C4xxxType=0x5
  C5xxxType=0x5
  C6xxxType=0x5
  C7xxxType=0x5
MTRRfix4K_C8000      = 0x0000000000000000
  C8xxxType=0
  C9xxxType=0
  CAxxxType=0
  CBxxxType=0
  CCxxxType=0
  CDxxxType=0
  CExxxType=0
  CFxxxType=0
MTRRfix4K_D0000      = 0x0000000000000000
  D0xxxType=0
  D1xxxType=0
  D2xxxType=0
  D3xxxType=0
  D4xxxType=0
  D5xxxType=0
  D6xxxType=0
  D7xxxType=0
MTRRfix4K_D8000      = 0x0000000000000000
  D8xxxType=0
  D9xxxType=0
  DAxxxType=0
  DBxxxType=0
  DCxxxType=0
  DDxxxType=0
  DExxxType=0
  DFxxxType=0
MTRRfix4K_E0000      = 0x0000000000000000
  E0xxxType=0
  E1xxxType=0
  E2xxxType=0
  E3xxxType=0
  E4xxxType=0
  E5xxxType=0
  E6xxxType=0
  E7xxxType=0
MTRRfix4K_E8000      = 0x0000000000000000
  E8xxxType=0
  E9xxxType=0
  EAxxxType=0
  EBxxxType=0
  ECxxxType=0
  EDxxxType=0
  EExxxType=0
  EFxxxType=0
MTRRfix4K_F0000      = 0x0000000000000000
  F0xxxType=0
  F1xxxType=0
  F2xxxType=0
  F3xxxType=0
  F4xxxType=0
  F5xxxType=0
  F6xxxType=0
  F7xxxType=0
MTRRfix4K_F8000      = 0x0000000000000000
  F8xxxType=0
  F9xxxType=0
  FAxxxType=0
  FBxxxType=0
  FCxxxType=0
  FDxxxType=0
  FExxxType=0
  FFxxxType=0
PAT                  = 0x0007010600070106
  PA0MemType=0x6
  PA1MemType=0x1
  PA2MemType=0x7
  PA3MemType=0
  PA4MemType=0x6
  PA5MemType=0x1
  PA6MemType=0x7
  PA7MemType=0
MTRRdefType          = 0x0000000000000c00
  MemType=0
  MtrrDefTypeFixEn=0x1
  MtrrDefTypeEn=0x1
MC0_CTL              = 0x0000000000000080
  ECCI=0
  ECCM=0
  DECC=0
  DMTP=0
  DSTP=0
  L1TP=0
  L2TP=0
MC0_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  Syndrome=0
  Scrub=0
  UECC=0
  CECC=0
  Syndrome=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  OVER=0
  VAL=0
MC0_ADDR             = 0x0000ec1fb0608800
  ADDR=0xec1fb0608800
MC0_MISC             = 0x0000000000000000
MC1_CTL              = 0x0000000000000000
  ECCI=0
  ECCM=0
  IDP=0
  IMTP=0
  ISTP=0
  L1TP=0
  L2TP=0
  RDDE=0
MC1_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  UECC=0
  CECC=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  OVER=0
  VAL=0
MC1_ADDR             = 0xfbf8ad6d977c8cbf
  ADDR=0xad6d977c8cbf
MC1_MISC             = 0x0000000000000000
MC2_CTL              = 0x0000000000000000
  SRDE_HP=0
  SRDE_TLB=0
  SRDE_ALL=0
  L2T_PAR=0
  L2T_CECC=0
  L2T_UECC=0
  L2D_PAR=0
  L2D_CECC=0
  L2D_UECC=0
  VB_PAR=0
  PDC_PAR=0
MC2_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  Scrub=0
  UECC=0
  CECC=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  OVER=0
  VAL=0
MC2_ADDR             = 0x00008bdd580c29e1
  ADDR=0x8bdd580c29e1
MC2_MISC             = 0x0000000000000000
MC3_CTL              = 0x0000000000000000
  SRDE_L=0
  SRDE_S=0
MC3_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  UECC=0
  CECC=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  OVER=0
  VAL=0
MC3_ADDR             = 0x0000ba0a31f72094
  ADDR=0xba0a31f72094
MC3_MISC             = 0x0000000000000000
MC4_CTL              = 0x0000000000800102
  CECCEn=0
  UECCEn=0x1
  CrcErr0En=0
  CrcErr1En=0
  CrcErr2En=0
  SyncPkt0En=0
  SyncPkt1En=0
  SyncPkt2En=0
  MstrAbrtEn=0x1
  TgtAbrtEn=0
  GartTblWkEn=0
  AtomicRMWEn=0
  WDTRptEn=0
  DevErrEn=0
  L3ArrayCorEn=0
  L3ArrayUCEn=0
  HtProtEn=0
  HtDataEn=0
  DramParEn=0
  RtryHt0En=0
  RtryHt1En=0
  RtryHt2En=0
  RtryHt3En=0
  CrcErr3En=0x1
  SyncPkt3En=0
  McaUsPwDatErrEn=0
  NbArrayParEn=0
  TblWlkDatErrEn=0
MC4_STATUS           = 0x0000000000000082
  ErrorCode=0x82
  ErrorCodeExt=0
  Syndrome=0
  ErrCpu0=0
  ErrCpu1=0
  ErrCpu2=0
  ErrCpu3=0
  LDTLink0=0
  LDTLink1=0
  LDTLink2=0
  LDTLink3=0
  Scrub=0
  SubLink=0
  McaStatSubCache=0
  UECC=0
  CECC=0
  Syndrome=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  Over=0
  Val=0
MC4_ADDR             = 0x00000000fff801f0
  ErrAddr=0x7ffc00f8
MC4_MISC0            = 0xc000000001000000
  BlkPtr=0x1
  ErrCnt=0
  Ovrflw=0
  IntType=0
  CntEn=0
  LvtOffset=0
  Locked=0
  CntP=0x1
  Valid=0x1
MC5_CTL              = 0x0000000000000000
  CPUWDT=0
MC5_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  Syndrome=0
  Scrub=0
  UECC=0
  CECC=0
  Syndrome=0
  PCC=0
  AddrV=0
  MiscV=0
  En=0
  UC=0
  OVER=0
  VAL=0
MC5_ADDR             = 0x0000ad6d01000a13
  ADDR=0xad6d01000a13
MC5_MISC             = 0x0000000000000ccd
  State=0xccd
EFER                 = 0x0000000000000000
  SYSCALL=0
  LME=0
  LMA=0
  NXE=0
  SVME=0
  LMSLE=0
  FFXSE=0
STAR                 = 0x0000000000000000
  Target=0
  SysCallSel=0
  SysRetSel=0
STAR64               = 0x0000000000000000
  LSTAR=0
STARCOMPAT           = 0x0000000000000000
  CSTAR=0
SYSCALL_FLAG_MASK    = 0x0000000000000000
  MASK=0
FS_BASE              = 0x00000000023ef000
  FS_BASE=0x23ef000
GS_BASE              = 0x00000000b7eab6c0
  GS_BASE=0xb7eab6c0
KernelGSbase         = 0x0000000000000000
  KernelGSBase=0
TSC_AUX              = 0x0000000000000000
  TscAux=0
MC4_MISC1            = 0xc000000001000000
  BlkPtr=0x1
  ErrCnt=0
  Ovrflw=0
  IntType=0
  CntEn=0
  LvtOffset=0
  Locked=0
  CntP=0x1
  Valid=0x1
MC4_MISC2            = 0xc000000001000000
  BlkPtr=0x1
  ErrCnt=0
  Ovrflw=0
  IntType=0
  CntEn=0
  LvtOffset=0
  Locked=0
  CntP=0x1
  Valid=0x1
MC4_MISC3            = 0x0000000001000000
  BlkPtr=0x1
PERF_CTL0            = 0x00000200d082c243
  EventSelect=0x43
  UnitMask=0xc2
  User=0
  OS=0x1
  Edge=0
  Int=0
  En=0
  Inv=0x1
  CntMask=0xd0
  EventSelect=0
  GuestOnly=0
  HostOnly=0x1
PERF_CTL1            = 0x0000010e030f8d17
  EventSelect=0x17
  UnitMask=0x8d
  User=0x1
  OS=0x1
  Edge=0x1
  Int=0
  En=0
  Inv=0
  CntMask=0x3
  EventSelect=0xe
  GuestOnly=0x1
  HostOnly=0
PERF_CTL2            = 0x000000074307d19e
  EventSelect=0x9e
  UnitMask=0xd1
  User=0x1
  OS=0x1
  Edge=0x1
  Int=0
  En=0
  Inv=0
  CntMask=0x43
  EventSelect=0x7
  GuestOnly=0
  HostOnly=0
PERF_CTL3            = 0x00000201a00f00cb
  EventSelect=0xcb
  UnitMask=0
  User=0x1
  OS=0x1
  Edge=0x1
  Int=0
  En=0
  Inv=0
  CntMask=0xa0
  EventSelect=0x1
  GuestOnly=0
  HostOnly=0x1
PERF_CTR0            = 0x00000a8121b3acb7
  CTR=0xa8121b3acb7
PERF_CTR1            = 0x00008e982076597e
  CTR=0x8e982076597e
PERF_CTR2            = 0x00009271a6dffefe
  CTR=0x9271a6dffefe
PERF_CTR3            = 0x000038ee7bfe7ca9
  CTR=0x38ee7bfe7ca9
SYS_CFG              = 0x0000000000760600
  SetDirtyEnE=0
  SetDirtyEnS=0x1
  SetDirtyEnO=0x1
  ChxToDirtyDis=0
  SysUcLockEn=0x1
  MtrrFixDramEn=0x1
  MtrrFixDramModeEn=0
  MtrrVarDramEn=0x1
  MtrrTom2En=0x1
  Tom2ForceMemTypeWB=0x1
HWCR                 = 0x0000000001000011
  SmmLock=0x1
  SlowFence=0
  TlbCacheDis=0
  INVD_WBINVD=0x1
  IgnneEm=0
  MonMwaitDis=0
  MonMwaitUserEn=0
  LimitCpuidStdMaxVal=0
  HltXSpCycEn=0
  SmiSpCycDis=0
  RsmSpCycDis=0
  SseDis=0
  Wrap32Dis=0
  McStatusWrEn=0
  IoCfgGpFault=0
  MisAlignSseDis=0
  ForceUsRdWrSzPrb=0
  TscFreqSel=0x1
IORR_BASE0           = 0x0000000000220000
  WrMem=0
  RdMem=0
  PhyBase=0x220
IORR_MASK0           = 0x0000000000000000
  Valid=0
  PhyMask=0
IORR_BASE1           = 0x0000000000000000
  WrMem=0
  RdMem=0
  PhyBase=0
IORR_MASK1           = 0x0000000000000000
  Valid=0
  PhyMask=0
TOP_MEM              = 0x00000000c0000000
  TOM=0x180
TOM2                 = 0x0000000140000000
  TOM2=0x280
NB_CFG               = 0x0040400000000008
  DisRefUseFreeBuf=0
  DisXdsBypass=0
  DisCohLdtCfg=0
  DisDatMsk=0
  DisUsSysMgtReqToNcHt=0
  EnableCf8ExtCfg=0x1
  DisOrderRdRsp=0
  InitApicIdCpuIdLo=0x1
MCEredirection       = 0x0000000000000000
  RedirVector=0
  RedirVecEn=0
  RedirSmiEn=0
ProcessorNameString0 = 0x6e65685020444d41
  CpuNameString=0x6e65685020444d41
ProcessorNameString1 = 0x4920296d74286d6f
  CpuNameString=0x4920296d74286d6f
ProcessorNameString2 = 0x3034392034582049
  CpuNameString=0x3034392034582049
ProcessorNameString3 = 0x737365636f725020
  CpuNameString=0x737365636f725020
ProcessorNameString4 = 0x000000000000726f
  CpuNameString=0x726f
ProcessorNameString5 = 0x0000000000000000
  CpuNameString=0
MC0_CTL_MASK         = 0x0000000000000080
  ECCI=0
  ECCM=0
  DECC=0
  DMTP=0
  DSTP=0
  L1TP=0
  L2TP=0
MC1_CTL_MASK         = 0x0000000000000080
  ECCI=0
  ECCM=0
  IDP=0
  IMTP=0
  ISTP=0
  L1TP=0
  L2TP=0
  RDDE=0
MC2_CTL_MASK         = 0x0000000000000200
  SRDE_HP=0
  SRDE_TLB=0
  SRDE_ALL=0
  L2T_PAR=0
  L2T_CECC=0
  L2T_UECC=0
  L2D_PAR=0
  L2D_CECC=0
  L2D_UECC=0
  VB_PAR=0
  PDC_PAR=0
MC3_CTL_MASK         = 0x0000000000000000
  SRDE_L=0
  SRDE_S=0
MC4_CTL_MASK         = 0x0000000000780000
  CECCEn=0
  UECCEn=0
  CrcErr0En=0
  CrcErr1En=0
  CrcErr2En=0
  SyncPkt0En=0
  SyncPkt1En=0
  SyncPkt2En=0
  MstrAbrtEn=0
  TgtAbrtEn=0
  GartTblWkEn=0
  AtomicRMWEn=0
  WDTRptEn=0
  DevErrEn=0
  L3ArrayCorEn=0
  L3ArrayUCEn=0
  HtProtEn=0
  HtDataEn=0
  DramParEn=0
  RtryHt0En=0x1
  RtryHt1En=0x1
  RtryHt2En=0x1
  RtryHt3En=0x1
  CrcErr3En=0
  SyncPkt3En=0
  McaUsPwDatErrEn=0
  NbArrayParEn=0
  TblWlkDatErrEn=0
MC5_CTL_MASK         = 0x0000000000000000
  CPUWDT=0
SMI_ON_IO_TRAP_0     = 0x0000000000000000
  SmiAddr=0
  SmiMask=0
  ConfigSmi=0
  SmiOnWrEn=0
  SmiOnRdEn=0
SMI_ON_IO_TRAP_1     = 0x0000000000000000
  SmiAddr=0
  SmiMask=0
  ConfigSmi=0
  SmiOnWrEn=0
  SmiOnRdEn=0
SMI_ON_IO_TRAP_2     = 0x0000000000000000
  SmiAddr=0
  SmiMask=0
  ConfigSmi=0
  SmiOnWrEn=0
  SmiOnRdEn=0
SMI_ON_IO_TRAP_3     = 0xe0fffff8800000e8
  SmiAddr=0x800000e8
  SmiMask=0xfffff8
  ConfigSmi=0x1
  SmiOnWrEn=0x1
  SmiOnRdEn=0x1
SMI_ON_IO_TRAP_CTL_STS = 0x0000000000000080
  SmiEn_0=0
  SmiEn_1=0
  SmiEn_2=0
  SmiEn_3=0x1
  IoTrapEn=0
IntPendingMessage    = 0x0000000000000000
  IOMsgAddr=0
  IOMsgData=0
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0
  SmiOnCmpHalt=0
SmiTriggerIoCycle    = 0x0000000000000000
  IoPortAddress=0
  IoData=0
  IoCycleEn=0
  IoRd=0
MmioConfigBase       = 0x00000000e0000001
  Enable=0x1
  TrapAccess=0
  SegBusRange=0
  MmiocCfgBaseAddr=0xe00
PstateCurrentLimit   = 0x0000000000000030
  CurPstateLimit=0
  PstateMaxVal=0x3
PstateControl        = 0x0000000000000000
  PstateCmd=0
PstateStatus         = 0x0000000000000000
  CurPstate=0
Pstate0              = 0x8000001a20002010
  CpuFid=0x10
  CpuDid=0
  CpuVid=0x10
  NbDid=0
  NbVid=0x10
  IddValue=0x1a
  IddDiv=0
  PstateEn=0x1
Pstate1              = 0x800001c330003007
  CpuFid=0x7
  CpuDid=0
  CpuVid=0x18
  NbDid=0
  NbVid=0x18
  IddValue=0xc3
  IddDiv=0x1
  PstateEn=0x1
Pstate2              = 0x800001b640004002
  CpuFid=0x2
  CpuDid=0
  CpuVid=0x20
  NbDid=0
  NbVid=0x20
  IddValue=0xb6
  IddDiv=0x1
  PstateEn=0x1
Pstate3              = 0x8000017240004040
  CpuFid=0
  CpuDid=0x1
  CpuVid=0x20
  NbDid=0
  NbVid=0x20
  IddValue=0x72
  IddDiv=0x1
  PstateEn=0x1
Pstate4              = 0x0000000000000000
  CpuFid=0
  CpuDid=0
  CpuVid=0
  NbDid=0
  NbVid=0
  IddValue=0
  IddDiv=0
  PstateEn=0
COFVIDcontrol        = 0x0000000020002010
  CpuFid=0x10
  CpuDid=0
  CpuVid=0x10
  PstateId=0
  NbDid=0
  NbVid=0x10
COFVIDstatus         = 0x0080000320002010
  CurCpuFid=0x10
  CurCpuDid=0
  CurCpuVid=0x10
  CurPstate=0
  CurNbDid=0
  CurNbVid=0x10
  StartupPstate=0x3
  MaxVid=0
  MinVid=0
  MaxCpuCof=0
  CurPstateLimit=0
  MaxNbFid=0
CpuWdTmrCfg          = 0x0000000000000000
  CpuWdtEn=0
  CpuWdtTimeBase=0
  CpuWdtCountSel=0
SMM_BASE             = 0x00000000000a0000
  SMM_BASE=0xa0000
SMMAddr              = 0x0000000000000000
  TSegBase=0
SMMMask              = 0x000000ff00000001
  AValid=0x1
  TValid=0
  AClose=0
  TClose=0
  AMTypeIoWc=0
  TMTypeIoWc=0
  AMTypeDram=0
  TMTypeDram=0
  TSegMask=0x7f8000
VM_CR                = 0x0000000000000000
  dpd=0
  r_init=0
  dis_a20m=0
  Lock=0
  Svme_Disable=0
IGNNE                = 0x0000000000000000
  IGNNE=0
VM_HSAVE_PA          = 0x0000000000000000
  VM_HSAVE_PA=0
SMIstatus            = 0x0000000000000000
  IoTrapSts=0
  MceRedirSts=0
  SmiOnCmpHaltSts=0
  IntPendSmiSts=0
  SmiSrcLvtLcy=0
  SmiSrcLvtExt=0
  SmiSrcThrCntDram=0
  SmiSrcThrCntHt=0
  SmiSrcThrCntL3=0
  SmiSrcOnLineSpare=0
OSVW_ID_Length       = 0x0000000000000001
  OSVW_ID_Length=0x1
OsvwStatus           = 0x0000000000000000
  OsvwStatusBits=0
CPUIDFeatures        = 0x00802009178bfbff
  Features=0x178bfbff
  Features=0x802009
CPUIDExtFeatures     = 0x000037ffefd3fbff
  ExtFeaturesEcx=0xefd3fbff
  ExtFeaturesEdx=0x37ff
DC_CFG               = 0x0000009c49000000
  REQ_CTR=0x3
BU_CFG               = 0x0000000010200020
  WbEnhWsbDis=0
BU_CFG2              = 0x00040040050000c0
  FrcWTMemTypToWPDis=0
  CILinesToNbDis=0
  Smash1GPages=0
IbsFetchCtl          = 0x0000000000000000
  IbsFetchMaxCnt=0
  IbsFetchCnt=0
  IbsFetchLat=0
  IbsFetchEn=0
  IbsFetchVal=0
  IbsFetchComp=0
  IbsIcMiss=0
  IbsPhyAddrValid=0
  IbsL1TlbPgSz=0
  IbsL1TlbMiss=0
  IbsL2TlbMiss=0
  IbsRandEn=0
IbsFetchLinAd        = 0xffffa3e65a746cd5
  IbsFetchLinAd=0xffffa3e65a746cd5
IbsFetchPhysAd       = 0x00007e03d6486cd5
  IbsFetchPhysAd=0x7e03d6486cd5
IbsOpCtl             = 0x0000000000000000
  IbsOpMaxCnt=0
  IbsOpEn=0
  IbsOpVal=0
IbsOpRip             = 0xffffa914180a05af
  IbsOpRip=0xffffa914180a05af
IbsOpData            = 0x00000008dafaafa3
  IbsCompToRetCtr=0xafa3
  IbsTagToRetCtr=0xdafa
  IbsOpBrnResync=0
  IbsOpMispReturn=0
  IbsOpReturn=0
  IbsOpBrnTaken=0x1
  IbsOpBrnMisp=0
  IbsOpBrnRet=0
IbsOpData2           = 0x0000000000000000
  NbIbsReqSrc=0
  NbIbsReqDstProc=0
  NbIbsReqCacheHitSt=0
IbsOpData3           = 0x0000000000000000
  IbsLdOp=0
  IbsStOp=0
  IbsDcL1tlbMiss=0
  IbsDcL2tlbMiss=0
  IbsDcL1tlbHit2M=0
  IbsDcL1tlbHit1G=0
  IbsDcL2tlbHit2M=0
  IbsDcMiss=0
  IbsDcMisAcc=0
  IbsDcLdBnkCon=0
  IbsDcStBnkCon=0
  IbsDcStToLdFwd=0
  IbsDcStToLdCan=0
  IbsDcUcMemAcc=0
  IbsDcWcMemAcc=0
  IbsDcLockedOp=0
  IbsDcMabHit=0
  IbsDcLinAddrValid=0
  IbsDcPhyAddrValid=0
  IbsDcMissLat=0
IbsDcLinAd           = 0x0000000000000000
  IbsDcLinAd=0
IbsDcPhysAd          = 0x0000000000000000
  IbsDcPhysAd=0
IbsControl           = 0x0000000000000100
  LvtOffset=0
  LvtOffsetVal=0x1

--------------060903000404020005000706--
