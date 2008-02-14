Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYBNGV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYBNGV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYBNGVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:21:19 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:54394 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYBNGVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:21:16 -0500
Date: Thu, 14 Feb 2008 11:50:33 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Chris Snook <csnook@redhat.com>
Cc: lenb@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 panics on boot
Message-ID: <20080214062033.GB17151@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080213170310.GC19570@linux.vnet.ibm.com> <47B3322A.2030607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B3322A.2030607@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 01:08:42PM -0500, Chris Snook wrote:
> Dhaval Giani wrote:
>> I am getting the following oops on bootup on 2.6.25-rc1
> ...
>> I am booting using kexec with maxcpus=1. It does not have any problems
>> with maxcpus=2 or higher.
>
> Sounds like another (the same?) kexec cpu numbering bug.  Can you post/link 
> the entire dmesg from both a cold boot and a kexec boot so we can compare?
>

Don't think its a kexec bug. Get the same on cold boot. dmesg from kexec boot.

[    0.000000] Linux version 2.6.25-rc1 (root@llm11.in.ibm.com) (gcc version 3.4.4 20050721 (Red Hat 3.4.4-2)) #5 SMP Thu Feb 14 06:46:02 IST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000e97f5f00 (usable)
[    0.000000]  BIOS-e820: 00000000e97f5f00 - 00000000e97ff800 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e97ff800 - 00000000e9800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] 4224MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009dc00 for 1024 bytes.
[    0.000000] found SMP MP-table at [c009dd40] 0009dd40
[    0.000000] Reserving 64MB of memory at 16MB for crashkernel (System RAM: 5111MB)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1310720
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1310720
[    0.000000] DMI 2.3 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000FDD90, 0014 (r0 IBM   )
[    0.000000] ACPI: RSDT E97FF780, 0030 (r1 IBM    SERONYXP     1000 IBM  45444F43)
[    0.000000] ACPI: FACP E97FF700, 0074 (r1 IBM    SERONYXP     1000 IBM  45444F43)
[    0.000000] ACPI: DSDT E97F5F00, 962E (r1 IBM    SERAVATR     1000 MSFT  100000B)
[    0.000000] ACPI: FACS E97FF5C0, 0040
[    0.000000] ACPI: APIC E97FF600, 00CA (r1 IBM    SERONYXP     1000 IBM  45444F43)
[    0.000000] ACPI: ASF! E97FF540, 004B (r16 IBM    SERONYXP        1 IBM  45444F43)
[    0.000000] ACPI: PM-Timer IO Port: 0x488
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] Processor #2 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] Processor #4 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] Processor #6 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] Processor #3 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] Processor #5 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] Processor #7 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 12, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Enabling APIC mode:  Flat.  Using 3 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at ea000000 (gap: e9800000:15400000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1294080
[    0.000000] Kernel command line: root=/dev/sdd1 console=ttyS0,38400 crashkernel=64M@16M nmi_watchdog=2 maxcpus=1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2488.156 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          30
[    0.004000] ... MAX_LOCKDEP_KEYS:        2048
[    0.004000] ... CLASSHASH_SIZE:           1024
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 992 kB
[    0.004000]  per task-struct memory footprint: 1200 bytes
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 4731916k/5242880k available (3107k kernel code, 141068k reserved, 1706k data, 260k init, 3956692k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc05ba000 - 0xc05fb000   ( 260 kB)
[    0.004000]       .data : 0xc0408e4a - 0xc05b371c   (1706 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0408e4a   (3107 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.084010] Calibrating delay using timer specific routine.. 4983.48 BogoMIPS (lpj=9966971)
[    0.092286] Mount-cache hash table entries: 512
[    0.100102] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.108012] CPU: L2 cache: 512K
[    0.112012] CPU: L3 cache: 1024K
[    0.116013] CPU: Physical Processor ID: 0
[    0.120015] Intel machine check architecture supported.
[    0.124017] Intel machine check reporting enabled on CPU#0.
[    0.128014] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.132020] Compat vDSO mapped to ffffe000.
[    0.136022] Checking 'hlt' instruction... OK.
[    0.158163] SMP alternatives: switching to UP code
[    0.160031] Freeing SMP alternatives: 14k freed
[    0.164016] ACPI: Core revision 20070126
[    0.200595] Parsing all Control Methods:
[    0.204180] Table [DSDT](id 0001) - 990 Objects with 113 Devices 426 Methods 13 Regions
[    0.208019]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.220036] evxfevnt-0079 [00] enable                : System is already in ACPI mode
[    0.232194] CPU0: Intel(R) Xeon(TM) MP CPU 2.50GHz stepping 05
[    0.244067] Total of 1 processors activated (4983.48 BogoMIPS).
[    0.252499] ENABLING IO-APIC IRQs
[    0.256251] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.304019] Brought up 1 CPUs
[    0.305161] net_namespace: 308 bytes
[    0.308747] NET: Registered protocol family 16
[    0.316064] ACPI: bus type pci registered
[    0.320630] PCI: PCI BIOS revision 2.10 entry at 0xfd74c, last bus=12
[    0.324046] PCI: Using configuration type 1
[    0.328053] Setting up standard PCI resources
[    0.342765] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x7
[    0.352175] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x7
[    0.368856] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 0 Runtime GPEs in this block
[    0.380358] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 1 Runtime GPEs in this block
[    0.411906] Completing Region/Field/Buffer/Package initialization:.................................
[    0.428442] Initialized 8/13 Regions 0/0 Fields 8/8 Buffers 17/18 Packages (999 nodes)
[    0.432032] Initializing Device/Processor/Thermal objects by executing _INI methods:.
[    0.647297] Executed 1 _INI methods requiring 0 _STA executions (examined 123 objects)
[    0.648128] ACPI: Interpreter enabled
[    0.652050] ACPI: (supports S0 S5)
[    0.660875] ACPI: Using IOAPIC for interrupt routing
[    0.708888] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.723588] ACPI: PCI Root Bridge [PCI1] (0000:01)
[    0.724861] ACPI: PCI Root Bridge [PCI2] (0000:05)
[    0.728811] ACPI: PCI Root Bridge [PCI3] (0000:08)
[    0.733374] ACPI: PCI Root Bridge [PCI4] (0000:09)
[    0.746441] ACPI: PCI Interrupt Link [LP00] (IRQs *10)
[    0.753299] ACPI: Blank IRQ resource
[    0.756056] ACPI: Resource is not an IRQ entry
[    0.760258] ACPI: PCI Interrupt Link [LP01] (IRQs) *0, disabled.
[    0.768985] ACPI: Blank IRQ resource
[    0.772056] ACPI: Resource is not an IRQ entry
[    0.776257] ACPI: PCI Interrupt Link [LP02] (IRQs) *0, disabled.
[    0.787897] ACPI: Blank IRQ resource
[    0.788057] ACPI: Resource is not an IRQ entry
[    0.796234] ACPI: PCI Interrupt Link [LP03] (IRQs) *0, disabled.
[    0.805192] ACPI: PCI Interrupt Link [LP04] (IRQs *5)
[    0.810378] ACPI: PCI Interrupt Link [LP05] (IRQs *5)
[    0.814331] ACPI: PCI Interrupt Link [LP06] (IRQs *5)
[    0.818343] ACPI: PCI Interrupt Link [LP07] (IRQs *5)
[    0.822338] ACPI: PCI Interrupt Link [LP08] (IRQs *5)
[    0.829507] ACPI: PCI Interrupt Link [LP09] (IRQs *5)
[    0.837507] ACPI: PCI Interrupt Link [LP0A] (IRQs *5)
[    0.845506] ACPI: PCI Interrupt Link [LP0B] (IRQs *5)
[    0.853504] ACPI: PCI Interrupt Link [LP0C] (IRQs *5)
[    0.861506] ACPI: PCI Interrupt Link [LP0D] (IRQs *5)
[    0.869506] ACPI: PCI Interrupt Link [LP0E] (IRQs *5)
[    0.877197] ACPI: PCI Interrupt Link [LP0F] (IRQs *5)
[    0.885208] ACPI: PCI Interrupt Link [LP10] (IRQs *5)
[    0.893195] ACPI: PCI Interrupt Link [LP11] (IRQs *5)
[    0.900629] ACPI: PCI Interrupt Link [LP12] (IRQs *5)
[    0.908632] ACPI: PCI Interrupt Link [LP13] (IRQs *5)
[    0.916630] ACPI: PCI Interrupt Link [LP14] (IRQs *5)
[    0.924632] ACPI: PCI Interrupt Link [LP15] (IRQs *5)
[    0.932569] ACPI: PCI Interrupt Link [LP16] (IRQs *5)
[    0.940437] ACPI: PCI Interrupt Link [LP17] (IRQs *5)
[    0.948292] ACPI: PCI Interrupt Link [LP18] (IRQs *5)
[    0.956159] ACPI: PCI Interrupt Link [LP19] (IRQs *5)
[    0.962340] ACPI: PCI Interrupt Link [LP1A] (IRQs *5)
[    0.966341] ACPI: PCI Interrupt Link [LP1B] (IRQs *5)
[    0.970343] ACPI: PCI Interrupt Link [LP1C] (IRQs *9)
[    0.974341] ACPI: PCI Interrupt Link [LP1D] (IRQs *9)
[    0.978142] ACPI: Blank IRQ resource
[    0.980069] ACPI: Resource is not an IRQ entry
[    0.984269] ACPI: PCI Interrupt Link [LP1E] (IRQs) *0, disabled.
[    0.993206] ACPI: PCI Interrupt Link [LP1F] (IRQs *3)
[    1.001519] ACPI: PCI Interrupt Link [LPUS] (IRQs *11)
[    1.009458] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.012214] pnp: PnP ACPI init
[    1.016135] ACPI: bus type pnp registered
[    1.080559] pnp: PnP ACPI: found 16 devices
[    1.084077] ACPI: ACPI bus type pnp unregistered
[    1.089161] SCSI subsystem initialized
[    1.092692] PCI: Using ACPI for IRQ routing
[    1.096086] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    1.112067] Time: tsc clocksource has been installed.
[    1.116172] system 00:01: ioport range 0x900-0x93f has been reserved
[    1.120081] system 00:01: ioport range 0x510-0x517 has been reserved
[    1.124081] system 00:01: ioport range 0x504-0x507 has been reserved
[    1.128081] system 00:01: ioport range 0x500-0x503 has been reserved
[    1.132081] system 00:01: ioport range 0x520-0x53f has been reserved
[    1.136081] system 00:01: ioport range 0x420-0x427 has been reserved
[    1.140082] system 00:01: ioport range 0x460-0x461 has been reserved
[    1.144106] system 00:0b: ioport range 0x1ec-0x1ef has been reserved
[    1.148084] system 00:0b: ioport range 0x400-0x4fe could not be reserved
[    1.152082] system 00:0b: ioport range 0x600-0x600 has been reserved
[    1.156083] system 00:0b: ioport range 0x800-0x80f has been reserved
[    1.160085] system 00:0b: ioport range 0xc00-0xcfe could not be reserved
[    1.164083] system 00:0b: ioport range 0xf50-0xf58 has been reserved
[    1.168087] system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
[    1.208055] NET: Registered protocol family 2
[    1.208400] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.213035] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.217326] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.231138] TCP: Hash tables configured (established 131072 bind 65536)
[    1.232148] TCP reno registered
[    1.237205] checking if image is initramfs... it is
[    1.273950] Freeing initrd memory: 298k freed
[    1.282923] Machine check exception polling timer started.
[    1.293703] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    1.307534] audit: initializing netlink socket (disabled)
[    1.308179] type=2000 audit(1202972872.679:1): initialized
[    1.313132] highmem bounce pool size: 64 pages
[    1.316100] Total HugeTLB memory allocated, 0
[    1.325444] io scheduler noop registered
[    1.328093] io scheduler anticipatory registered (default)
[    1.332092] io scheduler deadline registered
[    1.336123] io scheduler cfq registered
[    1.345336] input: Power Button (FF) as /class/input/input0
[    1.348156] ACPI: Power Button (FF) [PWRF]
[    1.359185] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.360409] BIOS reported wrong ACPI id for the processor
[    2.372176] ACPI Exception (evxface-0544): AE_NOT_EXIST, Removing notify handler [20070126]
[    2.380187] BUG: unable to handle kernel NULL pointer dereference at 0000010c
[    2.392180] IP: [<c01a9105>] sysfs_remove_link+0x1/0xd
[    2.400181] *pdpt = 00000000005fd001 *pde = 0000000000000000 
[    2.408750] Oops: 0000 [#1] SMP 
[    2.412178] Modules linked in:
[    2.412178] 
[    2.412178] Pid: 1, comm: swapper Not tainted (2.6.25-rc1 #5)
[    2.412178] EIP: 0060:[<c01a9105>] EFLAGS: 00010206 CPU: 0
[    2.412178] EIP is at sysfs_remove_link+0x1/0xd
[    2.412178] EAX: 000000f0 EBX: f7202cc8 ECX: f789eaf0 EDX: c0533e87
[    2.412178] ESI: f793c970 EDI: ffffffed EBP: f78a1ea0 ESP: f78a1e90
[    2.412178]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    2.412178] Process swapper (pid: 1, ti=f78a0000 task=f789eaf0 task.ti=f78a0000)
[    2.412178] Stack: f78a1ea0 c02709e4 c0568920 f793c970 f78a1eb4 c0269fb5 f793c970 f793cb7c 
[    2.412178]        c0568920 f78a1ecc c0269b25 00000000 f793cb7c 00000000 c05689f0 f78a1ee0 
[    2.412179]        c02b6460 c05689f0 f793cb7c 00000000 f78a1ef4 c02b6528 f793cb7c f78c332c 
[    2.412179] Call Trace:
[    2.412179]  [<c02709e4>] ? acpi_processor_remove+0x82/0xb4
[    2.412179]  [<c0269fb5>] ? acpi_start_single_object+0x3a/0x41
[    2.412179]  [<c0269b25>] ? acpi_device_probe+0x3b/0x79
[    2.412179]  [<c02b6460>] ? really_probe+0x74/0xf2
[    2.412179]  [<c02b6528>] ? driver_probe_device+0x37/0x40
[    2.412179]  [<c02b6639>] ? __driver_attach+0x76/0xaf
[    2.412179]  [<c02b5825>] ? bus_for_each_dev+0x38/0x5d
[    2.412179]  [<c0238906>] ? kobject_init_and_add+0x20/0x22
[    2.412179]  [<c02b6686>] ? driver_attach+0x14/0x16
[    2.412179]  [<c02b65c3>] ? __driver_attach+0x0/0xaf
[    2.412179]  [<c02b5e04>] ? bus_add_driver+0x99/0x149
[    2.412179]  [<c02b6a68>] ? driver_register+0x43/0x69
[    2.412179]  [<c0269ff6>] ? acpi_bus_register_driver+0x3a/0x3c
[    2.412179]  [<c05cf8dc>] ? acpi_processor_init+0x70/0xa6
[    2.412179]  [<c05ba8e0>] ? kernel_init+0x0/0x88
[    2.412179]  [<c05ba779>] ? do_initcalls+0x75/0x18d
[    2.412179]  [<c01a3eb9>] ? create_proc_entry+0x67/0x7b
[    2.412179]  [<c01527b7>] ? register_irq_proc+0xa4/0xba
[    2.412179]  [<c01a0000>] ? pagemap_read+0x13a/0x1c2
[    2.412179]  [<c05ba8e0>] ? kernel_init+0x0/0x88
[    2.412179]  [<c05ba8ad>] ? do_basic_setup+0x1c/0x1e
[    2.412179]  [<c05ba92d>] ? kernel_init+0x4d/0x88
[    2.412179]  [<c010563b>] ? kernel_thread_helper+0x7/0x10
[    2.412179]  =======================
[    2.412179] Code: c0 74 07 89 f0 e8 57 f4 ff ff 85 ff 74 11 90 ff 0f 0f 94 c0 84 c0 74 07 89 f8 e8 42 f4 ff ff 8b 45 d8 83 c4 1c 5b 5e 5f 5d c3 55 <8b> 40 1c 89 e5 e8 c1 e8 ff ff 5d c3 55 89 e5 57 89 cf 56 89 c6 
[    2.412179] EIP: [<c01a9105>] sysfs_remove_link+0x1/0xd SS:ESP 0068:f78a1e90
[    2.412191] ---[ end trace 778e504de7e3b1e3 ]---
[    2.416182] Kernel panic - not syncing: Attempted to kill init!

Won't be able to a bisect for sometime, but can try debug patches.

-- 
regards,
Dhaval
