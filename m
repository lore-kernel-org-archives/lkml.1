Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXE3OeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXE3OeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXE3Od7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:33:59 -0400
Received: from lucidpixels.com ([75.144.35.66]:51449 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbXE3Od4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:33:56 -0400
Date: Wed, 30 May 2007 10:33:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org, crmotherboard@mailbox.cps.intel.com
Subject: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on
 Intel 965WH motherboards. (FULL DMESG)
In-Reply-To: <465D89E1.7030301@shaw.ca>
Message-ID: <Pine.LNX.4.64.0705301029500.13945@p34.internal.lan>
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no> <465CF8CA.8070009@shaw.ca>
 <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan> <465D89E1.7030301@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are correct, the netconsole output from another machine is shown 
below.  If we can access the memory directly, why is it so slow? :(  Am I 
the first person to try using 8 gigabytes of RAM on the 965 chipset?

On Wed, 30 May 2007, Robert Hancock wrote:

> Justin Piszcz wrote:
>> Kernel dmesg attached from 8GB bootup.
>
> It looks like part of the start of the output was truncated..
>
>> Robert, how come the option is not applicable in 64-bit mode? If I want to 
>> use all 8GB of memory I need to run a 32-bit kernel?
>> 
>> Justin.
>> 
>
> Highmem and PAE (which are essentially what the 4GB/64GB memory options 
> control) are not needed in 64-bit mode, since we can access the entire 64-bit 
> address space directly.
>
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>

Here is the _FULL_ dmesg!  Thanks netconsole!

May 29 17:39:11 p34 [    0.000000] Linux version 2.6.21.3 (root@p34.internal.lan) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #4 SMP Sun May 27 06:28:33 EDT 2007 
May 29 17:39:11 p34 [    0.000000] Command line: auto BOOT_IMAGE=2.6.21.3-4 ro root=902 netconsole=4444@192.168.168.253/eth0,514@192.168.168.254/00:50:8D:ED:3C:E7 nmi_watchdog=1 
May 29 17:39:11 p34 [    0.000000] BIOS-provided physical RAM map: 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf59c000 - 00000000cf653000 (usable) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf653000 - 00000000cf6a5000 (ACPI NVS) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6a5000 - 00000000cf6a8000 (ACPI data) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6a8000 - 00000000cf6ef000 (ACPI NVS) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved) 
May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable) 
May 29 17:39:11 p34 [    0.000000] end_pfn_map = 2277376 
May 29 17:39:11 p34 [    0.000000] DMI 2.4 present. 
May 29 17:39:11 p34 [    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL ) 
May 29 17:39:11 p34 [    0.000000] ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DG965WH       64C       1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: FACP CF6FC000, 0074 (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: DSDT CF6F7000, 40E9 (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: FACS CF6A8000, 0040 
May 29 17:39:11 p34 [    0.000000] ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: WDDT CF6F5000, 0040 (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: HPET CF6F2000, 0038 (r1 INTEL  DG965WH       64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6F0000, 01BC (r1 INTEL     CpuPm      64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6EF000, 0175 (r1 INTEL   Cpu0Ist      64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6A7000, 0175 (r1 INTEL   Cpu1Ist      64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6A6000, 0175 (r1 INTEL   Cpu2Ist      64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6A5000, 0175 (r1 INTEL   Cpu3Ist      64C MSFT  1000013) 
May 29 17:39:11 p34 [    0.000000] Zone PFN ranges: 
May 29 17:39:11 p34 [    0.000000]   DMA             0 ->     4096 
May 29 17:39:11 p34 [    0.000000]   DMA32        4096 ->  1048576 
May 29 17:39:11 p34 [    0.000000]   Normal    1048576 ->  2277376 
May 29 17:39:11 p34 [    0.000000] early_node_map[6] active PFN ranges 
May 29 17:39:11 p34 [    0.000000]     0:        0 ->      143 
May 29 17:39:11 p34 [    0.000000]     0:      256 ->   849295 
May 29 17:39:11 p34 [    0.000000]     0:   849308 ->   849491 
May 29 17:39:11 p34 [    0.000000]     0:   849649 ->   849650 
May 29 17:39:11 p34 [    0.000000]     0:   849663 ->   849664 
May 29 17:39:11 p34 [    0.000000]     0:  1048576 ->  2277376 
May 29 17:39:11 p34 [    0.000000] ACPI: PM-Timer IO Port: 0x408 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled) 
May 29 17:39:11 p34 [    0.000000] Processor #0 (Bootup-CPU) 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled) 
May 29 17:39:11 p34 [    0.000000] Processor #2 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled) 
May 29 17:39:11 p34 [    0.000000] Processor #1 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled) 
May 29 17:39:11 p34 [    0.000000] Processor #3 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1]) 
May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1]) 
May 29 17:39:11 p34 [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0]) 
May 29 17:39:11 p34 [    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23 
May 29 17:39:11 p34 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl) 
May 29 17:39:11 p34 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level) 
May 29 17:39:11 p34 [    0.000000] Setting APIC routing to flat 
May 29 17:39:11 p34 [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000 
May 29 17:39:11 p34 [    0.000000] Using ACPI (MADT) for SMP configuration information 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 000000000008f000 - 00000000000a0000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000000a0000 - 00000000000e0000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000000e0000 - 0000000000100000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf58f000 - 00000000cf59c000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf653000 - 00000000cf6a5000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf6a5000 - 00000000cf6a8000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf6a8000 - 00000000cf6ef000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf6ef000 - 00000000cf6f1000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf6f2000 - 00000000cf6ff000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf700000 - 00000000d0000000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000d0000000 - 00000000fff00000 
May 29 17:39:11 p34 [    0.000000] Nosave address range: 00000000fff00000 - 0000000100000000 
May 29 17:39:11 p34 [    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000) 
May 29 17:39:11 p34 [    0.000000] PERCPU: Allocating 24512 bytes of per cpu data 
May 29 17:39:11 p34 [    0.000000] Built 1 zonelists.  Total pages: 2045692 
May 29 17:39:11 p34 [    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.21.3-4 ro root=902 netconsole=4444@192.168.168.253/eth0,514@192.168.168.254/00:50:8D:ED:3C:E7 nmi_watchdog=1 
May 29 17:39:11 p34 [    0.000000] netconsole: local port 4444 
May 29 17:39:11 p34 [    0.000000] netconsole: local IP 192.168.168.253 
May 29 17:39:11 p34 [    0.000000] netconsole: interface eth0 
May 29 17:39:11 p34 [    0.000000] netconsole: remote port 514 
May 29 17:39:11 p34 [    0.000000] netconsole: remote IP 192.168.168.254 
May 29 17:39:11 p34 [    0.000000] netconsole: remote ethernet address 00:50:8d:ed:3c:e7 
May 29 17:39:11 p34 [    0.000000] Initializing CPU#0 
May 29 17:39:11 p34 [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes) 
May 29 17:39:11 p34 [   48.249507] time.c: Detected 2397.605 MHz processor. 
May 29 17:39:11 p34 [   48.250572] Console: colour VGA+ 80x25 
May 29 17:39:11 p34 [   48.258651] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes) 
May 29 17:39:11 p34 [   48.264855] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes) 
May 29 17:39:11 p34 [   48.265963] Checking aperture... 
May 29 17:39:11 p34 [   48.266011] PCI-DMA: Using software bounce buffering for IO (SWIOTLB) 
May 29 17:39:11 p34 [   48.302233] Placing software IO TLB between 0x95f6000 - 0xd5f6000 
May 29 17:39:11 p34 [   48.374061] Memory: 8103748k/9109504k available (3428k kernel code, 208464k reserved, 1270k data, 220k init) 
May 29 17:39:11 p34 [   48.434756] Calibrating delay using timer specific routine.. 4797.72 BogoMIPS (lpj=2398863) 
May 29 17:39:11 p34 [   48.435408] Mount-cache hash table entries: 256 
May 29 17:39:11 p34 [   48.436246] CPU: L1 I cache: 32K, L1 D cache: 32K 
May 29 17:39:11 p34 [   48.436307] CPU: L2 cache: 4096K 
May 29 17:39:11 p34 [   48.436347] using mwait in idle threads. 
May 29 17:39:11 p34 [   48.436389] CPU: Physical Processor ID: 0 
May 29 17:39:11 p34 [   48.436430] CPU: Processor Core ID: 0 
May 29 17:39:11 p34 [   48.436474] CPU0: Thermal monitoring enabled (TM2) 
May 29 17:39:11 p34 [   48.436526] Freeing SMP alternatives: 36k freed 
May 29 17:39:11 p34 [   48.436584] ACPI: Core revision 20070126 
May 29 17:39:11 p34 [   48.485666] activating NMI Watchdog ... done. 
May 29 17:39:11 p34 [   48.485786] Using local APIC timer interrupts. 
May 29 17:39:11 p34 [   48.527564] result 16650037 
May 29 17:39:11 p34 [   48.527642] Detected 16.650 MHz APIC timer. 
May 29 17:39:11 p34 [   48.529312] Booting processor 1/4 APIC 0x2 
May 29 17:39:11 p34 [   48.539943] Initializing CPU#1 
May 29 17:39:11 p34 [   48.600727] Calibrating delay using timer specific routine.. 4795.07 BogoMIPS (lpj=2397539) 
May 29 17:39:11 p34 [   48.600785] CPU: L1 I cache: 32K, L1 D cache: 32K 
May 29 17:39:11 p34 [   48.600822] CPU: L2 cache: 4096K 
May 29 17:39:11 p34 [   48.600852] CPU: Physical Processor ID: 0 
May 29 17:39:11 p34 [   48.600879] CPU: Processor Core ID: 2 
May 29 17:39:11 p34 [   48.600914] CPU1: Thermal monitoring enabled (TM2) 
May 29 17:39:11 p34 [   48.601348] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 
May 29 17:39:11 p34 [   48.601451] checking TSC synchronization [CPU#0 -> CPU#1]: passed. 
May 29 17:39:11 p34 [   48.623998] Booting processor 2/4 APIC 0x1 
May 29 17:39:11 p34 [   48.635015] Initializing CPU#2 
May 29 17:39:11 p34 [   48.694729] Calibrating delay using timer specific routine.. 4796.63 BogoMIPS (lpj=2398315) 
May 29 17:39:11 p34 [   48.694791] CPU: L1 I cache: 32K, L1 D cache: 32K 
May 29 17:39:11 p34 [   48.694829] CPU: L2 cache: 4096K 
May 29 17:39:11 p34 [   48.694861] CPU: Physical Processor ID: 0 
May 29 17:39:11 p34 [   48.694891] CPU: Processor Core ID: 1 
May 29 17:39:11 p34 [   48.694928] CPU2: Thermal monitoring enabled (TM2) 
May 29 17:39:11 p34 [   48.695368] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 
May 29 17:39:11 p34 [   48.695508] checking TSC synchronization [CPU#0 -> CPU#2]: passed. 
May 29 17:39:11 p34 [   48.717915] Booting processor 3/4 APIC 0x3 
May 29 17:39:11 p34 [   48.728547] Initializing CPU#3 
May 29 17:39:11 p34 [   48.788686] Calibrating delay using timer specific routine.. 4795.46 BogoMIPS (lpj=2397730) 
May 29 17:39:11 p34 [   48.788750] CPU: L1 I cache: 32K, L1 D cache: 32K 
May 29 17:39:11 p34 [   48.788787] CPU: L2 cache: 4096K 
May 29 17:39:11 p34 [   48.788817] CPU: Physical Processor ID: 0 
May 29 17:39:11 p34 [   48.788846] CPU: Processor Core ID: 3 
May 29 17:39:11 p34 [   48.788882] CPU3: Thermal monitoring enabled (TM2) 
May 29 17:39:11 p34 [   48.789318] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 
May 29 17:39:11 p34 [   48.789446] checking TSC synchronization [CPU#0 -> CPU#3]: passed. 
May 29 17:39:11 p34 [   48.810753] Brought up 4 CPUs 
May 29 17:39:11 p34 [   48.810941] testing NMI watchdog ... OK. 
May 29 17:39:11 p34 [   49.178287] migration_cost=156,193 
May 29 17:39:11 p34 [   49.182074] NET: Registered protocol family 16 
May 29 17:39:11 p34 [   49.183506] ACPI: bus type pci registered 
May 29 17:39:11 p34 [   49.183670] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved 
May 29 17:39:11 p34 [   49.183764] PCI: Not using MMCONFIG. 
May 29 17:39:11 p34 [   49.183847] PCI: Using configuration type 1 
May 29 17:39:11 p34 [   49.324928] ACPI: Interpreter enabled 
May 29 17:39:11 p34 [   49.325010] ACPI: Using IOAPIC for interrupt routing 
May 29 17:39:11 p34 [   49.518427] ACPI: PCI Root Bridge [PCI0] (0000:00) 
May 29 17:39:11 p34 [   49.523873] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO 
May 29 17:39:11 p34 [   49.523974] PCI quirk: region 0500-053f claimed by ICH6 GPIO 
May 29 17:39:11 p34 [   49.534492] PCI: Transparent bridge - 0000:00:1e.0 
May 29 17:39:11 p34 [   49.792346] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12) 
May 29 17:39:11 p34 [   49.796475] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12) 
May 29 17:39:11 p34 [   49.800543] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12) 
May 29 17:39:11 p34 [   49.804653] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12) 
May 29 17:39:11 p34 [   49.808781] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12) 
May 29 17:39:11 p34 [   49.812812] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12) 
May 29 17:39:11 p34 [   49.816864] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12) 
May 29 17:39:11 p34 [   49.820999] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12) 
May 29 17:39:11 p34 [   49.824280] Linux Plug and Play Support v0.97 (c) Adam Belay 
May 29 17:39:11 p34 [   49.824569] pnp: PnP ACPI init 
May 29 17:39:11 p34 [   49.923406] pnp: PnP ACPI: found 12 devices 
May 29 17:39:11 p34 [   49.927655] SCSI subsystem initialized 
May 29 17:39:11 p34 [   49.935480] usbcore: registered new interface driver usbfs 
May 29 17:39:11 p34 [   49.936497] usbcore: registered new interface driver hub 
May 29 17:39:11 p34 [   49.939469] usbcore: registered new device driver usb 
May 29 17:39:11 p34 [   49.942750] PCI: Using ACPI for IRQ routing 
May 29 17:39:11 p34 [   49.942851] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report 
May 29 17:39:11 p34 [   49.944223] PCI-GART: No AMD northbridge found. 
May 29 17:39:11 p34 [   49.944929] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0 
May 29 17:39:11 p34 [   49.945145] hpet0: 3 64-bit timers, 14318180 Hz 
May 29 17:39:11 p34 [   49.946417] Time: tsc clocksource has been installed. 
May 29 17:39:11 p34 [   49.947517] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved 
May 29 17:39:11 p34 [   49.947640] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved 
May 29 17:39:11 p34 [   49.947785] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved 
May 29 17:39:11 p34 [   49.947943] pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved 
May 29 17:39:11 p34 [   49.948125] pnp: 00:06: ioport range 0x500-0x53f has been reserved 
May 29 17:39:11 p34 [   49.948231] pnp: 00:06: ioport range 0x400-0x47f has been reserved 
May 29 17:39:11 p34 [   49.948433] pnp: 00:06: ioport range 0x680-0x6ff has been reserved 
May 29 17:39:11 p34 [   49.961379] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19 
May 29 17:39:11 p34 [   50.015143] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0084000-e00847ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
May 29 17:39:11 p34 [   50.016694] PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0 
May 29 17:39:11 p34 [   50.017108] PCI: Bridge: 0000:00:1c.0 
May 29 17:39:11 p34 [   50.017203]   IO window: disabled. 
May 29 17:39:11 p34 [   50.017295]   MEM window: e0700000-e07fffff 
May 29 17:39:11 p34 [   50.017381]   PREFETCH window: disabled. 
May 29 17:39:11 p34 [   50.017507] PCI: Bridge: 0000:00:1c.1 
May 29 17:39:11 p34 [   50.017598]   IO window: 5000-5fff 
May 29 17:39:11 p34 [   50.017689]   MEM window: e0400000-e04fffff 
May 29 17:39:11 p34 [   50.017776]   PREFETCH window: disabled. 
May 29 17:39:11 p34 [   50.017882] PCI: Bridge: 0000:00:1c.2 
May 29 17:39:11 p34 [   50.017966]   IO window: 4000-4fff 
May 29 17:39:11 p34 [   50.018071]   MEM window: e0300000-e03fffff 
May 29 17:39:11 p34 [   50.018189]   PREFETCH window: e0800000-e08fffff 
May 29 17:39:11 p34 [   50.018297] PCI: Bridge: 0000:00:1c.3 
May 29 17:39:11 p34 [   50.018382]   IO window: 3000-3fff 
May 29 17:39:11 p34 [   50.018504]   MEM window: e0200000-e02fffff 
May 29 17:39:11 p34 [   50.018598]   PREFETCH window: e0900000-e09fffff 
May 29 17:39:11 p34 [   50.018707] PCI: Bridge: 0000:00:1c.4 
May 29 17:39:11 p34 [   50.018792]   IO window: 2000-2fff 
May 29 17:39:11 p34 [   50.018885]   MEM window: e0100000-e01fffff 
May 29 17:39:11 p34 [   50.018976]   PREFETCH window: e0a00000-e0afffff 
May 29 17:39:11 p34 [   50.019121] PCI: Bridge: 0000:00:1e.0 
May 29 17:39:11 p34 [   50.019234]   IO window: 1000-1fff 
May 29 17:39:11 p34 [   50.019325]   MEM window: e0000000-e00fffff 
May 29 17:39:11 p34 [   50.019436]   PREFETCH window: e0b00000-e0bfffff 
May 29 17:39:11 p34 [   50.019625] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17 
May 29 17:39:11 p34 [   50.019912] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16 
May 29 17:39:11 p34 [   50.020251] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18 
May 29 17:39:11 p34 [   50.020556] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19 
May 29 17:39:11 p34 [   50.020829] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17 
May 29 17:39:11 p34 [   50.022111] NET: Registered protocol family 2 
May 29 17:39:11 p34 [   50.032134] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes) 
May 29 17:39:11 p34 [   50.041151] TCP established hash table entries: 131072 (order: 9, 3145728 bytes) 
May 29 17:39:11 p34 [   50.053741] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes) 
May 29 17:39:11 p34 [   50.057942] TCP: Hash tables configured (established 131072 bind 65536) 
May 29 17:39:11 p34 [   50.058031] TCP reno registered 
May 29 17:39:11 p34 [   50.104079] Installing knfsd (copyright (C) 1996 okir@monad.swb.de). 
May 29 17:39:11 p34 [   50.108290] SGI XFS with large block/inode numbers, no debug enabled 
May 29 17:39:11 p34 [   50.124796] io scheduler noop registered 
May 29 17:39:11 p34 [   50.124877] io scheduler anticipatory registered (default) 
May 29 17:39:11 p34 [   50.130760] assign_interrupt_mode Found MSI capability 
May 29 17:39:11 p34 [   50.133909] assign_interrupt_mode Found MSI capability 
May 29 17:39:11 p34 [   50.136992] assign_interrupt_mode Found MSI capability 
May 29 17:39:11 p34 [   50.139916] assign_interrupt_mode Found MSI capability 
May 29 17:39:11 p34 [   50.142907] assign_interrupt_mode Found MSI capability 
May 29 17:39:11 p34 [   50.217615] lp: driver loaded but no devices found 
May 29 17:39:11 p34 [   50.219124] Real Time Clock Driver v1.12ac 
May 29 17:39:11 p34 [   50.221782] Linux agpgart interface v0.102 (c) Dave Jones 
May 29 17:39:11 p34 [   50.223328] agpgart: Detected an Intel 965G Chipset. 
May 29 17:39:11 p34 [   50.224565] agpgart: Detected 7676K stolen memory. 
May 29 17:39:11 p34 [   50.243289] agpgart: AGP aperture is 256M @ 0xd0000000 
May 29 17:39:11 p34 [   50.243856] [drm] Initialized drm 1.1.0 20060810 
May 29 17:39:11 p34 [   50.244141] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16 
May 29 17:39:11 p34 [   50.246322] [drm] Initialized i915 1.6.0 20060119 on minor 0 
May 29 17:39:11 p34 [   50.247415] parport: PnPBIOS parport detected. 
May 29 17:39:11 p34 [   50.247654] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP] 
May 29 17:39:11 p34 [   50.331362] lp0: using parport0 (interrupt-driven). 
May 29 17:39:11 p34 [   50.341355] loop: loaded (max 8 devices) 
May 29 17:39:11 p34 [   50.341437] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI 
May 29 17:39:11 p34 [   50.341528] Copyright (c) 1999-2006 Intel Corporation. 
May 29 17:39:11 p34 [   50.342520] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20 
May 29 17:39:11 p34 [   50.360685] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:19:d1:6e:9d:43 
May 29 17:39:11 p34 [   50.439132] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection 
May 29 17:39:11 p34 [   50.439655] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21 
May 29 17:39:11 p34 [   50.705534] e1000: 0000:06:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:00:cd:b1 
May 29 17:39:11 p34 [   50.857482] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection 
May 29 17:39:11 p34 [   50.857724] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 22 (level, low) -> IRQ 22 
May 29 17:39:11 p34 [   51.107171] e1000: 0000:06:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:29:37:db 
May 29 17:39:11 p34 [   51.136221] e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection 
May 29 17:39:11 p34 [   51.138251] netconsole: device eth0 not up yet, forcing it 
May 29 17:39:11 p34 [   53.180364] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX 
May 29 17:39:11 p34 [   53.683096] netconsole: network logging started 
May 29 17:39:11 p34 [   53.686923] ACPI: PCI Interrupt 0000:00:1f.2[A] -> 
May 29 17:39:11 p34 GSI 19 (level, low) -> IRQ 19 
May 29 17:39:12 p34 [   54.687783] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode 
May 29 17:39:12 p34 [   54.687956] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
May 29 17:39:12 p34 [   54.690522] ata1: SATA max UDMA/133 cmd 0xffffc20000078100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.692552] ata2: SATA max UDMA/133 cmd 0xffffc20000078180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.694637] ata3: SATA max UDMA/133 cmd 0xffffc20000078200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.696669] ata4: SATA max UDMA/133 cmd 0xffffc20000078280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.698687] ata5: SATA max UDMA/133 cmd 0xffffc20000078300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.700726] ata6: SATA max UDMA/133 cmd 0xffffc20000078380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
May 29 17:39:12 p34 [   54.701011] scsi0 : ahci 
May 29 17:39:13 p34 [   55.162816] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:13 p34 [   55.165434] ata1.00: ATA-6: WDC WD740GD-00FLC0, 33.08F33, max UDMA/133 
May 29 17:39:13 p34 [   55.165604] ata1.00: 145226112 sectors, multi 0: LBA48 
May 29 17:39:13 p34 [   55.169510] ata1.00: configured for UDMA/133 
May 29 17:39:13 p34 [   55.170050] scsi1 : ahci 
May 29 17:39:13 p34 [   55.632888] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:13 p34 [   55.635466] ata2.00: ATA-6: WDC WD740GD-00FLC0, 33.08F33, max UDMA/133 
May 29 17:39:13 p34 [   55.635625] ata2.00: 145226112 sectors, multi 0: LBA48 
May 29 17:39:13 p34 [   55.639563] ata2.00: configured for UDMA/133 
May 29 17:39:13 p34 [   55.639885] scsi2 : ahci 
May 29 17:39:14 p34 [   56.100111] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:14 p34 [   56.101908] ata3.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:14 p34 [   56.102086] ata3.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32) 
May 29 17:39:14 p34 [   56.104825] ata3.00: configured for UDMA/133 
May 29 17:39:14 p34 [   56.105036] scsi3 : ahci 
May 29 17:39:14 p34 [   56.567476] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:14 p34 [   56.569281] ata4.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:14 p34 [   56.569423] ata4.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32) 
May 29 17:39:14 p34 [   56.572150] ata4.00: configured for UDMA/133 
May 29 17:39:14 p34 [   56.572391] scsi4 : ahci 
May 29 17:39:15 p34 [   57.032365] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:15 p34 [   57.034115] ata5.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:15 p34 [   57.034245] ata5.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32) 
May 29 17:39:15 p34 [   57.036865] ata5.00: configured for UDMA/133 
May 29 17:39:15 p34 [   57.037078] scsi5 : ahci 
May 29 17:39:15 p34 [   57.496550] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:15 p34 [   57.498270] ata6.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:15 p34 [   57.498438] ata6.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32) 
May 29 17:39:15 p34 [   57.501093] ata6.00: configured for UDMA/133 
May 29 17:39:15 p34 [   57.502916] scsi 0:0:0:0: Direct-Access     ATA      WDC WD740GD-00FL 33.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.505120] SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB) 
May 29 17:39:15 p34 [   57.505456] sda: Write Protect is off 
May 29 17:39:15 p34 [   57.506051] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.507023] SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB) 
May 29 17:39:15 p34 [   57.507356] sda: Write Protect is off 
May 29 17:39:15 p34 [   57.507977] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.508155]  sda:
May 29 17:39:15 p34  sda1
May 29 17:39:15 p34  sda2
May 29 17:39:15 p34  sda3
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.524234] sd 0:0:0:0: Attached scsi disk sda 
May 29 17:39:15 p34 [   57.526473] scsi 1:0:0:0: Direct-Access     ATA      WDC WD740GD-00FL 33.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.528478] SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB) 
May 29 17:39:15 p34 [   57.528824] sdb: Write Protect is off 
May 29 17:39:15 p34 [   57.529324] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.530179] SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB) 
May 29 17:39:15 p34 [   57.530511] sdb: Write Protect is off 
May 29 17:39:15 p34 [   57.531016] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.531162]  sdb:
May 29 17:39:15 p34  sdb1
May 29 17:39:15 p34  sdb2
May 29 17:39:15 p34  sdb3
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.545063] sd 1:0:0:0: Attached scsi disk sdb 
May 29 17:39:15 p34 [   57.547103] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.549007] SCSI device sdc: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.549322] sdc: Write Protect is off 
May 29 17:39:15 p34 [   57.549869] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.550710] SCSI device sdc: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.551003] sdc: Write Protect is off 
May 29 17:39:15 p34 [   57.551505] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.551726]  sdc:
May 29 17:39:15 p34  sdc1
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.565362] sd 2:0:0:0: Attached scsi disk sdc 
May 29 17:39:15 p34 [   57.567447] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.569384] SCSI device sdd: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.569725] sdd: Write Protect is off 
May 29 17:39:15 p34 [   57.570218] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.571193] SCSI device sdd: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.571500] sdd: Write Protect is off 
May 29 17:39:15 p34 [   57.572003] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.572162]  sdd:
May 29 17:39:15 p34  sdd1
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.587442] sd 3:0:0:0: Attached scsi disk sdd 
May 29 17:39:15 p34 [   57.589470] scsi 4:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.591359] SCSI device sde: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.591632] sde: Write Protect is off 
May 29 17:39:15 p34 [   57.592147] SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.593038] SCSI device sde: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.593357] sde: Write Protect is off 
May 29 17:39:15 p34 [   57.593826] SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.594001]  sde:
May 29 17:39:15 p34  sde1
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.605438] sd 4:0:0:0: Attached scsi disk sde 
May 29 17:39:15 p34 [   57.607617] scsi 5:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:15 p34 [   57.609437] SCSI device sdf: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.609770] sdf: Write Protect is off 
May 29 17:39:15 p34 [   57.610284] SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.611221] SCSI device sdf: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:15 p34 [   57.611518] sdf: Write Protect is off 
May 29 17:39:15 p34 [   57.612049] SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:15 p34 [   57.612225]  sdf:
May 29 17:39:15 p34  sdf1
May 29 17:39:15 p34 
May 29 17:39:15 p34 [   57.623709] sd 5:0:0:0: Attached scsi disk sdf 
May 29 17:39:15 p34 [   57.626592] ACPI: PCI Interrupt 0000:03:00.0[A] -> 
May 29 17:39:15 p34 GSI 18 (level, low) -> IRQ 18 
May 29 17:39:15 p34 [   57.628562] ata7: SATA max UDMA/100 cmd 0xffffc20000108000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 18 
May 29 17:39:15 p34 [   57.629915] ata8: SATA max UDMA/100 cmd 0xffffc2000010a000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 18 
May 29 17:39:15 p34 [   57.630185] scsi6 : sata_sil24 
May 29 17:39:16 p34 [   58.036965] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:16 p34 [   58.039003] ata7.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:16 p34 [   58.039153] ata7.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:16 p34 [   58.042162] ata7.00: configured for UDMA/100 
May 29 17:39:16 p34 [   58.042345] scsi7 : sata_sil24 
May 29 17:39:16 p34 [   58.448234] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:16 p34 [   58.450325] ata8.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:16 p34 [   58.450480] ata8.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:16 p34 [   58.453526] ata8.00: configured for UDMA/100 
May 29 17:39:16 p34 [   58.454693] scsi 6:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:16 p34 [   58.456666] SCSI device sdg: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:16 p34 [   58.456964] sdg: Write Protect is off 
May 29 17:39:16 p34 [   58.458045] SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:16 p34 [   58.458913] SCSI device sdg: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:16 p34 [   58.459203] sdg: Write Protect is off 
May 29 17:39:16 p34 [   58.459754] SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:16 p34 [   58.459918]  sdg:
May 29 17:39:16 p34  sdg1
May 29 17:39:16 p34 
May 29 17:39:16 p34 [   58.474199] sd 6:0:0:0: Attached scsi disk sdg 
May 29 17:39:16 p34 [   58.476416] scsi 7:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:16 p34 [   58.478356] SCSI device sdh: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:16 p34 [   58.478711] sdh: Write Protect is off 
May 29 17:39:16 p34 [   58.479177] SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:16 p34 [   58.480075] SCSI device sdh: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:16 p34 [   58.480402] sdh: Write Protect is off 
May 29 17:39:16 p34 [   58.480928] SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:16 p34 [   58.481075]  sdh:
May 29 17:39:16 p34  sdh1
May 29 17:39:16 p34 
May 29 17:39:16 p34 [   58.495586] sd 7:0:0:0: Attached scsi disk sdh 
May 29 17:39:16 p34 [   58.496786] ACPI: PCI Interrupt 0000:04:00.0[A] -> 
May 29 17:39:16 p34 GSI 19 (level, low) -> IRQ 19 
May 29 17:39:16 p34 [   58.498258] ata9: SATA max UDMA/100 cmd 0xffffc20000110000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19 
May 29 17:39:16 p34 [   58.499601] ata10: SATA max UDMA/100 cmd 0xffffc20000112000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19 
May 29 17:39:16 p34 [   58.499831] scsi8 : sata_sil24 
May 29 17:39:16 p34 [   58.906766] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:16 p34 [   58.908540] ata9.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:16 p34 [   58.908698] ata9.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:16 p34 [   58.911323] ata9.00: configured for UDMA/100 
May 29 17:39:16 p34 [   58.911545] scsi9 : sata_sil24 
May 29 17:39:17 p34 [   59.317958] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:17 p34 [   59.319759] ata10.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:17 p34 [   59.319892] ata10.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:17 p34 [   59.322532] ata10.00: configured for UDMA/100 
May 29 17:39:17 p34 [   59.323739] scsi 8:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:17 p34 [   59.325657] SCSI device sdi: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:17 p34 [   59.325964] sdi: Write Protect is off 
May 29 17:39:17 p34 [   59.326500] SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:17 p34 [   59.327388] SCSI device sdi: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:17 p34 [   59.327707] sdi: Write Protect is off 
May 29 17:39:17 p34 [   59.328203] SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:17 p34 [   59.328380]  sdi:
May 29 17:39:17 p34  sdi1
May 29 17:39:17 p34 
May 29 17:39:17 p34 [   59.340639] sd 8:0:0:0: Attached scsi disk sdi 
May 29 17:39:17 p34 [   59.342775] scsi 9:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:17 p34 [   59.344776] SCSI device sdj: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:17 p34 [   59.345103] sdj: Write Protect is off 
May 29 17:39:17 p34 [   59.345608] SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:17 p34 [   59.346489] SCSI device sdj: 293046768 5
May 29 17:39:17 p34 12-byte hdwr sectors (150040 MB) 
May 29 17:39:17 p34 [   59.346850] sdj: Write Protect is off 
May 29 17:39:17 p34 [   59.347393] SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:17 p34 [   59.347552]  sdj:
May 29 17:39:17 p34  sdj1
May 29 17:39:17 p34 
May 29 17:39:17 p34 [   59.362148] sd 9:0:0:0: Attached scsi disk sdj 
May 29 17:39:17 p34 [   59.363387] ACPI: PCI Interrupt 0000:05:00.0[A] -> 
May 29 17:39:17 p34 GSI 16 (level, low) -> IRQ 16 
May 29 17:39:17 p34 [   59.365179] ata11: SATA max UDMA/100 cmd 0xffffc20000118000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16 
May 29 17:39:17 p34 [   59.367143] ata12: SATA max UDMA/100 cmd 0xffffc2000011a000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16 
May 29 17:39:17 p34 [   59.367432] scsi10 : sata_sil24 
May 29 17:39:17 p34 [   59.775363] ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:17 p34 [   59.777435] ata11.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:17 p34 [   59.777565] ata11.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:17 p34 [   59.780599] ata11.00: configured for UDMA/100 
May 29 17:39:17 p34 [   59.780798] scsi11 : sata_sil24 
May 29 17:39:18 p34 [   60.187580] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 300) 
May 29 17:39:18 p34 [   60.189625] ata12.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 
May 29 17:39:18 p34 [   60.189769] ata12.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) 
May 29 17:39:18 p34 [   60.192796] ata12.00: configured for UDMA/100 
May 29 17:39:18 p34 [   60.193974] scsi 10:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:18 p34 [   60.195832] SCSI device sdk: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:18 p34 [   60.196127] sdk: Write Protect is off 
May 29 17:39:18 p34 [   60.196614] SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:18 p34 [   60.197514] SCSI device sdk: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:18 p34 [   60.197845] sdk: Write Protect is off 
May 29 17:39:18 p34 [   60.198333] SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:18 p34 [   60.198507]  sdk:
May 29 17:39:18 p34  sdk1
May 29 17:39:18 p34 
May 29 17:39:18 p34 [   60.212748] sd 10:0:0:0: Attached scsi disk sdk 
May 29 17:39:18 p34 [   60.214934] scsi 11:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 
May 29 17:39:18 p34 [   60.216923] SCSI device sdl: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:18 p34 [   60.217271] sdl: Write Protect is off 
May 29 17:39:18 p34 [   60.217774] SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:18 p34 [   60.218665] SCSI device sdl: 293046768 512-byte hdwr sectors (150040 MB) 
May 29 17:39:18 p34 [   60.218974] sdl: Write Protect is off 
May 29 17:39:18 p34 [   60.219497] SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 29 17:39:18 p34 [   60.219671]  sdl:
May 29 17:39:18 p34  sdl1
May 29 17:39:18 p34 
May 29 17:39:18 p34 [   60.234367] sd 11:0:0:0: Attached scsi disk sdl 
May 29 17:39:18 p34 [   60.236317] ACPI: PCI Interrupt 0000:02:00.0[A] -> 
May 29 17:39:18 p34 GSI 17 (level, low) -> IRQ 17 
May 29 17:39:18 p34 [   60.237365] ata13: PATA max UDMA/100 cmd 0x0000000000015018 ctl 0x0000000000015026 bmdma 0x0000000000015000 irq 17 
May 29 17:39:18 p34 [   60.237631] scsi12 : pata_marvell 
May 29 17:39:18 p34 [   60.239266] BAR5:
May 29 17:39:18 p34 00:00 
May 29 17:39:18 p34 01:7F 
May 29 17:39:18 p34 02:22 
May 29 17:39:18 p34 03:CA 
May 29 17:39:18 p34 04:00 
May 29 17:39:18 p34 05:00 
May 29 17:39:18 p34 06:00 
May 29 17:39:18 p34 07:00 
May 29 17:39:18 p34 08:00 
May 29 17:39:18 p34 09:00 
May 29 17:39:18 p34 0A:00 
May 29 17:39:18 p34 0B:00 
May 29 17:39:18 p34 0C:01 
May 29 17:39:18 p34 0D:00 
May 29 17:39:18 p34 0E:00 
May 29 17:39:18 p34 0F:00 
May 29 17:39:18 p34 
May 29 17:39:18 p34 [   60.545828] ata13.00: ATAPI, max UDMA/33 
May 29 17:39:18 p34 [   60.701530] ata13.00: configured for UDMA/33 
May 29 17:39:18 p34 [   60.703942] scsi 12:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5 
May 29 17:39:18 p34 [   60.711411] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray 
May 29 17:39:18 p34 [   60.711545] Uniform CD-ROM driver Revision: 3.20 
May 29 17:39:18 p34 [   60.714694] ACPI: PCI Interrupt 0000:00:1a.7[C] -> 
May 29 17:39:18 p34 GSI 18 (level, low) -> IRQ 18 
May 29 17:39:18 p34 [   60.715083] ehci_hcd 0000:00:1a.7: EHCI Host Controller 
May 29 17:39:18 p34 [   60.716069] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1 
May 29 17:39:18 p34 [   60.716562] ehci_hcd 0000:00:1a.7: debug port 1 
May 29 17:39:18 p34 [   60.716810] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0625c00 
May 29 17:39:18 p34 [   60.720814] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
May 29 17:39:18 p34 [   60.723647] usb usb1: configuration #1 chosen from 1 choice 
May 29 17:39:18 p34 [   60.724706] hub 1-0:1.0: USB hub found 
May 29 17:39:18 p34 [   60.724901] hub 1-0:1.0: 4 ports detected 
May 29 17:39:18 p34 [   60.829165] ACPI: PCI Interrupt 0000:00:1d.7[A] -> 
May 29 17:39:18 p34 GSI 23 (level, low) -> IRQ 23 
May 29 17:39:18 p34 [   60.829583] ehci_hcd 0000:00:1d.7: EHCI Host Controller 
May 29 17:39:18 p34 [   60.830451] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2 
May 29 17:39:18 p34 [   60.830986] ehci_hcd 0000:00:1d.7: debug port 1 
May 29 17:39:18 p34 [   60.831229] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0625800 
May 29 17:39:18 p34 [   60.835261] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
May 29 17:39:18 p34 [   60.837971] usb usb2: configuration #1 chosen from 1 choice 
May 29 17:39:18 p34 [   60.839024] hub 2-0:1.0: USB hub found 
May 29 17:39:18 p34 [   60.839241] hub 2-0:1.0: 6 ports detected 
May 29 17:39:19 p34 [   60.942849] USB Universal Host Controller Interface driver v3.0 
May 29 17:39:19 p34 [   60.943912] ACPI: PCI Interrupt 0000:00:1a.0[A] -> 
May 29 17:39:19 p34 GSI 16 (level, low) -> IRQ 16 
May 29 17:39:19 p34 [   60.944250] uhci_hcd 0000:00:1a.0: UHCI Host Controller 
May 29 17:39:19 p34 [   60.945081] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3 
May 29 17:39:19 p34 [   60.945338] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0 
May 29 17:39:19 p34 [   60.948562] usb usb3: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   60.949639] hub 3-0:1.0: USB hub found 
May 29 17:39:19 p34 [   60.949832] hub 3-0:1.0: 2 ports detected 
May 29 17:39:19 p34 [   61.053768] ACPI: PCI Interrupt 0000:00:1a.1[B] -> 
May 29 17:39:19 p34 GSI 21 (level, low) -> IRQ 21 
May 29 17:39:19 p34 [   61.054098] uhci_hcd 0000:00:1a.1: UHCI Host Controller 
May 29 17:39:19 p34 [   61.054937] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4 
May 29 17:39:19 p34 [   61.055187] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0 
May 29 17:39:19 p34 [   61.058179] usb usb4: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   61.059320] hub 4-0:1.0: USB hub found 
May 29 17:39:19 p34 [   61.059500] hub 4-0:1.0: 2 ports detected 
May 29 17:39:19 p34 [   61.162594] ACPI: PCI Interrupt 0000:00:1d.0[A] -> 
May 29 17:39:19 p34 GSI 23 (level, low) -> IRQ 23 
May 29 17:39:19 p34 [   61.162944] uhci_hcd 0000:00:1d.0: UHCI Host Controller 
May 29 17:39:19 p34 [   61.163751] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5 
May 29 17:39:19 p34 [   61.164039] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080 
May 29 17:39:19 p34 [   61.166996] usb usb5: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   61.168132] hub 5-0:1.0: USB hub found 
May 29 17:39:19 p34 [   61.168320] hub 5-0:1.0: 2 ports detected 
May 29 17:39:19 p34 [   61.271253] ACPI: PCI Interrupt 0000:00:1d.1[B] -> 
May 29 17:39:19 p34 GSI 19 (level, low) -> IRQ 19 
May 29 17:39:19 p34 [   61.271587] uhci_hcd 0000:00:1d.1: UHCI Host Controller 
May 29 17:39:19 p34 [   61.272501] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6 
May 29 17:39:19 p34 [   61.272757] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060 
May 29 17:39:19 p34 [   61.275754] usb usb6: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   61.276869] hub 6-0:1.0: USB hub found 
May 29 17:39:19 p34 [   61.277042] hub 6-0:1.0: 2 ports detected 
May 29 17:39:19 p34 [   61.379999] ACPI: PCI Interrupt 0000:00:1d.2[C] -> 
May 29 17:39:19 p34 GSI 18 (level, low) -> IRQ 18 
May 29 17:39:19 p34 [   61.380331] uhci_hcd 0000:00:1d.2: UHCI Host Controller 
May 29 17:39:19 p34 [   61.381211] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7 
May 29 17:39:19 p34 [   61.381464] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040 
May 29 17:39:19 p34 [   61.385027] usb usb7: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   61.386139] hub 7-0:1.0: USB hub found 
May 29 17:39:19 p34 [   61.386313] hub 7-0:1.0: 2 ports detected 
May 29 17:39:19 p34 [   61.477697] usb 5-1: new low speed USB device using uhci_hcd and address 2 
May 29 17:39:19 p34 [   61.489915] Initializing USB Mass Storage driver... 
May 29 17:39:19 p34 [   61.641966] usb 5-1: configuration #1 chosen from 1 choice 
May 29 17:39:19 p34 [   61.647974] usbcore: registered new interface driver usb-storage 
May 29 17:39:19 p34 [   61.648124] USB Mass Storage support registered. 
May 29 17:39:19 p34 [   61.649681] usbcore: registered new interface driver hiddev 
May 29 17:39:20 p34 [   62.146211] 
May 29 17:39:20 p34 hiddev96
May 29 17:39:20 p34 : USB HID v1.00 Device [        UPS] on usb-0000:00:1d.0-1 
May 29 17:39:20 p34 [   62.146611] usbcore: registered new interface driver usbhid 
May 29 17:39:20 p34 [   62.146747] drivers/usb/input/hid-core.c: v2.6:USB HID core driver 
May 29 17:39:20 p34 [   62.148329] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12 
May 29 17:39:20 p34 [   62.152574] serio: i8042 KBD port at 0x60,0x64 irq 1 
May 29 17:39:20 p34 [   62.152739] serio: i8042 AUX port at 0x60,0x64 irq 12 
May 29 17:39:20 p34 [   62.153709] mice: PS/2 mouse device common for all mice 
May 29 17:39:20 p34 [   62.157353] input: PC Speaker as /class/input/input0 
May 29 17:39:20 p34 [   62.157569] i2c /dev entries driver 
May 29 17:39:20 p34 [   62.158424] md: raid1 personality registered for level 1 
May 29 17:39:20 p34 [   62.174745] raid6: int64x1     62 MB/s 
May 29 17:39:20 p34 [   62.178692] input: AT Translated Set 2 keyboard as /class/input/input1 
May 29 17:39:20 p34 [   62.192019] raid6: int64x2     89 MB/s 
May 29 17:39:20 p34 [   62.209023] raid6: int64x4     31 MB/s 
May 29 17:39:20 p34 [   62.225777] raid6: int64x8     11 MB/s 
May 29 17:39:20 p34 [   62.242854] raid6: sse2x1     148 MB/s 
May 29 17:39:20 p34 [   62.259636] raid6: sse2x2     269 MB/s 
May 29 17:39:20 p34 [   62.276650] raid6: sse2x4     460 MB/s 
May 29 17:39:20 p34 [   62.276789] raid6: using algorithm sse2x4 (460 MB/s) 
May 29 17:39:20 p34 [   62.276937] md: raid6 personality registered for level 6 
May 29 17:39:20 p34 [   62.277053] md: raid5 personality registered for level 5 
May 29 17:39:20 p34 [   62.277191] md: raid4 personality registered for level 4 
May 29 17:39:20 p34 [   62.277346] raid5: automatically using best checksumming function: generic_sse 
May 29 17:39:20 p34 [   62.281657]    generic_sse:    56.000 MB/sec 
May 29 17:39:20 p34 [   62.281777] raid5: using function: generic_sse (56.000 MB/sec) 
May 29 17:39:20 p34 [   62.282244] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC). 
May 29 17:39:20 p34 [   62.288220] ACPI: PCI Interrupt 0000:00:1b.0[A] -> 
May 29 17:39:20 p34 GSI 22 (level, low) -> IRQ 22 
May 29 17:39:20 p34 [   62.839554] input: ImPS/2 Generic Wheel Mouse as /class/input/input2 
May 29 17:39:21 p34 [   63.412487] hda_intel: azx_get_response timeout, switching to polling mode... 
May 29 17:39:21 p34 [   63.435772] ALSA device list: 
May 29 17:39:21 p34 [   63.435876]   #0: HDA Intel at 0xe0620000 irq 22 
May 29 17:39:21 p34 [   63.436031] u32 classifier 
May 29 17:39:21 p34 [   63.436148]     Actions configured 
May 29 17:39:21 p34 [   63.436279] nf_conntrack version 0.5.0 (8192 buckets, 65536 max) 
May 29 17:39:21 p34 [   63.438882] ip_tables: (C) 2000-2006 Netfilter Core Team 
May 29 17:39:21 p34 [   63.439995] TCP cubic registered 
May 29 17:39:21 p34 [   63.440386] NET: Registered protocol family 1 
May 29 17:39:21 p34 [   63.440507] NET: Registered protocol family 17 
May 29 17:39:21 p34 [   63.445397] md: Autodetecting RAID arrays. 
May 29 17:39:21 p34 [   63.572955] md: autorun ... 
May 29 17:39:21 p34 [   63.573095] md: considering sdl1 ... 
May 29 17:39:21 p34 [   63.573596] md:  adding sdl1 ... 
May 29 17:39:21 p34 [   63.573924] md:  adding sdk1 ... 
May 29 17:39:21 p34 [   63.574312] md:  adding sdj1 ... 
May 29 17:39:21 p34 [   63.574664] md:  adding sdi1 ... 
May 29 17:39:21 p34 [   63.575005] md:  adding sdh1 ... 
May 29 17:39:21 p34 [   63.575396] md:  adding sdg1 ... 
May 29 17:39:21 p34 [   63.575754] md:  adding sdf1 ... 
May 29 17:39:21 p34 [   63.576089] md:  adding sde1 ... 
May 29 17:39:21 p34 [   63.576472] md:  adding sdd1 ... 
May 29 17:39:21 p34 [   63.576824] md:  adding sdc1 ... 
May 29 17:39:21 p34 [   63.577015] md: sdb3 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.577204] md: sdb2 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.577446] md: sdb1 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.577647] md: sda3 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.577846] md: sda2 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.578043] md: sda1 has different UUID to sdl1 
May 29 17:39:21 p34 [   63.579527] md: created md3 
May 29 17:39:21 p34 [   63.579639] md: bind<sdc1> 
May 29 17:39:21 p34 [   63.579956] md: bind<sdd1> 
May 29 17:39:21 p34 [   63.580329] md: bind<sde1> 
May 29 17:39:21 p34 [   63.580627] md: bind<sdf1> 
May 29 17:39:21 p34 [   63.580933] md: bind<sdg1> 
May 29 17:39:21 p34 [   63.581229] md: bind<sdh1> 
May 29 17:39:21 p34 [   63.581624] md: bind<sdi1> 
May 29 17:39:21 p34 [   63.582103] md: bind<sdj1> 
May 29 17:39:21 p34 [   63.582436] md: bind<sdk1> 
May 29 17:39:21 p34 [   63.582776] md: bind<sdl1> 
May 29 17:39:21 p34 [   63.583100] md: running: 
May 29 17:39:21 p34 
May 29 17:39:21 p34 [   63.586384] raid5: device sdl1 operational as raid disk 2 
May 29 17:39:21 p34 [   63.586509] raid5: device sdk1 operational as raid disk 3 
May 29 17:39:21 p34 [   63.586656] raid5: device sdj1 operational as raid disk 0 
May 29 17:39:21 p34 [   63.586829] raid5: device sdi1 operational as raid disk 1 
May 29 17:39:21 p34 [   63.586973] raid5: device sdh1 operational as raid disk 6 
May 29 17:39:21 p34 [   63.587122] raid5: device sdg1 operational as raid disk 5 
May 29 17:39:21 p34 [   63.587317] raid5: device sdf1 operational as raid disk 4 
May 29 17:39:21 p34 [   63.587459] raid5: device sde1 operational as raid disk 7 
May 29 17:39:21 p34 [   63.587603] raid5: device sdd1 operational as raid disk 8 
May 29 17:39:21 p34 [   63.587758] raid5: device sdc1 operational as raid disk 9 
May 29 17:39:21 p34 [   63.608186] raid5: allocated 10562kB for md3 
May 29 17:39:21 p34 [   63.608334] raid5: raid level 5 set md3 active with 10 out of 10 devices, algorithm 2 
May 29 17:39:21 p34 [   63.608519] RAID5 conf printout: 
May 29 17:39:21 p34 [   63.608639]  --- rd:10 wd:10 
May 29 17:39:21 p34 [   63.608767]  disk 0, o:1, dev:sdj1 
May 29 17:39:21 p34 [   63.608897]  disk 1, o:1, dev:sdi1 
May 29 17:39:21 p34 [   63.609073]  disk 2, o:1, dev:sdl1 
May 29 17:39:21 p34 [   63.609184]  disk 3, o:1, dev:sdk1 
May 29 17:39:21 p34 [   63.609346]  disk 4, o:1, dev:sdf1 
May 29 17:39:21 p34 [   63.609507]  disk 5, o:1, dev:sdg1 
May 29 17:39:21 p34 [   63.609640]  disk 6, o:1, dev:sdh1 
May 29 17:39:21 p34 [   63.609771]  disk 7, o:1, dev:sde1 
May 29 17:39:21 p34 [   63.609903]  disk 8, o:1, dev:sdd1 
May 29 17:39:21 p34 [   63.610040]  disk 9, o:1, dev:sdc1 
May 29 17:39:21 p34 [   63.612460] md: considering sdb3 ... 
May 29 17:39:21 p34 [   63.612835] md:  adding sdb3 ... 
May 29 17:39:21 p34 [   63.613027] md: sdb2 has different UUID to sdb3 
May 29 17:39:21 p34 [   63.613220] md: sdb1 has different UUID to sdb3 
May 29 17:39:21 p34 [   63.613589] md:  adding sda3 ... 
May 29 17:39:21 p34 [   63.613801] md: sda2 has different UUID to sdb3 
May 29 17:39:21 p34 [   63.613997] md: sda1 has different UUID to sdb3 
May 29 17:39:21 p34 [   63.615606] md: created md2 
May 29 17:39:21 p34 [   63.615720] md: bind<sda3> 
May 29 17:39:21 p34 [   63.616094] md: bind<sdb3> 
May 29 17:39:21 p34 [   63.616575] md: running: 
May 29 17:39:21 p34 
May 29 17:39:21 p34 [   63.619316] raid1: raid set md2 active with 2 out of 2 mirrors 
May 29 17:39:21 p34 [   63.620513] md: considering sdb2 ... 
May 29 17:39:21 p34 [   63.620870] md:  adding sdb2 ... 
May 29 17:39:21 p34 [   63.621082] md: sdb1 has different UUID to sdb2 
May 29 17:39:21 p34 [   63.621465] md:  adding sda2 ... 
May 29 17:39:21 p34 [   63.621646] md: sda1 has different UUID to sdb2 
May 29 17:39:21 p34 [   63.623619] md: created md1 
May 29 17:39:21 p34 [   63.623733] md: bind<sda2> 
May 29 17:39:21 p34 [   63.624059] md: bind<sdb2> 
May 29 17:39:21 p34 [   63.624439] md: running: 
May 29 17:39:21 p34 
May 29 17:39:21 p34 [   63.627438] raid1: raid set md1 active with 2 out of 2 mirrors 
May 29 17:39:21 p34 [   63.628555] md: considering sdb1 ... 
May 29 17:39:21 p34 [   63.628883] md:  adding sdb1 ... 
May 29 17:39:21 p34 [   63.629302] md:  adding sda1 ... 
May 29 17:39:21 p34 [   63.629411] md: created md0 
May 29 17:39:21 p34 [   63.629576] md: bind<sda1> 
May 29 17:39:21 p34 [   63.629882] md: bind<sdb1> 
May 29 17:39:21 p34 [   63.630233] md: running: 
May 29 17:39:21 p34 
May 29 17:39:21 p34 [   63.633438] raid1: raid set md0 active with 2 out of 2 mirrors 
May 29 17:39:21 p34 [   63.634598] md: ... autorun DONE. 
May 29 17:39:21 p34 [   63.695456] UDF-fs: No VRS found 
May 29 17:39:21 p34 [   63.699158] Filesystem "md2": Disabling barriers, not supported by the underlying device 
May 29 17:39:21 p34 [   63.713776] XFS mounting filesystem md2 
May 29 17:39:21 p34 [   63.813743] VFS: Mounted root (xfs filesystem) readonly. 
May 29 17:39:21 p34 [   63.814115] Freeing unused kernel memory: 220k freed 
May 29 17:40:39 p34 [  141.447304] Adding 16787768k swap on /dev/md0.  Priority:-1 extents:1 across:16787768k 
May 29 17:40:40 p34 [  142.497721] Filesystem "md2": Disabling barriers, not supported by the underlying device 
May 29 17:41:04 p34 [  166.716017] kjournald starting.  Commit interval 5 seconds 
May 29 17:41:04 p34 [  166.729375] EXT3 FS on md1, 
May 29 17:41:04 p34 internal journal 
May 29 17:41:04 p34 [  166.729663] EXT3-fs: mounted filesystem with ordered data mode. 
May 29 17:41:04 p34 [  166.751799] Filesystem "md3": Disabling barriers, not supported by the underlying device 
May 29 17:41:04 p34 [  166.758717] XFS mounting filesystem md3 
May 29 17:41:54 p34 [  216.821357] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX 
May 29 17:42:29 p34 [  251.481399] process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT 
May 29 17:46:42 p34 [  504.074171] mtrr: no more MTRRs available
