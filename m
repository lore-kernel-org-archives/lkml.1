Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbXLGD5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbXLGD5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXLGD5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:57:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:31990 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXLGD47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TAoD0FmylWofnVLAeOX1mlyjHu7TkhM7w3okHnh3+FStK0abRhyd89pga924u+VEbTZjQ1hl1XQcdKNB6n5XlY85RWexc7eb+tR3s6Jcwferxq1UpwZVsF8lURgfWkfpxJp6oFwYqEAv0vqiZM+0qYjMvUWIjlKXSbVbwkcE0CQ=
Message-ID: <a44ae5cd0712061956i1bd8f354rbfcffdbafad2e5d8@mail.gmail.com>
Date: Thu, 6 Dec 2007 22:56:53 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc4-mm1 -- boot process hangs -- tty4 main process (2988) terminated with status 1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine is:  http://www.gateway.com/retail/mt6821.php
Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18.20071027
util-linux             2.13.1-rc1
mount                  2.13.1-rc1
module-init-tools      3.3-pre11
e2fsprogs              1.40.2
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   113
wireless-tools         29

Dec  6 21:24:09 erratic-orbits kernel: Inspecting
/boot/System.map-2.6.24-rc4-mm1
Dec  6 21:24:09 erratic-orbits kernel: Loaded 32575 symbols from
/boot/System.map-2.6.24-rc4-mm1.
Dec  6 21:24:09 erratic-orbits kernel: Symbols match kernel version 2.6.24.
Dec  6 21:24:09 erratic-orbits kernel: Loaded 2594 symbols from 18 modules.
Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys cpuset
Dec  6 21:24:09 erratic-orbits kernel: Linux version 2.6.24-rc4-mm1
(root@erratic-orbits) (gcc version 4.2.3 20071123 (prerelease) (Ubuntu
4.2.2-3ubuntu4)) #2 SMP PREEMPT Thu Dec 6 21:15:36 EST 2007
Dec  6 21:24:09 erratic-orbits kernel: BIOS-provided physical RAM map:
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 0000000000000000 -
000000000009f800 (usable)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 000000000009f800 -
00000000000a0000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000000dc000 -
0000000000100000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 0000000000100000 -
000000007f690000 (usable)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 000000007f690000 -
000000007f699000 (ACPI data)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 000000007f699000 -
000000007f700000 (ACPI NVS)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 000000007f700000 -
0000000080000000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000e0000000 -
00000000f0000000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000fec00000 -
00000000fec10000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000fed00000 -
00000000fed00400 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000fed14000 -
00000000fed1a000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000fed1c000 -
00000000fed90000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000fee00000 -
00000000fee01000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel:  BIOS-e820: 00000000ff000000 -
0000000100000000 (reserved)
Dec  6 21:24:09 erratic-orbits kernel: 1142MB HIGHMEM available.
Dec  6 21:24:09 erratic-orbits kernel: 896MB LOWMEM available.
Dec  6 21:24:09 erratic-orbits kernel: found SMP MP-table at 000f66b0
Dec  6 21:24:09 erratic-orbits kernel: Entering add_active_range(0, 0,
521872) 0 entries of 256 used
Dec  6 21:24:09 erratic-orbits kernel: sizeof(struct page) = 36
Dec  6 21:24:09 erratic-orbits kernel: Zone PFN ranges:
Dec  6 21:24:09 erratic-orbits kernel:   DMA             0 ->     4096
Dec  6 21:24:09 erratic-orbits kernel:   Normal       4096 ->   229376
Dec  6 21:24:09 erratic-orbits kernel:   HighMem    229376 ->   521872
Dec  6 21:24:09 erratic-orbits kernel: Movable zone start PFN for each node
Dec  6 21:24:09 erratic-orbits kernel: early_node_map[1] active PFN ranges
Dec  6 21:24:09 erratic-orbits kernel:     0:        0 ->   521872
Dec  6 21:24:09 erratic-orbits kernel: On node 0 totalpages: 521872
Dec  6 21:24:09 erratic-orbits kernel:   DMA zone: 36 pages used for memmap
Dec  6 21:24:09 erratic-orbits kernel:   DMA zone: 0 pages reserved
Dec  6 21:24:09 erratic-orbits kernel:   DMA zone: 4060 pages, LIFO batch:0
Dec  6 21:24:09 erratic-orbits kernel:   Normal zone: 1980 pages used for memmap
Dec  6 21:24:09 erratic-orbits kernel:   Normal zone: 223300 pages,
LIFO batch:31
Dec  6 21:24:09 erratic-orbits kernel:   HighMem zone: 2570 pages used
for memmap
Dec  6 21:24:09 erratic-orbits kernel:   HighMem zone: 289926 pages,
LIFO batch:31
Dec  6 21:24:09 erratic-orbits kernel:   Movable zone: 0 pages used for memmap
Dec  6 21:24:09 erratic-orbits kernel: DMI 2.4 present.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: RSDP 000F6600, 0014 (r0 PTLTD )
Dec  6 21:24:09 erratic-orbits kernel: ACPI: RSDT 7F6928B4, 0044 (r1
GATEWA SYSTEM   20070319  LTP        0)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: FACP 7F698CAA, 0074 (r1
GATEWA SYSTEM   20070319 LOHR       5A)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: DSDT 7F6932A6, 5A04 (r1
GATEWA SYSTEM   20070319 MSFT  100000E)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: FACS 7F699FC0, 0040
Dec  6 21:24:09 erratic-orbits kernel: ACPI: APIC 7F698D1E, 0068 (r1
GATEWA SYSTEM   20070319 LOHR       5A)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: HPET 7F698D86, 0038 (r1
GATEWA SYSTEM   20070319 LOHR       5A)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: MCFG 7F698DBE, 003C (r1
GATEWA SYSTEM   20070319 LOHR       5A)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: APIC 7F698DFA, 0068 (r1
GATEWA SYSTEM   20070319  LTP        0)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: BOOT 7F698E62, 0028 (r1
GATEWA SYSTEM   20070319  LTP        1)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SLIC 7F698E8A, 0176 (r1
GATEWA SYSTEM   20070319  LTP        0)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SSDT 7F6928F8, 04EA (r1
GATEWA SYSTEM       3000 INTL 20050228)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: BIOS bug: multiple
APIC/MADT found, using 0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: If "acpi_apic_instance=2"
works better, notify linux-acpi@vger.kernel.org
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PM-Timer IO Port: 0x1008
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Local APIC address 0xfee00000
Dec  6 21:24:09 erratic-orbits kernel: ACPI: LAPIC (acpi_id[0x00]
lapic_id[0x00] enabled)
Dec  6 21:24:09 erratic-orbits kernel: Processor #0 6:15 APIC version 20
Dec  6 21:24:09 erratic-orbits kernel: ACPI: LAPIC (acpi_id[0x01]
lapic_id[0x01] enabled)
Dec  6 21:24:09 erratic-orbits kernel: Processor #1 6:15 APIC version 20
Dec  6 21:24:09 erratic-orbits kernel: ACPI: LAPIC_NMI (acpi_id[0x00]
high edge lint[0x1])
Dec  6 21:24:09 erratic-orbits kernel: ACPI: LAPIC_NMI (acpi_id[0x01]
high edge lint[0x1])
Dec  6 21:24:09 erratic-orbits kernel: ACPI: IOAPIC (id[0x01]
address[0xfec00000] gsi_base[0])
Dec  6 21:24:09 erratic-orbits kernel: IOAPIC[0]: apic_id 1, version
32, address 0xfec00000, GSI 0-23
Dec  6 21:24:09 erratic-orbits kernel: ACPI: INT_SRC_OVR (bus 0
bus_irq 0 global_irq 2 dfl dfl)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: INT_SRC_OVR (bus 0
bus_irq 9 global_irq 9 high level)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: IRQ0 used by override.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: IRQ2 used by override.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: IRQ9 used by override.
Dec  6 21:24:09 erratic-orbits kernel: Enabling APIC mode:  Flat.
Using 1 I/O APICs
Dec  6 21:24:09 erratic-orbits kernel: ACPI: HPET id: 0x8086a201 base:
0xfed00000
Dec  6 21:24:09 erratic-orbits kernel: Using ACPI (MADT) for SMP
configuration information
Dec  6 21:24:09 erratic-orbits kernel: Allocating PCI resources
starting at 88000000 (gap: 80000000:60000000)
Dec  6 21:24:09 erratic-orbits kernel: swsusp: Registered nosave
memory region: 000000000009f000 - 00000000000a0000
Dec  6 21:24:09 erratic-orbits kernel: swsusp: Registered nosave
memory region: 00000000000a0000 - 00000000000dc000
Dec  6 21:24:09 erratic-orbits kernel: swsusp: Registered nosave
memory region: 00000000000dc000 - 0000000000100000
Dec  6 21:24:09 erratic-orbits kernel: Built 1 zonelists in Zone
order, mobility grouping on.  Total pages: 517286
Dec  6 21:24:09 erratic-orbits kernel: Kernel command line:
root=UUID=05e6ac23-5c9c-46d5-9197-5da658f79165 ro quiet splash
Dec  6 21:24:09 erratic-orbits kernel: mapped APIC to ffffb000 (fee00000)
Dec  6 21:24:09 erratic-orbits kernel: mapped IOAPIC to ffffa000 (fec00000)
Dec  6 21:24:09 erratic-orbits kernel: Enabling fast FPU save and
restore... done.
Dec  6 21:24:09 erratic-orbits kernel: Enabling unmasked SIMD FPU
exception support... done.
Dec  6 21:24:09 erratic-orbits kernel: Initializing CPU#0
Dec  6 21:24:09 erratic-orbits kernel: CPU 0 irqstacks, hard=c0584000
soft=c0582000
Dec  6 21:24:09 erratic-orbits kernel: PID hash table entries: 4096
(order: 12, 16384 bytes)
Dec  6 21:24:09 erratic-orbits kernel: Detected 1596.569 MHz processor.
Dec  6 21:24:09 erratic-orbits kernel: Console: colour VGA+ 80x25
Dec  6 21:24:09 erratic-orbits kernel: console [tty0] enabled
Dec  6 21:24:09 erratic-orbits kernel: Lock dependency validator:
Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Dec  6 21:24:09 erratic-orbits kernel: ... MAX_LOCKDEP_SUBCLASSES:    8
Dec  6 21:24:09 erratic-orbits kernel: ... MAX_LOCK_DEPTH:          30
Dec  6 21:24:09 erratic-orbits kernel: ... MAX_LOCKDEP_KEYS:        2048
Dec  6 21:24:09 erratic-orbits kernel: ... CLASSHASH_SIZE:           1024
Dec  6 21:24:09 erratic-orbits kernel: ... MAX_LOCKDEP_ENTRIES:     8192
Dec  6 21:24:09 erratic-orbits kernel: ... MAX_LOCKDEP_CHAINS:      16384
Dec  6 21:24:09 erratic-orbits kernel: ... CHAINHASH_SIZE:          8192
Dec  6 21:24:09 erratic-orbits kernel:  memory used by lock dependency
info: 992 kB
Dec  6 21:24:09 erratic-orbits kernel:  per task-struct memory
footprint: 1200 bytes
Dec  6 21:24:09 erratic-orbits kernel: Dentry cache hash table
entries: 131072 (order: 7, 524288 bytes)
Dec  6 21:24:09 erratic-orbits kernel: Inode-cache hash table entries:
65536 (order: 6, 262144 bytes)
Dec  6 21:24:09 erratic-orbits kernel: Memory: 2055180k/2087488k
available (2855k kernel code, 31076k reserved, 1406k data, 316k init,
1169984k highmem)
Dec  6 21:24:09 erratic-orbits kernel: virtual kernel memory layout:
Dec  6 21:24:09 erratic-orbits kernel:     fixmap  : 0xfff7e000 -
0xfffff000   ( 516 kB)
Dec  6 21:24:09 erratic-orbits kernel:     pkmap   : 0xff800000 -
0xffc00000   (4096 kB)
Dec  6 21:24:09 erratic-orbits kernel:     vmalloc : 0xf8800000 -
0xff7fe000   ( 111 MB)
Dec  6 21:24:09 erratic-orbits kernel:     lowmem  : 0xc0000000 -
0xf8000000   ( 896 MB)
Dec  6 21:24:09 erratic-orbits kernel:       .init : 0xc052f000 -
0xc057e000   ( 316 kB)
Dec  6 21:24:09 erratic-orbits kernel:       .data : 0xc03c9ce5 -
0xc0529684   (1406 kB)
Dec  6 21:24:09 erratic-orbits kernel:       .text : 0xc0100000 -
0xc03c9ce5   (2855 kB)
Dec  6 21:24:09 erratic-orbits kernel: Checking if this processor
honours the WP bit even in supervisor mode... Ok.
Dec  6 21:24:09 erratic-orbits kernel: SLUB: Genslabs=11, HWalign=64,
Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Dec  6 21:24:09 erratic-orbits kernel: hpet clockevent registered
Dec  6 21:24:09 erratic-orbits kernel: Calibrating delay using timer
specific routine.. 3198.67 BogoMIPS (lpj=5329077)
Dec  6 21:24:09 erratic-orbits kernel: Mount-cache hash table entries: 512
Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys debug
Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys ns
Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys cpuacct
Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys memory
Dec  6 21:24:09 erratic-orbits kernel: CPU: After generic identify,
caps: bfebfbff 20100000 00000000 00000000 0000e39d 00000000 00000001
00000000
Dec  6 21:24:09 erratic-orbits kernel: monitor/mwait feature present.
Dec  6 21:24:09 erratic-orbits kernel: using mwait in idle threads.
Dec  6 21:24:09 erratic-orbits kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Dec  6 21:24:09 erratic-orbits kernel: CPU: L2 cache: 2048K
Dec  6 21:24:09 erratic-orbits kernel: CPU: Physical Processor ID: 0
Dec  6 21:24:09 erratic-orbits kernel: CPU: Processor Core ID: 0
Dec  6 21:24:09 erratic-orbits kernel: CPU: After all inits, caps:
bfebfbff 20100000 00000000 00003940 0000e39d 00000000 00000001
00000000
Dec  6 21:24:09 erratic-orbits kernel: Intel machine check
architecture supported.
Dec  6 21:24:09 erratic-orbits kernel: Intel machine check reporting
enabled on CPU#0.
Dec  6 21:24:09 erratic-orbits kernel: Compat vDSO mapped to ffffe000.
Dec  6 21:24:09 erratic-orbits kernel: Checking 'hlt' instruction... OK.
Dec  6 21:24:09 erratic-orbits kernel: lockdep: not fixing up alternatives.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Core revision 20070126
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [DSDT](id 0001) - 856
Objects with 80 Devices 183 Methods 21 Regions
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [SSDT](id 0002) - 13
Objects with 0 Devices 4 Methods 0 Regions
Dec  6 21:24:09 erratic-orbits kernel:  tbxface-0598 [00]
tb_load_namespace     : ACPI Tables successfully acquired
Dec  6 21:24:09 erratic-orbits kernel: evxfevnt-0091 [00] enable
         : Transition to ACPI mode successful
Dec  6 21:24:09 erratic-orbits kernel: CPU0: Intel(R) Core(TM)2 CPU
     T5200  @ 1.60GHz stepping 06
Dec  6 21:24:09 erratic-orbits kernel: lockdep: not fixing up alternatives.
Dec  6 21:24:09 erratic-orbits kernel: Booting processor 1/1 ip 3000
Dec  6 21:24:09 erratic-orbits kernel: CPU 1 irqstacks, hard=c0585000
soft=c0583000
Dec  6 21:24:09 erratic-orbits kernel: Initializing CPU#1
Dec  6 21:24:09 erratic-orbits kernel: Calibrating delay using timer
specific routine.. 3194.98 BogoMIPS (lpj=5321578)
Dec  6 21:24:09 erratic-orbits kernel: CPU: After generic identify,
caps: bfebfbff 20100000 00000000 00000000 0000e39d 00000000 00000001
00000000
Dec  6 21:24:09 erratic-orbits kernel: monitor/mwait feature present.
Dec  6 21:24:09 erratic-orbits kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Dec  6 21:24:09 erratic-orbits kernel: CPU: L2 cache: 2048K
Dec  6 21:24:09 erratic-orbits kernel: CPU: Physical Processor ID: 0
Dec  6 21:24:09 erratic-orbits kernel: CPU: Processor Core ID: 1
Dec  6 21:24:09 erratic-orbits kernel: CPU: After all inits, caps:
bfebfbff 20100000 00000000 00003940 0000e39d 00000000 00000001
00000000
Dec  6 21:24:09 erratic-orbits kernel: Intel machine check
architecture supported.
Dec  6 21:24:09 erratic-orbits kernel: Intel machine check reporting
enabled on CPU#1.
Dec  6 21:24:09 erratic-orbits kernel: CPU1: Intel(R) Core(TM)2 CPU
     T5200  @ 1.60GHz stepping 06
Dec  6 21:24:09 erratic-orbits kernel: Total of 2 processors activated
(6392.65 BogoMIPS).
Dec  6 21:24:09 erratic-orbits kernel: ENABLING IO-APIC IRQs
Dec  6 21:24:09 erratic-orbits kernel: ..TIMER: vector=0x31 apic1=0
pin1=2 apic2=-1 pin2=-1
Dec  6 21:24:09 erratic-orbits kernel: checking TSC synchronization
[CPU#0 -> CPU#1]: passed.
Dec  6 21:24:09 erratic-orbits kernel: Brought up 2 CPUs
Dec  6 21:24:09 erratic-orbits kernel: net_namespace: 132 bytes
Dec  6 21:24:09 erratic-orbits kernel: Booting paravirtualized kernel
on bare hardware
Dec  6 21:24:09 erratic-orbits kernel: NET: Registered protocol family 16
Dec  6 21:24:09 erratic-orbits kernel: ACPI: bus type pci registered
Dec  6 21:24:09 erratic-orbits kernel: PCI: PCI BIOS revision 2.10
entry at 0xfd893, last bus=4
Dec  6 21:24:09 erratic-orbits kernel: PCI: Using configuration type 1
Dec  6 21:24:09 erratic-orbits kernel: Setting up standard PCI resources
Dec  6 21:24:09 erratic-orbits kernel: evgpeblk-0956 [00]
ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
Dec  6 21:24:09 erratic-orbits kernel: evgpeblk-1052 [00]
ev_initialize_gpe_bloc: Found 8 Wake, Enabled 4 Runtime GPEs in this
block
Dec  6 21:24:09 erratic-orbits kernel: ACPI: EC: Look up EC in DSDT
Dec  6 21:24:09 erratic-orbits kernel: Completing
Region/Field/Buffer/Package
initialization:................................................
Dec  6 21:24:09 erratic-orbits kernel: Initialized 17/21 Regions 0/0
Fields 20/20 Buffers 11/22 Packages (878 nodes)
Dec  6 21:24:09 erratic-orbits kernel: Initializing
Device/Processor/Thermal objects by executing _INI methods:.
Dec  6 21:24:09 erratic-orbits kernel: Executed 1 _INI methods
requiring 0 _STA executions (examined 85 objects)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Interpreter enabled
Dec  6 21:24:09 erratic-orbits kernel: ACPI: (supports S0 S3 S4 S5)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Using IOAPIC for interrupt routing
Dec  6 21:24:09 erratic-orbits kernel: PCI: MCFG configuration 0: base
3758096384 segment 0 buses 0 - 255
Dec  6 21:24:09 erratic-orbits kernel: PCI: MCFG area at e0000000
reserved in ACPI motherboard resources
Dec  6 21:24:09 erratic-orbits kernel: PCI: Using MMCONFIG
Dec  6 21:24:09 erratic-orbits kernel: ACPI: EC: GPE = 0x17, I/O:
command/status = 0x66, data = 0x62
Dec  6 21:24:09 erratic-orbits kernel: ACPI: EC: driver started in poll mode
Dec  6 21:24:09 erratic-orbits kernel: ACPI: EC: non-query interrupt
received, switching to interrupt mode
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec  6 21:24:09 erratic-orbits kernel: PCI quirk: region 1000-107f
claimed by ICH6 ACPI/GPIO/TCO
Dec  6 21:24:09 erratic-orbits kernel: PCI quirk: region 1180-11bf
claimed by ICH6 GPIO
Dec  6 21:24:09 erratic-orbits kernel: PCI: Transparent bridge - 0000:00:1e.0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Routing
Table [\_SB_.PCI0._PRT]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Routing
Table [\_SB_.PCI0.RP01._PRT]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Routing
Table [\_SB_.PCI0.RP02._PRT]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Routing
Table [\_SB_.PCI0.PCIB._PRT]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKA]
(IRQs 1 3 4 5 6 7 10 12 14 15) *11
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKB]
(IRQs 1 3 4 5 6 7 *11 12 14 15)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKC]
(IRQs 1 3 4 5 6 7 *10 12 14 15)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKD]
(IRQs 1 3 4 5 6 7 11 12 14 15) *10
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKE]
(IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKF]
(IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKG]
(IRQs 1 3 4 5 6 7 *10 12 14 15)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt Link [LNKH]
(IRQs 3 4 5 6 7 *11 12 14 15)
Dec  6 21:24:09 erratic-orbits kernel: Linux Plug and Play Support
v0.97 (c) Adam Belay
Dec  6 21:24:09 erratic-orbits kernel: pnp: PnP ACPI init
Dec  6 21:24:09 erratic-orbits kernel: ACPI: bus type pnp registered
Dec  6 21:24:09 erratic-orbits kernel: pnp 00:02: can't allocate I/O
ports at 0x81
Dec  6 21:24:09 erratic-orbits kernel: pnp: PnP ACPI: found 9 devices
Dec  6 21:24:09 erratic-orbits kernel: ACPI: ACPI bus type pnp unregistered
Dec  6 21:24:09 erratic-orbits kernel: SCSI subsystem initialized
Dec  6 21:24:09 erratic-orbits kernel: libata version 3.00 loaded.
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver usbfs
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver hub
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new device driver usb
Dec  6 21:24:09 erratic-orbits kernel: PCI: Using ACPI for IRQ routing
Dec  6 21:24:09 erratic-orbits kernel: PCI: If a device doesn't work,
try "pci=routeirq".  If it helps, post a report
Dec  6 21:24:09 erratic-orbits kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Dec  6 21:24:09 erratic-orbits kernel: hpet0: 3 64-bit timers, 14318180 Hz
Dec  6 21:24:09 erratic-orbits kernel: ACPI: RTC can wake from S4
Dec  6 21:24:09 erratic-orbits kernel: Time: tsc clocksource has been installed.
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xe0000000-0xefffffff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed14000-0xfed17fff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed18000-0xfed18fff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed19000-0xfed19fff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed1c000-0xfed1ffff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed20000-0xfed3ffff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:01: iomem range
0xfed45000-0xfed8ffff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:03: iomem range
0xfed00000-0xfed003ff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: ioport range
0x800-0x80f has been reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: ioport range
0x1000-0x107f has been reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: ioport range
0x1180-0x11bf has been reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: ioport range
0x1640-0x164f has been reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: ioport range
0xfe00-0xfe00 has been reserved
Dec  6 21:24:09 erratic-orbits kernel: system 00:05: iomem range
0xff000000-0xffffffff could not be reserved
Dec  6 21:24:09 erratic-orbits kernel: PCI: Bridge: 0000:00:1c.0
Dec  6 21:24:09 erratic-orbits kernel:   IO window: 2000-2fff
Dec  6 21:24:09 erratic-orbits kernel:   MEM window: d4000000-d5ffffff
Dec  6 21:24:09 erratic-orbits kernel:   PREFETCH window: d0000000-d1ffffff
Dec  6 21:24:09 erratic-orbits kernel: PCI: Bridge: 0000:00:1c.1
Dec  6 21:24:09 erratic-orbits kernel:   IO window: 3000-3fff
Dec  6 21:24:09 erratic-orbits kernel:   MEM window: d6000000-d7ffffff
Dec  6 21:24:09 erratic-orbits kernel:   PREFETCH window: d2000000-d3ffffff
Dec  6 21:24:09 erratic-orbits kernel: PCI: Bus 5, cardbus bridge: 0000:04:09.0
Dec  6 21:24:09 erratic-orbits kernel:   IO window: 00001400-000014ff
Dec  6 21:24:09 erratic-orbits kernel:   IO window: 00001c00-00001cff
Dec  6 21:24:09 erratic-orbits kernel:   PREFETCH window: 88000000-8bffffff
Dec  6 21:24:09 erratic-orbits kernel:   MEM window: 8c000000-8fffffff
Dec  6 21:24:09 erratic-orbits kernel: PCI: Bridge: 0000:00:1e.0
Dec  6 21:24:09 erratic-orbits kernel:   IO window: disabled.
Dec  6 21:24:09 erratic-orbits kernel:   MEM window: d8000000-d80fffff
Dec  6 21:24:09 erratic-orbits kernel:   PREFETCH window: disabled.
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1c.0 to 64
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1c.1 to 64
Dec  6 21:24:09 erratic-orbits kernel: PCI: Enabling device
0000:00:1e.0 (0004 -> 0006)
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1e.0 to 64
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:04:09.0[A] -> GSI 17 (level, low) -> IRQ 17
Dec  6 21:24:09 erratic-orbits kernel: NET: Registered protocol family 2
Dec  6 21:24:09 erratic-orbits kernel: IP route cache hash table
entries: 32768 (order: 5, 131072 bytes)
Dec  6 21:24:09 erratic-orbits kernel: TCP established hash table
entries: 131072 (order: 8, 1048576 bytes)
Dec  6 21:24:09 erratic-orbits kernel: TCP bind hash table entries:
65536 (order: 9, 2359296 bytes)
Dec  6 21:24:09 erratic-orbits kernel: TCP: Hash tables configured
(established 131072 bind 65536)
Dec  6 21:24:09 erratic-orbits kernel: TCP reno registered
Dec  6 21:24:09 erratic-orbits kernel: checking if image is
initramfs...<7>Switched to high resolution mode on CPU 1
Dec  6 21:24:09 erratic-orbits kernel: Switched to high resolution mode on CPU 0
Dec  6 21:24:09 erratic-orbits kernel:  it is
Dec  6 21:24:09 erratic-orbits kernel: Freeing initrd memory: 4316k freed
Dec  6 21:24:09 erratic-orbits kernel: Simple Boot Flag at 0x36 set to 0x1
Dec  6 21:24:09 erratic-orbits kernel: audit: initializing netlink
socket (disabled)
Dec  6 21:24:09 erratic-orbits kernel: audit(1196976226.013:1): initialized
Dec  6 21:24:09 erratic-orbits kernel: highmem bounce pool size: 64 pages
Dec  6 21:24:09 erratic-orbits kernel: Total HugeTLB memory allocated, 0
Dec  6 21:24:09 erratic-orbits kernel: io scheduler noop registered
Dec  6 21:24:09 erratic-orbits kernel: io scheduler anticipatory registered
Dec  6 21:24:09 erratic-orbits kernel: io scheduler deadline registered
Dec  6 21:24:09 erratic-orbits kernel: io scheduler cfq registered (default)
Dec  6 21:24:09 erratic-orbits kernel: Boot video device is 0000:00:02.0
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1c.0 to 64
Dec  6 21:24:09 erratic-orbits kernel: assign_interrupt_mode Found MSI
capability
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.0:pcie00]
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.0:pcie02]
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.0:pcie03]
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1c.1 to 64
Dec  6 21:24:09 erratic-orbits kernel: assign_interrupt_mode Found MSI
capability
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.1:pcie00]
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.1:pcie02]
Dec  6 21:24:09 erratic-orbits kernel: Allocate Port
Service[0000:00:1c.1:pcie03]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: AC Adapter [ACAD] (on-line)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Battery Slot [BAT1]
(battery present)
Dec  6 21:24:09 erratic-orbits kernel: input: Power Button (FF) as
/class/input/input0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Power Button (FF) [PWRF]
Dec  6 21:24:09 erratic-orbits kernel: input: Power Button (CM) as
/class/input/input1
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Power Button (CM) [PWRB]
Dec  6 21:24:09 erratic-orbits kernel: input: Sleep Button (CM) as
/class/input/input2
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Sleep Button (CM) [SLPB]
Dec  6 21:24:09 erratic-orbits kernel: input: Lid Switch as /class/input/input3
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Lid Switch [LID]
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SSDT 7F693033, 01EA (r1
PmRef  Cpu0Ist     3000 INTL 20050228)
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [SSDT](id 0096) - 5
Objects with 0 Devices 3 Methods 0 Regions
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SSDT 7F692DE2, 01CC (r1
PmRef  Cpu0Cst     3001 INTL 20050228)
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [SSDT](id 0097) - 1
Objects with 0 Devices 1 Methods 0 Regions
Dec  6 21:24:09 erratic-orbits kernel: ACPI: CPU0 (power states:
C1[C1] C2[C2] C3[C3])
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SSDT 7F69321D, 0089 (r1
PmRef  Cpu1Ist     3000 INTL 20050228)
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [SSDT](id 009C) - 3
Objects with 0 Devices 3 Methods 0 Regions
Dec  6 21:24:09 erratic-orbits kernel: ACPI: SSDT 7F692FAE, 0085 (r1
PmRef  Cpu1Cst     3000 INTL 20050228)
Dec  6 21:24:09 erratic-orbits kernel: Parsing all Control Methods:
Dec  6 21:24:09 erratic-orbits kernel: Table [SSDT](id 009D) - 1
Objects with 0 Devices 1 Methods 0 Regions
Dec  6 21:24:09 erratic-orbits kernel: ACPI: CPU1 (power states:
C1[C1] C2[C2] C3[C3])
Dec  6 21:24:09 erratic-orbits kernel: ACPI: Thermal Zone [TZ00] (64 C)
Dec  6 21:24:09 erratic-orbits kernel: rtc: I/O resource 70 is not free.
Dec  6 21:24:09 erratic-orbits kernel: hpet_resources: 0xfed00000 is busy
Dec  6 21:24:09 erratic-orbits kernel: intel_rng: FWH not detected
Dec  6 21:24:09 erratic-orbits kernel: Linux agpgart interface v0.103
Dec  6 21:24:09 erratic-orbits kernel: agpgart: suspend/resume
problematic: resume with 3D/DRI active may lockup X.Org
Dec  6 21:24:09 erratic-orbits kernel: on some chipset/BIOS combos
(see DEBUG_AGP_PM in intel-agp.c)
Dec  6 21:24:09 erratic-orbits kernel: agpgart: Detected an Intel 945GM Chipset.
Dec  6 21:24:09 erratic-orbits kernel: agpgart: Detected 7932K stolen memory.
Dec  6 21:24:09 erratic-orbits kernel: agpgart: AGP aperture is 256M @
0xc0000000
Dec  6 21:24:09 erratic-orbits kernel: Serial: 8250/16550 driver
$Revision: 1.90 $ 4 ports, IRQ sharing disabled
Dec  6 21:24:09 erratic-orbits kernel: floppy0: no floppy controllers found
Dec  6 21:24:09 erratic-orbits kernel: brd: module loaded
Dec  6 21:24:09 erratic-orbits kernel: loop: module loaded
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:02:00.0 to 64
Dec  6 21:24:09 erratic-orbits kernel: sky2 0000:02:00.0: v1.20 addr
0xd4000000 irq 16 Yukon-FE (0xb7) rev 1
Dec  6 21:24:09 erratic-orbits kernel: sky2 eth0: addr 00:e0:b8:c3:08:eb
Dec  6 21:24:09 erratic-orbits kernel: console [netcon0] enabled
Dec  6 21:24:09 erratic-orbits kernel: netconsole: network logging started
Dec  6 21:24:09 erratic-orbits kernel: 3ware Storage Controller device
driver for Linux v1.26.02.002.
Dec  6 21:24:09 erratic-orbits kernel: ahci 0000:00:1f.2: version 3.0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
Dec  6 21:24:09 erratic-orbits kernel: ahci 0000:00:1f.2: nr_ports (4)
and implemented port map (0x5) don't match, using nr_ports
Dec  6 21:24:09 erratic-orbits kernel: ahci 0000:00:1f.2: forcing
PORTS_IMPL to 0xf
Dec  6 21:24:09 erratic-orbits kernel: ahci 0000:00:1f.2: AHCI
0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
Dec  6 21:24:09 erratic-orbits kernel: ahci 0000:00:1f.2: flags: 64bit
ncq pm led clo pio slum part
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1f.2 to 64
Dec  6 21:24:09 erratic-orbits kernel: scsi0 : ahci
Dec  6 21:24:09 erratic-orbits kernel: scsi1 : ahci
Dec  6 21:24:09 erratic-orbits kernel: scsi2 : ahci
Dec  6 21:24:09 erratic-orbits kernel: scsi3 : ahci
Dec  6 21:24:09 erratic-orbits kernel: ata1: SATA max UDMA/133 abar
m1024@0xd8444400 port 0xd8444500 irq 220
Dec  6 21:24:09 erratic-orbits kernel: ata2: SATA max UDMA/133 abar
m1024@0xd8444400 port 0xd8444580 irq 220
Dec  6 21:24:09 erratic-orbits kernel: ata3: SATA max UDMA/133 abar
m1024@0xd8444400 port 0xd8444600 irq 220
Dec  6 21:24:09 erratic-orbits kernel: ata4: SATA max UDMA/133 abar
m1024@0xd8444400 port 0xd8444680 irq 220
Dec  6 21:24:09 erratic-orbits kernel: ata1: SATA link up 1.5 Gbps
(SStatus 113 SControl 300)
Dec  6 21:24:09 erratic-orbits kernel: ata1.00: ATA-7: Hitachi
HTS541616J9SA00, SB4OC70P, max UDMA/100
Dec  6 21:24:09 erratic-orbits kernel: ata1.00: 312581808 sectors,
multi 16: LBA48 NCQ (not used)
Dec  6 21:24:09 erratic-orbits kernel: ata1.00: configured for UDMA/100
Dec  6 21:24:09 erratic-orbits kernel: ata2: SATA link down (SStatus 0
SControl 0)
Dec  6 21:24:09 erratic-orbits kernel: ata3: SATA link down (SStatus 0
SControl 300)
Dec  6 21:24:09 erratic-orbits kernel: ata4: SATA link down (SStatus 0
SControl 0)
Dec  6 21:24:09 erratic-orbits kernel: scsi 0:0:0:0: Direct-Access
ATA      Hitachi HTS54161 SB4O PQ: 0 ANSI: 5
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] 312581808
512-byte hardware sectors (160042 MB)
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Write Protect is off
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] 312581808
512-byte hardware sectors (160042 MB)
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Write Protect is off
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Dec  6 21:24:09 erratic-orbits kernel:  sda: sda1 sda2 sda3 sda4 < sda5 >
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Dec  6 21:24:09 erratic-orbits kernel: sd 0:0:0:0: Attached scsi
generic sg0 type 0
Dec  6 21:24:09 erratic-orbits kernel: ata_piix 0000:00:1f.1: version 2.12
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1f.1[B] -> GSI 19 (level, low) -> IRQ 19
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1f.1 to 64
Dec  6 21:24:09 erratic-orbits kernel: scsi4 : ata_piix
Dec  6 21:24:09 erratic-orbits kernel: scsi5 : ata_piix
Dec  6 21:24:09 erratic-orbits kernel: ata5: PATA max UDMA/100 cmd
0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
Dec  6 21:24:09 erratic-orbits kernel: ata6: PATA max UDMA/100 cmd
0x170 ctl 0x376 bmdma 0x1818 irq 15
Dec  6 21:24:09 erratic-orbits kernel: ata5.00: ATAPI: Optiarc DVD RW
AD-7530A, EX32, max UDMA/33
Dec  6 21:24:09 erratic-orbits kernel: ata5.00: configured for UDMA/33
Dec  6 21:24:09 erratic-orbits kernel: ata6: port disabled. ignoring.
Dec  6 21:24:09 erratic-orbits kernel: scsi 4:0:0:0: CD-ROM
Optiarc  DVD RW AD-7530A  EX32 PQ: 0 ANSI: 5
Dec  6 21:24:09 erratic-orbits kernel: sr0: scsi3-mmc drive: 24x/24x
writer dvd-ram cd/rw xa/form2 cdda tray
Dec  6 21:24:09 erratic-orbits kernel: Uniform CD-ROM driver Revision: 3.20
Dec  6 21:24:09 erratic-orbits kernel: sr 4:0:0:0: Attached scsi CD-ROM sr0
Dec  6 21:24:09 erratic-orbits kernel: sr 4:0:0:0: Attached scsi
generic sg1 type 5
Dec  6 21:24:09 erratic-orbits kernel: Fusion MPT base driver 3.04.06
Dec  6 21:24:09 erratic-orbits kernel: Copyright (c) 1999-2007 LSI Corporation
Dec  6 21:24:09 erratic-orbits kernel: Fusion MPT SPI Host driver 3.04.06
Dec  6 21:24:09 erratic-orbits kernel: PCI: Enabling device
0000:04:09.1 (0000 -> 0002)
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:04:09.1[B] -> GSI 18 (level, low) -> IRQ 18
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:04:09.1 to 64
Dec  6 21:24:09 erratic-orbits kernel: ohci1394: fw-host0: OHCI-1394
1.1 (PCI): IRQ=[18]  MMIO=[d8005000-d80057ff]  Max Packet=[2048]
IR/IT contexts=[4/8]
Dec  6 21:24:09 erratic-orbits kernel: ieee1394: raw1394: /dev/raw1394
device initialized
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1d.7 to 64
Dec  6 21:24:09 erratic-orbits kernel: ehci_hcd 0000:00:1d.7: EHCI
Host Controller
Dec  6 21:24:09 erratic-orbits kernel: ehci_hcd 0000:00:1d.7: new USB
bus registered, assigned bus number 1
Dec  6 21:24:09 erratic-orbits kernel: ehci_hcd 0000:00:1d.7: debug port 1
Dec  6 21:24:09 erratic-orbits kernel: PCI: cache line size of 32 is
not supported by device 0000:00:1d.7
Dec  6 21:24:09 erratic-orbits kernel: ehci_hcd 0000:00:1d.7: irq 23,
io mem 0xd8444000
Dec  6 21:24:09 erratic-orbits kernel: ehci_hcd 0000:00:1d.7: USB 2.0
started, EHCI 1.00, driver 10 Dec 2004
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: configuration #1
chosen from 1 choice
Dec  6 21:24:09 erratic-orbits kernel: hub 1-0:1.0: USB hub found
Dec  6 21:24:09 erratic-orbits kernel: hub 1-0:1.0: 8 ports detected
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: New USB device found,
idVendor=0000, idProduct=0000
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: Product: EHCI Host Controller
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: Manufacturer: Linux
2.6.24-rc4-mm1 ehci_hcd
Dec  6 21:24:09 erratic-orbits kernel: usb usb1: SerialNumber: 0000:00:1d.7
Dec  6 21:24:09 erratic-orbits kernel: ohci_hcd: 2006 August 04 USB
1.1 'Open' Host Controller (OHCI) Driver
Dec  6 21:24:09 erratic-orbits kernel: USB Universal Host Controller
Interface driver v3.0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1d.0 to 64
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.0: UHCI
Host Controller
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.0: new USB
bus registered, assigned bus number 2
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.0: irq 23,
io base 0x00001820
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: configuration #1
chosen from 1 choice
Dec  6 21:24:09 erratic-orbits kernel: hub 2-0:1.0: USB hub found
Dec  6 21:24:09 erratic-orbits kernel: hub 2-0:1.0: 2 ports detected
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: New USB device found,
idVendor=0000, idProduct=0000
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: Product: UHCI Host Controller
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: Manufacturer: Linux
2.6.24-rc4-mm1 uhci_hcd
Dec  6 21:24:09 erratic-orbits kernel: usb usb2: SerialNumber: 0000:00:1d.0
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1d.1 to 64
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.1: UHCI
Host Controller
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.1: new USB
bus registered, assigned bus number 3
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.1: irq 19,
io base 0x00001840
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: configuration #1
chosen from 1 choice
Dec  6 21:24:09 erratic-orbits kernel: hub 3-0:1.0: USB hub found
Dec  6 21:24:09 erratic-orbits kernel: hub 3-0:1.0: 2 ports detected
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: New USB device found,
idVendor=0000, idProduct=0000
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: Product: UHCI Host Controller
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: Manufacturer: Linux
2.6.24-rc4-mm1 uhci_hcd
Dec  6 21:24:09 erratic-orbits kernel: usb usb3: SerialNumber: 0000:00:1d.1
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1d.2 to 64
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.2: UHCI
Host Controller
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.2: new USB
bus registered, assigned bus number 4
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.2: irq 18,
io base 0x00001860
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: configuration #1
chosen from 1 choice
Dec  6 21:24:09 erratic-orbits kernel: hub 4-0:1.0: USB hub found
Dec  6 21:24:09 erratic-orbits kernel: hub 4-0:1.0: 2 ports detected
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: New USB device found,
idVendor=0000, idProduct=0000
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: Product: UHCI Host Controller
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: Manufacturer: Linux
2.6.24-rc4-mm1 uhci_hcd
Dec  6 21:24:09 erratic-orbits kernel: usb usb4: SerialNumber: 0000:00:1d.2
Dec  6 21:24:09 erratic-orbits kernel: ACPI: PCI Interrupt
0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
Dec  6 21:24:09 erratic-orbits kernel: PCI: Setting latency timer of
device 0000:00:1d.3 to 64
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.3: UHCI
Host Controller
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.3: new USB
bus registered, assigned bus number 5
Dec  6 21:24:09 erratic-orbits kernel: uhci_hcd 0000:00:1d.3: irq 16,
io base 0x00001880
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: configuration #1
chosen from 1 choice
Dec  6 21:24:09 erratic-orbits kernel: hub 5-0:1.0: USB hub found
Dec  6 21:24:09 erratic-orbits kernel: hub 5-0:1.0: 2 ports detected
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: New USB device found,
idVendor=0000, idProduct=0000
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: Product: UHCI Host Controller
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: Manufacturer: Linux
2.6.24-rc4-mm1 uhci_hcd
Dec  6 21:24:09 erratic-orbits kernel: usb usb5: SerialNumber: 0000:00:1d.3
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver usblp
Dec  6 21:24:09 erratic-orbits kernel: Initializing USB Mass Storage driver...
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver usb-storage
Dec  6 21:24:09 erratic-orbits kernel: USB Mass Storage support registered.
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver libusual
Dec  6 21:24:09 erratic-orbits kernel: PNP: PS/2 Controller
[PNP0303:PS2K,PNP0f13:PS2P] at 0x60,0x64 irq 1,12
Dec  6 21:24:09 erratic-orbits kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Dec  6 21:24:09 erratic-orbits kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Dec  6 21:24:09 erratic-orbits kernel: mice: PS/2 mouse device common
for all mice
Dec  6 21:24:09 erratic-orbits kernel: input: AT Translated Set 2
keyboard as /class/input/input4
Dec  6 21:24:09 erratic-orbits kernel: device-mapper: uevent: version 1.0.3
Dec  6 21:24:09 erratic-orbits kernel: device-mapper: ioctl:
4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Dec  6 21:24:09 erratic-orbits kernel: EDAC MC: Ver: 2.1.0 Dec  6 2007
Dec  6 21:24:09 erratic-orbits kernel: cpuidle: using governor ladder
Dec  6 21:24:09 erratic-orbits kernel: Synaptics Touchpad, model: 1,
fw: 5.9, id: 0x23aeb3, caps: 0xa04713/0x10008
Dec  6 21:24:09 erratic-orbits kernel: input: SynPS/2 Synaptics
TouchPad as /class/input/input5
Dec  6 21:24:09 erratic-orbits kernel: cpuidle: using governor menu
Dec  6 21:24:09 erratic-orbits kernel: usbcore: registered new
interface driver usbhid
Dec  6 21:24:09 erratic-orbits kernel: drivers/hid/usbhid/hid-core.c:
v2.6:USB HID core driver
Dec  6 21:24:09 erratic-orbits kernel: Marking TSC unstable due to:
TSC halts in idle.
Dec  6 21:24:09 erratic-orbits kernel: oprofile: using NMI interrupt.
Dec  6 21:24:09 erratic-orbits kernel: TCP cubic registered
Dec  6 21:24:09 erratic-orbits kernel: NET: Registered protocol family 1
Dec  6 21:24:09 erratic-orbits kernel: Time: hpet clocksource has been
installed.
Dec  6 21:24:09 erratic-orbits kernel: NET: Registered protocol family 10
Dec  6 21:24:09 erratic-orbits kernel: lo: Disabled Privacy Extensions
Dec  6 21:24:09 erratic-orbits kernel: IPv6 over IPv4 tunneling driver
Dec  6 21:24:09 erratic-orbits kernel: sit0: Disabled Privacy Extensions
Dec  6 21:24:09 erratic-orbits kernel: NET: Registered protocol family 17
Dec  6 21:24:09 erratic-orbits kernel: Starting balanced_irq
Dec  6 21:24:09 erratic-orbits kernel: Using IPI No-Shortcut mode
Dec  6 21:24:09 erratic-orbits kernel: Freeing unused kernel memory: 316k freed
Dec  6 21:24:09 erratic-orbits kernel: Write protecting the kernel
read-only data: 1140k
Dec  6 21:24:09 erratic-orbits kernel: Clocksource tsc unstable (delta
= -63952293 ns)
Dec  6 21:24:09 erratic-orbits kernel: fuse init (API version 7.9)
Dec  6 21:24:09 erratic-orbits kernel: Uniform Multi-Platform E-IDE
driver Revision: 7.00alpha2
Dec  6 21:24:09 erratic-orbits kernel: ide: Assuming 33MHz system bus
speed for PIO modes; override with idebus=xx
Dec  6 21:24:09 erratic-orbits kernel: Attempting manual resume
Dec  6 21:24:09 erratic-orbits kernel: kjournald starting.  Commit
interval 5 seconds
Dec  6 21:24:09 erratic-orbits kernel: EXT3-fs: mounted filesystem
with ordered data mode.
Dec  6 21:24:09 erratic-orbits kernel: lp: driver loaded but no devices found
Dec  6 21:24:09 erratic-orbits kernel: EXT3 FS on sda3, internal journal
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>  starting...
Dec  6 21:24:10 erratic-orbits kernel: sky2 eth0: enabling interface
Dec  6 21:24:10 erratic-orbits kernel: ADDRCONF(NETDEV_UP): eth0: link
is not ready
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>  eth0: Device is
fully-supported using driver 'sky2'.
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>
nm_device_init(): waiting for device's worker thread to start
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>
nm_device_init(): device's worker thread started, continuing.
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>  Now managing
wired Ethernet (802.3) device 'eth0'.
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>  Deactivating
device eth0.
Dec  6 21:24:10 erratic-orbits NetworkManager: <info>  Will activate
wired connection 'eth0' because it now has a link.
Dec  6 21:24:12 erratic-orbits kernel: warning: `avahi-daemon' uses
32-bit capabilities (legacy support in use)
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Found user 'avahi'
(UID 106) and group 'avahi' (GID 114).
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Successfully
dropped root privileges.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: avahi-daemon 0.6.21
starting up.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Successfully called chroot().
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Successfully
dropped remaining capabilities.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: No service file
found in /etc/avahi/services.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Network interface
enumeration completed.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Registering HINFO
record with values 'I686'/'LINUX'.
Dec  6 21:24:12 erratic-orbits avahi-daemon[2870]: Server startup
complete. Host name is erratic-orbits.local. Local service cookie is
3151300777.
Dec  6 21:24:12 erratic-orbits dhcdbd: Started up.
Dec  6 21:24:12 erratic-orbits hcid[2906]: Bluetooth HCI daemon
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: Core ver 2.11
Dec  6 21:24:12 erratic-orbits kernel: NET: Registered protocol family 31
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: HCI device and
connection manager initialized
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: HCI socket layer initialized
Dec  6 21:24:12 erratic-orbits hcid[2906]: Starting SDP server
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: L2CAP ver 2.9
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: L2CAP socket layer initialized
Dec  6 21:24:12 erratic-orbits hcid[2906]: Created local server at
unix:abstract=/var/run/dbus-MeFsHTwsfU,guid=00c70fda273ded8bbdfe1cb14758aecc
Dec  6 21:24:12 erratic-orbits input[2926]: Bluetooth Input daemon
Dec  6 21:24:12 erratic-orbits input[2926]: Registered input manager
path:/org/bluez/input
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: RFCOMM socket layer
initialized
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: RFCOMM TTY layer initialized
Dec  6 21:24:12 erratic-orbits kernel: Bluetooth: RFCOMM ver 1.8
Dec  6 21:24:12 erratic-orbits audio[2927]: Bluetooth Audio daemon
Dec  6 21:24:12 erratic-orbits audio[2927]: Parsing
/etc/bluetooth/audio.conf failed: No such file or directory
Dec  6 21:24:12 erratic-orbits audio[2927]: Unix socket created: 5
Dec  6 21:24:12 erratic-orbits audio[2927]: add_service_record: got
record id 0x10000
Dec  6 21:24:12 erratic-orbits audio[2927]: add_service_record: got
record id 0x10001
Dec  6 21:24:12 erratic-orbits audio[2927]: Registered manager
path:/org/bluez/audio
Dec  6 21:24:18 erratic-orbits init: tty4 main process (2328)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty4 main process ended, respawning
Dec  6 21:24:18 erratic-orbits init: tty5 main process (2329)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty5 main process ended, respawning
Dec  6 21:24:18 erratic-orbits init: tty2 main process (2331)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty2 main process ended, respawning
Dec  6 21:24:18 erratic-orbits init: tty3 main process (2333)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty3 main process ended, respawning
Dec  6 21:24:18 erratic-orbits init: tty1 main process (2335)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty1 main process ended, respawning
Dec  6 21:24:18 erratic-orbits init: tty6 main process (2336)
terminated with status 1
Dec  6 21:24:18 erratic-orbits init: tty6 main process ended, respawning
Dec  6 21:24:19 erratic-orbits anacron[3012]: Anacron 2.3 started on 2007-12-06
Dec  6 21:24:19 erratic-orbits anacron[3012]: Normal exit (0 jobs run)
Dec  6 21:24:19 erratic-orbits atd[3025]: Error redirecting I/O:
Permission denied
Dec  6 21:24:19 erratic-orbits /usr/sbin/cron[3036]: (CRON) INFO
(pidfile fd = 3)
Dec  6 21:24:19 erratic-orbits /usr/sbin/cron[3037]: (CRON) STARTUP (fork ok)
Dec  6 21:24:19 erratic-orbits /usr/sbin/cron[3037]: (CRON) INFO
(Running @reboot jobs)
Dec  6 21:24:26 erratic-orbits gdm[2970]: CRITICAL:
gdm_config_value_get_bool: assertion `value->type ==
GDM_CONFIG_VALUE_BOOL' failed
Dec  6 21:24:28 erratic-orbits init: tty4 main process (2988)
terminated with status 1
Dec  6 21:24:28 erratic-orbits init: tty4 main process ended, respawning
Dec  6 21:24:28 erratic-orbits init: tty5 main process (2989)
terminated with status 1
Dec  6 21:24:28 erratic-orbits init: tty5 main process ended, respawning
Dec  6 21:24:28 erratic-orbits init: tty2 main process (2990)
terminated with status 1
Dec  6 21:24:28 erratic-orbits init: tty2 main process ended, respawning
Dec  6 21:24:28 erratic-orbits init: tty3 main process (2991)
terminated with status 1
