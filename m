Return-Path: <linux-kernel-owner+w=401wt.eu-S1422783AbXDXS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422783AbXDXS2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422995AbXDXS2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:28:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:25900 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422783AbXDXS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type;
        b=U3KAojQeKbW/DetE2kJ1LObOd94YXFwA2ogFEolSJLP5v5CsmdBIindsSQmtlc3/T6SFaKZTKb7m24SMS4aPv4+Kw/lty9+sKJiEiNM1jvPIwgeTbm0nkRc6ps9NphYxjzQU4WtmnBI/rJqG8XXTjat4DHc2e+ck+0BUkFdb83g=
Message-ID: <462E4C4D.9020806@gmail.com>
Date: Tue, 24 Apr 2007 12:28:29 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------050100060009070603030408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050100060009070603030408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Kernel panic on boot, console output attached.


--------------050100060009070603030408
Content-Type: text/plain;
 name="rc7mm1-bug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rc7mm1-bug"

[14316256.221707] Linux version 2.6.21-rc7-mm1 (root@luna) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Apr 24 12:09:02 MDT 2007
[14316256.221707] Command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[14316256.221707] BIOS-provided physical RAM map:
[14316256.221707]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[14316256.221707]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[14316256.221707]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[14316256.221707]  BIOS-e820: 0000000000100000 - 000000003ff80000 (usable)
[14316256.221707]  BIOS-e820: 000000003ff80000 - 000000003ff8e000 (ACPI data)
[14316256.221707]  BIOS-e820: 000000003ff8e000 - 000000003ffe0000 (ACPI NVS)
[14316256.221707]  BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
[14316256.221707]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[14316256.221707] end_pfn_map = 1048576
[14316256.221707] DMI 2.4 present.
[14316256.221707] ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
[14316256.221707] ACPI: XSDT 3FF80100, 0064 (r1 NEC              1000724 MSFT       97)
[14316256.221707] ACPI: FACP 3FF80290, 00F4 (r3 A_M_I_ OEMFACP   1000724 MSFT       97)
[14316256.221707] ACPI: DSDT 3FF80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
[14316256.221707] ACPI: FACS 3FF8E000, 0040
[14316256.221707] ACPI: APIC 3FF80390, 0080 (r1 A_M_I_ OEMAPIC   1000724 MSFT       97)
[14316256.221707] ACPI: SLIC 3FF80410, 0176 (r1 NEC              1000724 MSFT       97)
[14316256.221707] ACPI: OEMB 3FF8E040, 0066 (r1 A_M_I_ AMI_OEM   1000724 MSFT       97)
[14316256.221707] ACPI: HPET 3FF89AF0, 0038 (r1 A_M_I_ OEMHPET   1000724 MSFT       97)
[14316256.221707] ACPI: MCFG 3FF89B30, 003C (r1 A_M_I_ OEMMCFG   1000724 MSFT       97)
[14316256.221707] ACPI: SSDT 3FF8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[14316256.221707] ACPI: SSDT 3FF8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[14316256.221707] Zone PFN ranges:
[14316256.221707]   DMA             0 ->     4096
[14316256.221707]   DMA32        4096 ->  1048576
[14316256.221707]   Normal    1048576 ->  1048576
[14316256.221707] Movable zone start PFN for each node
[14316256.221707] early_node_map[2] active PFN ranges
[14316256.221707]     0:        0 ->      159
[14316256.221707]     0:      256 ->   262016
[14316256.221707] ACPI: PM-Timer IO Port: 0x808
[14316256.221707] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[14316256.221707] Processor #0 (Bootup-CPU)
[14316256.221707] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[14316256.221707] Processor #1
[14316256.221707] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[14316256.221707] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[14316256.221707] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[14316256.221707] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[14316256.221707] Setting APIC routing to flat
[14316256.221707] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[14316256.221707] Using ACPI (MADT) for SMP configuration information
[14316256.221707] Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
[14316256.221707] PERCPU: Allocating 32896 bytes of per cpu data
[14316256.221707] Built 1 zonelists, mobility grouping on.  Total pages: 257236
[14316256.221707] Kernel command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[14316256.221707] Initializing CPU#0
[14316256.221707] PID hash table entries: 4096 (order: 12, 32768 bytes)
[14316256.221707] time.c: Detected 2564.902 MHz processor.
[14316256.231707] Console: colour VGA+ 80x25
[14316256.235040] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[14316256.235040] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[14316256.235040] Checking aperture...
[14316256.241707] Memory: 1026888k/1048064k available (2355k kernel code, 20620k reserved, 1490k data, 212k init)
[14316256.325040] Calibrating delay using timer specific routine.. 5134.38 BogoMIPS (lpj=8554219)
[14316256.325040] Mount-cache hash table entries: 256
[14316256.325040] CPU: L1 I cache: 32K, L1 D cache: 32K
[14316256.325040] CPU: L2 cache: 2048K
[14316256.325040] using mwait in idle threads.
[14316256.325040] CPU: Physical Processor ID: 0
[14316256.325040] CPU: Processor Core ID: 0
[14316256.325040] CPU0: Thermal monitoring enabled (TM2)
[14316256.325040] Freeing SMP alternatives: 26k freed
[14316256.325040] ACPI: Core revision 20070126
[14316256.361707] Using local APIC timer interrupts.
[14316256.361707] result 22900897
[14316256.361707] Detected 22.900 MHz APIC timer.
[14316256.368374] Booting processor 1/2 APIC 0x1
[14316256.378374] Initializing CPU#1
[14316256.461707] Calibrating delay using timer specific routine.. 5131.29 BogoMIPS (lpj=8549273)
[14316256.461707] CPU: L1 I cache: 32K, L1 D cache: 32K
[14316256.461707] CPU: L2 cache: 2048K
[14316256.461707] CPU: Physical Processor ID: 0
[14316256.461707] CPU: Processor Core ID: 1
[14316256.461707] CPU1: Thermal monitoring enabled (TM2)
[14316256.461707] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[14316256.461707] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[14316256.468374] Brought up 2 CPUs
[14316256.591707] migration_cost=3333
[14316256.591707] BUG: at arch/x86_64/kernel/../../i386/kernel/sched-clock.c:175 init_sched_clock()
[14316256.591707] 
[14316256.591707] Call Trace:
[14316256.591707]  [<ffffffff8025dae3>] dump_trace+0xb6/0x3d6
[14316256.591707]  [<ffffffff8025de3f>] show_trace+0x3c/0x52
[14316256.591707]  [<ffffffff8025de6a>] dump_stack+0x15/0x17
[14316256.591707]  [<ffffffff805e24f9>] init_sched_clock+0x57/0x64
[14316256.591707]  [<ffffffff805dc654>] kernel_init+0x167/0x2df
[14316256.591707]  [<ffffffff80255978>] child_rip+0xa/0x12
[14316256.591707] 
[    0.370007] NET: Registered protocol family 16
[    0.370103] ACPI: bus type pci registered
[    0.370149] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[    0.370192] PCI: Not using MMCONFIG.
[    0.370232] PCI: Using configuration type 1
[    0.379163] ACPI: Interpreter enabled
[    0.379204] ACPI: Using IOAPIC for interrupt routing
[    0.386382] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.386815] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.386860] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.386938] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[    0.386982] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[    0.387026] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[    0.387069] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[    0.387575] PCI: Transparent bridge - 0000:00:1e.0
[    0.390113] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.390562] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.391011] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.391475] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.391922] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.392370] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.392818] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.393265] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.393688] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.393738] pnp: PnP ACPI init
[    0.393782] ACPI: bus type pnp registered
[    0.396339] pnp: PnP ACPI: found 15 devices
[    0.396381] ACPI: ACPI bus type pnp unregistered
[    0.396529] SCSI subsystem initialized
[    0.396613] PCI: Using ACPI for IRQ routing
[    0.396654] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.396774] PCI-GART: No AMD northbridge found.
[    0.396817] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.396963] hpet0: 3 64-bit timers, 14318180 Hz
[    0.398059] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.398108] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[    0.398155] pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.398200] pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.398244] pnp: 00:08: iomem range 0xfed: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.398347] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.398393] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.398451] pnp: 00:0d: iome0-0x9ffff could not be reserved
[    0.398542] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    0.398586] pnp: bled.
[    0.398942]   MEM window: faa00000-feafffff
[    0.398983]   PREFETCH window: cff00000-efefffff
[    0.399025] PCI:
[    0.399147]   PREFETCH window: cfe00000-cfefffff
[    0.399191] PCI: Bridge: 0000:00:1c.3
[    0.399231]   IO window: c00
[    0.399358] PCI: Bridge: 0000:00:1e.0
[    0.399398]   IO window: b000-bfff
[    0.399440]   MEM window: fa700000-fa8ffff-> IRQ 16
[    0.399719] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.399825] NET: Registered protocol family 2
[    0.401113] Time: tsc clocksource has been installed.
[    0.444654] IP route cache hash table entries: 2 (order: 9, 3145728 bytes)
[    0.445966] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.446496] TCP: H681707] audit: initializing netlink socket (disabled)
[14316256.681707] audit(1177416960.456:1): initialized
[14316256.681707ign_interrupt_mode Found MSI capability
[14316256.705040] input: Power Button (FF) as /class/input/input0
[14316256.705040] ACPI: Power Button (FF) [PWRF]
[14316256.705040] input: Power Button (CM) as /class/input/input1
[14316256.705040] ACPI: Power table [OEMB] -  00, should be F7 [20070126]
[14316256.705040] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_s Serialized
[14316256.705040] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff810002057bCPI: Processor [CPU1] (supports 8 throttling states)
[14316256.705040] ACPI Error (psparse-0537): Method parse/execution faile(Node ffff810002057a30), AE_ALREADY_EXISTS
[14316256.705040] ACPI: Marking method _PDC as Serialized
[14316256.705040] ACPI: 4316256.708374] intel_rng: FWH not detected
[14316256.708374] Linux agpgart interface v0.102 (c) Dave Jones
[14316256.708374] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[14316256.708374] 00:0c: ttyS0 at I/O 0x3f8 (irq =  low) -> IRQ 22
[14316258.065040] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[14316258.065040]         <Adaptec 2940 Ultra2 SCSI adapter>
[14316258.065040]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[14316258.065040] 
[14316258.088374] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
[    2.131675] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[    2.139821] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[    2.145306]  target0:0:1: Beginning Domain Validation
[    2.156823]  target0:0:1: wide asynchronous
[    2.165751]  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    2.176992]  target0:0:1: Domain Validation skipping write tests
[    2.183054]  target0:0:1: Ending Domain Validation
[    2.190882] scsi 0:0:2:0: Direct-Access     SGI      SEAGATE ST39102L 2702 PQ: 0 ANSI: 2
[    2.199011] scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
[    2.204513]  target0:0:2: Beginning Domain Validation
[    2.214897]  target0:0:2: wide asynchronous
[    2.223011]  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    2.233459]  target0:0:2: Domain Validation skipping write tests
[    2.239500]  target0:0:2: Ending Domain Validation
[14316259.098373] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[14316259.105040] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.923144] Unable to handle kernel NULL pointer dereference at 0000000000000058 RIP: 
[    2.928657]  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
[    2.936805] PGD 0 
[    2.938896] Oops: 0000 [1] SMP 
[    2.942163] CPU 0 
[    2.944250] Modules linked in:
[    2.947394] Pid: 0, comm: swapper Tainted: G      D 2.6.21-rc7-mm1 #1
[    2.953862] RIP: 0010:[<ffffffff803ae98b>]  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
[    2.962210] RSP: 0000:ffffffff80615e28  EFLAGS: 00010206
[    2.967557] RAX: ffffffff80479b60 RBX: 0000000000000000 RCX: 0000000004050000
[    2.974730] RDX: 000000000000001b RSI: ffffffffffffffe5 RDI: 0000000000000000
[    2.981892] RBP: ffffffff80615e38 R08: 00000000ffffffff R09: 0000000000000030
[    2.989072] R10: 0000000000000000 R11: 0000000000000000 R12: ffff810002f5c000
[    2.996252] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000000
[    3.003433] FS:  0000000000000000(0000) GS:ffffffff805c2000(0000) knlGS:0000000000000000
[    3.011570] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    3.017351] CR2: 0000000000000058 CR3: 0000000000201000 CR4: 00000000000006e0
[    3.024518] Process swapper (pid: 0, threadinfo ffffffff805d2000, task ffffffff80589380)
[    3.032661] Stack:  ffff810002f5c000 ffff810002f5c000 ffffffff80615e58 ffffffff803e1e01
[    3.040930]  ffffffff80615e78 ffff810002f5e9e0 ffffffff80615e88 ffffffff803e1ea7
[    3.048552]  000000000000002e ffff810002f5c000 ffff810002f5c000 0000000000400040
[    3.055950] Call Trace:
[    3.058672]  [<ffffffff803e1e01>] ata_port_schedule_eh+0x4c/0x50
[    3.064725]  [<ffffffff803e1ea7>] ata_port_abort+0xa2/0xae
[    3.070248]  [<ffffffff803e1ef9>] ata_port_freeze+0x46/0x57
[    3.075853]  [<ffffffff803e4c39>] ahci_interrupt+0x300/0x47a
[    3.081552]  [<ffffffff8020eb83>] handle_IRQ_event+0x27/0x57
[    3.087253]  [<ffffffff8029a021>] handle_edge_irq+0xee/0x133
[    3.092960]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
[    3.097793]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
[    3.103059]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
[    3.108231]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
[    3.113227]  [<ffffffff8025c988>] rest_init+0x49/0x4b
[    3.118322]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
[    3.123837]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
[    3.129199] 
[    3.130726] 
[    3.130726] Code: 48 8b 7f 58 e8 96 b0 ea ff be 05 00 00 00 48 89 df 49 89 c4 
[    3.140452] RIP  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
[    3.146449]  RSP <ffffffff80615e28>
[    3.149975] CR2: 0000000000000058
[    3.153408] Kernel panic - not syncing: Aiee, killing interrupt handler!

--------------050100060009070603030408--
