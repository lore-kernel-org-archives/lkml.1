Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYCKIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYCKIDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYCKICy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:02:54 -0400
Received: from lucidpixels.com ([75.144.35.66]:50887 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYCKICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:02:45 -0400
Date: Tue, 11 Mar 2008 04:02:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.3: WARNING: native_smp_call_function_mask() at boot
 time
In-Reply-To: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan>
Message-ID: <alpine.DEB.1.00.0803110402250.3395@p34.internal.lan>
References: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comment/regarding this problem?  Please cc me as I am not on the list, 
thanks.

On Mon, 10 Mar 2008, Justin Piszcz wrote:

> Running kernel 2.6.24.3 on Debian Testing here..
> Kernel config attached.
>
> Problem(?) in question:
> [   19.130558] Intel machine check architecture supported.
> [   19.130560] Intel machine check reporting enabled on CPU#1.
> [   19.130977] CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 
> 06
> [   19.131428] Total of 2 processors activated (10883.20 BogoMIPS).
> [   19.131613] ENABLING IO-APIC IRQs
> [   19.131808] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [   19.141846] WARNING: at arch/x86/kernel/smp_32.c:561 
> native_smp_call_function_mask()
> [   19.141896] Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
> [   19.141937]  [<c010e50b>] native_smp_call_function_mask+0x14b/0x150
> [   19.142009]  [<c01036c3>] common_interrupt+0x23/0x28
> [   19.142076]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142144]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142212]  [<c010e8fc>] smp_call_function+0x1c/0x30
> [   19.142279]  [<c012196c>] on_each_cpu+0x2c/0x60
> [   19.142346]  [<c0110840>] setup_nmi+0x30/0x50
> [   19.142413]  [<c054cc21>] setup_IO_APIC+0xdd1/0xf30
> [   19.142482]  [<c02cf850>] vt_console_print+0x0/0x2c0
> [   19.142550]  [<c011cdaa>] release_console_sem+0x1ba/0x1e0
> [   19.142619]  [<c011d33b>] printk+0x1b/0x20
> [   19.142685]  [<c05489fb>] native_smp_prepare_cpus+0x57b/0xac0
> [   19.142754]  [<c01188b4>] set_cpus_allowed+0x44/0xa0
> [   19.142821]  [<c0540700>] kernel_init+0x0/0x300
> [   19.142888]  [<c0540752>] kernel_init+0x52/0x300
> [   19.142954]  [<c0118d97>] finish_task_switch+0x27/0x80
> [   19.143022]  [<c0119327>] schedule_tail+0x17/0x60
> [   19.143089]  [<c0102bd2>] ret_from_fork+0x6/0x1c
> [   19.143155]  [<c0540700>] kernel_init+0x0/0x300
> [   19.143222]  [<c0540700>] kernel_init+0x0/0x300
> [   19.143288]  [<c01038d3>] kernel_thread_helper+0x7/0x14
> [   19.143356]  =======================
> [   19.244403] APIC timer registered as dummy, due to nmi_watchdog=1!
> [   19.244504] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [   19.264560] Brought up 2 CPUs
>
> Full dmesg output below:
>
> [    0.000000] Linux version 2.6.24.3 (root@machine_name) (gcc version 4.2.3 
> (Debian 4.2.3-1)) #1 SMP PREEMPT Tue Feb 26 04:15:02 EST 2008
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
> [    0.000000] Warning only 4GB will be used.
> [    0.000000] Use a HIGHMEM64G enabled kernel.
> [    0.000000] 3200MB HIGHMEM available.
> [    0.000000] 896MB LOWMEM available.
> [    0.000000] found SMP MP-table at 000f3430
> [    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   Normal       4096 ->   229376
> [    0.000000]   HighMem    229376 ->  1048576
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[1] active PFN ranges
> [    0.000000]     0:        0 ->  1048576
> [    0.000000] On node 0 totalpages: 1048576
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1760 pages used for memmap
> [    0.000000]   Normal zone: 223520 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 6400 pages used for memmap
> [    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] DMI 2.2 present.
> [    0.000000] ACPI: RSDP 000F7330, 0014 (r0 IntelR)
> [    0.000000] ACPI: RSDT CFEE3040, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD 
> 0)
> [    0.000000] ACPI: FACP CFEE30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD 
> 0)
> [    0.000000] ACPI: DSDT CFEE3180, 485D (r1 INTELR AWRDACPI     1000 MSFT 
> 100000E)
> [    0.000000] ACPI: FACS CFEE0000, 0040
> [    0.000000] ACPI: MCFG CFEE7B40, 003C (r1 IntelR AWRDACPI 42302E31 AWRD 
> 0)
> [    0.000000] ACPI: APIC CFEE7A40, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD 
> 0)
> [    0.000000] ACPI: SSDT CFEE7BC0, 019E (r1  PmRef  Cpu0Ist     3000 INTL 
> 20041203)
> [    0.000000] ACPI: SSDT CFEE8050, 02F1 (r1  PmRef    CpuPm     3000 INTL 
> 20041203)
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] Processor #0 6:15 APIC version 20
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] Processor #1 6:15 APIC version 20
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: 
> cff00000:10100000)
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
> pages: 1040384
> [    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.24.3-1 ro root=802 
> netconsole=4444@192.168.0.1/eth0,514@192.168.0.254/00:19:D1:6E:9D:43 
> nmi_watchdog=1
> [    0.000000] mapped APIC to ffffb000 (fee00000)
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Detected 2720.482 MHz processor.
> [   18.849054] Console: colour VGA+ 80x25
> [   18.849057] console [tty0] enabled
> [   18.851688] Dentry cache hash table entries: 131072 (order: 7, 524288 
> bytes)
> [   18.851914] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [   18.991168] Memory: 3367044k/4194304k available (3253k kernel code, 38552k 
> reserved, 1071k data, 224k init, 2489216k highmem)
> [   18.991225] virtual kernel memory layout:
> [   18.991226]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
> [   18.991226]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [   18.991227]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
> [   18.991228]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
> [   18.991228]       .init : 0xc0540000 - 0xc0578000   ( 224 kB)
> [   18.991229]       .data : 0xc042d514 - 0xc053930c   (1071 kB)
> [   18.991230]       .text : 0xc0100000 - 0xc042d514   (3253 kB)
> [   18.991541] Checking if this processor honours the WP bit even in 
> supervisor mode... Ok.
> [   18.991647] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, 
> CPUs=2, Nodes=1
> [   19.051640] Calibrating delay using timer specific routine.. 5443.06 
> BogoMIPS (lpj=2721534)
> [   19.051740] Mount-cache hash table entries: 512
> [   19.051871] CPU: After generic identify, caps: bfebfbff 20100000 00000000 
> 00000000 0000e3bd 00000000 00000001 00000000
> [   19.051876] monitor/mwait feature present.
> [   19.051915] using mwait in idle threads.
> [   19.051955] CPU: L1 I cache: 32K, L1 D cache: 32K
> [   19.052022] CPU: L2 cache: 4096K
> [   19.052060] CPU: Physical Processor ID: 0
> [   19.052099] CPU: Processor Core ID: 0
> [   19.052137] CPU: After all inits, caps: bfebfbff 20100000 00000000 
> 00003940 0000e3bd 00000000 00000001 00000000
> [   19.052141] Intel machine check architecture supported.
> [   19.052182] Intel machine check reporting enabled on CPU#0.
> [   19.052224] Compat vDSO mapped to ffffe000.
> [   19.052270] Checking 'hlt' instruction... OK.
> [   19.055927] Freeing SMP alternatives: 13k freed
> [   19.055966] ACPI: Core revision 20070126
> [   19.060026] CPU0: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 
> 06
> [   19.060133] Booting processor 1/1 eip 2000
> [   19.071017] Initializing CPU#1
> [   19.130541] Calibrating delay using timer specific routine.. 5440.13 
> BogoMIPS (lpj=2720069)
> [   19.130545] CPU: After generic identify, caps: bfebfbff 20100000 00000000 
> 00000000 0000e3bd 00000000 00000001 00000000
> [   19.130548] monitor/mwait feature present.
> [   19.130550] CPU: L1 I cache: 32K, L1 D cache: 32K
> [   19.130552] CPU: L2 cache: 4096K
> [   19.130553] CPU: Physical Processor ID: 0
> [   19.130554] CPU: Processor Core ID: 1
> [   19.130555] CPU: After all inits, caps: bfebfbff 20100000 00000000 
> 00003940 0000e3bd 00000000 00000001 00000000
> [   19.130558] Intel machine check architecture supported.
> [   19.130560] Intel machine check reporting enabled on CPU#1.
> [   19.130977] CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 
> 06
> [   19.131428] Total of 2 processors activated (10883.20 BogoMIPS).
> [   19.131613] ENABLING IO-APIC IRQs
> [   19.131808] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [   19.141846] WARNING: at arch/x86/kernel/smp_32.c:561 
> native_smp_call_function_mask()
> [   19.141896] Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
> [   19.141937]  [<c010e50b>] native_smp_call_function_mask+0x14b/0x150
> [   19.142009]  [<c01036c3>] common_interrupt+0x23/0x28
> [   19.142076]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142144]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
> [   19.142212]  [<c010e8fc>] smp_call_function+0x1c/0x30
> [   19.142279]  [<c012196c>] on_each_cpu+0x2c/0x60
> [   19.142346]  [<c0110840>] setup_nmi+0x30/0x50
> [   19.142413]  [<c054cc21>] setup_IO_APIC+0xdd1/0xf30
> [   19.142482]  [<c02cf850>] vt_console_print+0x0/0x2c0
> [   19.142550]  [<c011cdaa>] release_console_sem+0x1ba/0x1e0
> [   19.142619]  [<c011d33b>] printk+0x1b/0x20
> [   19.142685]  [<c05489fb>] native_smp_prepare_cpus+0x57b/0xac0
> [   19.142754]  [<c01188b4>] set_cpus_allowed+0x44/0xa0
> [   19.142821]  [<c0540700>] kernel_init+0x0/0x300
> [   19.142888]  [<c0540752>] kernel_init+0x52/0x300
> [   19.142954]  [<c0118d97>] finish_task_switch+0x27/0x80
> [   19.143022]  [<c0119327>] schedule_tail+0x17/0x60
> [   19.143089]  [<c0102bd2>] ret_from_fork+0x6/0x1c
> [   19.143155]  [<c0540700>] kernel_init+0x0/0x300
> [   19.143222]  [<c0540700>] kernel_init+0x0/0x300
> [   19.143288]  [<c01038d3>] kernel_thread_helper+0x7/0x14
> [   19.143356]  =======================
> [   19.244403] APIC timer registered as dummy, due to nmi_watchdog=1!
> [   19.244504] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [   19.264560] Brought up 2 CPUs
> [   19.264705] net_namespace: 64 bytes
> [   19.264950] NET: Registered protocol family 16
> [   19.265070] ACPI: bus type pci registered
> [   19.265115] PCI: Using MMCONFIG
> [   19.265517] Setting up standard PCI resources
> [   19.266222] mtrr: your CPUs had inconsistent variable MTRR settings
> [   19.266263] mtrr: probably your BIOS does not setup all CPUs.
> [   19.266303] mtrr: corrected configuration.
> [   19.267455] ACPI: EC: Look up EC in DSDT
> [   19.270146] ACPI: Interpreter enabled
> [   19.270185] ACPI: (supports S0 S5)
> [   19.270280] ACPI: Using IOAPIC for interrupt routing
> [   19.273395] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [   19.273774] Force enabled HPET at base address 0xfed00000
> [   19.273777] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> [   19.273819] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
> [   19.274321] PCI: Transparent bridge - 0000:00:1e.0
> [   19.274379] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [   19.274489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
> [   19.274541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
> [   19.274593] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
> [   19.274645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
> [   19.282717] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 9 *10 11 12 14 15)
> [   19.283126] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *5 7 9 10 11 12 14 15)
> [   19.283542] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 *7 9 10 11 12 14 15)
> [   19.283947] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9 10 *11 12 14 15)
> [   19.284353] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 9 10 11 12 14 15) 
> *0, disabled.
> [   19.284827] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 9 10 11 12 14 15) 
> *0, disabled.
> [   19.285295] ACPI: PCI Interrupt Link [LNK0] (IRQs 4 5 7 9 10 11 12 14 15) 
> *0, disabled.
> [   19.285769] ACPI: PCI Interrupt Link [LNK1] (IRQs *4 5 7 9 10 11 12 14 15)
> [   19.286181] Linux Plug and Play Support v0.97 (c) Adam Belay
> [   19.286237] pnp: PnP ACPI init
> [   19.286278] ACPI: bus type pnp registered
> [   19.287860] pnpacpi: exceeded the max number of mem resources: 12
> [   19.287936] pnp: PnP ACPI: found 13 devices
> [   19.287975] ACPI: ACPI bus type pnp unregistered
> [   19.288948] SCSI subsystem initialized
> [   19.289002] libata version 3.00 loaded.
> [   19.289059] usbcore: registered new interface driver usbfs
> [   19.289131] usbcore: registered new interface driver hub
> [   19.289193] usbcore: registered new device driver usb
> [   19.289321] PCI: Using ACPI for IRQ routing
> [   19.289360] PCI: If a device doesn't work, try "pci=routeirq".  If it 
> helps, post a report
> [   19.293500] hpet clockevent registered
> [   19.293503] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [   19.293652] hpet0: 3 64-bit timers, 14318180 Hz
> [   19.295500] Time: tsc clocksource has been installed.
> [   19.298518] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
> [   19.298559] system 00:01: ioport range 0x880-0x88f has been reserved
> [   19.298604] system 00:08: ioport range 0x400-0x4bf could not be reserved
> [   19.298648] system 00:0b: iomem range 0xe0000000-0xefffffff could not be 
> reserved
> [   19.298700] system 00:0c: iomem range 0x636500-0xd1ccff could not be 
> reserved
> [   19.298741] system 00:0c: iomem range 0xf0000-0xf7fff could not be 
> reserved
> [   19.298783] system 00:0c: iomem range 0xf8000-0xfbfff could not be 
> reserved
> [   19.298824] system 00:0c: iomem range 0xfc000-0xfffff could not be 
> reserved
> [   19.298866] system 00:0c: iomem range 0xcfee0000-0xcfefffff could not be 
> reserved
> [   19.298915] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
> [   19.298957] system 00:0c: iomem range 0x100000-0xcfedffff could not be 
> reserved
> [   19.299006] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be 
> reserved
> [   19.299055] system 00:0c: iomem range 0xfed13000-0xfed1dfff could not be 
> reserved
> [   19.299105] system 00:0c: iomem range 0xfed20000-0xfed8ffff could not be 
> reserved
> [   19.299154] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be 
> reserved
> [   19.299203] system 00:0c: iomem range 0xffb00000-0xffb7ffff could not be 
> reserved
> [   19.329446] PCI: Bridge: 0000:00:01.0
> [   19.329489]   IO window: b000-bfff
> [   19.329528]   MEM window: f8000000-fbffffff
> [   19.329567]   PREFETCH window: d0000000-dfffffff
> [   19.329607] PCI: Bridge: 0000:00:1c.0
> [   19.329645]   IO window: a000-afff
> [   19.329685]   MEM window: fda00000-fdafffff
> [   19.329724]   PREFETCH window: fd700000-fd7fffff
> [   19.329765] PCI: Bridge: 0000:00:1c.2
> [   19.329803]   IO window: e000-efff
> [   19.329843]   MEM window: fde00000-fdefffff
> [   19.329882]   PREFETCH window: fdd00000-fddfffff
> [   19.329923] PCI: Bridge: 0000:00:1c.4
> [   19.329961]   IO window: d000-dfff
> [   19.330001]   MEM window: fdc00000-fdcfffff
> [   19.330040]   PREFETCH window: fdb00000-fdbfffff
> [   19.330081] PCI: Bridge: 0000:00:1e.0
> [   19.330119]   IO window: c000-cfff
> [   19.330159]   MEM window: fd900000-fd9fffff
> [   19.330198]   PREFETCH window: fd800000-fd8fffff
> [   19.330243] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   19.330320] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [   19.330330] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   19.330407] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [   19.330417] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> 
> IRQ 17
> [   19.330499] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> [   19.330508] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   19.330586] PCI: Setting latency timer of device 0000:00:1c.4 to 64
> [   19.330591] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [   19.330597] NET: Registered protocol family 2
> [   19.340479] IP route cache hash table entries: 32768 (order: 5, 131072 
> bytes)
> [   19.340640] TCP established hash table entries: 131072 (order: 8, 1048576 
> bytes)
> [   19.340985] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
> [   19.341234] TCP: Hash tables configured (established 131072 bind 65536)
> [   19.341276] TCP reno registered
> [   19.344975] highmem bounce pool size: 64 pages
> [   19.346480] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   19.346652] SGI XFS with no debug enabled
> [   19.347036] io scheduler noop registered
> [   19.347111] io scheduler cfq registered (default)
> [   19.347212] Boot video device is 0000:01:00.0
> [   19.347266] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [   19.347277] assign_interrupt_mode Found MSI capability
> [   19.347326] Allocate Port Service[0000:00:01.0:pcie00]
> [   19.347346] Allocate Port Service[0000:00:01.0:pcie03]
> [   19.347379] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [   19.347403] assign_interrupt_mode Found MSI capability
> [   19.347463] Allocate Port Service[0000:00:1c.0:pcie00]
> [   19.347483] Allocate Port Service[0000:00:1c.0:pcie02]
> [   19.347501] Allocate Port Service[0000:00:1c.0:pcie03]
> [   19.347546] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> [   19.347569] assign_interrupt_mode Found MSI capability
> [   19.347625] Allocate Port Service[0000:00:1c.2:pcie00]
> [   19.347645] Allocate Port Service[0000:00:1c.2:pcie02]
> [   19.347663] Allocate Port Service[0000:00:1c.2:pcie03]
> [   19.347710] PCI: Setting latency timer of device 0000:00:1c.4 to 64
> [   19.347733] assign_interrupt_mode Found MSI capability
> [   19.347789] Allocate Port Service[0000:00:1c.4:pcie00]
> [   19.347808] Allocate Port Service[0000:00:1c.4:pcie02]
> [   19.347826] Allocate Port Service[0000:00:1c.4:pcie03]
> [   19.347956] input: Power Button (FF) as /devices/virtual/input/input0
> [   19.347997] ACPI: Power Button (FF) [PWRF]
> [   19.348078] input: Power Button (CM) as /devices/virtual/input/input1
> [   19.348119] ACPI: Power Button (CM) [PWRB]
> [   19.357494] Real Time Clock Driver v1.12ac
> [   19.357580] Linux agpgart interface v0.102
> [   19.357665] Floppy drive(s): fd0 is 1.44M
> [   19.372054] FDC 0 is a post-1991 82077
> [   19.373161] loop: module loaded
> [   19.373234] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
> [   19.373275] Copyright (c) 1999-2006 Intel Corporation.
> [   19.373350] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   19.373436] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [   19.429545] e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width 
> x1) 00:1b:21:02:86:95
> [   19.486899] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> [   19.486947] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
> [   19.486987] e1000e: Copyright (c) 1999-2007 Intel Corporation.
> [   19.487052] netconsole: local port 4444
> [   19.487091] netconsole: local IP 192.168.0.1
> [   19.487129] netconsole: interface eth0
> [   19.487168] netconsole: remote port 514
> [   19.487206] netconsole: remote IP 192.168.0.254
> [   19.487246] netconsole: remote ethernet address 00:19:d1:6e:9d:43
> [   19.487287] netconsole: device eth0 not up yet, forcing it
> [   19.793953] Clockevents: could not switch to one-shot mode:<6>Clockevents: 
> could not switch to one-shot mode: lapic is not functional.
> [   19.793956] Could not switch to high resolution mode on CPU 1
> [   19.794073]  lapic is not functional.
> [   19.794111] Could not switch to high resolution mode on CPU 0
> [   22.522434] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full 
> Duplex, Flow Control: RX/TX
> [   22.524960] console [netcon0] enabled
> [   22.537821] netconsole: network logging started
> [   22.537892] Driver 'sd' needs updating - please use bus_type methods
> [   22.537954] Driver 'sr' needs updating - please use bus_type methods
> [   22.538040] ahci 0000:00:1f.2: version 3.0
> [   22.538052] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> 
> IRQ 18
> [   23.537862] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
> impl SATA mode
> [   23.537913] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part [ 
> 23.537956] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [   23.538089] scsi0 : ahci
> [   23.538170] scsi1 : ahci
> [   23.538240] scsi2 : ahci
> [   23.538318] scsi3 : ahci
> [   23.538411] ata1: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe100 
> irq 218
> [   23.538463] ata2: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe180 
> irq 218
> [   23.538518] ata3: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe200 
> irq 218
> [   23.538573] ata4: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe280 
> irq 218
> [   23.993352] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   24.000089] ata1.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
> [   24.000131] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   24.000956] ata1.00: configured for UDMA/133
> [   24.455844] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   24.609697] ata2.00: ATAPI: TSSTcorpCD/DVDW SH-S183L, SB02, max UDMA/33, 
> ATAPI AN
> [   24.609746] ata2.00: applying bridge limits
> [   24.763896] ata2.00: configured for UDMA/33
> [   25.066174] ata3: SATA link down (SStatus 0 SControl 300)
> [   25.368842] ata4: SATA link down (SStatus 0 SControl 300)
> [   25.368947] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500AAKS-0 30.0 
> PQ: 0 ANSI: 5
> [   25.369061] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 
> MB)
> [   25.369117] sd 0:0:0:0: [sda] Write Protect is off
> [   25.369162] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   25.369171] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA
> [   25.369252] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 
> MB)
> [   25.369309] sd 0:0:0:0: [sda] Write Protect is off
> [   25.369354] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   25.369364] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA
> [   25.369419]  sda: sda1 sda2
> [   25.374009] sd 0:0:0:0: [sda] Attached SCSI disk
> [   25.374905] scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S183L SB02 
> PQ: 0 ANSI: 5
> [   25.383411] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
> cdda tray
> [   25.383462] Uniform CD-ROM driver Revision: 3.20
> [   25.383558] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [   25.383615] ata_piix 0000:00:1f.1: version 2.12
> [   25.383622] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> 
> IRQ 17
> [   25.383723] PCI: Setting latency timer of device 0000:00:1f.1 to 64
> [   25.383756] scsi4 : ata_piix
> [   25.383834] scsi5 : ata_piix
> [   25.384178] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfb00 irq 
> 14
> [   25.384220] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfb08 irq 
> 15
> [   25.534721] ata6: port disabled. ignoring.
> [   25.545781] ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 17 (level, low) -> 
> IRQ 19
> [   25.595935] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19] 
> MMIO=[fd9ff000-fd9ff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> [   25.596066] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> 
> IRQ 20
> [   25.596153] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [   25.596155] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [   25.596237] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
> number 1
> [   25.600172] PCI: cache line size of 32 is not supported by device 
> 0000:00:1d.7
> [   25.600177] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfdfff000
> [   25.609576] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 
> Dec 2004
> [   25.609735] usb usb1: configuration #1 chosen from 1 choice
> [   25.609799] hub 1-0:1.0: USB hub found
> [   25.609847] hub 1-0:1.0: 8 ports detected
> [   25.710538] USB Universal Host Controller Interface driver v3.0
> [   25.710603] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> 
> IRQ 20
> [   25.710696] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [   25.710698] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [   25.710766] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
> number 2
> [   25.710839] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000ff00
> [   25.710970] usb usb2: configuration #1 chosen from 1 choice
> [   25.711034] hub 2-0:1.0: USB hub found
> [   25.711081] hub 2-0:1.0: 2 ports detected
> [   25.811418] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> 
> IRQ 18
> [   25.811498] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [   25.811500] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [   25.811567] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
> number 3
> [   25.811641] uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000fe00
> [   25.811774] usb usb3: configuration #1 chosen from 1 choice
> [   25.811838] hub 3-0:1.0: USB hub found
> [   25.811885] hub 3-0:1.0: 2 ports detected
> [   25.912307] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> 
> IRQ 17
> [   25.912394] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [   25.912395] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [   25.912462] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
> number 4
> [   25.912542] uhci_hcd 0000:00:1d.2: irq 17, io base 0x0000fd00
> [   25.912670] usb usb4: configuration #1 chosen from 1 choice
> [   25.912739] hub 4-0:1.0: USB hub found
> [   25.912780] hub 4-0:1.0: 2 ports detected
> [   26.013198] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> 
> IRQ 16
> [   26.013284] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [   26.013286] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [   26.013354] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus 
> number 5
> [   26.013428] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fc00
> [   26.013562] usb usb5: configuration #1 chosen from 1 choice
> [   26.013625] hub 5-0:1.0: USB hub found
> [   26.013672] hub 5-0:1.0: 2 ports detected
> [   26.114089] Initializing USB Mass Storage driver...
> [   26.225899] usb 2-2: new low speed USB device using uhci_hcd and address 2
> [   26.395248] usb 2-2: configuration #1 chosen from 1 choice
> [   26.603485] usb 3-1: new low speed USB device using uhci_hcd and address 2
> [   26.766761] usb 3-1: configuration #1 chosen from 1 choice
> [   26.770797] usbcore: registered new interface driver usb-storage
> [   26.770839] USB Mass Storage support registered.
> [   26.770934] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [   26.770976] PNP: PS/2 appears to have AUX port disabled, if this is 
> incorrect please boot with i8042.nopnp
> [   26.771515] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   26.771603] mice: PS/2 mouse device common for all mice
> [   26.801022] input: AT Translated Set 2 keyboard as 
> /devices/platform/i8042/serio0/input/input2
> [   26.803324] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [   26.850285] ieee1394: Host added: ID:BUS[0-00:1023] 
> GUID[00508d0000994687]
> [   26.852373] abituguru3: found Abit uGuru3, motherboard ID: 0016 (AW9D-MAX)
> [   26.852819] coretemp coretemp.0: Using undocumented features, absolute 
> temperature might be wrong!
> [   26.852914] coretemp coretemp.1: Using undocumented features, absolute 
> temperature might be wrong!
> [   26.853014] usbcore: registered new interface driver hiddev
> [   26.867836] input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) 
> as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
> [   26.870213] input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse 
> with IntelliEye(TM)] on usb-0000:00:1d.0-2
> [   27.142344] hiddev96: USB HID v1.11 Device [Belkin  Belkin UPS] on 
> usb-0000:00:1d.1-1
> [   27.142461] usbcore: registered new interface driver usbhid
> [   27.142503] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [   27.142570] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue 
> Nov 20 19:16:42 2007 UTC).
> [   27.143593] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   27.143681] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [   27.194837] hda_codec: Unknown model for ALC882, trying auto-probe from 
> BIOS...
> [   27.234870] ALSA device list:
> [   27.234909]   #0: HDA Intel at 0xfdff8000 irq 16
> [   27.234950] TCP cubic registered
> [   27.235004] NET: Registered protocol family 1
> [   27.235057] NET: Registered protocol family 17
> [   27.235187] RPC: Registered udp transport module.
> [   27.235228] RPC: Registered tcp transport module.
> [   27.235275] Testing NMI watchdog ... OK.
> [   27.255332] Starting balanced_irq
> [   27.255383] Using IPI Shortcut mode
> [   27.285525] UDF-fs: No VRS found
> [   27.323228] XFS mounting filesystem sda2
> [   27.413136] Ending clean XFS mount for filesystem: sda2
> [   27.413153] VFS: Mounted root (xfs filesystem) readonly.
> [   27.413273] Freeing unused kernel memory: 224k freed
> [   29.727530] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> 
> IRQ 18
> [   31.260700] Adding 8393920k swap on /dev/sda1.  Priority:-1 extents:1 
> across:8393920k
> [   49.957428] nvidia: module license 'NVIDIA' taints kernel.
> [   50.210535] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> 
> IRQ 16
> [   50.210547] PCI: Setting latency timer of device 0000:01:00.0 to 64
> [   50.210639] NVRM: loading NVIDIA UNIX x86 Kernel Module  171.05  Tue Jan 
> 22 18:08:39 PST 2008
