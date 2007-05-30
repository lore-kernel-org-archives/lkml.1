Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXE3OgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXE3OgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXE3OgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:36:11 -0400
Received: from lucidpixels.com ([75.144.35.66]:50245 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXE3OgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:36:07 -0400
Date: Wed, 30 May 2007 10:36:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org, crmotherboard@mailbox.cps.intel.com
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of
 RAM on Intel 965WH motherboards. (FULL DMESG)
In-Reply-To: <Pine.LNX.4.64.0705301029500.13945@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0705301035320.13945@p34.internal.lan>
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no> <465CF8CA.8070009@shaw.ca>
 <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan> <465D89E1.7030301@shaw.ca>
 <Pine.LNX.4.64.0705301029500.13945@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-925635164-1180535762=:13945"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-925635164-1180535762=:13945
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

That output looked nasty, attaching entries from syslog.

Justin.

On Wed, 30 May 2007, Justin Piszcz wrote:

> Yes, you are correct, the netconsole output from another machine is shown 
> below.  If we can access the memory directly, why is it so slow? :(  Am I the 
> first person to try using 8 gigabytes of RAM on the 965 chipset?
>
> On Wed, 30 May 2007, Robert Hancock wrote:
>
>> Justin Piszcz wrote:
>>> Kernel dmesg attached from 8GB bootup.
>> 
>> It looks like part of the start of the output was truncated..
>> 
>>> Robert, how come the option is not applicable in 64-bit mode? If I want to 
>>> use all 8GB of memory I need to run a 32-bit kernel?
>>> 
>>> Justin.
>>> 
>> 
>> Highmem and PAE (which are essentially what the 4GB/64GB memory options 
>> control) are not needed in 64-bit mode, since we can access the entire 
>> 64-bit address space directly.
>> 
>> -- 
>> Robert Hancock      Saskatoon, SK, Canada
>> To email, remove "nospam" from hancockr@nospamshaw.ca
>> Home Page: http://www.roberthancock.com/
>> 
>
> Here is the _FULL_ dmesg!  Thanks netconsole!
>
> May 29 17:39:11 p34 [    0.000000] Linux version 2.6.21.3 
> (root@p34.internal.lan) (gcc version 4.1.2 20061115 (prerelease) (Debian 
> 4.1.1-21)) #4 SMP Sun May 27 06:28:33 EDT 2007 May 29 17:39:11 p34 [ 
> 0.000000] Command line: auto BOOT_IMAGE=2.6.21.3-4 ro root=902 
> netconsole=4444@192.168.168.253/eth0,514@192.168.168.254/00:50:8D:ED:3C:E7 
> nmi_watchdog=1 May 29 17:39:11 p34 [    0.000000] BIOS-provided physical RAM 
> map: May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000000000000 - 
> 000000000008f000 (usable) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 
> 000000000008f000 - 00000000000a0000 (reserved) May 29 17:39:11 p34 [ 
> 0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved) May 29 
> 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf58f000 
> (usable) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf58f000 - 
> 00000000cf59c000 (reserved) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 
> 00000000cf59c000 - 00000000cf653000 (usable) May 29 17:39:11 p34 [ 
> 0.000000]  BIOS-e820: 00000000cf653000 - 00000000cf6a5000 (ACPI NVS) May 29 
> 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6a5000 - 00000000cf6a8000 
> (ACPI data) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6a8000 - 
> 00000000cf6ef000 (ACPI NVS) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 
> 00000000cf6ef000 - 00000000cf6f1000 (ACPI data) May 29 17:39:11 p34 [ 
> 0.000000]  BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable) May 29 
> 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 
> (ACPI data) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 00000000cf6ff000 - 
> 00000000cf700000 (usable) May 29 17:39:11 p34 [    0.000000]  BIOS-e820: 
> 00000000cf700000 - 00000000d0000000 (reserved) May 29 17:39:11 p34 [ 
> 0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved) May 29 
> 17:39:11 p34 [    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 
> (usable) May 29 17:39:11 p34 [    0.000000] end_pfn_map = 2277376 May 29 
> 17:39:11 p34 [    0.000000] DMI 2.4 present. May 29 17:39:11 p34 [ 
> 0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL ) May 29 17:39:11 p34 [ 
> 0.000000] ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DG965WH       64C 
> 1000013) May 29 17:39:11 p34 [    0.000000] ACPI: FACP CF6FC000, 0074 (r1 
> INTEL  DG965WH       64C MSFT  1000013) May 29 17:39:11 p34 [    0.000000] 
> ACPI: DSDT CF6F7000, 40E9 (r1 INTEL  DG965WH       64C MSFT  1000013) May 29 
> 17:39:11 p34 [    0.000000] ACPI: FACS CF6A8000, 0040 May 29 17:39:11 p34 [ 
> 0.000000] ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       64C MSFT 
> 1000013) May 29 17:39:11 p34 [    0.000000] ACPI: WDDT CF6F5000, 0040 (r1 
> INTEL  DG965WH       64C MSFT  1000013) May 29 17:39:11 p34 [    0.000000] 
> ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       64C MSFT  1000013) May 29 
> 17:39:11 p34 [    0.000000] ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH 
> 64C MSFT  1000013) May 29 17:39:11 p34 [    0.000000] ACPI: HPET CF6F2000, 
> 0038 (r1 INTEL  DG965WH       64C MSFT  1000013) May 29 17:39:11 p34 [ 
> 0.000000] ACPI: SSDT CF6F0000, 01BC (r1 INTEL     CpuPm      64C MSFT 
> 1000013) May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6EF000, 0175 (r1 
> INTEL   Cpu0Ist      64C MSFT  1000013) May 29 17:39:11 p34 [    0.000000] 
> ACPI: SSDT CF6A7000, 0175 (r1 INTEL   Cpu1Ist      64C MSFT  1000013) May 29 
> 17:39:11 p34 [    0.000000] ACPI: SSDT CF6A6000, 0175 (r1 INTEL   Cpu2Ist 
> 64C MSFT  1000013) May 29 17:39:11 p34 [    0.000000] ACPI: SSDT CF6A5000, 
> 0175 (r1 INTEL   Cpu3Ist      64C MSFT  1000013) May 29 17:39:11 p34 [ 
> 0.000000] Zone PFN ranges: May 29 17:39:11 p34 [    0.000000]   DMA 
> 0 ->     4096 May 29 17:39:11 p34 [    0.000000]   DMA32        4096 -> 
> 1048576 May 29 17:39:11 p34 [    0.000000]   Normal    1048576 ->  2277376 
> May 29 17:39:11 p34 [    0.000000] early_node_map[6] active PFN ranges May 29 
> 17:39:11 p34 [    0.000000]     0:        0 ->      143 May 29 17:39:11 p34 [ 
> 0.000000]     0:      256 ->   849295 May 29 17:39:11 p34 [    0.000000] 
> 0:   849308 ->   849491 May 29 17:39:11 p34 [    0.000000]     0:   849649 -> 
> 849650 May 29 17:39:11 p34 [    0.000000]     0:   849663 ->   849664 May 29 
> 17:39:11 p34 [    0.000000]     0:  1048576 ->  2277376 May 29 17:39:11 p34 [ 
> 0.000000] ACPI: PM-Timer IO Port: 0x408 May 29 17:39:11 p34 [    0.000000] 
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled) May 29 17:39:11 p34 [ 
> 0.000000] Processor #0 (Bootup-CPU) May 29 17:39:11 p34 [    0.000000] ACPI: 
> LAPIC (acpi_id[0x03] lapic_id[0x02] enabled) May 29 17:39:11 p34 [ 
> 0.000000] Processor #2 May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC 
> (acpi_id[0x02] lapic_id[0x01] enabled) May 29 17:39:11 p34 [    0.000000] 
> Processor #1 May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC (acpi_id[0x04] 
> lapic_id[0x03] enabled) May 29 17:39:11 p34 [    0.000000] Processor #3 May 
> 29 17:39:11 p34 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl 
> lint[0x1]) May 29 17:39:11 p34 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] 
> dfl dfl lint[0x1]) May 29 17:39:11 p34 [    0.000000] ACPI: IOAPIC (id[0x02] 
> address[0xfec00000] gsi_base[0]) May 29 17:39:11 p34 [    0.000000] 
> IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23 May 29 17:39:11 p34 [ 
> 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl) May 29 
> 17:39:11 p34 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 
> high level) May 29 17:39:11 p34 [    0.000000] Setting APIC routing to flat 
> May 29 17:39:11 p34 [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000 
> May 29 17:39:11 p34 [    0.000000] Using ACPI (MADT) for SMP configuration 
> information May 29 17:39:11 p34 [    0.000000] Nosave address range: 
> 000000000008f000 - 00000000000a0000 May 29 17:39:11 p34 [    0.000000] Nosave 
> address range: 00000000000a0000 - 00000000000e0000 May 29 17:39:11 p34 [ 
> 0.000000] Nosave address range: 00000000000e0000 - 0000000000100000 May 29 
> 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf58f000 - 
> 00000000cf59c000 May 29 17:39:11 p34 [    0.000000] Nosave address range: 
> 00000000cf653000 - 00000000cf6a5000 May 29 17:39:11 p34 [    0.000000] Nosave 
> address range: 00000000cf6a5000 - 00000000cf6a8000 May 29 17:39:11 p34 [ 
> 0.000000] Nosave address range: 00000000cf6a8000 - 00000000cf6ef000 May 29 
> 17:39:11 p34 [    0.000000] Nosave address range: 00000000cf6ef000 - 
> 00000000cf6f1000 May 29 17:39:11 p34 [    0.000000] Nosave address range: 
> 00000000cf6f2000 - 00000000cf6ff000 May 29 17:39:11 p34 [    0.000000] Nosave 
> address range: 00000000cf700000 - 00000000d0000000 May 29 17:39:11 p34 [ 
> 0.000000] Nosave address range: 00000000d0000000 - 00000000fff00000 May 29 
> 17:39:11 p34 [    0.000000] Nosave address range: 00000000fff00000 - 
> 0000000100000000 May 29 17:39:11 p34 [    0.000000] Allocating PCI resources 
> starting at d4000000 (gap: d0000000:2ff00000) May 29 17:39:11 p34 [ 
> 0.000000] PERCPU: Allocating 24512 bytes of per cpu data May 29 17:39:11 p34 
> [    0.000000] Built 1 zonelists.  Total pages: 2045692 May 29 17:39:11 p34 [ 
> 0.000000] Kernel command line: auto BOOT_IMAGE=2.6.21.3-4 ro root=902 
> netconsole=4444@192.168.168.253/eth0,514@192.168.168.254/00:50:8D:ED:3C:E7 
> nmi_watchdog=1 May 29 17:39:11 p34 [    0.000000] netconsole: local port 4444 
> May 29 17:39:11 p34 [    0.000000] netconsole: local IP 192.168.168.253 May 
> 29 17:39:11 p34 [    0.000000] netconsole: interface eth0 May 29 17:39:11 p34 
> [    0.000000] netconsole: remote port 514 May 29 17:39:11 p34 [    0.000000] 
> netconsole: remote IP 192.168.168.254 May 29 17:39:11 p34 [    0.000000] 
> netconsole: remote ethernet address 00:50:8d:ed:3c:e7 May 29 17:39:11 p34 [ 
> 0.000000] Initializing CPU#0 May 29 17:39:11 p34 [    0.000000] PID hash 
> table entries: 4096 (order: 12, 32768 bytes) May 29 17:39:11 p34 [ 
> 48.249507] time.c: Detected 2397.605 MHz processor. May 29 17:39:11 p34 [ 
> 48.250572] Console: colour VGA+ 80x25 May 29 17:39:11 p34 [   48.258651] 
> Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes) May 29 
> 17:39:11 p34 [   48.264855] Inode-cache hash table entries: 524288 (order: 
> 10, 4194304 bytes) May 29 17:39:11 p34 [   48.265963] Checking aperture... 
> May 29 17:39:11 p34 [   48.266011] PCI-DMA: Using software bounce buffering 
> for IO (SWIOTLB) May 29 17:39:11 p34 [   48.302233] Placing software IO TLB 
> between 0x95f6000 - 0xd5f6000 May 29 17:39:11 p34 [   48.374061] Memory: 
> 8103748k/9109504k available (3428k kernel code, 208464k reserved, 1270k data, 
> 220k init) May 29 17:39:11 p34 [   48.434756] Calibrating delay using timer 
> specific routine.. 4797.72 BogoMIPS (lpj=2398863) May 29 17:39:11 p34 [ 
> 48.435408] Mount-cache hash table entries: 256 May 29 17:39:11 p34 [ 
> 48.436246] CPU: L1 I cache: 32K, L1 D cache: 32K May 29 17:39:11 p34 [ 
> 48.436307] CPU: L2 cache: 4096K May 29 17:39:11 p34 [   48.436347] using 
> mwait in idle threads. May 29 17:39:11 p34 [   48.436389] CPU: Physical 
> Processor ID: 0 May 29 17:39:11 p34 [   48.436430] CPU: Processor Core ID: 0 
> May 29 17:39:11 p34 [   48.436474] CPU0: Thermal monitoring enabled (TM2) May 
> 29 17:39:11 p34 [   48.436526] Freeing SMP alternatives: 36k freed May 29 
> 17:39:11 p34 [   48.436584] ACPI: Core revision 20070126 May 29 17:39:11 p34 
> [   48.485666] activating NMI Watchdog ... done. May 29 17:39:11 p34 [ 
> 48.485786] Using local APIC timer interrupts. May 29 17:39:11 p34 [ 
> 48.527564] result 16650037 May 29 17:39:11 p34 [   48.527642] Detected 16.650 
> MHz APIC timer. May 29 17:39:11 p34 [   48.529312] Booting processor 1/4 APIC 
> 0x2 May 29 17:39:11 p34 [   48.539943] Initializing CPU#1 May 29 17:39:11 p34 
> [   48.600727] Calibrating delay using timer specific routine.. 4795.07 
> BogoMIPS (lpj=2397539) May 29 17:39:11 p34 [   48.600785] CPU: L1 I cache: 
> 32K, L1 D cache: 32K May 29 17:39:11 p34 [   48.600822] CPU: L2 cache: 4096K 
> May 29 17:39:11 p34 [   48.600852] CPU: Physical Processor ID: 0 May 29 
> 17:39:11 p34 [   48.600879] CPU: Processor Core ID: 2 May 29 17:39:11 p34 [ 
> 48.600914] CPU1: Thermal monitoring enabled (TM2) May 29 17:39:11 p34 [ 
> 48.601348] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 May 29 
> 17:39:11 p34 [   48.601451] checking TSC synchronization [CPU#0 -> CPU#1]: 
> passed. May 29 17:39:11 p34 [   48.623998] Booting processor 2/4 APIC 0x1 May 
> 29 17:39:11 p34 [   48.635015] Initializing CPU#2 May 29 17:39:11 p34 [ 
> 48.694729] Calibrating delay using timer specific routine.. 4796.63 BogoMIPS 
> (lpj=2398315) May 29 17:39:11 p34 [   48.694791] CPU: L1 I cache: 32K, L1 D 
> cache: 32K May 29 17:39:11 p34 [   48.694829] CPU: L2 cache: 4096K May 29 
> 17:39:11 p34 [   48.694861] CPU: Physical Processor ID: 0 May 29 17:39:11 p34 
> [   48.694891] CPU: Processor Core ID: 1 May 29 17:39:11 p34 [   48.694928] 
> CPU2: Thermal monitoring enabled (TM2) May 29 17:39:11 p34 [   48.695368] 
> Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 May 29 17:39:11 
> p34 [   48.695508] checking TSC synchronization [CPU#0 -> CPU#2]: passed. May 
> 29 17:39:11 p34 [   48.717915] Booting processor 3/4 APIC 0x3 May 29 17:39:11 
> p34 [   48.728547] Initializing CPU#3 May 29 17:39:11 p34 [   48.788686] 
> Calibrating delay using timer specific routine.. 4795.46 BogoMIPS 
> (lpj=2397730) May 29 17:39:11 p34 [   48.788750] CPU: L1 I cache: 32K, L1 D 
> cache: 32K May 29 17:39:11 p34 [   48.788787] CPU: L2 cache: 4096K May 29 
> 17:39:11 p34 [   48.788817] CPU: Physical Processor ID: 0 May 29 17:39:11 p34 
> [   48.788846] CPU: Processor Core ID: 3 May 29 17:39:11 p34 [   48.788882] 
> CPU3: Thermal monitoring enabled (TM2) May 29 17:39:11 p34 [   48.789318] 
> Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07 May 29 17:39:11 
> p34 [   48.789446] checking TSC synchronization [CPU#0 -> CPU#3]: passed. May 
> 29 17:39:11 p34 [   48.810753] Brought up 4 CPUs May 29 17:39:11 p34 [ 
> 48.810941] testing NMI watchdog ... OK. May 29 17:39:11 p34 [   49.178287] 
> migration_cost=156,193 May 29 17:39:11 p34 [   49.182074] NET: Registered 
> protocol family 16 May 29 17:39:11 p34 [   49.183506] ACPI: bus type pci 
> registered May 29 17:39:11 p34 [   49.183670] PCI: BIOS Bug: MCFG area at 
> f0000000 is not E820-reserved May 29 17:39:11 p34 [   49.183764] PCI: Not 
> using MMCONFIG. May 29 17:39:11 p34 [   49.183847] PCI: Using configuration 
> type 1 May 29 17:39:11 p34 [   49.324928] ACPI: Interpreter enabled May 29 
> 17:39:11 p34 [   49.325010] ACPI: Using IOAPIC for interrupt routing May 29 
> 17:39:11 p34 [   49.518427] ACPI: PCI Root Bridge [PCI0] (0000:00) May 29 
> 17:39:11 p34 [   49.523873] PCI quirk: region 0400-047f claimed by ICH6 
> ACPI/GPIO/TCO May 29 17:39:11 p34 [   49.523974] PCI quirk: region 0500-053f 
> claimed by ICH6 GPIO May 29 17:39:11 p34 [   49.534492] PCI: Transparent 
> bridge - 0000:00:1e.0 May 29 17:39:11 p34 [   49.792346] ACPI: PCI Interrupt 
> Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12) May 29 17:39:11 p34 [   49.796475] 
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12) May 29 17:39:11 
> p34 [   49.800543] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12) 
> May 29 17:39:11 p34 [   49.804653] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 
> 5 7 9 10 *11 12) May 29 17:39:11 p34 [   49.808781] ACPI: PCI Interrupt Link 
> [LNKE] (IRQs 3 4 5 7 *9 10 11 12) May 29 17:39:11 p34 [   49.812812] ACPI: 
> PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12) May 29 17:39:11 p34 [ 
> 49.816864] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12) May 29 
> 17:39:11 p34 [   49.820999] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 
> 10 *11 12) May 29 17:39:11 p34 [   49.824280] Linux Plug and Play Support 
> v0.97 (c) Adam Belay May 29 17:39:11 p34 [   49.824569] pnp: PnP ACPI init 
> May 29 17:39:11 p34 [   49.923406] pnp: PnP ACPI: found 12 devices May 29 
> 17:39:11 p34 [   49.927655] SCSI subsystem initialized May 29 17:39:11 p34 [ 
> 49.935480] usbcore: registered new interface driver usbfs May 29 17:39:11 p34 
> [   49.936497] usbcore: registered new interface driver hub May 29 17:39:11 
> p34 [   49.939469] usbcore: registered new device driver usb May 29 17:39:11 
> p34 [   49.942750] PCI: Using ACPI for IRQ routing May 29 17:39:11 p34 [ 
> 49.942851] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, 
> post a report May 29 17:39:11 p34 [   49.944223] PCI-GART: No AMD northbridge 
> found. May 29 17:39:11 p34 [   49.944929] hpet0: at MMIO 0xfed00000, IRQs 2, 
> 8, 0 May 29 17:39:11 p34 [   49.945145] hpet0: 3 64-bit timers, 14318180 Hz 
> May 29 17:39:11 p34 [   49.946417] Time: tsc clocksource has been installed. 
> May 29 17:39:11 p34 [   49.947517] pnp: 00:01: iomem range 
> 0xf0000000-0xf7ffffff has been reserved May 29 17:39:11 p34 [   49.947640] 
> pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved May 29 
> 17:39:11 p34 [   49.947785] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has 
> been reserved May 29 17:39:11 p34 [   49.947943] pnp: 00:01: iomem range 
> 0xfed18000-0xfed18fff has been reserved May 29 17:39:11 p34 [   49.948125] 
> pnp: 00:06: ioport range 0x500-0x53f has been reserved May 29 17:39:11 p34 [ 
> 49.948231] pnp: 00:06: ioport range 0x400-0x47f has been reserved May 29 
> 17:39:11 p34 [   49.948433] pnp: 00:06: ioport range 0x680-0x6ff has been 
> reserved May 29 17:39:11 p34 [   49.961379] ACPI: PCI Interrupt 
> 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19 May 29 17:39:11 p34 [ 
> 50.015143] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19] 
> MMIO=[e0084000-e00847ff]  Max Packet=[2048]  IR/IT contexts=[4/8] May 29 
> 17:39:11 p34 [   50.016694] PCI: Ignore bogus resource 6 [0:0] of 
> 0000:00:02.0 May 29 17:39:11 p34 [   50.017108] PCI: Bridge: 0000:00:1c.0 May 
> 29 17:39:11 p34 [   50.017203]   IO window: disabled. May 29 17:39:11 p34 [ 
> 50.017295]   MEM window: e0700000-e07fffff May 29 17:39:11 p34 [   50.017381] 
> PREFETCH window: disabled. May 29 17:39:11 p34 [   50.017507] PCI: Bridge: 
> 0000:00:1c.1 May 29 17:39:11 p34 [   50.017598]   IO window: 5000-5fff May 29 
> 17:39:11 p34 [   50.017689]   MEM window: e0400000-e04fffff May 29 17:39:11 
> p34 [   50.017776]   PREFETCH window: disabled. May 29 17:39:11 p34 [ 
> 50.017882] PCI: Bridge: 0000:00:1c.2 May 29 17:39:11 p34 [   50.017966]   IO 
> window: 4000-4fff May 29 17:39:11 p34 [   50.018071]   MEM window: 
> e0300000-e03fffff May 29 17:39:11 p34 [   50.018189]   PREFETCH window: 
> e0800000-e08fffff May 29 17:39:11 p34 [   50.018297] PCI: Bridge: 
> 0000:00:1c.3 May 29 17:39:11 p34 [   50.018382]   IO window: 3000-3fff May 29 
> 17:39:11 p34 [   50.018504]   MEM window: e0200000-e02fffff May 29 17:39:11 
> p34 [   50.018598]   PREFETCH window: e0900000-e09fffff May 29 17:39:11 p34 [ 
> 50.018707] PCI: Bridge: 0000:00:1c.4 May 29 17:39:11 p34 [   50.018792]   IO 
> window: 2000-2fff May 29 17:39:11 p34 [   50.018885]   MEM window: 
> e0100000-e01fffff May 29 17:39:11 p34 [   50.018976]   PREFETCH window: 
> e0a00000-e0afffff May 29 17:39:11 p34 [   50.019121] PCI: Bridge: 
> 0000:00:1e.0 May 29 17:39:11 p34 [   50.019234]   IO window: 1000-1fff May 29 
> 17:39:11 p34 [   50.019325]   MEM window: e0000000-e00fffff May 29 17:39:11 
> p34 [   50.019436]   PREFETCH window: e0b00000-e0bfffff May 29 17:39:11 p34 [ 
> 50.019625] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 
> 17 May 29 17:39:11 p34 [   50.019912] ACPI: PCI Interrupt 0000:00:1c.1[B] -> 
> GSI 16 (level, low) -> IRQ 16 May 29 17:39:11 p34 [   50.020251] ACPI: PCI 
> Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18 May 29 17:39:11 
> p34 [   50.020556] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) 
> -> IRQ 19 May 29 17:39:11 p34 [   50.020829] ACPI: PCI Interrupt 
> 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17 May 29 17:39:11 p34 [ 
> 50.022111] NET: Registered protocol family 2 May 29 17:39:11 p34 [ 
> 50.032134] IP route cache hash table entries: 262144 (order: 9, 2097152 
> bytes) May 29 17:39:11 p34 [   50.041151] TCP established hash table entries: 
> 131072 (order: 9, 3145728 bytes) May 29 17:39:11 p34 [   50.053741] TCP bind 
> hash table entries: 65536 (order: 8, 1048576 bytes) May 29 17:39:11 p34 [ 
> 50.057942] TCP: Hash tables configured (established 131072 bind 65536) May 29 
> 17:39:11 p34 [   50.058031] TCP reno registered May 29 17:39:11 p34 [ 
> 50.104079] Installing knfsd (copyright (C) 1996 okir@monad.swb.de). May 29 
> 17:39:11 p34 [   50.108290] SGI XFS with large block/inode numbers, no debug 
> enabled May 29 17:39:11 p34 [   50.124796] io scheduler noop registered May 
> 29 17:39:11 p34 [   50.124877] io scheduler anticipatory registered (default) 
> May 29 17:39:11 p34 [   50.130760] assign_interrupt_mode Found MSI capability 
> May 29 17:39:11 p34 [   50.133909] assign_interrupt_mode Found MSI capability 
> May 29 17:39:11 p34 [   50.136992] assign_interrupt_mode Found MSI capability 
> May 29 17:39:11 p34 [   50.139916] assign_interrupt_mode Found MSI capability 
> May 29 17:39:11 p34 [   50.142907] assign_interrupt_mode Found MSI capability 
> May 29 17:39:11 p34 [   50.217615] lp: driver loaded but no devices found May 
> 29 17:39:11 p34 [   50.219124] Real Time Clock Driver v1.12ac May 29 17:39:11 
> p34 [   50.221782] Linux agpgart interface v0.102 (c) Dave Jones May 29 
> 17:39:11 p34 [   50.223328] agpgart: Detected an Intel 965G Chipset. May 29 
> 17:39:11 p34 [   50.224565] agpgart: Detected 7676K stolen memory. May 29 
> 17:39:11 p34 [   50.243289] agpgart: AGP aperture is 256M @ 0xd0000000 May 29 
> 17:39:11 p34 [   50.243856] [drm] Initialized drm 1.1.0 20060810 May 29 
> 17:39:11 p34 [   50.244141] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 
> (level, low) -> IRQ 16 May 29 17:39:11 p34 [   50.246322] [drm] Initialized 
> i915 1.6.0 20060119 on minor 0 May 29 17:39:11 p34 [   50.247415] parport: 
> PnPBIOS parport detected. May 29 17:39:11 p34 [   50.247654] parport0: 
> PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP] May 
> 29 17:39:11 p34 [   50.331362] lp0: using parport0 (interrupt-driven). May 29 
> 17:39:11 p34 [   50.341355] loop: loaded (max 8 devices) May 29 17:39:11 p34 
> [   50.341437] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI May 
> 29 17:39:11 p34 [   50.341528] Copyright (c) 1999-2006 Intel Corporation. May 
> 29 17:39:11 p34 [   50.342520] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 
> (level, low) -> IRQ 20 May 29 17:39:11 p34 [   50.360685] e1000: 
> 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:19:d1:6e:9d:43 
> May 29 17:39:11 p34 [   50.439132] e1000: eth0: e1000_probe: Intel(R) 
> PRO/1000 Network Connection May 29 17:39:11 p34 [   50.439655] ACPI: PCI 
> Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21 May 29 17:39:11 
> p34 [   50.705534] e1000: 0000:06:00.0: e1000_probe: (PCI:33MHz:32-bit) 
> 00:0e:0c:00:cd:b1 May 29 17:39:11 p34 [   50.857482] e1000: eth1: 
> e1000_probe: Intel(R) PRO/1000 Network Connection May 29 17:39:11 p34 [ 
> 50.857724] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 22 (level, low) -> IRQ 
> 22 May 29 17:39:11 p34 [   51.107171] e1000: 0000:06:01.0: e1000_probe: 
> (PCI:33MHz:32-bit) 00:07:e9:29:37:db May 29 17:39:11 p34 [   51.136221] 
> e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection May 29 
> 17:39:11 p34 [   51.138251] netconsole: device eth0 not up yet, forcing it 
> May 29 17:39:11 p34 [   53.180364] e1000: eth0: e1000_watchdog: NIC Link is 
> Up 1000 Mbps Full Duplex, Flow Control: RX/TX May 29 17:39:11 p34 [ 
> 53.683096] netconsole: network logging started May 29 17:39:11 p34 [ 
> 53.686923] ACPI: PCI Interrupt 0000:00:1f.2[A] -> May 29 17:39:11 p34 GSI 19 
> (level, low) -> IRQ 19 May 29 17:39:12 p34 [   54.687783] ahci 0000:00:1f.2: 
> AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode May 29 17:39:12 
> p34 [   54.687956] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
> May 29 17:39:12 p34 [   54.690522] ata1: SATA max UDMA/133 cmd 
> 0xffffc20000078100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.692552] ata2: SATA max UDMA/133 cmd 
> 0xffffc20000078180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.694637] ata3: SATA max UDMA/133 cmd 
> 0xffffc20000078200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.696669] ata4: SATA max UDMA/133 cmd 
> 0xffffc20000078280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.698687] ata5: SATA max UDMA/133 cmd 
> 0xffffc20000078300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.700726] ata6: SATA max UDMA/133 cmd 
> 0xffffc20000078380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 377 
> May 29 17:39:12 p34 [   54.701011] scsi0 : ahci May 29 17:39:13 p34 [ 
> 55.162816] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300) May 29 
> 17:39:13 p34 [   55.165434] ata1.00: ATA-6: WDC WD740GD-00FLC0, 33.08F33, max 
> UDMA/133 May 29 17:39:13 p34 [   55.165604] ata1.00: 145226112 sectors, multi 
> 0: LBA48 May 29 17:39:13 p34 [   55.169510] ata1.00: configured for UDMA/133 
> May 29 17:39:13 p34 [   55.170050] scsi1 : ahci May 29 17:39:13 p34 [ 
> 55.632888] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300) May 29 
> 17:39:13 p34 [   55.635466] ata2.00: ATA-6: WDC WD740GD-00FLC0, 33.08F33, max 
> UDMA/133 May 29 17:39:13 p34 [   55.635625] ata2.00: 145226112 sectors, multi 
> 0: LBA48 May 29 17:39:13 p34 [   55.639563] ata2.00: configured for UDMA/133 
> May 29 17:39:13 p34 [   55.639885] scsi2 : ahci May 29 17:39:14 p34 [ 
> 56.100111] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300) May 29 
> 17:39:14 p34 [   56.101908] ata3.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, 
> max UDMA/133 May 29 17:39:14 p34 [   56.102086] ata3.00: 293046768 sectors, 
> multi 0: LBA48 NCQ (depth 31/32) May 29 17:39:14 p34 [   56.104825] ata3.00: 
> configured for UDMA/133 May 29 17:39:14 p34 [   56.105036] scsi3 : ahci May 
> 29 17:39:14 p34 [   56.567476] ata4: SATA link up 1.5 Gbps (SStatus 113 
> SControl 300) May 29 17:39:14 p34 [   56.569281] ata4.00: ATA-7: WDC 
> WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 29 17:39:14 p34 [   56.569423] 
> ata4.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32) May 29 17:39:14 
> p34 [   56.572150] ata4.00: configured for UDMA/133 May 29 17:39:14 p34 [ 
> 56.572391] scsi4 : ahci May 29 17:39:15 p34 [   57.032365] ata5: SATA link up 
> 1.5 Gbps (SStatus 113 SControl 300) May 29 17:39:15 p34 [   57.034115] 
> ata5.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 29 17:39:15 
> p34 [   57.034245] ata5.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 
> 31/32) May 29 17:39:15 p34 [   57.036865] ata5.00: configured for UDMA/133 
> May 29 17:39:15 p34 [   57.037078] scsi5 : ahci May 29 17:39:15 p34 [ 
> 57.496550] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300) May 29 
> 17:39:15 p34 [   57.498270] ata6.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, 
> max UDMA/133 May 29 17:39:15 p34 [   57.498438] ata6.00: 293046768 sectors, 
> multi 0: LBA48 NCQ (depth 31/32) May 29 17:39:15 p34 [   57.501093] ata6.00: 
> configured for UDMA/133 May 29 17:39:15 p34 [   57.502916] scsi 0:0:0:0: 
> Direct-Access     ATA      WDC WD740GD-00FL 33.0 PQ: 0 ANSI: 5 May 29 
> 17:39:15 p34 [   57.505120] SCSI device sda: 145226112 512-byte hdwr sectors 
> (74356 MB) May 29 17:39:15 p34 [   57.505456] sda: Write Protect is off May 
> 29 17:39:15 p34 [   57.506051] SCSI device sda: write cache: enabled, read 
> cache: enabled, doesn't support DPO or FUA May 29 17:39:15 p34 [   57.507023] 
> SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB) May 29 17:39:15 
> p34 [   57.507356] sda: Write Protect is off May 29 17:39:15 p34 [ 
> 57.507977] SCSI device sda: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.508155]  sda:
> May 29 17:39:15 p34  sda1
> May 29 17:39:15 p34  sda2
> May 29 17:39:15 p34  sda3
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.524234] sd 0:0:0:0: Attached 
> scsi disk sda May 29 17:39:15 p34 [   57.526473] scsi 1:0:0:0: Direct-Access 
> ATA      WDC WD740GD-00FL 33.0 PQ: 0 ANSI: 5 May 29 17:39:15 p34 [ 
> 57.528478] SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB) May 29 
> 17:39:15 p34 [   57.528824] sdb: Write Protect is off May 29 17:39:15 p34 [ 
> 57.529324] SCSI device sdb: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.530179] SCSI device 
> sdb: 145226112 512-byte hdwr sectors (74356 MB) May 29 17:39:15 p34 [ 
> 57.530511] sdb: Write Protect is off May 29 17:39:15 p34 [   57.531016] SCSI 
> device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:15 p34 [   57.531162]  sdb:
> May 29 17:39:15 p34  sdb1
> May 29 17:39:15 p34  sdb2
> May 29 17:39:15 p34  sdb3
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.545063] sd 1:0:0:0: Attached 
> scsi disk sdb May 29 17:39:15 p34 [   57.547103] scsi 2:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:15 p34 [ 
> 57.549007] SCSI device sdc: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:15 p34 [   57.549322] sdc: Write Protect is off May 29 17:39:15 p34 
> [   57.549869] SCSI device sdc: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.550710] SCSI device 
> sdc: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:15 p34 [ 
> 57.551003] sdc: Write Protect is off May 29 17:39:15 p34 [   57.551505] SCSI 
> device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:15 p34 [   57.551726]  sdc:
> May 29 17:39:15 p34  sdc1
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.565362] sd 2:0:0:0: Attached 
> scsi disk sdc May 29 17:39:15 p34 [   57.567447] scsi 3:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:15 p34 [ 
> 57.569384] SCSI device sdd: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:15 p34 [   57.569725] sdd: Write Protect is off May 29 17:39:15 p34 
> [   57.570218] SCSI device sdd: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.571193] SCSI device 
> sdd: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:15 p34 [ 
> 57.571500] sdd: Write Protect is off May 29 17:39:15 p34 [   57.572003] SCSI 
> device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:15 p34 [   57.572162]  sdd:
> May 29 17:39:15 p34  sdd1
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.587442] sd 3:0:0:0: Attached 
> scsi disk sdd May 29 17:39:15 p34 [   57.589470] scsi 4:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:15 p34 [ 
> 57.591359] SCSI device sde: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:15 p34 [   57.591632] sde: Write Protect is off May 29 17:39:15 p34 
> [   57.592147] SCSI device sde: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.593038] SCSI device 
> sde: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:15 p34 [ 
> 57.593357] sde: Write Protect is off May 29 17:39:15 p34 [   57.593826] SCSI 
> device sde: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:15 p34 [   57.594001]  sde:
> May 29 17:39:15 p34  sde1
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.605438] sd 4:0:0:0: Attached 
> scsi disk sde May 29 17:39:15 p34 [   57.607617] scsi 5:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:15 p34 [ 
> 57.609437] SCSI device sdf: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:15 p34 [   57.609770] sdf: Write Protect is off May 29 17:39:15 p34 
> [   57.610284] SCSI device sdf: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:15 p34 [   57.611221] SCSI device 
> sdf: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:15 p34 [ 
> 57.611518] sdf: Write Protect is off May 29 17:39:15 p34 [   57.612049] SCSI 
> device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:15 p34 [   57.612225]  sdf:
> May 29 17:39:15 p34  sdf1
> May 29 17:39:15 p34 May 29 17:39:15 p34 [   57.623709] sd 5:0:0:0: Attached 
> scsi disk sdf May 29 17:39:15 p34 [   57.626592] ACPI: PCI Interrupt 
> 0000:03:00.0[A] -> May 29 17:39:15 p34 GSI 18 (level, low) -> IRQ 18 May 29 
> 17:39:15 p34 [   57.628562] ata7: SATA max UDMA/100 cmd 0xffffc20000108000 
> ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 18 May 29 17:39:15 p34 [ 
> 57.629915] ata8: SATA max UDMA/100 cmd 0xffffc2000010a000 ctl 
> 0x0000000000000000 bmdma 0x0000000000000000 irq 18 May 29 17:39:15 p34 [ 
> 57.630185] scsi6 : sata_sil24 May 29 17:39:16 p34 [   58.036965] ata7: SATA 
> link up 1.5 Gbps (SStatus 113 SControl 300) May 29 17:39:16 p34 [ 
> 58.039003] ata7.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 
> 29 17:39:16 p34 [   58.039153] ata7.00: 293046768 sectors, multi 16: LBA48 
> NCQ (depth 31/32) May 29 17:39:16 p34 [   58.042162] ata7.00: configured for 
> UDMA/100 May 29 17:39:16 p34 [   58.042345] scsi7 : sata_sil24 May 29 
> 17:39:16 p34 [   58.448234] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 
> 300) May 29 17:39:16 p34 [   58.450325] ata8.00: ATA-7: WDC 
> WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 29 17:39:16 p34 [   58.450480] 
> ata8.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) May 29 17:39:16 
> p34 [   58.453526] ata8.00: configured for UDMA/100 May 29 17:39:16 p34 [ 
> 58.454693] scsi 6:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 
> 0 ANSI: 5 May 29 17:39:16 p34 [   58.456666] SCSI device sdg: 293046768 
> 512-byte hdwr sectors (150040 MB) May 29 17:39:16 p34 [   58.456964] sdg: 
> Write Protect is off May 29 17:39:16 p34 [   58.458045] SCSI device sdg: 
> write cache: enabled, read cache: enabled, doesn't support DPO or FUA May 29 
> 17:39:16 p34 [   58.458913] SCSI device sdg: 293046768 512-byte hdwr sectors 
> (150040 MB) May 29 17:39:16 p34 [   58.459203] sdg: Write Protect is off May 
> 29 17:39:16 p34 [   58.459754] SCSI device sdg: write cache: enabled, read 
> cache: enabled, doesn't support DPO or FUA May 29 17:39:16 p34 [   58.459918] 
> sdg:
> May 29 17:39:16 p34  sdg1
> May 29 17:39:16 p34 May 29 17:39:16 p34 [   58.474199] sd 6:0:0:0: Attached 
> scsi disk sdg May 29 17:39:16 p34 [   58.476416] scsi 7:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:16 p34 [ 
> 58.478356] SCSI device sdh: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:16 p34 [   58.478711] sdh: Write Protect is off May 29 17:39:16 p34 
> [   58.479177] SCSI device sdh: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:16 p34 [   58.480075] SCSI device 
> sdh: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:16 p34 [ 
> 58.480402] sdh: Write Protect is off May 29 17:39:16 p34 [   58.480928] SCSI 
> device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:16 p34 [   58.481075]  sdh:
> May 29 17:39:16 p34  sdh1
> May 29 17:39:16 p34 May 29 17:39:16 p34 [   58.495586] sd 7:0:0:0: Attached 
> scsi disk sdh May 29 17:39:16 p34 [   58.496786] ACPI: PCI Interrupt 
> 0000:04:00.0[A] -> May 29 17:39:16 p34 GSI 19 (level, low) -> IRQ 19 May 29 
> 17:39:16 p34 [   58.498258] ata9: SATA max UDMA/100 cmd 0xffffc20000110000 
> ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19 May 29 17:39:16 p34 [ 
> 58.499601] ata10: SATA max UDMA/100 cmd 0xffffc20000112000 ctl 
> 0x0000000000000000 bmdma 0x0000000000000000 irq 19 May 29 17:39:16 p34 [ 
> 58.499831] scsi8 : sata_sil24 May 29 17:39:16 p34 [   58.906766] ata9: SATA 
> link up 1.5 Gbps (SStatus 113 SControl 300) May 29 17:39:16 p34 [ 
> 58.908540] ata9.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 
> 29 17:39:16 p34 [   58.908698] ata9.00: 293046768 sectors, multi 16: LBA48 
> NCQ (depth 31/32) May 29 17:39:16 p34 [   58.911323] ata9.00: configured for 
> UDMA/100 May 29 17:39:16 p34 [   58.911545] scsi9 : sata_sil24 May 29 
> 17:39:17 p34 [   59.317958] ata10: SATA link up 1.5 Gbps (SStatus 113 
> SControl 300) May 29 17:39:17 p34 [   59.319759] ata10.00: ATA-7: WDC 
> WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 29 17:39:17 p34 [   59.319892] 
> ata10.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) May 29 
> 17:39:17 p34 [   59.322532] ata10.00: configured for UDMA/100 May 29 17:39:17 
> p34 [   59.323739] scsi 8:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 
> 20.0 PQ: 0 ANSI: 5 May 29 17:39:17 p34 [   59.325657] SCSI device sdi: 
> 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:17 p34 [ 
> 59.325964] sdi: Write Protect is off May 29 17:39:17 p34 [   59.326500] SCSI 
> device sdi: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:17 p34 [   59.327388] SCSI device sdi: 293046768 512-byte 
> hdwr sectors (150040 MB) May 29 17:39:17 p34 [   59.327707] sdi: Write 
> Protect is off May 29 17:39:17 p34 [   59.328203] SCSI device sdi: write 
> cache: enabled, read cache: enabled, doesn't support DPO or FUA May 29 
> 17:39:17 p34 [   59.328380]  sdi:
> May 29 17:39:17 p34  sdi1
> May 29 17:39:17 p34 May 29 17:39:17 p34 [   59.340639] sd 8:0:0:0: Attached 
> scsi disk sdi May 29 17:39:17 p34 [   59.342775] scsi 9:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:17 p34 [ 
> 59.344776] SCSI device sdj: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:17 p34 [   59.345103] sdj: Write Protect is off May 29 17:39:17 p34 
> [   59.345608] SCSI device sdj: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:17 p34 [   59.346489] SCSI device 
> sdj: 293046768 5
> May 29 17:39:17 p34 12-byte hdwr sectors (150040 MB) May 29 17:39:17 p34 [ 
> 59.346850] sdj: Write Protect is off May 29 17:39:17 p34 [   59.347393] SCSI 
> device sdj: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:17 p34 [   59.347552]  sdj:
> May 29 17:39:17 p34  sdj1
> May 29 17:39:17 p34 May 29 17:39:17 p34 [   59.362148] sd 9:0:0:0: Attached 
> scsi disk sdj May 29 17:39:17 p34 [   59.363387] ACPI: PCI Interrupt 
> 0000:05:00.0[A] -> May 29 17:39:17 p34 GSI 16 (level, low) -> IRQ 16 May 29 
> 17:39:17 p34 [   59.365179] ata11: SATA max UDMA/100 cmd 0xffffc20000118000 
> ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16 May 29 17:39:17 p34 [ 
> 59.367143] ata12: SATA max UDMA/100 cmd 0xffffc2000011a000 ctl 
> 0x0000000000000000 bmdma 0x0000000000000000 irq 16 May 29 17:39:17 p34 [ 
> 59.367432] scsi10 : sata_sil24 May 29 17:39:17 p34 [   59.775363] ata11: SATA 
> link up 1.5 Gbps (SStatus 113 SControl 300) May 29 17:39:17 p34 [ 
> 59.777435] ata11.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 
> 29 17:39:17 p34 [   59.777565] ata11.00: 293046768 sectors, multi 16: LBA48 
> NCQ (depth 31/32) May 29 17:39:17 p34 [   59.780599] ata11.00: configured for 
> UDMA/100 May 29 17:39:17 p34 [   59.780798] scsi11 : sata_sil24 May 29 
> 17:39:18 p34 [   60.187580] ata12: SATA link up 1.5 Gbps (SStatus 113 
> SControl 300) May 29 17:39:18 p34 [   60.189625] ata12.00: ATA-7: WDC 
> WD1500ADFD-00NLR1, 20.07P20, max UDMA/133 May 29 17:39:18 p34 [   60.189769] 
> ata12.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 31/32) May 29 
> 17:39:18 p34 [   60.192796] ata12.00: configured for UDMA/100 May 29 17:39:18 
> p34 [   60.193974] scsi 10:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 
> 20.0 PQ: 0 ANSI: 5 May 29 17:39:18 p34 [   60.195832] SCSI device sdk: 
> 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:18 p34 [ 
> 60.196127] sdk: Write Protect is off May 29 17:39:18 p34 [   60.196614] SCSI 
> device sdk: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:18 p34 [   60.197514] SCSI device sdk: 293046768 512-byte 
> hdwr sectors (150040 MB) May 29 17:39:18 p34 [   60.197845] sdk: Write 
> Protect is off May 29 17:39:18 p34 [   60.198333] SCSI device sdk: write 
> cache: enabled, read cache: enabled, doesn't support DPO or FUA May 29 
> 17:39:18 p34 [   60.198507]  sdk:
> May 29 17:39:18 p34  sdk1
> May 29 17:39:18 p34 May 29 17:39:18 p34 [   60.212748] sd 10:0:0:0: Attached 
> scsi disk sdk May 29 17:39:18 p34 [   60.214934] scsi 11:0:0:0: Direct-Access 
> ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5 May 29 17:39:18 p34 [ 
> 60.216923] SCSI device sdl: 293046768 512-byte hdwr sectors (150040 MB) May 
> 29 17:39:18 p34 [   60.217271] sdl: Write Protect is off May 29 17:39:18 p34 
> [   60.217774] SCSI device sdl: write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA May 29 17:39:18 p34 [   60.218665] SCSI device 
> sdl: 293046768 512-byte hdwr sectors (150040 MB) May 29 17:39:18 p34 [ 
> 60.218974] sdl: Write Protect is off May 29 17:39:18 p34 [   60.219497] SCSI 
> device sdl: write cache: enabled, read cache: enabled, doesn't support DPO or 
> FUA May 29 17:39:18 p34 [   60.219671]  sdl:
> May 29 17:39:18 p34  sdl1
> May 29 17:39:18 p34 May 29 17:39:18 p34 [   60.234367] sd 11:0:0:0: Attached 
> scsi disk sdl May 29 17:39:18 p34 [   60.236317] ACPI: PCI Interrupt 
> 0000:02:00.0[A] -> May 29 17:39:18 p34 GSI 17 (level, low) -> IRQ 17 May 29 
> 17:39:18 p34 [   60.237365] ata13: PATA max UDMA/100 cmd 0x0000000000015018 
> ctl 0x0000000000015026 bmdma 0x0000000000015000 irq 17 May 29 17:39:18 p34 [ 
> 60.237631] scsi12 : pata_marvell May 29 17:39:18 p34 [   60.239266] BAR5:
> May 29 17:39:18 p34 00:00 May 29 17:39:18 p34 01:7F May 29 17:39:18 p34 02:22 
> May 29 17:39:18 p34 03:CA May 29 17:39:18 p34 04:00 May 29 17:39:18 p34 05:00 
> May 29 17:39:18 p34 06:00 May 29 17:39:18 p34 07:00 May 29 17:39:18 p34 08:00 
> May 29 17:39:18 p34 09:00 May 29 17:39:18 p34 0A:00 May 29 17:39:18 p34 0B:00 
> May 29 17:39:18 p34 0C:01 May 29 17:39:18 p34 0D:00 May 29 17:39:18 p34 0E:00 
> May 29 17:39:18 p34 0F:00 May 29 17:39:18 p34 May 29 17:39:18 p34 [ 
> 60.545828] ata13.00: ATAPI, max UDMA/33 May 29 17:39:18 p34 [   60.701530] 
> ata13.00: configured for UDMA/33 May 29 17:39:18 p34 [   60.703942] scsi 
> 12:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5 May 
> 29 17:39:18 p34 [   60.711411] sr0: scsi3-mmc drive: 48x/48x writer cd/rw 
> xa/form2 cdda tray May 29 17:39:18 p34 [   60.711545] Uniform CD-ROM driver 
> Revision: 3.20 May 29 17:39:18 p34 [   60.714694] ACPI: PCI Interrupt 
> 0000:00:1a.7[C] -> May 29 17:39:18 p34 GSI 18 (level, low) -> IRQ 18 May 29 
> 17:39:18 p34 [   60.715083] ehci_hcd 0000:00:1a.7: EHCI Host Controller May 
> 29 17:39:18 p34 [   60.716069] ehci_hcd 0000:00:1a.7: new USB bus registered, 
> assigned bus number 1 May 29 17:39:18 p34 [   60.716562] ehci_hcd 
> 0000:00:1a.7: debug port 1 May 29 17:39:18 p34 [   60.716810] ehci_hcd 
> 0000:00:1a.7: irq 18, io mem 0xe0625c00 May 29 17:39:18 p34 [   60.720814] 
> ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 May 29 
> 17:39:18 p34 [   60.723647] usb usb1: configuration #1 chosen from 1 choice 
> May 29 17:39:18 p34 [   60.724706] hub 1-0:1.0: USB hub found May 29 17:39:18 
> p34 [   60.724901] hub 1-0:1.0: 4 ports detected May 29 17:39:18 p34 [ 
> 60.829165] ACPI: PCI Interrupt 0000:00:1d.7[A] -> May 29 17:39:18 p34 GSI 23 
> (level, low) -> IRQ 23 May 29 17:39:18 p34 [   60.829583] ehci_hcd 
> 0000:00:1d.7: EHCI Host Controller May 29 17:39:18 p34 [   60.830451] 
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2 May 29 
> 17:39:18 p34 [   60.830986] ehci_hcd 0000:00:1d.7: debug port 1 May 29 
> 17:39:18 p34 [   60.831229] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0625800 
> May 29 17:39:18 p34 [   60.835261] ehci_hcd 0000:00:1d.7: USB 2.0 started, 
> EHCI 1.00, driver 10 Dec 2004 May 29 17:39:18 p34 [   60.837971] usb usb2: 
> configuration #1 chosen from 1 choice May 29 17:39:18 p34 [   60.839024] hub 
> 2-0:1.0: USB hub found May 29 17:39:18 p34 [   60.839241] hub 2-0:1.0: 6 
> ports detected May 29 17:39:19 p34 [   60.942849] USB Universal Host 
> Controller Interface driver v3.0 May 29 17:39:19 p34 [   60.943912] ACPI: PCI 
> Interrupt 0000:00:1a.0[A] -> May 29 17:39:19 p34 GSI 16 (level, low) -> IRQ 
> 16 May 29 17:39:19 p34 [   60.944250] uhci_hcd 0000:00:1a.0: UHCI Host 
> Controller May 29 17:39:19 p34 [   60.945081] uhci_hcd 0000:00:1a.0: new USB 
> bus registered, assigned bus number 3 May 29 17:39:19 p34 [   60.945338] 
> uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0 May 29 17:39:19 p34 [ 
> 60.948562] usb usb3: configuration #1 chosen from 1 choice May 29 17:39:19 
> p34 [   60.949639] hub 3-0:1.0: USB hub found May 29 17:39:19 p34 [ 
> 60.949832] hub 3-0:1.0: 2 ports detected May 29 17:39:19 p34 [   61.053768] 
> ACPI: PCI Interrupt 0000:00:1a.1[B] -> May 29 17:39:19 p34 GSI 21 (level, 
> low) -> IRQ 21 May 29 17:39:19 p34 [   61.054098] uhci_hcd 0000:00:1a.1: UHCI 
> Host Controller May 29 17:39:19 p34 [   61.054937] uhci_hcd 0000:00:1a.1: new 
> USB bus registered, assigned bus number 4 May 29 17:39:19 p34 [   61.055187] 
> uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0 May 29 17:39:19 p34 [ 
> 61.058179] usb usb4: configuration #1 chosen from 1 choice May 29 17:39:19 
> p34 [   61.059320] hub 4-0:1.0: USB hub found May 29 17:39:19 p34 [ 
> 61.059500] hub 4-0:1.0: 2 ports detected May 29 17:39:19 p34 [   61.162594] 
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> May 29 17:39:19 p34 GSI 23 (level, 
> low) -> IRQ 23 May 29 17:39:19 p34 [   61.162944] uhci_hcd 0000:00:1d.0: UHCI 
> Host Controller May 29 17:39:19 p34 [   61.163751] uhci_hcd 0000:00:1d.0: new 
> USB bus registered, assigned bus number 5 May 29 17:39:19 p34 [   61.164039] 
> uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080 May 29 17:39:19 p34 [ 
> 61.166996] usb usb5: configuration #1 chosen from 1 choice May 29 17:39:19 
> p34 [   61.168132] hub 5-0:1.0: USB hub found May 29 17:39:19 p34 [ 
> 61.168320] hub 5-0:1.0: 2 ports detected May 29 17:39:19 p34 [   61.271253] 
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> May 29 17:39:19 p34 GSI 19 (level, 
> low) -> IRQ 19 May 29 17:39:19 p34 [   61.271587] uhci_hcd 0000:00:1d.1: UHCI 
> Host Controller May 29 17:39:19 p34 [   61.272501] uhci_hcd 0000:00:1d.1: new 
> USB bus registered, assigned bus number 6 May 29 17:39:19 p34 [   61.272757] 
> uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060 May 29 17:39:19 p34 [ 
> 61.275754] usb usb6: configuration #1 chosen from 1 choice May 29 17:39:19 
> p34 [   61.276869] hub 6-0:1.0: USB hub found May 29 17:39:19 p34 [ 
> 61.277042] hub 6-0:1.0: 2 ports detected May 29 17:39:19 p34 [   61.379999] 
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> May 29 17:39:19 p34 GSI 18 (level, 
> low) -> IRQ 18 May 29 17:39:19 p34 [   61.380331] uhci_hcd 0000:00:1d.2: UHCI 
> Host Controller May 29 17:39:19 p34 [   61.381211] uhci_hcd 0000:00:1d.2: new 
> USB bus registered, assigned bus number 7 May 29 17:39:19 p34 [   61.381464] 
> uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040 May 29 17:39:19 p34 [ 
> 61.385027] usb usb7: configuration #1 chosen from 1 choice May 29 17:39:19 
> p34 [   61.386139] hub 7-0:1.0: USB hub found May 29 17:39:19 p34 [ 
> 61.386313] hub 7-0:1.0: 2 ports detected May 29 17:39:19 p34 [   61.477697] 
> usb 5-1: new low speed USB device using uhci_hcd and address 2 May 29 
> 17:39:19 p34 [   61.489915] Initializing USB Mass Storage driver... May 29 
> 17:39:19 p34 [   61.641966] usb 5-1: configuration #1 chosen from 1 choice 
> May 29 17:39:19 p34 [   61.647974] usbcore: registered new interface driver 
> usb-storage May 29 17:39:19 p34 [   61.648124] USB Mass Storage support 
> registered. May 29 17:39:19 p34 [   61.649681] usbcore: registered new 
> interface driver hiddev May 29 17:39:20 p34 [   62.146211] May 29 17:39:20 
> p34 hiddev96
> May 29 17:39:20 p34 : USB HID v1.00 Device [        UPS] on 
> usb-0000:00:1d.0-1 May 29 17:39:20 p34 [   62.146611] usbcore: registered new 
> interface driver usbhid May 29 17:39:20 p34 [   62.146747] 
> drivers/usb/input/hid-core.c: v2.6:USB HID core driver May 29 17:39:20 p34 [ 
> 62.148329] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 
> 1,12 May 29 17:39:20 p34 [   62.152574] serio: i8042 KBD port at 0x60,0x64 
> irq 1 May 29 17:39:20 p34 [   62.152739] serio: i8042 AUX port at 0x60,0x64 
> irq 12 May 29 17:39:20 p34 [   62.153709] mice: PS/2 mouse device common for 
> all mice May 29 17:39:20 p34 [   62.157353] input: PC Speaker as 
> /class/input/input0 May 29 17:39:20 p34 [   62.157569] i2c /dev entries 
> driver May 29 17:39:20 p34 [   62.158424] md: raid1 personality registered 
> for level 1 May 29 17:39:20 p34 [   62.174745] raid6: int64x1     62 MB/s May 
> 29 17:39:20 p34 [   62.178692] input: AT Translated Set 2 keyboard as 
> /class/input/input1 May 29 17:39:20 p34 [   62.192019] raid6: int64x2     89 
> MB/s May 29 17:39:20 p34 [   62.209023] raid6: int64x4     31 MB/s May 29 
> 17:39:20 p34 [   62.225777] raid6: int64x8     11 MB/s May 29 17:39:20 p34 [ 
> 62.242854] raid6: sse2x1     148 MB/s May 29 17:39:20 p34 [   62.259636] 
> raid6: sse2x2     269 MB/s May 29 17:39:20 p34 [   62.276650] raid6: sse2x4 
> 460 MB/s May 29 17:39:20 p34 [   62.276789] raid6: using algorithm sse2x4 
> (460 MB/s) May 29 17:39:20 p34 [   62.276937] md: raid6 personality 
> registered for level 6 May 29 17:39:20 p34 [   62.277053] md: raid5 
> personality registered for level 5 May 29 17:39:20 p34 [   62.277191] md: 
> raid4 personality registered for level 4 May 29 17:39:20 p34 [   62.277346] 
> raid5: automatically using best checksumming function: generic_sse May 29 
> 17:39:20 p34 [   62.281657]    generic_sse:    56.000 MB/sec May 29 17:39:20 
> p34 [   62.281777] raid5: using function: generic_sse (56.000 MB/sec) May 29 
> 17:39:20 p34 [   62.282244] Advanced Linux Sound Architecture Driver Version 
> 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC). May 29 17:39:20 p34 [   62.288220] 
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> May 29 17:39:20 p34 GSI 22 (level, 
> low) -> IRQ 22 May 29 17:39:20 p34 [   62.839554] input: ImPS/2 Generic Wheel 
> Mouse as /class/input/input2 May 29 17:39:21 p34 [   63.412487] hda_intel: 
> azx_get_response timeout, switching to polling mode... May 29 17:39:21 p34 [ 
> 63.435772] ALSA device list: May 29 17:39:21 p34 [   63.435876]   #0: HDA 
> Intel at 0xe0620000 irq 22 May 29 17:39:21 p34 [   63.436031] u32 classifier 
> May 29 17:39:21 p34 [   63.436148]     Actions configured May 29 17:39:21 p34 
> [   63.436279] nf_conntrack version 0.5.0 (8192 buckets, 65536 max) May 29 
> 17:39:21 p34 [   63.438882] ip_tables: (C) 2000-2006 Netfilter Core Team May 
> 29 17:39:21 p34 [   63.439995] TCP cubic registered May 29 17:39:21 p34 [ 
> 63.440386] NET: Registered protocol family 1 May 29 17:39:21 p34 [ 
> 63.440507] NET: Registered protocol family 17 May 29 17:39:21 p34 [ 
> 63.445397] md: Autodetecting RAID arrays. May 29 17:39:21 p34 [   63.572955] 
> md: autorun ... May 29 17:39:21 p34 [   63.573095] md: considering sdl1 ... 
> May 29 17:39:21 p34 [   63.573596] md:  adding sdl1 ... May 29 17:39:21 p34 [ 
> 63.573924] md:  adding sdk1 ... May 29 17:39:21 p34 [   63.574312] md: 
> adding sdj1 ... May 29 17:39:21 p34 [   63.574664] md:  adding sdi1 ... May 
> 29 17:39:21 p34 [   63.575005] md:  adding sdh1 ... May 29 17:39:21 p34 [ 
> 63.575396] md:  adding sdg1 ... May 29 17:39:21 p34 [   63.575754] md: 
> adding sdf1 ... May 29 17:39:21 p34 [   63.576089] md:  adding sde1 ... May 
> 29 17:39:21 p34 [   63.576472] md:  adding sdd1 ... May 29 17:39:21 p34 [ 
> 63.576824] md:  adding sdc1 ... May 29 17:39:21 p34 [   63.577015] md: sdb3 
> has different UUID to sdl1 May 29 17:39:21 p34 [   63.577204] md: sdb2 has 
> different UUID to sdl1 May 29 17:39:21 p34 [   63.577446] md: sdb1 has 
> different UUID to sdl1 May 29 17:39:21 p34 [   63.577647] md: sda3 has 
> different UUID to sdl1 May 29 17:39:21 p34 [   63.577846] md: sda2 has 
> different UUID to sdl1 May 29 17:39:21 p34 [   63.578043] md: sda1 has 
> different UUID to sdl1 May 29 17:39:21 p34 [   63.579527] md: created md3 May 
> 29 17:39:21 p34 [   63.579639] md: bind<sdc1> May 29 17:39:21 p34 [ 
> 63.579956] md: bind<sdd1> May 29 17:39:21 p34 [   63.580329] md: bind<sde1> 
> May 29 17:39:21 p34 [   63.580627] md: bind<sdf1> May 29 17:39:21 p34 [ 
> 63.580933] md: bind<sdg1> May 29 17:39:21 p34 [   63.581229] md: bind<sdh1> 
> May 29 17:39:21 p34 [   63.581624] md: bind<sdi1> May 29 17:39:21 p34 [ 
> 63.582103] md: bind<sdj1> May 29 17:39:21 p34 [   63.582436] md: bind<sdk1> 
> May 29 17:39:21 p34 [   63.582776] md: bind<sdl1> May 29 17:39:21 p34 [ 
> 63.583100] md: running: May 29 17:39:21 p34 May 29 17:39:21 p34 [ 
> 63.586384] raid5: device sdl1 operational as raid disk 2 May 29 17:39:21 p34 
> [   63.586509] raid5: device sdk1 operational as raid disk 3 May 29 17:39:21 
> p34 [   63.586656] raid5: device sdj1 operational as raid disk 0 May 29 
> 17:39:21 p34 [   63.586829] raid5: device sdi1 operational as raid disk 1 May 
> 29 17:39:21 p34 [   63.586973] raid5: device sdh1 operational as raid disk 6 
> May 29 17:39:21 p34 [   63.587122] raid5: device sdg1 operational as raid 
> disk 5 May 29 17:39:21 p34 [   63.587317] raid5: device sdf1 operational as 
> raid disk 4 May 29 17:39:21 p34 [   63.587459] raid5: device sde1 operational 
> as raid disk 7 May 29 17:39:21 p34 [   63.587603] raid5: device sdd1 
> operational as raid disk 8 May 29 17:39:21 p34 [   63.587758] raid5: device 
> sdc1 operational as raid disk 9 May 29 17:39:21 p34 [   63.608186] raid5: 
> allocated 10562kB for md3 May 29 17:39:21 p34 [   63.608334] raid5: raid 
> level 5 set md3 active with 10 out of 10 devices, algorithm 2 May 29 17:39:21 
> p34 [   63.608519] RAID5 conf printout: May 29 17:39:21 p34 [   63.608639] 
> --- rd:10 wd:10 May 29 17:39:21 p34 [   63.608767]  disk 0, o:1, dev:sdj1 May 
> 29 17:39:21 p34 [   63.608897]  disk 1, o:1, dev:sdi1 May 29 17:39:21 p34 [ 
> 63.609073]  disk 2, o:1, dev:sdl1 May 29 17:39:21 p34 [   63.609184]  disk 3, 
> o:1, dev:sdk1 May 29 17:39:21 p34 [   63.609346]  disk 4, o:1, dev:sdf1 May 
> 29 17:39:21 p34 [   63.609507]  disk 5, o:1, dev:sdg1 May 29 17:39:21 p34 [ 
> 63.609640]  disk 6, o:1, dev:sdh1 May 29 17:39:21 p34 [   63.609771]  disk 7, 
> o:1, dev:sde1 May 29 17:39:21 p34 [   63.609903]  disk 8, o:1, dev:sdd1 May 
> 29 17:39:21 p34 [   63.610040]  disk 9, o:1, dev:sdc1 May 29 17:39:21 p34 [ 
> 63.612460] md: considering sdb3 ... May 29 17:39:21 p34 [   63.612835] md: 
> adding sdb3 ... May 29 17:39:21 p34 [   63.613027] md: sdb2 has different 
> UUID to sdb3 May 29 17:39:21 p34 [   63.613220] md: sdb1 has different UUID 
> to sdb3 May 29 17:39:21 p34 [   63.613589] md:  adding sda3 ... May 29 
> 17:39:21 p34 [   63.613801] md: sda2 has different UUID to sdb3 May 29 
> 17:39:21 p34 [   63.613997] md: sda1 has different UUID to sdb3 May 29 
> 17:39:21 p34 [   63.615606] md: created md2 May 29 17:39:21 p34 [ 
> 63.615720] md: bind<sda3> May 29 17:39:21 p34 [   63.616094] md: bind<sdb3> 
> May 29 17:39:21 p34 [   63.616575] md: running: May 29 17:39:21 p34 May 29 
> 17:39:21 p34 [   63.619316] raid1: raid set md2 active with 2 out of 2 
> mirrors May 29 17:39:21 p34 [   63.620513] md: considering sdb2 ... May 29 
> 17:39:21 p34 [   63.620870] md:  adding sdb2 ... May 29 17:39:21 p34 [ 
> 63.621082] md: sdb1 has different UUID to sdb2 May 29 17:39:21 p34 [ 
> 63.621465] md:  adding sda2 ... May 29 17:39:21 p34 [   63.621646] md: sda1 
> has different UUID to sdb2 May 29 17:39:21 p34 [   63.623619] md: created md1 
> May 29 17:39:21 p34 [   63.623733] md: bind<sda2> May 29 17:39:21 p34 [ 
> 63.624059] md: bind<sdb2> May 29 17:39:21 p34 [   63.624439] md: running: May 
> 29 17:39:21 p34 May 29 17:39:21 p34 [   63.627438] raid1: raid set md1 active 
> with 2 out of 2 mirrors May 29 17:39:21 p34 [   63.628555] md: considering 
> sdb1 ... May 29 17:39:21 p34 [   63.628883] md:  adding sdb1 ... May 29 
> 17:39:21 p34 [   63.629302] md:  adding sda1 ... May 29 17:39:21 p34 [ 
> 63.629411] md: created md0 May 29 17:39:21 p34 [   63.629576] md: bind<sda1> 
> May 29 17:39:21 p34 [   63.629882] md: bind<sdb1> May 29 17:39:21 p34 [ 
> 63.630233] md: running: May 29 17:39:21 p34 May 29 17:39:21 p34 [ 
> 63.633438] raid1: raid set md0 active with 2 out of 2 mirrors May 29 17:39:21 
> p34 [   63.634598] md: ... autorun DONE. May 29 17:39:21 p34 [   63.695456] 
> UDF-fs: No VRS found May 29 17:39:21 p34 [   63.699158] Filesystem "md2": 
> Disabling barriers, not supported by the underlying device May 29 17:39:21 
> p34 [   63.713776] XFS mounting filesystem md2 May 29 17:39:21 p34 [ 
> 63.813743] VFS: Mounted root (xfs filesystem) readonly. May 29 17:39:21 p34 [ 
> 63.814115] Freeing unused kernel memory: 220k freed May 29 17:40:39 p34 [ 
> 141.447304] Adding 16787768k swap on /dev/md0.  Priority:-1 extents:1 
> across:16787768k May 29 17:40:40 p34 [  142.497721] Filesystem "md2": 
> Disabling barriers, not supported by the underlying device May 29 17:41:04 
> p34 [  166.716017] kjournald starting.  Commit interval 5 seconds May 29 
> 17:41:04 p34 [  166.729375] EXT3 FS on md1, May 29 17:41:04 p34 internal 
> journal May 29 17:41:04 p34 [  166.729663] EXT3-fs: mounted filesystem with 
> ordered data mode. May 29 17:41:04 p34 [  166.751799] Filesystem "md3": 
> Disabling barriers, not supported by the underlying device May 29 17:41:04 
> p34 [  166.758717] XFS mounting filesystem md3 May 29 17:41:54 p34 [ 
> 216.821357] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, 
> Flow Control: RX May 29 17:42:29 p34 [  251.481399] process `syslogd' is 
> using obsolete setsockopt SO_BSDCOMPAT May 29 17:46:42 p34 [  504.074171] 
> mtrr: no more MTRRs available
>
---1463747160-925635164-1180535762=:13945
Content-Type: TEXT/plain; charset=US-ASCII; name=full-dmesg.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0705301036020.13945@p34.internal.lan>
Content-Description: 
Content-Disposition: attachment; filename=full-dmesg.txt

TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBMaW51eCB2ZXJz
aW9uIDIuNi4yMS4zIChyb290QHAzNC5pbnRlcm5hbC5sYW4pIChnY2MgdmVy
c2lvbiA0LjEuMiAyMDA2MTExNSAocHJlcmVsZWFzZSkgKERlYmlhbiA0LjEu
MS0yMSkpICM0IFNNUCBTdW4gTWF5IDI3IDA2OjI4OjMzIEVEVCAyMDA3IA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBDb21tYW5kIGxp
bmU6IGF1dG8gQk9PVF9JTUFHRT0yLjYuMjEuMy00IHJvIHJvb3Q9OTAyIG5l
dGNvbnNvbGU9NDQ0NEAxOTIuMTY4LjE2OC4yNTMvZXRoMCw1MTRAMTkyLjE2
OC4xNjguMjU0LzAwOjUwOjhEOkVEOjNDOkU3IG5taV93YXRjaGRvZz0xIA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBCSU9TLXByb3Zp
ZGVkIHBoeXNpY2FsIFJBTSBtYXA6IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBb
ICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMDAwMDAwMDAwIC0g
MDAwMDAwMDAwMDA4ZjAwMCAodXNhYmxlKSANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDAwMDA4ZjAw
MCAtIDAwMDAwMDAwMDAwYTAwMDAgKHJlc2VydmVkKSANCk1heSAyOSAxNzoz
OToxMSBwMzQgWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDAw
MDBlMDAwMCAtIDAwMDAwMDAwMDAxMDAwMDAgKHJlc2VydmVkKSANCk1heSAy
OSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAw
MDAwMDAwMDEwMDAwMCAtIDAwMDAwMDAwY2Y1OGYwMDAgKHVzYWJsZSkgDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6
IDAwMDAwMDAwY2Y1OGYwMDAgLSAwMDAwMDAwMGNmNTljMDAwIChyZXNlcnZl
ZCkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICBCSU9T
LWU4MjA6IDAwMDAwMDAwY2Y1OWMwMDAgLSAwMDAwMDAwMGNmNjUzMDAwICh1
c2FibGUpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSAg
QklPUy1lODIwOiAwMDAwMDAwMGNmNjUzMDAwIC0gMDAwMDAwMDBjZjZhNTAw
MCAoQUNQSSBOVlMpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAw
MDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGNmNmE1MDAwIC0gMDAwMDAwMDBj
ZjZhODAwMCAoQUNQSSBkYXRhKSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAg
ICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDBjZjZhODAwMCAtIDAw
MDAwMDAwY2Y2ZWYwMDAgKEFDUEkgTlZTKSANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDBjZjZlZjAw
MCAtIDAwMDAwMDAwY2Y2ZjEwMDAgKEFDUEkgZGF0YSkgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAw
Y2Y2ZjEwMDAgLSAwMDAwMDAwMGNmNmYyMDAwICh1c2FibGUpIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAw
MDAwMGNmNmYyMDAwIC0gMDAwMDAwMDBjZjZmZjAwMCAoQUNQSSBkYXRhKSAN
Ck1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgy
MDogMDAwMDAwMDBjZjZmZjAwMCAtIDAwMDAwMDAwY2Y3MDAwMDAgKHVzYWJs
ZSkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICBCSU9T
LWU4MjA6IDAwMDAwMDAwY2Y3MDAwMDAgLSAwMDAwMDAwMGQwMDAwMDAwIChy
ZXNlcnZlZCkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBd
ICBCSU9TLWU4MjA6IDAwMDAwMDAwZmZmMDAwMDAgLSAwMDAwMDAwMTAwMDAw
MDAwIChyZXNlcnZlZCkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4w
MDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAxMDAwMDAwMDAgLSAwMDAwMDAw
MjJjMDAwMDAwICh1c2FibGUpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
IDAuMDAwMDAwXSBlbmRfcGZuX21hcCA9IDIyNzczNzYgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIERNSSAyLjQgcHJlc2VudC4gDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IFJTRFAg
MDAwRkUwMjAsIDAwMTQgKHIwIElOVEVMICkgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IFJTRFQgQ0Y2RkQwMzgsIDAwNTAg
KHIxIElOVEVMICBERzk2NVdIICAgICAgIDY0QyAgICAgICAxMDAwMDEzKSAN
Ck1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gQUNQSTogRkFD
UCBDRjZGQzAwMCwgMDA3NCAocjEgSU5URUwgIERHOTY1V0ggICAgICAgNjRD
IE1TRlQgIDEwMDAwMTMpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAu
MDAwMDAwXSBBQ1BJOiBEU0RUIENGNkY3MDAwLCA0MEU5IChyMSBJTlRFTCAg
REc5NjVXSCAgICAgICA2NEMgTVNGVCAgMTAwMDAxMykgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IEZBQ1MgQ0Y2QTgwMDAs
IDAwNDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFD
UEk6IEFQSUMgQ0Y2RjYwMDAsIDAwNzggKHIxIElOVEVMICBERzk2NVdIICAg
ICAgIDY0QyBNU0ZUICAxMDAwMDEzKSANCk1heSAyOSAxNzozOToxMSBwMzQg
WyAgICAwLjAwMDAwMF0gQUNQSTogV0REVCBDRjZGNTAwMCwgMDA0MCAocjEg
SU5URUwgIERHOTY1V0ggICAgICAgNjRDIE1TRlQgIDEwMDAwMTMpIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBBQ1BJOiBNQ0ZHIENG
NkY0MDAwLCAwMDNDIChyMSBJTlRFTCAgREc5NjVXSCAgICAgICA2NEMgTVNG
VCAgMTAwMDAxMykgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAw
MDBdIEFDUEk6IEFTRiEgQ0Y2RjMwMDAsIDAwQTYgKHIzMiBJTlRFTCAgREc5
NjVXSCAgICAgICA2NEMgTVNGVCAgMTAwMDAxMykgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IEhQRVQgQ0Y2RjIwMDAsIDAw
MzggKHIxIElOVEVMICBERzk2NVdIICAgICAgIDY0QyBNU0ZUICAxMDAwMDEz
KSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gQUNQSTog
U1NEVCBDRjZGMDAwMCwgMDFCQyAocjEgSU5URUwgICAgIENwdVBtICAgICAg
NjRDIE1TRlQgIDEwMDAwMTMpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
IDAuMDAwMDAwXSBBQ1BJOiBTU0RUIENGNkVGMDAwLCAwMTc1IChyMSBJTlRF
TCAgIENwdTBJc3QgICAgICA2NEMgTVNGVCAgMTAwMDAxMykgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IFNTRFQgQ0Y2QTcw
MDAsIDAxNzUgKHIxIElOVEVMICAgQ3B1MUlzdCAgICAgIDY0QyBNU0ZUICAx
MDAwMDEzKSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0g
QUNQSTogU1NEVCBDRjZBNjAwMCwgMDE3NSAocjEgSU5URUwgICBDcHUySXN0
ICAgICAgNjRDIE1TRlQgIDEwMDAwMTMpIA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgIDAuMDAwMDAwXSBBQ1BJOiBTU0RUIENGNkE1MDAwLCAwMTc1IChy
MSBJTlRFTCAgIENwdTNJc3QgICAgICA2NEMgTVNGVCAgMTAwMDAxMykgDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIFpvbmUgUEZOIHJh
bmdlczogDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICAg
RE1BICAgICAgICAgICAgIDAgLT4gICAgIDQwOTYgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICAgMC4wMDAwMDBdICAgRE1BMzIgICAgICAgIDQwOTYgLT4g
IDEwNDg1NzYgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBd
ICAgTm9ybWFsICAgIDEwNDg1NzYgLT4gIDIyNzczNzYgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIGVhcmx5X25vZGVfbWFwWzZdIGFj
dGl2ZSBQRk4gcmFuZ2VzIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAu
MDAwMDAwXSAgICAgMDogICAgICAgIDAgLT4gICAgICAxNDMgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICAgICAwOiAgICAgIDI1NiAt
PiAgIDg0OTI5NSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAw
MF0gICAgIDA6ICAgODQ5MzA4IC0+ICAgODQ5NDkxIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgIDAuMDAwMDAwXSAgICAgMDogICA4NDk2NDkgLT4gICA4
NDk2NTAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdICAg
ICAwOiAgIDg0OTY2MyAtPiAgIDg0OTY2NCANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgICAwLjAwMDAwMF0gICAgIDA6ICAxMDQ4NTc2IC0+ICAyMjc3Mzc2
IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBBQ1BJOiBQ
TS1UaW1lciBJTyBQb3J0OiAweDQwOCANCk1heSAyOSAxNzozOToxMSBwMzQg
WyAgICAwLjAwMDAwMF0gQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwMV0gbGFw
aWNfaWRbMHgwMF0gZW5hYmxlZCkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsg
ICAgMC4wMDAwMDBdIFByb2Nlc3NvciAjMCAoQm9vdHVwLUNQVSkgDQpNYXkg
MjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChh
Y3BpX2lkWzB4MDNdIGxhcGljX2lkWzB4MDJdIGVuYWJsZWQpIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBQcm9jZXNzb3IgIzIgDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElD
IChhY3BpX2lkWzB4MDJdIGxhcGljX2lkWzB4MDFdIGVuYWJsZWQpIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBQcm9jZXNzb3IgIzEg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IExB
UElDIChhY3BpX2lkWzB4MDRdIGxhcGljX2lkWzB4MDNdIGVuYWJsZWQpIA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBQcm9jZXNzb3Ig
IzMgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6
IExBUElDX05NSSAoYWNwaV9pZFsweDAxXSBkZmwgZGZsIGxpbnRbMHgxXSkg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IExB
UElDX05NSSAoYWNwaV9pZFsweDAyXSBkZmwgZGZsIGxpbnRbMHgxXSkgDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IElPQVBJ
QyAoaWRbMHgwMl0gYWRkcmVzc1sweGZlYzAwMDAwXSBnc2lfYmFzZVswXSkg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIElPQVBJQ1sw
XTogYXBpY19pZCAyLCBhZGRyZXNzIDB4ZmVjMDAwMDAsIEdTSSAwLTIzIA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBBQ1BJOiBJTlRf
U1JDX09WUiAoYnVzIDAgYnVzX2lycSAwIGdsb2JhbF9pcnEgMiBkZmwgZGZs
KSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gQUNQSTog
SU5UX1NSQ19PVlIgKGJ1cyAwIGJ1c19pcnEgOSBnbG9iYWxfaXJxIDkgaGln
aCBsZXZlbCkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBd
IFNldHRpbmcgQVBJQyByb3V0aW5nIHRvIGZsYXQgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICAgMC4wMDAwMDBdIEFDUEk6IEhQRVQgaWQ6IDB4ODA4NmEy
MDEgYmFzZTogMHhmZWQwMDAwMCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAg
ICAwLjAwMDAwMF0gVXNpbmcgQUNQSSAoTUFEVCkgZm9yIFNNUCBjb25maWd1
cmF0aW9uIGluZm9ybWF0aW9uIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
IDAuMDAwMDAwXSBOb3NhdmUgYWRkcmVzcyByYW5nZTogMDAwMDAwMDAwMDA4
ZjAwMCAtIDAwMDAwMDAwMDAwYTAwMDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICAgMC4wMDAwMDBdIE5vc2F2ZSBhZGRyZXNzIHJhbmdlOiAwMDAwMDAw
MDAwMGEwMDAwIC0gMDAwMDAwMDAwMDBlMDAwMCANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgICAwLjAwMDAwMF0gTm9zYXZlIGFkZHJlc3MgcmFuZ2U6IDAw
MDAwMDAwMDAwZTAwMDAgLSAwMDAwMDAwMDAwMTAwMDAwIA0KTWF5IDI5IDE3
OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBOb3NhdmUgYWRkcmVzcyByYW5n
ZTogMDAwMDAwMDBjZjU4ZjAwMCAtIDAwMDAwMDAwY2Y1OWMwMDAgDQpNYXkg
MjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIE5vc2F2ZSBhZGRyZXNz
IHJhbmdlOiAwMDAwMDAwMGNmNjUzMDAwIC0gMDAwMDAwMDBjZjZhNTAwMCAN
Ck1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gTm9zYXZlIGFk
ZHJlc3MgcmFuZ2U6IDAwMDAwMDAwY2Y2YTUwMDAgLSAwMDAwMDAwMGNmNmE4
MDAwIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBOb3Nh
dmUgYWRkcmVzcyByYW5nZTogMDAwMDAwMDBjZjZhODAwMCAtIDAwMDAwMDAw
Y2Y2ZWYwMDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBd
IE5vc2F2ZSBhZGRyZXNzIHJhbmdlOiAwMDAwMDAwMGNmNmVmMDAwIC0gMDAw
MDAwMDBjZjZmMTAwMCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAw
MDAwMF0gTm9zYXZlIGFkZHJlc3MgcmFuZ2U6IDAwMDAwMDAwY2Y2ZjIwMDAg
LSAwMDAwMDAwMGNmNmZmMDAwIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
IDAuMDAwMDAwXSBOb3NhdmUgYWRkcmVzcyByYW5nZTogMDAwMDAwMDBjZjcw
MDAwMCAtIDAwMDAwMDAwZDAwMDAwMDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICAgMC4wMDAwMDBdIE5vc2F2ZSBhZGRyZXNzIHJhbmdlOiAwMDAwMDAw
MGQwMDAwMDAwIC0gMDAwMDAwMDBmZmYwMDAwMCANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgICAwLjAwMDAwMF0gTm9zYXZlIGFkZHJlc3MgcmFuZ2U6IDAw
MDAwMDAwZmZmMDAwMDAgLSAwMDAwMDAwMTAwMDAwMDAwIA0KTWF5IDI5IDE3
OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBBbGxvY2F0aW5nIFBDSSByZXNv
dXJjZXMgc3RhcnRpbmcgYXQgZDQwMDAwMDAgKGdhcDogZDAwMDAwMDA6MmZm
MDAwMDApIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBQ
RVJDUFU6IEFsbG9jYXRpbmcgMjQ1MTIgYnl0ZXMgb2YgcGVyIGNwdSBkYXRh
IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBCdWlsdCAx
IHpvbmVsaXN0cy4gIFRvdGFsIHBhZ2VzOiAyMDQ1NjkyIA0KTWF5IDI5IDE3
OjM5OjExIHAzNCBbICAgIDAuMDAwMDAwXSBLZXJuZWwgY29tbWFuZCBsaW5l
OiBhdXRvIEJPT1RfSU1BR0U9Mi42LjIxLjMtNCBybyByb290PTkwMiBuZXRj
b25zb2xlPTQ0NDRAMTkyLjE2OC4xNjguMjUzL2V0aDAsNTE0QDE5Mi4xNjgu
MTY4LjI1NC8wMDo1MDo4RDpFRDozQzpFNyBubWlfd2F0Y2hkb2c9MSANCk1h
eSAyOSAxNzozOToxMSBwMzQgWyAgICAwLjAwMDAwMF0gbmV0Y29uc29sZTog
bG9jYWwgcG9ydCA0NDQ0IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgIDAu
MDAwMDAwXSBuZXRjb25zb2xlOiBsb2NhbCBJUCAxOTIuMTY4LjE2OC4yNTMg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIG5ldGNvbnNv
bGU6IGludGVyZmFjZSBldGgwIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
IDAuMDAwMDAwXSBuZXRjb25zb2xlOiByZW1vdGUgcG9ydCA1MTQgDQpNYXkg
MjkgMTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIG5ldGNvbnNvbGU6IHJl
bW90ZSBJUCAxOTIuMTY4LjE2OC4yNTQgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICAgMC4wMDAwMDBdIG5ldGNvbnNvbGU6IHJlbW90ZSBldGhlcm5ldCBh
ZGRyZXNzIDAwOjUwOjhkOmVkOjNjOmU3IA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgIDAuMDAwMDAwXSBJbml0aWFsaXppbmcgQ1BVIzAgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICAgMC4wMDAwMDBdIFBJRCBoYXNoIHRhYmxlIGVu
dHJpZXM6IDQwOTYgKG9yZGVyOiAxMiwgMzI3NjggYnl0ZXMpIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNDguMjQ5NTA3XSB0aW1lLmM6IERldGVjdGVk
IDIzOTcuNjA1IE1IeiBwcm9jZXNzb3IuIA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgNDguMjUwNTcyXSBDb25zb2xlOiBjb2xvdXIgVkdBKyA4MHgyNSAN
Ck1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjI1ODY1MV0gRGVudHJ5IGNh
Y2hlIGhhc2ggdGFibGUgZW50cmllczogMTA0ODU3NiAob3JkZXI6IDExLCA4
Mzg4NjA4IGJ5dGVzKSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjI2
NDg1NV0gSW5vZGUtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiA1MjQyODgg
KG9yZGVyOiAxMCwgNDE5NDMwNCBieXRlcykgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA0OC4yNjU5NjNdIENoZWNraW5nIGFwZXJ0dXJlLi4uIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNDguMjY2MDExXSBQQ0ktRE1BOiBVc2lu
ZyBzb2Z0d2FyZSBib3VuY2UgYnVmZmVyaW5nIGZvciBJTyAoU1dJT1RMQikg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC4zMDIyMzNdIFBsYWNpbmcg
c29mdHdhcmUgSU8gVExCIGJldHdlZW4gMHg5NWY2MDAwIC0gMHhkNWY2MDAw
IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguMzc0MDYxXSBNZW1vcnk6
IDgxMDM3NDhrLzkxMDk1MDRrIGF2YWlsYWJsZSAoMzQyOGsga2VybmVsIGNv
ZGUsIDIwODQ2NGsgcmVzZXJ2ZWQsIDEyNzBrIGRhdGEsIDIyMGsgaW5pdCkg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC40MzQ3NTZdIENhbGlicmF0
aW5nIGRlbGF5IHVzaW5nIHRpbWVyIHNwZWNpZmljIHJvdXRpbmUuLiA0Nzk3
LjcyIEJvZ29NSVBTIChscGo9MjM5ODg2MykgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA0OC40MzU0MDhdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50
cmllczogMjU2IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNDM2MjQ2
XSBDUFU6IEwxIEkgY2FjaGU6IDMySywgTDEgRCBjYWNoZTogMzJLIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNDM2MzA3XSBDUFU6IEwyIGNhY2hl
OiA0MDk2SyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjQzNjM0N10g
dXNpbmcgbXdhaXQgaW4gaWRsZSB0aHJlYWRzLiANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgIDQ4LjQzNjM4OV0gQ1BVOiBQaHlzaWNhbCBQcm9jZXNzb3Ig
SUQ6IDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC40MzY0MzBdIENQ
VTogUHJvY2Vzc29yIENvcmUgSUQ6IDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICA0OC40MzY0NzRdIENQVTA6IFRoZXJtYWwgbW9uaXRvcmluZyBlbmFi
bGVkIChUTTIpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNDM2NTI2
XSBGcmVlaW5nIFNNUCBhbHRlcm5hdGl2ZXM6IDM2ayBmcmVlZCANCk1heSAy
OSAxNzozOToxMSBwMzQgWyAgIDQ4LjQzNjU4NF0gQUNQSTogQ29yZSByZXZp
c2lvbiAyMDA3MDEyNiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjQ4
NTY2Nl0gYWN0aXZhdGluZyBOTUkgV2F0Y2hkb2cgLi4uIGRvbmUuIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNDg1Nzg2XSBVc2luZyBsb2NhbCBB
UElDIHRpbWVyIGludGVycnVwdHMuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBb
ICAgNDguNTI3NTY0XSByZXN1bHQgMTY2NTAwMzcgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICA0OC41Mjc2NDJdIERldGVjdGVkIDE2LjY1MCBNSHogQVBJ
QyB0aW1lci4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC41MjkzMTJd
IEJvb3RpbmcgcHJvY2Vzc29yIDEvNCBBUElDIDB4MiANCk1heSAyOSAxNzoz
OToxMSBwMzQgWyAgIDQ4LjUzOTk0M10gSW5pdGlhbGl6aW5nIENQVSMxIA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNjAwNzI3XSBDYWxpYnJhdGlu
ZyBkZWxheSB1c2luZyB0aW1lciBzcGVjaWZpYyByb3V0aW5lLi4gNDc5NS4w
NyBCb2dvTUlQUyAobHBqPTIzOTc1MzkpIA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgNDguNjAwNzg1XSBDUFU6IEwxIEkgY2FjaGU6IDMySywgTDEgRCBj
YWNoZTogMzJLIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNjAwODIy
XSBDUFU6IEwyIGNhY2hlOiA0MDk2SyANCk1heSAyOSAxNzozOToxMSBwMzQg
WyAgIDQ4LjYwMDg1Ml0gQ1BVOiBQaHlzaWNhbCBQcm9jZXNzb3IgSUQ6IDAg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC42MDA4NzldIENQVTogUHJv
Y2Vzc29yIENvcmUgSUQ6IDIgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0
OC42MDA5MTRdIENQVTE6IFRoZXJtYWwgbW9uaXRvcmluZyBlbmFibGVkIChU
TTIpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNjAxMzQ4XSBJbnRl
bChSKSBDb3JlKFRNKTIgUXVhZCBDUFUgICAgICAgICAgIEAgMi40MEdIeiBz
dGVwcGluZyAwNyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjYwMTQ1
MV0gY2hlY2tpbmcgVFNDIHN5bmNocm9uaXphdGlvbiBbQ1BVIzAgLT4gQ1BV
IzFdOiBwYXNzZWQuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNjIz
OTk4XSBCb290aW5nIHByb2Nlc3NvciAyLzQgQVBJQyAweDEgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICA0OC42MzUwMTVdIEluaXRpYWxpemluZyBDUFUj
MiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjY5NDcyOV0gQ2FsaWJy
YXRpbmcgZGVsYXkgdXNpbmcgdGltZXIgc3BlY2lmaWMgcm91dGluZS4uIDQ3
OTYuNjMgQm9nb01JUFMgKGxwaj0yMzk4MzE1KSANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgIDQ4LjY5NDc5MV0gQ1BVOiBMMSBJIGNhY2hlOiAzMkssIEwx
IEQgY2FjaGU6IDMySyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjY5
NDgyOV0gQ1BVOiBMMiBjYWNoZTogNDA5NksgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA0OC42OTQ4NjFdIENQVTogUGh5c2ljYWwgUHJvY2Vzc29yIElE
OiAwIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNjk0ODkxXSBDUFU6
IFByb2Nlc3NvciBDb3JlIElEOiAxIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBb
ICAgNDguNjk0OTI4XSBDUFUyOiBUaGVybWFsIG1vbml0b3JpbmcgZW5hYmxl
ZCAoVE0yKSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4LjY5NTM2OF0g
SW50ZWwoUikgQ29yZShUTSkyIFF1YWQgQ1BVICAgICAgICAgICBAIDIuNDBH
SHogc3RlcHBpbmcgMDcgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC42
OTU1MDhdIGNoZWNraW5nIFRTQyBzeW5jaHJvbml6YXRpb24gW0NQVSMwIC0+
IENQVSMyXTogcGFzc2VkLiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4
LjcxNzkxNV0gQm9vdGluZyBwcm9jZXNzb3IgMy80IEFQSUMgMHgzIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNDguNzI4NTQ3XSBJbml0aWFsaXppbmcg
Q1BVIzMgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC43ODg2ODZdIENh
bGlicmF0aW5nIGRlbGF5IHVzaW5nIHRpbWVyIHNwZWNpZmljIHJvdXRpbmUu
LiA0Nzk1LjQ2IEJvZ29NSVBTIChscGo9MjM5NzczMCkgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICA0OC43ODg3NTBdIENQVTogTDEgSSBjYWNoZTogMzJL
LCBMMSBEIGNhY2hlOiAzMksgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0
OC43ODg3ODddIENQVTogTDIgY2FjaGU6IDQwOTZLIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNDguNzg4ODE3XSBDUFU6IFBoeXNpY2FsIFByb2Nlc3Nv
ciBJRDogMCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ4Ljc4ODg0Nl0g
Q1BVOiBQcm9jZXNzb3IgQ29yZSBJRDogMyANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgIDQ4Ljc4ODg4Ml0gQ1BVMzogVGhlcm1hbCBtb25pdG9yaW5nIGVu
YWJsZWQgKFRNMikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OC43ODkz
MThdIEludGVsKFIpIENvcmUoVE0pMiBRdWFkIENQVSAgICAgICAgICAgQCAy
LjQwR0h6IHN0ZXBwaW5nIDA3IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
NDguNzg5NDQ2XSBjaGVja2luZyBUU0Mgc3luY2hyb25pemF0aW9uIFtDUFUj
MCAtPiBDUFUjM106IHBhc3NlZC4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsg
ICA0OC44MTA3NTNdIEJyb3VnaHQgdXAgNCBDUFVzIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNDguODEwOTQxXSB0ZXN0aW5nIE5NSSB3YXRjaGRvZyAu
Li4gT0suIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDkuMTc4Mjg3XSBt
aWdyYXRpb25fY29zdD0xNTYsMTkzIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBb
ICAgNDkuMTgyMDc0XSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5
IDE2IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDkuMTgzNTA2XSBBQ1BJ
OiBidXMgdHlwZSBwY2kgcmVnaXN0ZXJlZCANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgIDQ5LjE4MzY3MF0gUENJOiBCSU9TIEJ1ZzogTUNGRyBhcmVhIGF0
IGYwMDAwMDAwIGlzIG5vdCBFODIwLXJlc2VydmVkIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNDkuMTgzNzY0XSBQQ0k6IE5vdCB1c2luZyBNTUNPTkZJ
Ry4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS4xODM4NDddIFBDSTog
VXNpbmcgY29uZmlndXJhdGlvbiB0eXBlIDEgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA0OS4zMjQ5MjhdIEFDUEk6IEludGVycHJldGVyIGVuYWJsZWQg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS4zMjUwMTBdIEFDUEk6IFVz
aW5nIElPQVBJQyBmb3IgaW50ZXJydXB0IHJvdXRpbmcgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICA0OS41MTg0MjddIEFDUEk6IFBDSSBSb290IEJyaWRn
ZSBbUENJMF0gKDAwMDA6MDApIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
NDkuNTIzODczXSBQQ0kgcXVpcms6IHJlZ2lvbiAwNDAwLTA0N2YgY2xhaW1l
ZCBieSBJQ0g2IEFDUEkvR1BJTy9UQ08gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICA0OS41MjM5NzRdIFBDSSBxdWlyazogcmVnaW9uIDA1MDAtMDUzZiBj
bGFpbWVkIGJ5IElDSDYgR1BJTyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAg
IDQ5LjUzNDQ5Ml0gUENJOiBUcmFuc3BhcmVudCBicmlkZ2UgLSAwMDAwOjAw
OjFlLjAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS43OTIzNDZdIEFD
UEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQV0gKElSUXMgMyA0IDUgNyA5
IDEwICoxMSAxMikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS43OTY0
NzVdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQl0gKElSUXMgMyA0
IDUgNyA5ICoxMCAxMSAxMikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0
OS44MDA1NDNdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LQ10gKElS
UXMgMyA0IDUgNyA5IDEwICoxMSAxMikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICA0OS44MDQ2NTNdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5L
RF0gKElSUXMgMyA0IDUgNyA5IDEwICoxMSAxMikgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICA0OS44MDg3ODFdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGlu
ayBbTE5LRV0gKElSUXMgMyA0IDUgNyAqOSAxMCAxMSAxMikgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICA0OS44MTI4MTJdIEFDUEk6IFBDSSBJbnRlcnJ1
cHQgTGluayBbTE5LRl0gKElSUXMgMyA0IDUgNyA5ICoxMCAxMSAxMikgDQpN
YXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS44MTY4NjRdIEFDUEk6IFBDSSBJ
bnRlcnJ1cHQgTGluayBbTE5LR10gKElSUXMgMyA0IDUgNyAqOSAxMCAxMSAx
MikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS44MjA5OTldIEFDUEk6
IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LSF0gKElSUXMgMyA0IDUgNyA5IDEw
ICoxMSAxMikgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS44MjQyODBd
IExpbnV4IFBsdWcgYW5kIFBsYXkgU3VwcG9ydCB2MC45NyAoYykgQWRhbSBC
ZWxheSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ5LjgyNDU2OV0gcG5w
OiBQblAgQUNQSSBpbml0IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDku
OTIzNDA2XSBwbnA6IFBuUCBBQ1BJOiBmb3VuZCAxMiBkZXZpY2VzIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNDkuOTI3NjU1XSBTQ1NJIHN1YnN5c3Rl
bSBpbml0aWFsaXplZCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ5Ljkz
NTQ4MF0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZl
ciB1c2JmcyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ5LjkzNjQ5N10g
dXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBodWIg
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS45Mzk0NjldIHVzYmNvcmU6
IHJlZ2lzdGVyZWQgbmV3IGRldmljZSBkcml2ZXIgdXNiIA0KTWF5IDI5IDE3
OjM5OjExIHAzNCBbICAgNDkuOTQyNzUwXSBQQ0k6IFVzaW5nIEFDUEkgZm9y
IElSUSByb3V0aW5nIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNDkuOTQy
ODUxXSBQQ0k6IElmIGEgZGV2aWNlIGRvZXNuJ3Qgd29yaywgdHJ5ICJwY2k9
cm91dGVpcnEiLiAgSWYgaXQgaGVscHMsIHBvc3QgYSByZXBvcnQgDQpNYXkg
MjkgMTc6Mzk6MTEgcDM0IFsgICA0OS45NDQyMjNdIFBDSS1HQVJUOiBObyBB
TUQgbm9ydGhicmlkZ2UgZm91bmQuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBb
ICAgNDkuOTQ0OTI5XSBocGV0MDogYXQgTU1JTyAweGZlZDAwMDAwLCBJUlFz
IDIsIDgsIDAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS45NDUxNDVd
IGhwZXQwOiAzIDY0LWJpdCB0aW1lcnMsIDE0MzE4MTgwIEh6IA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNDkuOTQ2NDE3XSBUaW1lOiB0c2MgY2xvY2tz
b3VyY2UgaGFzIGJlZW4gaW5zdGFsbGVkLiANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgIDQ5Ljk0NzUxN10gcG5wOiAwMDowMTogaW9tZW0gcmFuZ2UgMHhm
MDAwMDAwMC0weGY3ZmZmZmZmIGhhcyBiZWVuIHJlc2VydmVkIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNDkuOTQ3NjQwXSBwbnA6IDAwOjAxOiBpb21l
bSByYW5nZSAweGZlZDEzMDAwLTB4ZmVkMTNmZmYgaGFzIGJlZW4gcmVzZXJ2
ZWQgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA0OS45NDc3ODVdIHBucDog
MDA6MDE6IGlvbWVtIHJhbmdlIDB4ZmVkMTQwMDAtMHhmZWQxN2ZmZiBoYXMg
YmVlbiByZXNlcnZlZCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDQ5Ljk0
Nzk0M10gcG5wOiAwMDowMTogaW9tZW0gcmFuZ2UgMHhmZWQxODAwMC0weGZl
ZDE4ZmZmIGhhcyBiZWVuIHJlc2VydmVkIA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgNDkuOTQ4MTI1XSBwbnA6IDAwOjA2OiBpb3BvcnQgcmFuZ2UgMHg1
MDAtMHg1M2YgaGFzIGJlZW4gcmVzZXJ2ZWQgDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA0OS45NDgyMzFdIHBucDogMDA6MDY6IGlvcG9ydCByYW5nZSAw
eDQwMC0weDQ3ZiBoYXMgYmVlbiByZXNlcnZlZCANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgIDQ5Ljk0ODQzM10gcG5wOiAwMDowNjogaW9wb3J0IHJhbmdl
IDB4NjgwLTB4NmZmIGhhcyBiZWVuIHJlc2VydmVkIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNDkuOTYxMzc5XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IDAw
MDA6MDY6MDMuMFtBXSAtPiBHU0kgMTkgKGxldmVsLCBsb3cpIC0+IElSUSAx
OSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjAxNTE0M10gb2hjaTEz
OTQ6IGZ3LWhvc3QwOiBPSENJLTEzOTQgMS4xIChQQ0kpOiBJUlE9WzE5XSAg
TU1JTz1bZTAwODQwMDAtZTAwODQ3ZmZdICBNYXggUGFja2V0PVsyMDQ4XSAg
SVIvSVQgY29udGV4dHM9WzQvOF0gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsg
ICA1MC4wMTY2OTRdIFBDSTogSWdub3JlIGJvZ3VzIHJlc291cmNlIDYgWzA6
MF0gb2YgMDAwMDowMDowMi4wIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
NTAuMDE3MTA4XSBQQ0k6IEJyaWRnZTogMDAwMDowMDoxYy4wIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3MjAzXSAgIElPIHdpbmRvdzogZGlz
YWJsZWQuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3Mjk1XSAg
IE1FTSB3aW5kb3c6IGUwNzAwMDAwLWUwN2ZmZmZmIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNTAuMDE3MzgxXSAgIFBSRUZFVENIIHdpbmRvdzogZGlz
YWJsZWQuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3NTA3XSBQ
Q0k6IEJyaWRnZTogMDAwMDowMDoxYy4xIA0KTWF5IDI5IDE3OjM5OjExIHAz
NCBbICAgNTAuMDE3NTk4XSAgIElPIHdpbmRvdzogNTAwMC01ZmZmIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3Njg5XSAgIE1FTSB3aW5kb3c6
IGUwNDAwMDAwLWUwNGZmZmZmIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
NTAuMDE3Nzc2XSAgIFBSRUZFVENIIHdpbmRvdzogZGlzYWJsZWQuIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3ODgyXSBQQ0k6IEJyaWRnZTog
MDAwMDowMDoxYy4yIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE3
OTY2XSAgIElPIHdpbmRvdzogNDAwMC00ZmZmIA0KTWF5IDI5IDE3OjM5OjEx
IHAzNCBbICAgNTAuMDE4MDcxXSAgIE1FTSB3aW5kb3c6IGUwMzAwMDAwLWUw
M2ZmZmZmIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE4MTg5XSAg
IFBSRUZFVENIIHdpbmRvdzogZTA4MDAwMDAtZTA4ZmZmZmYgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICA1MC4wMTgyOTddIFBDSTogQnJpZGdlOiAwMDAw
OjAwOjFjLjMgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4wMTgzODJd
ICAgSU8gd2luZG93OiAzMDAwLTNmZmYgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICA1MC4wMTg1MDRdICAgTUVNIHdpbmRvdzogZTAyMDAwMDAtZTAyZmZm
ZmYgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4wMTg1OThdICAgUFJF
RkVUQ0ggd2luZG93OiBlMDkwMDAwMC1lMDlmZmZmZiANCk1heSAyOSAxNzoz
OToxMSBwMzQgWyAgIDUwLjAxODcwN10gUENJOiBCcmlkZ2U6IDAwMDA6MDA6
MWMuNCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjAxODc5Ml0gICBJ
TyB3aW5kb3c6IDIwMDAtMmZmZiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAg
IDUwLjAxODg4NV0gICBNRU0gd2luZG93OiBlMDEwMDAwMC1lMDFmZmZmZiAN
Ck1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjAxODk3Nl0gICBQUkVGRVRD
SCB3aW5kb3c6IGUwYTAwMDAwLWUwYWZmZmZmIA0KTWF5IDI5IDE3OjM5OjEx
IHAzNCBbICAgNTAuMDE5MTIxXSBQQ0k6IEJyaWRnZTogMDAwMDowMDoxZS4w
IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE5MjM0XSAgIElPIHdp
bmRvdzogMTAwMC0xZmZmIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAu
MDE5MzI1XSAgIE1FTSB3aW5kb3c6IGUwMDAwMDAwLWUwMGZmZmZmIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE5NDM2XSAgIFBSRUZFVENIIHdp
bmRvdzogZTBiMDAwMDAtZTBiZmZmZmYgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0
IFsgICA1MC4wMTk2MjVdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgMDAwMDowMDox
Yy4wW0FdIC0+IEdTSSAxNyAobGV2ZWwsIGxvdykgLT4gSVJRIDE3IA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDE5OTEyXSBBQ1BJOiBQQ0kgSW50
ZXJydXB0IDAwMDA6MDA6MWMuMVtCXSAtPiBHU0kgMTYgKGxldmVsLCBsb3cp
IC0+IElSUSAxNiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjAyMDI1
MV0gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFjLjJbQ10gLT4gR1NJ
IDE4IChsZXZlbCwgbG93KSAtPiBJUlEgMTggDQpNYXkgMjkgMTc6Mzk6MTEg
cDM0IFsgICA1MC4wMjA1NTZdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgMDAwMDow
MDoxYy4zW0RdIC0+IEdTSSAxOSAobGV2ZWwsIGxvdykgLT4gSVJRIDE5IA0K
TWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDIwODI5XSBBQ1BJOiBQQ0kg
SW50ZXJydXB0IDAwMDA6MDA6MWMuNFtBXSAtPiBHU0kgMTcgKGxldmVsLCBs
b3cpIC0+IElSUSAxNyANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjAy
MjExMV0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAyIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDMyMTM0XSBJUCByb3V0ZSBjYWNo
ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDI2MjE0NCAob3JkZXI6IDksIDIwOTcx
NTIgYnl0ZXMpIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMDQxMTUx
XSBUQ1AgZXN0YWJsaXNoZWQgaGFzaCB0YWJsZSBlbnRyaWVzOiAxMzEwNzIg
KG9yZGVyOiA5LCAzMTQ1NzI4IGJ5dGVzKSANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgIDUwLjA1Mzc0MV0gVENQIGJpbmQgaGFzaCB0YWJsZSBlbnRyaWVz
OiA2NTUzNiAob3JkZXI6IDgsIDEwNDg1NzYgYnl0ZXMpIA0KTWF5IDI5IDE3
OjM5OjExIHAzNCBbICAgNTAuMDU3OTQyXSBUQ1A6IEhhc2ggdGFibGVzIGNv
bmZpZ3VyZWQgKGVzdGFibGlzaGVkIDEzMTA3MiBiaW5kIDY1NTM2KSANCk1h
eSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjA1ODAzMV0gVENQIHJlbm8gcmVn
aXN0ZXJlZCANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjEwNDA3OV0g
SW5zdGFsbGluZyBrbmZzZCAoY29weXJpZ2h0IChDKSAxOTk2IG9raXJAbW9u
YWQuc3diLmRlKS4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4xMDgy
OTBdIFNHSSBYRlMgd2l0aCBsYXJnZSBibG9jay9pbm9kZSBudW1iZXJzLCBu
byBkZWJ1ZyBlbmFibGVkIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAu
MTI0Nzk2XSBpbyBzY2hlZHVsZXIgbm9vcCByZWdpc3RlcmVkIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNTAuMTI0ODc3XSBpbyBzY2hlZHVsZXIgYW50
aWNpcGF0b3J5IHJlZ2lzdGVyZWQgKGRlZmF1bHQpIA0KTWF5IDI5IDE3OjM5
OjExIHAzNCBbICAgNTAuMTMwNzYwXSBhc3NpZ25faW50ZXJydXB0X21vZGUg
Rm91bmQgTVNJIGNhcGFiaWxpdHkgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsg
ICA1MC4xMzM5MDldIGFzc2lnbl9pbnRlcnJ1cHRfbW9kZSBGb3VuZCBNU0kg
Y2FwYWJpbGl0eSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjEzNjk5
Ml0gYXNzaWduX2ludGVycnVwdF9tb2RlIEZvdW5kIE1TSSBjYXBhYmlsaXR5
IA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMTM5OTE2XSBhc3NpZ25f
aW50ZXJydXB0X21vZGUgRm91bmQgTVNJIGNhcGFiaWxpdHkgDQpNYXkgMjkg
MTc6Mzk6MTEgcDM0IFsgICA1MC4xNDI5MDddIGFzc2lnbl9pbnRlcnJ1cHRf
bW9kZSBGb3VuZCBNU0kgY2FwYWJpbGl0eSANCk1heSAyOSAxNzozOToxMSBw
MzQgWyAgIDUwLjIxNzYxNV0gbHA6IGRyaXZlciBsb2FkZWQgYnV0IG5vIGRl
dmljZXMgZm91bmQgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4yMTkx
MjRdIFJlYWwgVGltZSBDbG9jayBEcml2ZXIgdjEuMTJhYyANCk1heSAyOSAx
NzozOToxMSBwMzQgWyAgIDUwLjIyMTc4Ml0gTGludXggYWdwZ2FydCBpbnRl
cmZhY2UgdjAuMTAyIChjKSBEYXZlIEpvbmVzIA0KTWF5IDI5IDE3OjM5OjEx
IHAzNCBbICAgNTAuMjIzMzI4XSBhZ3BnYXJ0OiBEZXRlY3RlZCBhbiBJbnRl
bCA5NjVHIENoaXBzZXQuIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAu
MjI0NTY1XSBhZ3BnYXJ0OiBEZXRlY3RlZCA3Njc2SyBzdG9sZW4gbWVtb3J5
LiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjI0MzI4OV0gYWdwZ2Fy
dDogQUdQIGFwZXJ0dXJlIGlzIDI1Nk0gQCAweGQwMDAwMDAwIA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNTAuMjQzODU2XSBbZHJtXSBJbml0aWFsaXpl
ZCBkcm0gMS4xLjAgMjAwNjA4MTAgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsg
ICA1MC4yNDQxNDFdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgMDAwMDowMDowMi4w
W0FdIC0+IEdTSSAxNiAobGV2ZWwsIGxvdykgLT4gSVJRIDE2IA0KTWF5IDI5
IDE3OjM5OjExIHAzNCBbICAgNTAuMjQ2MzIyXSBbZHJtXSBJbml0aWFsaXpl
ZCBpOTE1IDEuNi4wIDIwMDYwMTE5IG9uIG1pbm9yIDAgDQpNYXkgMjkgMTc6
Mzk6MTEgcDM0IFsgICA1MC4yNDc0MTVdIHBhcnBvcnQ6IFBuUEJJT1MgcGFy
cG9ydCBkZXRlY3RlZC4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4y
NDc2NTRdIHBhcnBvcnQwOiBQQy1zdHlsZSBhdCAweDM3OCAoMHg3NzgpLCBp
cnEgNywgdXNpbmcgRklGTyBbUENTUFAsVFJJU1RBVEUsQ09NUEFULEVDUF0g
DQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4zMzEzNjJdIGxwMDogdXNp
bmcgcGFycG9ydDAgKGludGVycnVwdC1kcml2ZW4pLiANCk1heSAyOSAxNzoz
OToxMSBwMzQgWyAgIDUwLjM0MTM1NV0gbG9vcDogbG9hZGVkIChtYXggOCBk
ZXZpY2VzKSANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjM0MTQzN10g
SW50ZWwoUikgUFJPLzEwMDAgTmV0d29yayBEcml2ZXIgLSB2ZXJzaW9uIDcu
My4yMC1rMi1OQVBJIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuMzQx
NTI4XSBDb3B5cmlnaHQgKGMpIDE5OTktMjAwNiBJbnRlbCBDb3Jwb3JhdGlv
bi4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC4zNDI1MjBdIEFDUEk6
IFBDSSBJbnRlcnJ1cHQgMDAwMDowMDoxOS4wW0FdIC0+IEdTSSAyMCAobGV2
ZWwsIGxvdykgLT4gSVJRIDIwIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAg
NTAuMzYwNjg1XSBlMTAwMDogMDAwMDowMDoxOS4wOiBlMTAwMF9wcm9iZTog
KFBDSSBFeHByZXNzOjIuNUdiL3M6V2lkdGggeDEpIDAwOjE5OmQxOjZlOjlk
OjQzIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuNDM5MTMyXSBlMTAw
MDogZXRoMDogZTEwMDBfcHJvYmU6IEludGVsKFIpIFBSTy8xMDAwIE5ldHdv
cmsgQ29ubmVjdGlvbiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUwLjQz
OTY1NV0gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjA2OjAwLjBbQV0gLT4g
R1NJIDIxIChsZXZlbCwgbG93KSAtPiBJUlEgMjEgDQpNYXkgMjkgMTc6Mzk6
MTEgcDM0IFsgICA1MC43MDU1MzRdIGUxMDAwOiAwMDAwOjA2OjAwLjA6IGUx
MDAwX3Byb2JlOiAoUENJOjMzTUh6OjMyLWJpdCkgMDA6MGU6MGM6MDA6Y2Q6
YjEgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MC44NTc0ODJdIGUxMDAw
OiBldGgxOiBlMTAwMF9wcm9iZTogSW50ZWwoUikgUFJPLzEwMDAgTmV0d29y
ayBDb25uZWN0aW9uIA0KTWF5IDI5IDE3OjM5OjExIHAzNCBbICAgNTAuODU3
NzI0XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDY6MDEuMFtBXSAtPiBH
U0kgMjIgKGxldmVsLCBsb3cpIC0+IElSUSAyMiANCk1heSAyOSAxNzozOTox
MSBwMzQgWyAgIDUxLjEwNzE3MV0gZTEwMDA6IDAwMDA6MDY6MDEuMDogZTEw
MDBfcHJvYmU6IChQQ0k6MzNNSHo6MzItYml0KSAwMDowNzplOToyOTozNzpk
YiANCk1heSAyOSAxNzozOToxMSBwMzQgWyAgIDUxLjEzNjIyMV0gZTEwMDA6
IGV0aDI6IGUxMDAwX3Byb2JlOiBJbnRlbChSKSBQUk8vMTAwMCBOZXR3b3Jr
IENvbm5lY3Rpb24gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1MS4xMzgy
NTFdIG5ldGNvbnNvbGU6IGRldmljZSBldGgwIG5vdCB1cCB5ZXQsIGZvcmNp
bmcgaXQgDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IFsgICA1My4xODAzNjRdIGUx
MDAwOiBldGgwOiBlMTAwMF93YXRjaGRvZzogTklDIExpbmsgaXMgVXAgMTAw
MCBNYnBzIEZ1bGwgRHVwbGV4LCBGbG93IENvbnRyb2w6IFJYL1RYIA0KTWF5
IDI5IDE3OjM5OjExIHAzNCBbICAgNTMuNjgzMDk2XSBuZXRjb25zb2xlOiBu
ZXR3b3JrIGxvZ2dpbmcgc3RhcnRlZCANCk1heSAyOSAxNzozOToxMSBwMzQg
WyAgIDUzLjY4NjkyM10gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFm
LjJbQV0gLT4gDQpNYXkgMjkgMTc6Mzk6MTEgcDM0IEdTSSAxOSAobGV2ZWws
IGxvdykgLT4gSVJRIDE5IA0KTWF5IDI5IDE3OjM5OjEyIHAzNCBbICAgNTQu
Njg3NzgzXSBhaGNpIDAwMDA6MDA6MWYuMjogQUhDSSAwMDAxLjAxMDAgMzIg
c2xvdHMgNiBwb3J0cyAzIEdicHMgMHgzZiBpbXBsIFNBVEEgbW9kZSANCk1h
eSAyOSAxNzozOToxMiBwMzQgWyAgIDU0LjY4Nzk1Nl0gYWhjaSAwMDAwOjAw
OjFmLjI6IGZsYWdzOiA2NGJpdCBuY3EgbGVkIGNsbyBwaW8gc2x1bSBwYXJ0
ICANCk1heSAyOSAxNzozOToxMiBwMzQgWyAgIDU0LjY5MDUyMl0gYXRhMTog
U0FUQSBtYXggVURNQS8xMzMgY21kIDB4ZmZmZmMyMDAwMDA3ODEwMCBjdGwg
MHgwMDAwMDAwMDAwMDAwMDAwIGJtZG1hIDB4MDAwMDAwMDAwMDAwMDAwMCBp
cnEgMzc3IA0KTWF5IDI5IDE3OjM5OjEyIHAzNCBbICAgNTQuNjkyNTUyXSBh
dGEyOiBTQVRBIG1heCBVRE1BLzEzMyBjbWQgMHhmZmZmYzIwMDAwMDc4MTgw
IGN0bCAweDAwMDAwMDAwMDAwMDAwMDAgYm1kbWEgMHgwMDAwMDAwMDAwMDAw
MDAwIGlycSAzNzcgDQpNYXkgMjkgMTc6Mzk6MTIgcDM0IFsgICA1NC42OTQ2
MzddIGF0YTM6IFNBVEEgbWF4IFVETUEvMTMzIGNtZCAweGZmZmZjMjAwMDAw
NzgyMDAgY3RsIDB4MDAwMDAwMDAwMDAwMDAwMCBibWRtYSAweDAwMDAwMDAw
MDAwMDAwMDAgaXJxIDM3NyANCk1heSAyOSAxNzozOToxMiBwMzQgWyAgIDU0
LjY5NjY2OV0gYXRhNDogU0FUQSBtYXggVURNQS8xMzMgY21kIDB4ZmZmZmMy
MDAwMDA3ODI4MCBjdGwgMHgwMDAwMDAwMDAwMDAwMDAwIGJtZG1hIDB4MDAw
MDAwMDAwMDAwMDAwMCBpcnEgMzc3IA0KTWF5IDI5IDE3OjM5OjEyIHAzNCBb
ICAgNTQuNjk4Njg3XSBhdGE1OiBTQVRBIG1heCBVRE1BLzEzMyBjbWQgMHhm
ZmZmYzIwMDAwMDc4MzAwIGN0bCAweDAwMDAwMDAwMDAwMDAwMDAgYm1kbWEg
MHgwMDAwMDAwMDAwMDAwMDAwIGlycSAzNzcgDQpNYXkgMjkgMTc6Mzk6MTIg
cDM0IFsgICA1NC43MDA3MjZdIGF0YTY6IFNBVEEgbWF4IFVETUEvMTMzIGNt
ZCAweGZmZmZjMjAwMDAwNzgzODAgY3RsIDB4MDAwMDAwMDAwMDAwMDAwMCBi
bWRtYSAweDAwMDAwMDAwMDAwMDAwMDAgaXJxIDM3NyANCk1heSAyOSAxNzoz
OToxMiBwMzQgWyAgIDU0LjcwMTAxMV0gc2NzaTAgOiBhaGNpIA0KTWF5IDI5
IDE3OjM5OjEzIHAzNCBbICAgNTUuMTYyODE2XSBhdGExOiBTQVRBIGxpbmsg
dXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFNDb250cm9sIDMwMCkgDQpNYXkg
MjkgMTc6Mzk6MTMgcDM0IFsgICA1NS4xNjU0MzRdIGF0YTEuMDA6IEFUQS02
OiBXREMgV0Q3NDBHRC0wMEZMQzAsIDMzLjA4RjMzLCBtYXggVURNQS8xMzMg
DQpNYXkgMjkgMTc6Mzk6MTMgcDM0IFsgICA1NS4xNjU2MDRdIGF0YTEuMDA6
IDE0NTIyNjExMiBzZWN0b3JzLCBtdWx0aSAwOiBMQkE0OCAgDQpNYXkgMjkg
MTc6Mzk6MTMgcDM0IFsgICA1NS4xNjk1MTBdIGF0YTEuMDA6IGNvbmZpZ3Vy
ZWQgZm9yIFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjEzIHAzNCBbICAgNTUu
MTcwMDUwXSBzY3NpMSA6IGFoY2kgDQpNYXkgMjkgMTc6Mzk6MTMgcDM0IFsg
ICA1NS42MzI4ODhdIGF0YTI6IFNBVEEgbGluayB1cCAxLjUgR2JwcyAoU1N0
YXR1cyAxMTMgU0NvbnRyb2wgMzAwKSANCk1heSAyOSAxNzozOToxMyBwMzQg
WyAgIDU1LjYzNTQ2Nl0gYXRhMi4wMDogQVRBLTY6IFdEQyBXRDc0MEdELTAw
RkxDMCwgMzMuMDhGMzMsIG1heCBVRE1BLzEzMyANCk1heSAyOSAxNzozOTox
MyBwMzQgWyAgIDU1LjYzNTYyNV0gYXRhMi4wMDogMTQ1MjI2MTEyIHNlY3Rv
cnMsIG11bHRpIDA6IExCQTQ4ICANCk1heSAyOSAxNzozOToxMyBwMzQgWyAg
IDU1LjYzOTU2M10gYXRhMi4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMg
DQpNYXkgMjkgMTc6Mzk6MTMgcDM0IFsgICA1NS42Mzk4ODVdIHNjc2kyIDog
YWhjaSANCk1heSAyOSAxNzozOToxNCBwMzQgWyAgIDU2LjEwMDExMV0gYXRh
MzogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBTQ29udHJv
bCAzMDApIA0KTWF5IDI5IDE3OjM5OjE0IHAzNCBbICAgNTYuMTAxOTA4XSBh
dGEzLjAwOiBBVEEtNzogV0RDIFdEMTUwMEFERkQtMDBOTFIxLCAyMC4wN1Ay
MCwgbWF4IFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjE0IHAzNCBbICAgNTYu
MTAyMDg2XSBhdGEzLjAwOiAyOTMwNDY3Njggc2VjdG9ycywgbXVsdGkgMDog
TEJBNDggTkNRIChkZXB0aCAzMS8zMikgDQpNYXkgMjkgMTc6Mzk6MTQgcDM0
IFsgICA1Ni4xMDQ4MjVdIGF0YTMuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEv
MTMzIA0KTWF5IDI5IDE3OjM5OjE0IHAzNCBbICAgNTYuMTA1MDM2XSBzY3Np
MyA6IGFoY2kgDQpNYXkgMjkgMTc6Mzk6MTQgcDM0IFsgICA1Ni41Njc0NzZd
IGF0YTQ6IFNBVEEgbGluayB1cCAxLjUgR2JwcyAoU1N0YXR1cyAxMTMgU0Nv
bnRyb2wgMzAwKSANCk1heSAyOSAxNzozOToxNCBwMzQgWyAgIDU2LjU2OTI4
MV0gYXRhNC4wMDogQVRBLTc6IFdEQyBXRDE1MDBBREZELTAwTkxSMSwgMjAu
MDdQMjAsIG1heCBVRE1BLzEzMyANCk1heSAyOSAxNzozOToxNCBwMzQgWyAg
IDU2LjU2OTQyM10gYXRhNC4wMDogMjkzMDQ2NzY4IHNlY3RvcnMsIG11bHRp
IDA6IExCQTQ4IE5DUSAoZGVwdGggMzEvMzIpIA0KTWF5IDI5IDE3OjM5OjE0
IHAzNCBbICAgNTYuNTcyMTUwXSBhdGE0LjAwOiBjb25maWd1cmVkIGZvciBV
RE1BLzEzMyANCk1heSAyOSAxNzozOToxNCBwMzQgWyAgIDU2LjU3MjM5MV0g
c2NzaTQgOiBhaGNpIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuMDMy
MzY1XSBhdGE1OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEz
IFNDb250cm9sIDMwMCkgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny4w
MzQxMTVdIGF0YTUuMDA6IEFUQS03OiBXREMgV0QxNTAwQURGRC0wME5MUjEs
IDIwLjA3UDIwLCBtYXggVURNQS8xMzMgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0
IFsgICA1Ny4wMzQyNDVdIGF0YTUuMDA6IDI5MzA0Njc2OCBzZWN0b3JzLCBt
dWx0aSAwOiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSANCk1heSAyOSAxNzoz
OToxNSBwMzQgWyAgIDU3LjAzNjg2NV0gYXRhNS4wMDogY29uZmlndXJlZCBm
b3IgVURNQS8xMzMgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny4wMzcw
NzhdIHNjc2k1IDogYWhjaSANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3
LjQ5NjU1MF0gYXRhNjogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVz
IDExMyBTQ29udHJvbCAzMDApIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAg
NTcuNDk4MjcwXSBhdGE2LjAwOiBBVEEtNzogV0RDIFdEMTUwMEFERkQtMDBO
TFIxLCAyMC4wN1AyMCwgbWF4IFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjE1
IHAzNCBbICAgNTcuNDk4NDM4XSBhdGE2LjAwOiAyOTMwNDY3Njggc2VjdG9y
cywgbXVsdGkgMDogTEJBNDggTkNRIChkZXB0aCAzMS8zMikgDQpNYXkgMjkg
MTc6Mzk6MTUgcDM0IFsgICA1Ny41MDEwOTNdIGF0YTYuMDA6IGNvbmZpZ3Vy
ZWQgZm9yIFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcu
NTAyOTE2XSBzY3NpIDA6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAg
ICAgIFdEQyBXRDc0MEdELTAwRkwgMzMuMCBQUTogMCBBTlNJOiA1IA0KTWF5
IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTA1MTIwXSBTQ1NJIGRldmljZSBz
ZGE6IDE0NTIyNjExMiA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDc0MzU2IE1C
KSANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjUwNTQ1Nl0gc2RhOiBX
cml0ZSBQcm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOToxNSBwMzQgWyAg
IDU3LjUwNjA1MV0gU0NTSSBkZXZpY2Ugc2RhOiB3cml0ZSBjYWNoZTogZW5h
YmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQ
TyBvciBGVUEgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny41MDcwMjNd
IFNDU0kgZGV2aWNlIHNkYTogMTQ1MjI2MTEyIDUxMi1ieXRlIGhkd3Igc2Vj
dG9ycyAoNzQzNTYgTUIpIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcu
NTA3MzU2XSBzZGE6IFdyaXRlIFByb3RlY3QgaXMgb2ZmIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNTA3OTc3XSBTQ1NJIGRldmljZSBzZGE6IHdy
aXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vz
bid0IHN1cHBvcnQgRFBPIG9yIEZVQSANCk1heSAyOSAxNzozOToxNSBwMzQg
WyAgIDU3LjUwODE1NV0gIHNkYToNCk1heSAyOSAxNzozOToxNSBwMzQgIHNk
YTENCk1heSAyOSAxNzozOToxNSBwMzQgIHNkYTINCk1heSAyOSAxNzozOTox
NSBwMzQgIHNkYTMNCk1heSAyOSAxNzozOToxNSBwMzQgIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNTI0MjM0XSBzZCAwOjA6MDowOiBBdHRhY2hl
ZCBzY3NpIGRpc2sgc2RhIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcu
NTI2NDczXSBzY3NpIDE6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAg
ICAgIFdEQyBXRDc0MEdELTAwRkwgMzMuMCBQUTogMCBBTlNJOiA1IA0KTWF5
IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTI4NDc4XSBTQ1NJIGRldmljZSBz
ZGI6IDE0NTIyNjExMiA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDc0MzU2IE1C
KSANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjUyODgyNF0gc2RiOiBX
cml0ZSBQcm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOToxNSBwMzQgWyAg
IDU3LjUyOTMyNF0gU0NTSSBkZXZpY2Ugc2RiOiB3cml0ZSBjYWNoZTogZW5h
YmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQ
TyBvciBGVUEgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny41MzAxNzld
IFNDU0kgZGV2aWNlIHNkYjogMTQ1MjI2MTEyIDUxMi1ieXRlIGhkd3Igc2Vj
dG9ycyAoNzQzNTYgTUIpIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcu
NTMwNTExXSBzZGI6IFdyaXRlIFByb3RlY3QgaXMgb2ZmIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNTMxMDE2XSBTQ1NJIGRldmljZSBzZGI6IHdy
aXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vz
bid0IHN1cHBvcnQgRFBPIG9yIEZVQSANCk1heSAyOSAxNzozOToxNSBwMzQg
WyAgIDU3LjUzMTE2Ml0gIHNkYjoNCk1heSAyOSAxNzozOToxNSBwMzQgIHNk
YjENCk1heSAyOSAxNzozOToxNSBwMzQgIHNkYjINCk1heSAyOSAxNzozOTox
NSBwMzQgIHNkYjMNCk1heSAyOSAxNzozOToxNSBwMzQgIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNTQ1MDYzXSBzZCAxOjA6MDowOiBBdHRhY2hl
ZCBzY3NpIGRpc2sgc2RiIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcu
NTQ3MTAzXSBzY3NpIDI6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAg
ICAgIFdEQyBXRDE1MDBBREZELTAgMjAuMCBQUTogMCBBTlNJOiA1IA0KTWF5
IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTQ5MDA3XSBTQ1NJIGRldmljZSBz
ZGM6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBN
QikgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny41NDkzMjJdIHNkYzog
V3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsg
ICA1Ny41NDk4NjldIFNDU0kgZGV2aWNlIHNkYzogd3JpdGUgY2FjaGU6IGVu
YWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBE
UE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTUwNzEw
XSBTQ1NJIGRldmljZSBzZGM6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNl
Y3RvcnMgKDE1MDA0MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1
Ny41NTEwMDNdIHNkYzogV3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkg
MTc6Mzk6MTUgcDM0IFsgICA1Ny41NTE1MDVdIFNDU0kgZGV2aWNlIHNkYzog
d3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRv
ZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE1IHAz
NCBbICAgNTcuNTUxNzI2XSAgc2RjOg0KTWF5IDI5IDE3OjM5OjE1IHAzNCAg
c2RjMQ0KTWF5IDI5IDE3OjM5OjE1IHAzNCAgDQpNYXkgMjkgMTc6Mzk6MTUg
cDM0IFsgICA1Ny41NjUzNjJdIHNkIDI6MDowOjA6IEF0dGFjaGVkIHNjc2kg
ZGlzayBzZGMgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny41Njc0NDdd
IHNjc2kgMzowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRBICAgICAgV0RD
IFdEMTUwMEFERkQtMCAyMC4wIFBROiAwIEFOU0k6IDUgDQpNYXkgMjkgMTc6
Mzk6MTUgcDM0IFsgICA1Ny41NjkzODRdIFNDU0kgZGV2aWNlIHNkZDogMjkz
MDQ2NzY4IDUxMi1ieXRlIGhkd3Igc2VjdG9ycyAoMTUwMDQwIE1CKSANCk1h
eSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU2OTcyNV0gc2RkOiBXcml0ZSBQ
cm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU3
MDIxOF0gU0NTSSBkZXZpY2Ugc2RkOiB3cml0ZSBjYWNoZTogZW5hYmxlZCwg
cmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBG
VUEgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny41NzExOTNdIFNDU0kg
ZGV2aWNlIHNkZDogMjkzMDQ2NzY4IDUxMi1ieXRlIGhkd3Igc2VjdG9ycyAo
MTUwMDQwIE1CKSANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU3MTUw
MF0gc2RkOiBXcml0ZSBQcm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOTox
NSBwMzQgWyAgIDU3LjU3MjAwM10gU0NTSSBkZXZpY2Ugc2RkOiB3cml0ZSBj
YWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBz
dXBwb3J0IERQTyBvciBGVUEgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1
Ny41NzIxNjJdICBzZGQ6DQpNYXkgMjkgMTc6Mzk6MTUgcDM0ICBzZGQxDQpN
YXkgMjkgMTc6Mzk6MTUgcDM0ICANCk1heSAyOSAxNzozOToxNSBwMzQgWyAg
IDU3LjU4NzQ0Ml0gc2QgMzowOjA6MDogQXR0YWNoZWQgc2NzaSBkaXNrIHNk
ZCANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU4OTQ3MF0gc2NzaSA0
OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBXREMgV0QxNTAw
QURGRC0wIDIwLjAgUFE6IDAgQU5TSTogNSANCk1heSAyOSAxNzozOToxNSBw
MzQgWyAgIDU3LjU5MTM1OV0gU0NTSSBkZXZpY2Ugc2RlOiAyOTMwNDY3Njgg
NTEyLWJ5dGUgaGR3ciBzZWN0b3JzICgxNTAwNDAgTUIpIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNTkxNjMyXSBzZGU6IFdyaXRlIFByb3RlY3Qg
aXMgb2ZmIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTkyMTQ3XSBT
Q1NJIGRldmljZSBzZGU6IHdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNh
Y2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQSANCk1h
eSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU5MzAzOF0gU0NTSSBkZXZpY2Ug
c2RlOiAyOTMwNDY3NjggNTEyLWJ5dGUgaGR3ciBzZWN0b3JzICgxNTAwNDAg
TUIpIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNTkzMzU3XSBzZGU6
IFdyaXRlIFByb3RlY3QgaXMgb2ZmIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBb
ICAgNTcuNTkzODI2XSBTQ1NJIGRldmljZSBzZGU6IHdyaXRlIGNhY2hlOiBl
bmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQg
RFBPIG9yIEZVQSANCk1heSAyOSAxNzozOToxNSBwMzQgWyAgIDU3LjU5NDAw
MV0gIHNkZToNCk1heSAyOSAxNzozOToxNSBwMzQgIHNkZTENCk1heSAyOSAx
NzozOToxNSBwMzQgIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNjA1
NDM4XSBzZCA0OjA6MDowOiBBdHRhY2hlZCBzY3NpIGRpc2sgc2RlIA0KTWF5
IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNjA3NjE3XSBzY3NpIDU6MDowOjA6
IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIFdEQyBXRDE1MDBBREZELTAg
MjAuMCBQUTogMCBBTlNJOiA1IA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAg
NTcuNjA5NDM3XSBTQ1NJIGRldmljZSBzZGY6IDI5MzA0Njc2OCA1MTItYnl0
ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTUg
cDM0IFsgICA1Ny42MDk3NzBdIHNkZjogV3JpdGUgUHJvdGVjdCBpcyBvZmYg
DQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny42MTAyODRdIFNDU0kgZGV2
aWNlIHNkZjogd3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVu
YWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNjExMjIxXSBTQ1NJIGRldmljZSBzZGY6IDI5
MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBNQikgDQpN
YXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny42MTE1MThdIHNkZjogV3JpdGUg
UHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny42
MTIwNDldIFNDU0kgZGV2aWNlIHNkZjogd3JpdGUgY2FjaGU6IGVuYWJsZWQs
IHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3Ig
RlVBIA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBbICAgNTcuNjEyMjI1XSAgc2Rm
Og0KTWF5IDI5IDE3OjM5OjE1IHAzNCAgc2RmMQ0KTWF5IDI5IDE3OjM5OjE1
IHAzNCAgDQpNYXkgMjkgMTc6Mzk6MTUgcDM0IFsgICA1Ny42MjM3MDldIHNk
IDU6MDowOjA6IEF0dGFjaGVkIHNjc2kgZGlzayBzZGYgDQpNYXkgMjkgMTc6
Mzk6MTUgcDM0IFsgICA1Ny42MjY1OTJdIEFDUEk6IFBDSSBJbnRlcnJ1cHQg
MDAwMDowMzowMC4wW0FdIC0+IA0KTWF5IDI5IDE3OjM5OjE1IHAzNCBHU0kg
MTggKGxldmVsLCBsb3cpIC0+IElSUSAxOCANCk1heSAyOSAxNzozOToxNSBw
MzQgWyAgIDU3LjYyODU2Ml0gYXRhNzogU0FUQSBtYXggVURNQS8xMDAgY21k
IDB4ZmZmZmMyMDAwMDEwODAwMCBjdGwgMHgwMDAwMDAwMDAwMDAwMDAwIGJt
ZG1hIDB4MDAwMDAwMDAwMDAwMDAwMCBpcnEgMTggDQpNYXkgMjkgMTc6Mzk6
MTUgcDM0IFsgICA1Ny42Mjk5MTVdIGF0YTg6IFNBVEEgbWF4IFVETUEvMTAw
IGNtZCAweGZmZmZjMjAwMDAxMGEwMDAgY3RsIDB4MDAwMDAwMDAwMDAwMDAw
MCBibWRtYSAweDAwMDAwMDAwMDAwMDAwMDAgaXJxIDE4IA0KTWF5IDI5IDE3
OjM5OjE1IHAzNCBbICAgNTcuNjMwMTg1XSBzY3NpNiA6IHNhdGFfc2lsMjQg
DQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC4wMzY5NjVdIGF0YTc6IFNB
VEEgbGluayB1cCAxLjUgR2JwcyAoU1N0YXR1cyAxMTMgU0NvbnRyb2wgMzAw
KSANCk1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjAzOTAwM10gYXRhNy4w
MDogQVRBLTc6IFdEQyBXRDE1MDBBREZELTAwTkxSMSwgMjAuMDdQMjAsIG1h
eCBVRE1BLzEzMyANCk1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjAzOTE1
M10gYXRhNy4wMDogMjkzMDQ2NzY4IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0
OCBOQ1EgKGRlcHRoIDMxLzMyKSANCk1heSAyOSAxNzozOToxNiBwMzQgWyAg
IDU4LjA0MjE2Ml0gYXRhNy4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMDAg
DQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC4wNDIzNDVdIHNjc2k3IDog
c2F0YV9zaWwyNCANCk1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjQ0ODIz
NF0gYXRhODogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3RhdHVzIDExMyBT
Q29udHJvbCAzMDApIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDUw
MzI1XSBhdGE4LjAwOiBBVEEtNzogV0RDIFdEMTUwMEFERkQtMDBOTFIxLCAy
MC4wN1AyMCwgbWF4IFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBb
ICAgNTguNDUwNDgwXSBhdGE4LjAwOiAyOTMwNDY3Njggc2VjdG9ycywgbXVs
dGkgMTY6IExCQTQ4IE5DUSAoZGVwdGggMzEvMzIpIA0KTWF5IDI5IDE3OjM5
OjE2IHAzNCBbICAgNTguNDUzNTI2XSBhdGE4LjAwOiBjb25maWd1cmVkIGZv
ciBVRE1BLzEwMCANCk1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjQ1NDY5
M10gc2NzaSA2OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBX
REMgV0QxNTAwQURGRC0wIDIwLjAgUFE6IDAgQU5TSTogNSANCk1heSAyOSAx
NzozOToxNiBwMzQgWyAgIDU4LjQ1NjY2Nl0gU0NTSSBkZXZpY2Ugc2RnOiAy
OTMwNDY3NjggNTEyLWJ5dGUgaGR3ciBzZWN0b3JzICgxNTAwNDAgTUIpIA0K
TWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDU2OTY0XSBzZGc6IFdyaXRl
IFByb3RlY3QgaXMgb2ZmIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTgu
NDU4MDQ1XSBTQ1NJIGRldmljZSBzZGc6IHdyaXRlIGNhY2hlOiBlbmFibGVk
LCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9y
IEZVQSANCk1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjQ1ODkxM10gU0NT
SSBkZXZpY2Ugc2RnOiAyOTMwNDY3NjggNTEyLWJ5dGUgaGR3ciBzZWN0b3Jz
ICgxNTAwNDAgTUIpIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDU5
MjAzXSBzZGc6IFdyaXRlIFByb3RlY3QgaXMgb2ZmIA0KTWF5IDI5IDE3OjM5
OjE2IHAzNCBbICAgNTguNDU5NzU0XSBTQ1NJIGRldmljZSBzZGc6IHdyaXRl
IGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBkb2Vzbid0
IHN1cHBvcnQgRFBPIG9yIEZVQSANCk1heSAyOSAxNzozOToxNiBwMzQgWyAg
IDU4LjQ1OTkxOF0gIHNkZzoNCk1heSAyOSAxNzozOToxNiBwMzQgIHNkZzEN
Ck1heSAyOSAxNzozOToxNiBwMzQgIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBb
ICAgNTguNDc0MTk5XSBzZCA2OjA6MDowOiBBdHRhY2hlZCBzY3NpIGRpc2sg
c2RnIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDc2NDE2XSBzY3Np
IDc6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIFdEQyBXRDE1
MDBBREZELTAgMjAuMCBQUTogMCBBTlNJOiA1IA0KTWF5IDI5IDE3OjM5OjE2
IHAzNCBbICAgNTguNDc4MzU2XSBTQ1NJIGRldmljZSBzZGg6IDI5MzA0Njc2
OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBNQikgDQpNYXkgMjkg
MTc6Mzk6MTYgcDM0IFsgICA1OC40Nzg3MTFdIHNkaDogV3JpdGUgUHJvdGVj
dCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC40NzkxNzdd
IFNDU0kgZGV2aWNlIHNkaDogd3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQg
Y2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBIA0K
TWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDgwMDc1XSBTQ1NJIGRldmlj
ZSBzZGg6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0
MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC40ODA0MDJdIHNk
aDogV3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0
IFsgICA1OC40ODA5MjhdIFNDU0kgZGV2aWNlIHNkaDogd3JpdGUgY2FjaGU6
IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9y
dCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguNDgx
MDc1XSAgc2RoOg0KTWF5IDI5IDE3OjM5OjE2IHAzNCAgc2RoMQ0KTWF5IDI5
IDE3OjM5OjE2IHAzNCAgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC40
OTU1ODZdIHNkIDc6MDowOjA6IEF0dGFjaGVkIHNjc2kgZGlzayBzZGggDQpN
YXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC40OTY3ODZdIEFDUEk6IFBDSSBJ
bnRlcnJ1cHQgMDAwMDowNDowMC4wW0FdIC0+IA0KTWF5IDI5IDE3OjM5OjE2
IHAzNCBHU0kgMTkgKGxldmVsLCBsb3cpIC0+IElSUSAxOSANCk1heSAyOSAx
NzozOToxNiBwMzQgWyAgIDU4LjQ5ODI1OF0gYXRhOTogU0FUQSBtYXggVURN
QS8xMDAgY21kIDB4ZmZmZmMyMDAwMDExMDAwMCBjdGwgMHgwMDAwMDAwMDAw
MDAwMDAwIGJtZG1hIDB4MDAwMDAwMDAwMDAwMDAwMCBpcnEgMTkgDQpNYXkg
MjkgMTc6Mzk6MTYgcDM0IFsgICA1OC40OTk2MDFdIGF0YTEwOiBTQVRBIG1h
eCBVRE1BLzEwMCBjbWQgMHhmZmZmYzIwMDAwMTEyMDAwIGN0bCAweDAwMDAw
MDAwMDAwMDAwMDAgYm1kbWEgMHgwMDAwMDAwMDAwMDAwMDAwIGlycSAxOSAN
Ck1heSAyOSAxNzozOToxNiBwMzQgWyAgIDU4LjQ5OTgzMV0gc2NzaTggOiBz
YXRhX3NpbDI0IA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguOTA2NzY2
XSBhdGE5OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFND
b250cm9sIDMwMCkgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsgICA1OC45MDg1
NDBdIGF0YTkuMDA6IEFUQS03OiBXREMgV0QxNTAwQURGRC0wME5MUjEsIDIw
LjA3UDIwLCBtYXggVURNQS8xMzMgDQpNYXkgMjkgMTc6Mzk6MTYgcDM0IFsg
ICA1OC45MDg2OThdIGF0YTkuMDA6IDI5MzA0Njc2OCBzZWN0b3JzLCBtdWx0
aSAxNjogTEJBNDggTkNRIChkZXB0aCAzMS8zMikgDQpNYXkgMjkgMTc6Mzk6
MTYgcDM0IFsgICA1OC45MTEzMjNdIGF0YTkuMDA6IGNvbmZpZ3VyZWQgZm9y
IFVETUEvMTAwIA0KTWF5IDI5IDE3OjM5OjE2IHAzNCBbICAgNTguOTExNTQ1
XSBzY3NpOSA6IHNhdGFfc2lsMjQgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsg
ICA1OS4zMTc5NThdIGF0YTEwOiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNT
dGF0dXMgMTEzIFNDb250cm9sIDMwMCkgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0
IFsgICA1OS4zMTk3NTldIGF0YTEwLjAwOiBBVEEtNzogV0RDIFdEMTUwMEFE
RkQtMDBOTFIxLCAyMC4wN1AyMCwgbWF4IFVETUEvMTMzIA0KTWF5IDI5IDE3
OjM5OjE3IHAzNCBbICAgNTkuMzE5ODkyXSBhdGExMC4wMDogMjkzMDQ2NzY4
IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSAN
Ck1heSAyOSAxNzozOToxNyBwMzQgWyAgIDU5LjMyMjUzMl0gYXRhMTAuMDA6
IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTAwIA0KTWF5IDI5IDE3OjM5OjE3IHAz
NCBbICAgNTkuMzIzNzM5XSBzY3NpIDg6MDowOjA6IERpcmVjdC1BY2Nlc3Mg
ICAgIEFUQSAgICAgIFdEQyBXRDE1MDBBREZELTAgMjAuMCBQUTogMCBBTlNJ
OiA1IA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBbICAgNTkuMzI1NjU3XSBTQ1NJ
IGRldmljZSBzZGk6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMg
KDE1MDA0MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zMjU5
NjRdIHNkaTogV3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6
MTcgcDM0IFsgICA1OS4zMjY1MDBdIFNDU0kgZGV2aWNlIHNkaTogd3JpdGUg
Y2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qg
c3VwcG9ydCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBbICAg
NTkuMzI3Mzg4XSBTQ1NJIGRldmljZSBzZGk6IDI5MzA0Njc2OCA1MTItYnl0
ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTcg
cDM0IFsgICA1OS4zMjc3MDddIHNkaTogV3JpdGUgUHJvdGVjdCBpcyBvZmYg
DQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zMjgyMDNdIFNDU0kgZGV2
aWNlIHNkaTogd3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVu
YWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3
OjM5OjE3IHAzNCBbICAgNTkuMzI4MzgwXSAgc2RpOg0KTWF5IDI5IDE3OjM5
OjE3IHAzNCAgc2RpMQ0KTWF5IDI5IDE3OjM5OjE3IHAzNCAgDQpNYXkgMjkg
MTc6Mzk6MTcgcDM0IFsgICA1OS4zNDA2MzldIHNkIDg6MDowOjA6IEF0dGFj
aGVkIHNjc2kgZGlzayBzZGkgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1
OS4zNDI3NzVdIHNjc2kgOTowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQVRB
ICAgICAgV0RDIFdEMTUwMEFERkQtMCAyMC4wIFBROiAwIEFOU0k6IDUgDQpN
YXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zNDQ3NzZdIFNDU0kgZGV2aWNl
IHNkajogMjkzMDQ2NzY4IDUxMi1ieXRlIGhkd3Igc2VjdG9ycyAoMTUwMDQw
IE1CKSANCk1heSAyOSAxNzozOToxNyBwMzQgWyAgIDU5LjM0NTEwM10gc2Rq
OiBXcml0ZSBQcm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOToxNyBwMzQg
WyAgIDU5LjM0NTYwOF0gU0NTSSBkZXZpY2Ugc2RqOiB3cml0ZSBjYWNoZTog
ZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0
IERQTyBvciBGVUEgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zNDY0
ODldIFNDU0kgZGV2aWNlIHNkajogMjkzMDQ2NzY4IDUNCk1heSAyOSAxNzoz
OToxNyBwMzQgMTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0MCBNQikgDQpN
YXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zNDY4NTBdIHNkajogV3JpdGUg
UHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4z
NDczOTNdIFNDU0kgZGV2aWNlIHNkajogd3JpdGUgY2FjaGU6IGVuYWJsZWQs
IHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3Ig
RlVBIA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBbICAgNTkuMzQ3NTUyXSAgc2Rq
Og0KTWF5IDI5IDE3OjM5OjE3IHAzNCAgc2RqMQ0KTWF5IDI5IDE3OjM5OjE3
IHAzNCAgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS4zNjIxNDhdIHNk
IDk6MDowOjA6IEF0dGFjaGVkIHNjc2kgZGlzayBzZGogDQpNYXkgMjkgMTc6
Mzk6MTcgcDM0IFsgICA1OS4zNjMzODddIEFDUEk6IFBDSSBJbnRlcnJ1cHQg
MDAwMDowNTowMC4wW0FdIC0+IA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBHU0kg
MTYgKGxldmVsLCBsb3cpIC0+IElSUSAxNiANCk1heSAyOSAxNzozOToxNyBw
MzQgWyAgIDU5LjM2NTE3OV0gYXRhMTE6IFNBVEEgbWF4IFVETUEvMTAwIGNt
ZCAweGZmZmZjMjAwMDAxMTgwMDAgY3RsIDB4MDAwMDAwMDAwMDAwMDAwMCBi
bWRtYSAweDAwMDAwMDAwMDAwMDAwMDAgaXJxIDE2IA0KTWF5IDI5IDE3OjM5
OjE3IHAzNCBbICAgNTkuMzY3MTQzXSBhdGExMjogU0FUQSBtYXggVURNQS8x
MDAgY21kIDB4ZmZmZmMyMDAwMDExYTAwMCBjdGwgMHgwMDAwMDAwMDAwMDAw
MDAwIGJtZG1hIDB4MDAwMDAwMDAwMDAwMDAwMCBpcnEgMTYgDQpNYXkgMjkg
MTc6Mzk6MTcgcDM0IFsgICA1OS4zNjc0MzJdIHNjc2kxMCA6IHNhdGFfc2ls
MjQgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS43NzUzNjNdIGF0YTEx
OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFNDb250cm9s
IDMwMCkgDQpNYXkgMjkgMTc6Mzk6MTcgcDM0IFsgICA1OS43Nzc0MzVdIGF0
YTExLjAwOiBBVEEtNzogV0RDIFdEMTUwMEFERkQtMDBOTFIxLCAyMC4wN1Ay
MCwgbWF4IFVETUEvMTMzIA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBbICAgNTku
Nzc3NTY1XSBhdGExMS4wMDogMjkzMDQ2NzY4IHNlY3RvcnMsIG11bHRpIDE2
OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSANCk1heSAyOSAxNzozOToxNyBw
MzQgWyAgIDU5Ljc4MDU5OV0gYXRhMTEuMDA6IGNvbmZpZ3VyZWQgZm9yIFVE
TUEvMTAwIA0KTWF5IDI5IDE3OjM5OjE3IHAzNCBbICAgNTkuNzgwNzk4XSBz
Y3NpMTEgOiBzYXRhX3NpbDI0IA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAg
NjAuMTg3NTgwXSBhdGExMjogU0FUQSBsaW5rIHVwIDEuNSBHYnBzIChTU3Rh
dHVzIDExMyBTQ29udHJvbCAzMDApIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBb
ICAgNjAuMTg5NjI1XSBhdGExMi4wMDogQVRBLTc6IFdEQyBXRDE1MDBBREZE
LTAwTkxSMSwgMjAuMDdQMjAsIG1heCBVRE1BLzEzMyANCk1heSAyOSAxNzoz
OToxOCBwMzQgWyAgIDYwLjE4OTc2OV0gYXRhMTIuMDA6IDI5MzA0Njc2OCBz
ZWN0b3JzLCBtdWx0aSAxNjogTEJBNDggTkNRIChkZXB0aCAzMS8zMikgDQpN
YXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC4xOTI3OTZdIGF0YTEyLjAwOiBj
b25maWd1cmVkIGZvciBVRE1BLzEwMCANCk1heSAyOSAxNzozOToxOCBwMzQg
WyAgIDYwLjE5Mzk3NF0gc2NzaSAxMDowOjA6MDogRGlyZWN0LUFjY2VzcyAg
ICAgQVRBICAgICAgV0RDIFdEMTUwMEFERkQtMCAyMC4wIFBROiAwIEFOU0k6
IDUgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC4xOTU4MzJdIFNDU0kg
ZGV2aWNlIHNkazogMjkzMDQ2NzY4IDUxMi1ieXRlIGhkd3Igc2VjdG9ycyAo
MTUwMDQwIE1CKSANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjE5NjEy
N10gc2RrOiBXcml0ZSBQcm90ZWN0IGlzIG9mZiANCk1heSAyOSAxNzozOTox
OCBwMzQgWyAgIDYwLjE5NjYxNF0gU0NTSSBkZXZpY2Ugc2RrOiB3cml0ZSBj
YWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBz
dXBwb3J0IERQTyBvciBGVUEgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2
MC4xOTc1MTRdIFNDU0kgZGV2aWNlIHNkazogMjkzMDQ2NzY4IDUxMi1ieXRl
IGhkd3Igc2VjdG9ycyAoMTUwMDQwIE1CKSANCk1heSAyOSAxNzozOToxOCBw
MzQgWyAgIDYwLjE5Nzg0NV0gc2RrOiBXcml0ZSBQcm90ZWN0IGlzIG9mZiAN
Ck1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjE5ODMzM10gU0NTSSBkZXZp
Y2Ugc2RrOiB3cml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5h
YmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUEgDQpNYXkgMjkgMTc6
Mzk6MTggcDM0IFsgICA2MC4xOTg1MDddICBzZGs6DQpNYXkgMjkgMTc6Mzk6
MTggcDM0ICBzZGsxDQpNYXkgMjkgMTc6Mzk6MTggcDM0ICANCk1heSAyOSAx
NzozOToxOCBwMzQgWyAgIDYwLjIxMjc0OF0gc2QgMTA6MDowOjA6IEF0dGFj
aGVkIHNjc2kgZGlzayBzZGsgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2
MC4yMTQ5MzRdIHNjc2kgMTE6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFU
QSAgICAgIFdEQyBXRDE1MDBBREZELTAgMjAuMCBQUTogMCBBTlNJOiA1IA0K
TWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuMjE2OTIzXSBTQ1NJIGRldmlj
ZSBzZGw6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdyIHNlY3RvcnMgKDE1MDA0
MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC4yMTcyNzFdIHNk
bDogV3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkgMjkgMTc6Mzk6MTggcDM0
IFsgICA2MC4yMTc3NzRdIFNDU0kgZGV2aWNlIHNkbDogd3JpdGUgY2FjaGU6
IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9y
dCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuMjE4
NjY1XSBTQ1NJIGRldmljZSBzZGw6IDI5MzA0Njc2OCA1MTItYnl0ZSBoZHdy
IHNlY3RvcnMgKDE1MDA0MCBNQikgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsg
ICA2MC4yMTg5NzRdIHNkbDogV3JpdGUgUHJvdGVjdCBpcyBvZmYgDQpNYXkg
MjkgMTc6Mzk6MTggcDM0IFsgICA2MC4yMTk0OTddIFNDU0kgZGV2aWNlIHNk
bDogd3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQs
IGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBIA0KTWF5IDI5IDE3OjM5OjE4
IHAzNCBbICAgNjAuMjE5NjcxXSAgc2RsOg0KTWF5IDI5IDE3OjM5OjE4IHAz
NCAgc2RsMQ0KTWF5IDI5IDE3OjM5OjE4IHAzNCAgDQpNYXkgMjkgMTc6Mzk6
MTggcDM0IFsgICA2MC4yMzQzNjddIHNkIDExOjA6MDowOiBBdHRhY2hlZCBz
Y3NpIGRpc2sgc2RsIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuMjM2
MzE3XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDI6MDAuMFtBXSAtPiAN
Ck1heSAyOSAxNzozOToxOCBwMzQgR1NJIDE3IChsZXZlbCwgbG93KSAtPiBJ
UlEgMTcgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC4yMzczNjVdIGF0
YTEzOiBQQVRBIG1heCBVRE1BLzEwMCBjbWQgMHgwMDAwMDAwMDAwMDE1MDE4
IGN0bCAweDAwMDAwMDAwMDAwMTUwMjYgYm1kbWEgMHgwMDAwMDAwMDAwMDE1
MDAwIGlycSAxNyANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjIzNzYz
MV0gc2NzaTEyIDogcGF0YV9tYXJ2ZWxsIA0KTWF5IDI5IDE3OjM5OjE4IHAz
NCBbICAgNjAuMjM5MjY2XSBCQVI1Og0KTWF5IDI5IDE3OjM5OjE4IHAzNCAw
MDowMCANCk1heSAyOSAxNzozOToxOCBwMzQgMDE6N0YgDQpNYXkgMjkgMTc6
Mzk6MTggcDM0IDAyOjIyIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCAwMzpDQSAN
Ck1heSAyOSAxNzozOToxOCBwMzQgMDQ6MDAgDQpNYXkgMjkgMTc6Mzk6MTgg
cDM0IDA1OjAwIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCAwNjowMCANCk1heSAy
OSAxNzozOToxOCBwMzQgMDc6MDAgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IDA4
OjAwIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCAwOTowMCANCk1heSAyOSAxNzoz
OToxOCBwMzQgMEE6MDAgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IDBCOjAwIA0K
TWF5IDI5IDE3OjM5OjE4IHAzNCAwQzowMSANCk1heSAyOSAxNzozOToxOCBw
MzQgMEQ6MDAgDQpNYXkgMjkgMTc6Mzk6MTggcDM0IDBFOjAwIA0KTWF5IDI5
IDE3OjM5OjE4IHAzNCAwRjowMCANCk1heSAyOSAxNzozOToxOCBwMzQgIA0K
TWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuNTQ1ODI4XSBhdGExMy4wMDog
QVRBUEksIG1heCBVRE1BLzMzIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAg
NjAuNzAxNTMwXSBhdGExMy4wMDogY29uZmlndXJlZCBmb3IgVURNQS8zMyAN
Ck1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjcwMzk0Ml0gc2NzaSAxMjow
OjA6MDogQ0QtUk9NICAgICAgICAgICAgX05FQyAgICAgRFZEX1JXIE5ELTM1
MjBBICAxLjA0IFBROiAwIEFOU0k6IDUgDQpNYXkgMjkgMTc6Mzk6MTggcDM0
IFsgICA2MC43MTE0MTFdIHNyMDogc2NzaTMtbW1jIGRyaXZlOiA0OHgvNDh4
IHdyaXRlciBjZC9ydyB4YS9mb3JtMiBjZGRhIHRyYXkgDQpNYXkgMjkgMTc6
Mzk6MTggcDM0IFsgICA2MC43MTE1NDVdIFVuaWZvcm0gQ0QtUk9NIGRyaXZl
ciBSZXZpc2lvbjogMy4yMCANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYw
LjcxNDY5NF0gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFhLjdbQ10g
LT4gDQpNYXkgMjkgMTc6Mzk6MTggcDM0IEdTSSAxOCAobGV2ZWwsIGxvdykg
LT4gSVJRIDE4IA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuNzE1MDgz
XSBlaGNpX2hjZCAwMDAwOjAwOjFhLjc6IEVIQ0kgSG9zdCBDb250cm9sbGVy
IA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuNzE2MDY5XSBlaGNpX2hj
ZCAwMDAwOjAwOjFhLjc6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2ln
bmVkIGJ1cyBudW1iZXIgMSANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYw
LjcxNjU2Ml0gZWhjaV9oY2QgMDAwMDowMDoxYS43OiBkZWJ1ZyBwb3J0IDEg
DQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC43MTY4MTBdIGVoY2lfaGNk
IDAwMDA6MDA6MWEuNzogaXJxIDE4LCBpbyBtZW0gMHhlMDYyNWMwMCANCk1h
eSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjcyMDgxNF0gZWhjaV9oY2QgMDAw
MDowMDoxYS43OiBVU0IgMi4wIHN0YXJ0ZWQsIEVIQ0kgMS4wMCwgZHJpdmVy
IDEwIERlYyAyMDA0IA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuNzIz
NjQ3XSB1c2IgdXNiMTogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4gZnJvbSAx
IGNob2ljZSANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjcyNDcwNl0g
aHViIDEtMDoxLjA6IFVTQiBodWIgZm91bmQgDQpNYXkgMjkgMTc6Mzk6MTgg
cDM0IFsgICA2MC43MjQ5MDFdIGh1YiAxLTA6MS4wOiA0IHBvcnRzIGRldGVj
dGVkIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuODI5MTY1XSBBQ1BJ
OiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6MWQuN1tBXSAtPiANCk1heSAyOSAx
NzozOToxOCBwMzQgR1NJIDIzIChsZXZlbCwgbG93KSAtPiBJUlEgMjMgDQpN
YXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC44Mjk1ODNdIGVoY2lfaGNkIDAw
MDA6MDA6MWQuNzogRUhDSSBIb3N0IENvbnRyb2xsZXIgDQpNYXkgMjkgMTc6
Mzk6MTggcDM0IFsgICA2MC44MzA0NTFdIGVoY2lfaGNkIDAwMDA6MDA6MWQu
NzogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJl
ciAyIA0KTWF5IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuODMwOTg2XSBlaGNp
X2hjZCAwMDAwOjAwOjFkLjc6IGRlYnVnIHBvcnQgMSANCk1heSAyOSAxNzoz
OToxOCBwMzQgWyAgIDYwLjgzMTIyOV0gZWhjaV9oY2QgMDAwMDowMDoxZC43
OiBpcnEgMjMsIGlvIG1lbSAweGUwNjI1ODAwIA0KTWF5IDI5IDE3OjM5OjE4
IHAzNCBbICAgNjAuODM1MjYxXSBlaGNpX2hjZCAwMDAwOjAwOjFkLjc6IFVT
QiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwLCBkcml2ZXIgMTAgRGVjIDIwMDQg
DQpNYXkgMjkgMTc6Mzk6MTggcDM0IFsgICA2MC44Mzc5NzFdIHVzYiB1c2Iy
OiBjb25maWd1cmF0aW9uICMxIGNob3NlbiBmcm9tIDEgY2hvaWNlIA0KTWF5
IDI5IDE3OjM5OjE4IHAzNCBbICAgNjAuODM5MDI0XSBodWIgMi0wOjEuMDog
VVNCIGh1YiBmb3VuZCANCk1heSAyOSAxNzozOToxOCBwMzQgWyAgIDYwLjgz
OTI0MV0gaHViIDItMDoxLjA6IDYgcG9ydHMgZGV0ZWN0ZWQgDQpNYXkgMjkg
MTc6Mzk6MTkgcDM0IFsgICA2MC45NDI4NDldIFVTQiBVbml2ZXJzYWwgSG9z
dCBDb250cm9sbGVyIEludGVyZmFjZSBkcml2ZXIgdjMuMCANCk1heSAyOSAx
NzozOToxOSBwMzQgWyAgIDYwLjk0MzkxMl0gQUNQSTogUENJIEludGVycnVw
dCAwMDAwOjAwOjFhLjBbQV0gLT4gDQpNYXkgMjkgMTc6Mzk6MTkgcDM0IEdT
SSAxNiAobGV2ZWwsIGxvdykgLT4gSVJRIDE2IA0KTWF5IDI5IDE3OjM5OjE5
IHAzNCBbICAgNjAuOTQ0MjUwXSB1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IFVI
Q0kgSG9zdCBDb250cm9sbGVyIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAg
NjAuOTQ1MDgxXSB1aGNpX2hjZCAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVz
IHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMyANCk1heSAyOSAx
NzozOToxOSBwMzQgWyAgIDYwLjk0NTMzOF0gdWhjaV9oY2QgMDAwMDowMDox
YS4wOiBpcnEgMTYsIGlvIGJhc2UgMHgwMDAwNjBjMCANCk1heSAyOSAxNzoz
OToxOSBwMzQgWyAgIDYwLjk0ODU2Ml0gdXNiIHVzYjM6IGNvbmZpZ3VyYXRp
b24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UgDQpNYXkgMjkgMTc6Mzk6MTkg
cDM0IFsgICA2MC45NDk2MzldIGh1YiAzLTA6MS4wOiBVU0IgaHViIGZvdW5k
IA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjAuOTQ5ODMyXSBodWIgMy0w
OjEuMDogMiBwb3J0cyBkZXRlY3RlZCANCk1heSAyOSAxNzozOToxOSBwMzQg
WyAgIDYxLjA1Mzc2OF0gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFh
LjFbQl0gLT4gDQpNYXkgMjkgMTc6Mzk6MTkgcDM0IEdTSSAyMSAobGV2ZWws
IGxvdykgLT4gSVJRIDIxIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEu
MDU0MDk4XSB1aGNpX2hjZCAwMDAwOjAwOjFhLjE6IFVIQ0kgSG9zdCBDb250
cm9sbGVyIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuMDU0OTM3XSB1
aGNpX2hjZCAwMDAwOjAwOjFhLjE6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQs
IGFzc2lnbmVkIGJ1cyBudW1iZXIgNCANCk1heSAyOSAxNzozOToxOSBwMzQg
WyAgIDYxLjA1NTE4N10gdWhjaV9oY2QgMDAwMDowMDoxYS4xOiBpcnEgMjEs
IGlvIGJhc2UgMHgwMDAwNjBhMCANCk1heSAyOSAxNzozOToxOSBwMzQgWyAg
IDYxLjA1ODE3OV0gdXNiIHVzYjQ6IGNvbmZpZ3VyYXRpb24gIzEgY2hvc2Vu
IGZyb20gMSBjaG9pY2UgDQpNYXkgMjkgMTc6Mzk6MTkgcDM0IFsgICA2MS4w
NTkzMjBdIGh1YiA0LTA6MS4wOiBVU0IgaHViIGZvdW5kIA0KTWF5IDI5IDE3
OjM5OjE5IHAzNCBbICAgNjEuMDU5NTAwXSBodWIgNC0wOjEuMDogMiBwb3J0
cyBkZXRlY3RlZCANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjE2MjU5
NF0gQUNQSTogUENJIEludGVycnVwdCAwMDAwOjAwOjFkLjBbQV0gLT4gDQpN
YXkgMjkgMTc6Mzk6MTkgcDM0IEdTSSAyMyAobGV2ZWwsIGxvdykgLT4gSVJR
IDIzIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuMTYyOTQ0XSB1aGNp
X2hjZCAwMDAwOjAwOjFkLjA6IFVIQ0kgSG9zdCBDb250cm9sbGVyIA0KTWF5
IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuMTYzNzUxXSB1aGNpX2hjZCAwMDAw
OjAwOjFkLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1
cyBudW1iZXIgNSANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjE2NDAz
OV0gdWhjaV9oY2QgMDAwMDowMDoxZC4wOiBpcnEgMjMsIGlvIGJhc2UgMHgw
MDAwNjA4MCANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjE2Njk5Nl0g
dXNiIHVzYjU6IGNvbmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9p
Y2UgDQpNYXkgMjkgMTc6Mzk6MTkgcDM0IFsgICA2MS4xNjgxMzJdIGh1YiA1
LTA6MS4wOiBVU0IgaHViIGZvdW5kIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBb
ICAgNjEuMTY4MzIwXSBodWIgNS0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZCAN
Ck1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjI3MTI1M10gQUNQSTogUENJ
IEludGVycnVwdCAwMDAwOjAwOjFkLjFbQl0gLT4gDQpNYXkgMjkgMTc6Mzk6
MTkgcDM0IEdTSSAxOSAobGV2ZWwsIGxvdykgLT4gSVJRIDE5IA0KTWF5IDI5
IDE3OjM5OjE5IHAzNCBbICAgNjEuMjcxNTg3XSB1aGNpX2hjZCAwMDAwOjAw
OjFkLjE6IFVIQ0kgSG9zdCBDb250cm9sbGVyIA0KTWF5IDI5IDE3OjM5OjE5
IHAzNCBbICAgNjEuMjcyNTAxXSB1aGNpX2hjZCAwMDAwOjAwOjFkLjE6IG5l
dyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNiAN
Ck1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjI3Mjc1N10gdWhjaV9oY2Qg
MDAwMDowMDoxZC4xOiBpcnEgMTksIGlvIGJhc2UgMHgwMDAwNjA2MCANCk1h
eSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjI3NTc1NF0gdXNiIHVzYjY6IGNv
bmZpZ3VyYXRpb24gIzEgY2hvc2VuIGZyb20gMSBjaG9pY2UgDQpNYXkgMjkg
MTc6Mzk6MTkgcDM0IFsgICA2MS4yNzY4NjldIGh1YiA2LTA6MS4wOiBVU0Ig
aHViIGZvdW5kIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuMjc3MDQy
XSBodWIgNi0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZCANCk1heSAyOSAxNzoz
OToxOSBwMzQgWyAgIDYxLjM3OTk5OV0gQUNQSTogUENJIEludGVycnVwdCAw
MDAwOjAwOjFkLjJbQ10gLT4gDQpNYXkgMjkgMTc6Mzk6MTkgcDM0IEdTSSAx
OCAobGV2ZWwsIGxvdykgLT4gSVJRIDE4IA0KTWF5IDI5IDE3OjM5OjE5IHAz
NCBbICAgNjEuMzgwMzMxXSB1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IFVIQ0kg
SG9zdCBDb250cm9sbGVyIA0KTWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEu
MzgxMjExXSB1aGNpX2hjZCAwMDAwOjAwOjFkLjI6IG5ldyBVU0IgYnVzIHJl
Z2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNyANCk1heSAyOSAxNzoz
OToxOSBwMzQgWyAgIDYxLjM4MTQ2NF0gdWhjaV9oY2QgMDAwMDowMDoxZC4y
OiBpcnEgMTgsIGlvIGJhc2UgMHgwMDAwNjA0MCANCk1heSAyOSAxNzozOTox
OSBwMzQgWyAgIDYxLjM4NTAyN10gdXNiIHVzYjc6IGNvbmZpZ3VyYXRpb24g
IzEgY2hvc2VuIGZyb20gMSBjaG9pY2UgDQpNYXkgMjkgMTc6Mzk6MTkgcDM0
IFsgICA2MS4zODYxMzldIGh1YiA3LTA6MS4wOiBVU0IgaHViIGZvdW5kIA0K
TWF5IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuMzg2MzEzXSBodWIgNy0wOjEu
MDogMiBwb3J0cyBkZXRlY3RlZCANCk1heSAyOSAxNzozOToxOSBwMzQgWyAg
IDYxLjQ3NzY5N10gdXNiIDUtMTogbmV3IGxvdyBzcGVlZCBVU0IgZGV2aWNl
IHVzaW5nIHVoY2lfaGNkIGFuZCBhZGRyZXNzIDIgDQpNYXkgMjkgMTc6Mzk6
MTkgcDM0IFsgICA2MS40ODk5MTVdIEluaXRpYWxpemluZyBVU0IgTWFzcyBT
dG9yYWdlIGRyaXZlci4uLiANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYx
LjY0MTk2Nl0gdXNiIDUtMTogY29uZmlndXJhdGlvbiAjMSBjaG9zZW4gZnJv
bSAxIGNob2ljZSANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjY0Nzk3
NF0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1
c2Itc3RvcmFnZSANCk1heSAyOSAxNzozOToxOSBwMzQgWyAgIDYxLjY0ODEy
NF0gVVNCIE1hc3MgU3RvcmFnZSBzdXBwb3J0IHJlZ2lzdGVyZWQuIA0KTWF5
IDI5IDE3OjM5OjE5IHAzNCBbICAgNjEuNjQ5NjgxXSB1c2Jjb3JlOiByZWdp
c3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIGhpZGRldiANCk1heSAyOSAx
NzozOToyMCBwMzQgWyAgIDYyLjE0NjIxMV0gDQpNYXkgMjkgMTc6Mzk6MjAg
cDM0IGhpZGRldjk2DQpNYXkgMjkgMTc6Mzk6MjAgcDM0IDogVVNCIEhJRCB2
MS4wMCBEZXZpY2UgWyAgICAgICAgVVBTXSBvbiB1c2ItMDAwMDowMDoxZC4w
LTEgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4xNDY2MTFdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkIA0K
TWF5IDI5IDE3OjM5OjIwIHAzNCBbICAgNjIuMTQ2NzQ3XSBkcml2ZXJzL3Vz
Yi9pbnB1dC9oaWQtY29yZS5jOiB2Mi42OlVTQiBISUQgY29yZSBkcml2ZXIg
DQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4xNDgzMjldIFBOUDogUFMv
MiBDb250cm9sbGVyIFtQTlAwMzAzOlBTMkssUE5QMGYwMzpQUzJNXSBhdCAw
eDYwLDB4NjQgaXJxIDEsMTIgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2
Mi4xNTI1NzRdIHNlcmlvOiBpODA0MiBLQkQgcG9ydCBhdCAweDYwLDB4NjQg
aXJxIDEgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4xNTI3MzldIHNl
cmlvOiBpODA0MiBBVVggcG9ydCBhdCAweDYwLDB4NjQgaXJxIDEyIA0KTWF5
IDI5IDE3OjM5OjIwIHAzNCBbICAgNjIuMTUzNzA5XSBtaWNlOiBQUy8yIG1v
dXNlIGRldmljZSBjb21tb24gZm9yIGFsbCBtaWNlIA0KTWF5IDI5IDE3OjM5
OjIwIHAzNCBbICAgNjIuMTU3MzUzXSBpbnB1dDogUEMgU3BlYWtlciBhcyAv
Y2xhc3MvaW5wdXQvaW5wdXQwIA0KTWF5IDI5IDE3OjM5OjIwIHAzNCBbICAg
NjIuMTU3NTY5XSBpMmMgL2RldiBlbnRyaWVzIGRyaXZlciANCk1heSAyOSAx
NzozOToyMCBwMzQgWyAgIDYyLjE1ODQyNF0gbWQ6IHJhaWQxIHBlcnNvbmFs
aXR5IHJlZ2lzdGVyZWQgZm9yIGxldmVsIDEgDQpNYXkgMjkgMTc6Mzk6MjAg
cDM0IFsgICA2Mi4xNzQ3NDVdIHJhaWQ2OiBpbnQ2NHgxICAgICA2MiBNQi9z
IA0KTWF5IDI5IDE3OjM5OjIwIHAzNCBbICAgNjIuMTc4NjkyXSBpbnB1dDog
QVQgVHJhbnNsYXRlZCBTZXQgMiBrZXlib2FyZCBhcyAvY2xhc3MvaW5wdXQv
aW5wdXQxIA0KTWF5IDI5IDE3OjM5OjIwIHAzNCBbICAgNjIuMTkyMDE5XSBy
YWlkNjogaW50NjR4MiAgICAgODkgTUIvcyANCk1heSAyOSAxNzozOToyMCBw
MzQgWyAgIDYyLjIwOTAyM10gcmFpZDY6IGludDY0eDQgICAgIDMxIE1CL3Mg
DQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4yMjU3NzddIHJhaWQ2OiBp
bnQ2NHg4ICAgICAxMSBNQi9zIA0KTWF5IDI5IDE3OjM5OjIwIHAzNCBbICAg
NjIuMjQyODU0XSByYWlkNjogc3NlMngxICAgICAxNDggTUIvcyANCk1heSAy
OSAxNzozOToyMCBwMzQgWyAgIDYyLjI1OTYzNl0gcmFpZDY6IHNzZTJ4MiAg
ICAgMjY5IE1CL3MgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4yNzY2
NTBdIHJhaWQ2OiBzc2UyeDQgICAgIDQ2MCBNQi9zIA0KTWF5IDI5IDE3OjM5
OjIwIHAzNCBbICAgNjIuMjc2Nzg5XSByYWlkNjogdXNpbmcgYWxnb3JpdGht
IHNzZTJ4NCAoNDYwIE1CL3MpIA0KTWF5IDI5IDE3OjM5OjIwIHAzNCBbICAg
NjIuMjc2OTM3XSBtZDogcmFpZDYgcGVyc29uYWxpdHkgcmVnaXN0ZXJlZCBm
b3IgbGV2ZWwgNiANCk1heSAyOSAxNzozOToyMCBwMzQgWyAgIDYyLjI3NzA1
M10gbWQ6IHJhaWQ1IHBlcnNvbmFsaXR5IHJlZ2lzdGVyZWQgZm9yIGxldmVs
IDUgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4yNzcxOTFdIG1kOiBy
YWlkNCBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZvciBsZXZlbCA0IA0KTWF5
IDI5IDE3OjM5OjIwIHAzNCBbICAgNjIuMjc3MzQ2XSByYWlkNTogYXV0b21h
dGljYWxseSB1c2luZyBiZXN0IGNoZWNrc3VtbWluZyBmdW5jdGlvbjogZ2Vu
ZXJpY19zc2UgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2Mi4yODE2NTdd
ICAgIGdlbmVyaWNfc3NlOiAgICA1Ni4wMDAgTUIvc2VjIA0KTWF5IDI5IDE3
OjM5OjIwIHAzNCBbICAgNjIuMjgxNzc3XSByYWlkNTogdXNpbmcgZnVuY3Rp
b246IGdlbmVyaWNfc3NlICg1Ni4wMDAgTUIvc2VjKSANCk1heSAyOSAxNzoz
OToyMCBwMzQgWyAgIDYyLjI4MjI0NF0gQWR2YW5jZWQgTGludXggU291bmQg
QXJjaGl0ZWN0dXJlIERyaXZlciBWZXJzaW9uIDEuMC4xNHJjMyAoV2VkIE1h
ciAxNCAwNzoyNTo1MCAyMDA3IFVUQykuIA0KTWF5IDI5IDE3OjM5OjIwIHAz
NCBbICAgNjIuMjg4MjIwXSBBQ1BJOiBQQ0kgSW50ZXJydXB0IDAwMDA6MDA6
MWIuMFtBXSAtPiANCk1heSAyOSAxNzozOToyMCBwMzQgR1NJIDIyIChsZXZl
bCwgbG93KSAtPiBJUlEgMjIgDQpNYXkgMjkgMTc6Mzk6MjAgcDM0IFsgICA2
Mi44Mzk1NTRdIGlucHV0OiBJbVBTLzIgR2VuZXJpYyBXaGVlbCBNb3VzZSBh
cyAvY2xhc3MvaW5wdXQvaW5wdXQyIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBb
ICAgNjMuNDEyNDg3XSBoZGFfaW50ZWw6IGF6eF9nZXRfcmVzcG9uc2UgdGlt
ZW91dCwgc3dpdGNoaW5nIHRvIHBvbGxpbmcgbW9kZS4uLiANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjQzNTc3Ml0gQUxTQSBkZXZpY2UgbGlzdDog
DQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My40MzU4NzZdICAgIzA6IEhE
QSBJbnRlbCBhdCAweGUwNjIwMDAwIGlycSAyMiANCk1heSAyOSAxNzozOToy
MSBwMzQgWyAgIDYzLjQzNjAzMV0gdTMyIGNsYXNzaWZpZXIgDQpNYXkgMjkg
MTc6Mzk6MjEgcDM0IFsgICA2My40MzYxNDhdICAgICBBY3Rpb25zIGNvbmZp
Z3VyZWQgIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNDM2Mjc5XSBu
Zl9jb25udHJhY2sgdmVyc2lvbiAwLjUuMCAoODE5MiBidWNrZXRzLCA2NTUz
NiBtYXgpIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNDM4ODgyXSBp
cF90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVyIENvcmUgVGVhbSAN
Ck1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjQzOTk5NV0gVENQIGN1Ymlj
IHJlZ2lzdGVyZWQgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My40NDAz
ODZdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMSANCk1heSAy
OSAxNzozOToyMSBwMzQgWyAgIDYzLjQ0MDUwN10gTkVUOiBSZWdpc3RlcmVk
IHByb3RvY29sIGZhbWlseSAxNyANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjQ0NTM5N10gbWQ6IEF1dG9kZXRlY3RpbmcgUkFJRCBhcnJheXMuIA0K
TWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTcyOTU1XSBtZDogYXV0b3J1
biAuLi4gDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My41NzMwOTVdIG1k
OiBjb25zaWRlcmluZyBzZGwxIC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQg
WyAgIDYzLjU3MzU5Nl0gbWQ6ICBhZGRpbmcgc2RsMSAuLi4gDQpNYXkgMjkg
MTc6Mzk6MjEgcDM0IFsgICA2My41NzM5MjRdIG1kOiAgYWRkaW5nIHNkazEg
Li4uIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTc0MzEyXSBtZDog
IGFkZGluZyBzZGoxIC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYz
LjU3NDY2NF0gbWQ6ICBhZGRpbmcgc2RpMSAuLi4gDQpNYXkgMjkgMTc6Mzk6
MjEgcDM0IFsgICA2My41NzUwMDVdIG1kOiAgYWRkaW5nIHNkaDEgLi4uIA0K
TWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTc1Mzk2XSBtZDogIGFkZGlu
ZyBzZGcxIC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU3NTc1
NF0gbWQ6ICBhZGRpbmcgc2RmMSAuLi4gDQpNYXkgMjkgMTc6Mzk6MjEgcDM0
IFsgICA2My41NzYwODldIG1kOiAgYWRkaW5nIHNkZTEgLi4uIA0KTWF5IDI5
IDE3OjM5OjIxIHAzNCBbICAgNjMuNTc2NDcyXSBtZDogIGFkZGluZyBzZGQx
IC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU3NjgyNF0gbWQ6
ICBhZGRpbmcgc2RjMSAuLi4gDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2
My41NzcwMTVdIG1kOiBzZGIzIGhhcyBkaWZmZXJlbnQgVVVJRCB0byBzZGwx
IA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTc3MjA0XSBtZDogc2Ri
MiBoYXMgZGlmZmVyZW50IFVVSUQgdG8gc2RsMSANCk1heSAyOSAxNzozOToy
MSBwMzQgWyAgIDYzLjU3NzQ0Nl0gbWQ6IHNkYjEgaGFzIGRpZmZlcmVudCBV
VUlEIHRvIHNkbDEgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My41Nzc2
NDddIG1kOiBzZGEzIGhhcyBkaWZmZXJlbnQgVVVJRCB0byBzZGwxIA0KTWF5
IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTc3ODQ2XSBtZDogc2RhMiBoYXMg
ZGlmZmVyZW50IFVVSUQgdG8gc2RsMSANCk1heSAyOSAxNzozOToyMSBwMzQg
WyAgIDYzLjU3ODA0M10gbWQ6IHNkYTEgaGFzIGRpZmZlcmVudCBVVUlEIHRv
IHNkbDEgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My41Nzk1MjddIG1k
OiBjcmVhdGVkIG1kMyANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU3
OTYzOV0gbWQ6IGJpbmQ8c2RjMT4gDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsg
ICA2My41Nzk5NTZdIG1kOiBiaW5kPHNkZDE+IA0KTWF5IDI5IDE3OjM5OjIx
IHAzNCBbICAgNjMuNTgwMzI5XSBtZDogYmluZDxzZGUxPiANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjU4MDYyN10gbWQ6IGJpbmQ8c2RmMT4gDQpN
YXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My41ODA5MzNdIG1kOiBiaW5kPHNk
ZzE+IA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTgxMjI5XSBtZDog
YmluZDxzZGgxPiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU4MTYy
NF0gbWQ6IGJpbmQ8c2RpMT4gDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2
My41ODIxMDNdIG1kOiBiaW5kPHNkajE+IA0KTWF5IDI5IDE3OjM5OjIxIHAz
NCBbICAgNjMuNTgyNDM2XSBtZDogYmluZDxzZGsxPiANCk1heSAyOSAxNzoz
OToyMSBwMzQgWyAgIDYzLjU4Mjc3Nl0gbWQ6IGJpbmQ8c2RsMT4gDQpNYXkg
MjkgMTc6Mzk6MjEgcDM0IFsgICA2My41ODMxMDBdIG1kOiBydW5uaW5nOiAN
Ck1heSAyOSAxNzozOToyMSBwMzQgIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBb
ICAgNjMuNTg2Mzg0XSByYWlkNTogZGV2aWNlIHNkbDEgb3BlcmF0aW9uYWwg
YXMgcmFpZCBkaXNrIDIgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My41
ODY1MDldIHJhaWQ1OiBkZXZpY2Ugc2RrMSBvcGVyYXRpb25hbCBhcyByYWlk
IGRpc2sgMyANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU4NjY1Nl0g
cmFpZDU6IGRldmljZSBzZGoxIG9wZXJhdGlvbmFsIGFzIHJhaWQgZGlzayAw
IA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTg2ODI5XSByYWlkNTog
ZGV2aWNlIHNkaTEgb3BlcmF0aW9uYWwgYXMgcmFpZCBkaXNrIDEgDQpNYXkg
MjkgMTc6Mzk6MjEgcDM0IFsgICA2My41ODY5NzNdIHJhaWQ1OiBkZXZpY2Ug
c2RoMSBvcGVyYXRpb25hbCBhcyByYWlkIGRpc2sgNiANCk1heSAyOSAxNzoz
OToyMSBwMzQgWyAgIDYzLjU4NzEyMl0gcmFpZDU6IGRldmljZSBzZGcxIG9w
ZXJhdGlvbmFsIGFzIHJhaWQgZGlzayA1IA0KTWF5IDI5IDE3OjM5OjIxIHAz
NCBbICAgNjMuNTg3MzE3XSByYWlkNTogZGV2aWNlIHNkZjEgb3BlcmF0aW9u
YWwgYXMgcmFpZCBkaXNrIDQgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2
My41ODc0NTldIHJhaWQ1OiBkZXZpY2Ugc2RlMSBvcGVyYXRpb25hbCBhcyBy
YWlkIGRpc2sgNyANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjU4NzYw
M10gcmFpZDU6IGRldmljZSBzZGQxIG9wZXJhdGlvbmFsIGFzIHJhaWQgZGlz
ayA4IA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNTg3NzU4XSByYWlk
NTogZGV2aWNlIHNkYzEgb3BlcmF0aW9uYWwgYXMgcmFpZCBkaXNrIDkgDQpN
YXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My42MDgxODZdIHJhaWQ1OiBhbGxv
Y2F0ZWQgMTA1NjJrQiBmb3IgbWQzIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBb
ICAgNjMuNjA4MzM0XSByYWlkNTogcmFpZCBsZXZlbCA1IHNldCBtZDMgYWN0
aXZlIHdpdGggMTAgb3V0IG9mIDEwIGRldmljZXMsIGFsZ29yaXRobSAyIA0K
TWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjA4NTE5XSBSQUlENSBjb25m
IHByaW50b3V0OiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYwODYz
OV0gIC0tLSByZDoxMCB3ZDoxMCANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjYwODc2N10gIGRpc2sgMCwgbzoxLCBkZXY6c2RqMSANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjYwODg5N10gIGRpc2sgMSwgbzoxLCBkZXY6
c2RpMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYwOTA3M10gIGRp
c2sgMiwgbzoxLCBkZXY6c2RsMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjYwOTE4NF0gIGRpc2sgMywgbzoxLCBkZXY6c2RrMSANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjYwOTM0Nl0gIGRpc2sgNCwgbzoxLCBkZXY6
c2RmMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYwOTUwN10gIGRp
c2sgNSwgbzoxLCBkZXY6c2RnMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjYwOTY0MF0gIGRpc2sgNiwgbzoxLCBkZXY6c2RoMSANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjYwOTc3MV0gIGRpc2sgNywgbzoxLCBkZXY6
c2RlMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYwOTkwM10gIGRp
c2sgOCwgbzoxLCBkZXY6c2RkMSANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjYxMDA0MF0gIGRpc2sgOSwgbzoxLCBkZXY6c2RjMSANCk1heSAyOSAx
NzozOToyMSBwMzQgWyAgIDYzLjYxMjQ2MF0gbWQ6IGNvbnNpZGVyaW5nIHNk
YjMgLi4uIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjEyODM1XSBt
ZDogIGFkZGluZyBzZGIzIC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQgWyAg
IDYzLjYxMzAyN10gbWQ6IHNkYjIgaGFzIGRpZmZlcmVudCBVVUlEIHRvIHNk
YjMgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My42MTMyMjBdIG1kOiBz
ZGIxIGhhcyBkaWZmZXJlbnQgVVVJRCB0byBzZGIzIA0KTWF5IDI5IDE3OjM5
OjIxIHAzNCBbICAgNjMuNjEzNTg5XSBtZDogIGFkZGluZyBzZGEzIC4uLiAN
Ck1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYxMzgwMV0gbWQ6IHNkYTIg
aGFzIGRpZmZlcmVudCBVVUlEIHRvIHNkYjMgDQpNYXkgMjkgMTc6Mzk6MjEg
cDM0IFsgICA2My42MTM5OTddIG1kOiBzZGExIGhhcyBkaWZmZXJlbnQgVVVJ
RCB0byBzZGIzIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjE1NjA2
XSBtZDogY3JlYXRlZCBtZDIgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2
My42MTU3MjBdIG1kOiBiaW5kPHNkYTM+IA0KTWF5IDI5IDE3OjM5OjIxIHAz
NCBbICAgNjMuNjE2MDk0XSBtZDogYmluZDxzZGIzPiANCk1heSAyOSAxNzoz
OToyMSBwMzQgWyAgIDYzLjYxNjU3NV0gbWQ6IHJ1bm5pbmc6IA0KTWF5IDI5
IDE3OjM5OjIxIHAzNCAgDQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My42
MTkzMTZdIHJhaWQxOiByYWlkIHNldCBtZDIgYWN0aXZlIHdpdGggMiBvdXQg
b2YgMiBtaXJyb3JzIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjIw
NTEzXSBtZDogY29uc2lkZXJpbmcgc2RiMiAuLi4gDQpNYXkgMjkgMTc6Mzk6
MjEgcDM0IFsgICA2My42MjA4NzBdIG1kOiAgYWRkaW5nIHNkYjIgLi4uIA0K
TWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjIxMDgyXSBtZDogc2RiMSBo
YXMgZGlmZmVyZW50IFVVSUQgdG8gc2RiMiANCk1heSAyOSAxNzozOToyMSBw
MzQgWyAgIDYzLjYyMTQ2NV0gbWQ6ICBhZGRpbmcgc2RhMiAuLi4gDQpNYXkg
MjkgMTc6Mzk6MjEgcDM0IFsgICA2My42MjE2NDZdIG1kOiBzZGExIGhhcyBk
aWZmZXJlbnQgVVVJRCB0byBzZGIyIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBb
ICAgNjMuNjIzNjE5XSBtZDogY3JlYXRlZCBtZDEgDQpNYXkgMjkgMTc6Mzk6
MjEgcDM0IFsgICA2My42MjM3MzNdIG1kOiBiaW5kPHNkYTI+IA0KTWF5IDI5
IDE3OjM5OjIxIHAzNCBbICAgNjMuNjI0MDU5XSBtZDogYmluZDxzZGIyPiAN
Ck1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjYyNDQzOV0gbWQ6IHJ1bm5p
bmc6IA0KTWF5IDI5IDE3OjM5OjIxIHAzNCAgDQpNYXkgMjkgMTc6Mzk6MjEg
cDM0IFsgICA2My42Mjc0MzhdIHJhaWQxOiByYWlkIHNldCBtZDEgYWN0aXZl
IHdpdGggMiBvdXQgb2YgMiBtaXJyb3JzIA0KTWF5IDI5IDE3OjM5OjIxIHAz
NCBbICAgNjMuNjI4NTU1XSBtZDogY29uc2lkZXJpbmcgc2RiMSAuLi4gDQpN
YXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My42Mjg4ODNdIG1kOiAgYWRkaW5n
IHNkYjEgLi4uIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjI5MzAy
XSBtZDogIGFkZGluZyBzZGExIC4uLiANCk1heSAyOSAxNzozOToyMSBwMzQg
WyAgIDYzLjYyOTQxMV0gbWQ6IGNyZWF0ZWQgbWQwIA0KTWF5IDI5IDE3OjM5
OjIxIHAzNCBbICAgNjMuNjI5NTc2XSBtZDogYmluZDxzZGExPiANCk1heSAy
OSAxNzozOToyMSBwMzQgWyAgIDYzLjYyOTg4Ml0gbWQ6IGJpbmQ8c2RiMT4g
DQpNYXkgMjkgMTc6Mzk6MjEgcDM0IFsgICA2My42MzAyMzNdIG1kOiBydW5u
aW5nOiANCk1heSAyOSAxNzozOToyMSBwMzQgIA0KTWF5IDI5IDE3OjM5OjIx
IHAzNCBbICAgNjMuNjMzNDM4XSByYWlkMTogcmFpZCBzZXQgbWQwIGFjdGl2
ZSB3aXRoIDIgb3V0IG9mIDIgbWlycm9ycyANCk1heSAyOSAxNzozOToyMSBw
MzQgWyAgIDYzLjYzNDU5OF0gbWQ6IC4uLiBhdXRvcnVuIERPTkUuIA0KTWF5
IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuNjk1NDU2XSBVREYtZnM6IE5vIFZS
UyBmb3VuZCANCk1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjY5OTE1OF0g
RmlsZXN5c3RlbSAibWQyIjogRGlzYWJsaW5nIGJhcnJpZXJzLCBub3Qgc3Vw
cG9ydGVkIGJ5IHRoZSB1bmRlcmx5aW5nIGRldmljZSANCk1heSAyOSAxNzoz
OToyMSBwMzQgWyAgIDYzLjcxMzc3Nl0gWEZTIG1vdW50aW5nIGZpbGVzeXN0
ZW0gbWQyIA0KTWF5IDI5IDE3OjM5OjIxIHAzNCBbICAgNjMuODEzNzQzXSBW
RlM6IE1vdW50ZWQgcm9vdCAoeGZzIGZpbGVzeXN0ZW0pIHJlYWRvbmx5LiAN
Ck1heSAyOSAxNzozOToyMSBwMzQgWyAgIDYzLjgxNDExNV0gRnJlZWluZyB1
bnVzZWQga2VybmVsIG1lbW9yeTogMjIwayBmcmVlZCANCk1heSAyOSAxNzo0
MDozOSBwMzQgWyAgMTQxLjQ0NzMwNF0gQWRkaW5nIDE2Nzg3NzY4ayBzd2Fw
IG9uIC9kZXYvbWQwLiAgUHJpb3JpdHk6LTEgZXh0ZW50czoxIGFjcm9zczox
Njc4Nzc2OGsgDQpNYXkgMjkgMTc6NDA6NDAgcDM0IFsgIDE0Mi40OTc3MjFd
IEZpbGVzeXN0ZW0gIm1kMiI6IERpc2FibGluZyBiYXJyaWVycywgbm90IHN1
cHBvcnRlZCBieSB0aGUgdW5kZXJseWluZyBkZXZpY2UgDQpNYXkgMjkgMTc6
NDE6MDQgcDM0IFsgIDE2Ni43MTYwMTddIGtqb3VybmFsZCBzdGFydGluZy4g
IENvbW1pdCBpbnRlcnZhbCA1IHNlY29uZHMgDQpNYXkgMjkgMTc6NDE6MDQg
cDM0IFsgIDE2Ni43MjkzNzVdIEVYVDMgRlMgb24gbWQxLCANCk1heSAyOSAx
Nzo0MTowNCBwMzQgaW50ZXJuYWwgam91cm5hbCANCk1heSAyOSAxNzo0MTow
NCBwMzQgWyAgMTY2LjcyOTY2M10gRVhUMy1mczogbW91bnRlZCBmaWxlc3lz
dGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIA0KTWF5IDI5IDE3OjQxOjA0
IHAzNCBbICAxNjYuNzUxNzk5XSBGaWxlc3lzdGVtICJtZDMiOiBEaXNhYmxp
bmcgYmFycmllcnMsIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIHVuZGVybHlpbmcg
ZGV2aWNlIA0KTWF5IDI5IDE3OjQxOjA0IHAzNCBbICAxNjYuNzU4NzE3XSBY
RlMgbW91bnRpbmcgZmlsZXN5c3RlbSBtZDMgDQpNYXkgMjkgMTc6NDE6NTQg
cDM0IFsgIDIxNi44MjEzNTddIGUxMDAwOiBldGgxOiBlMTAwMF93YXRjaGRv
ZzogTklDIExpbmsgaXMgVXAgMTAwIE1icHMgRnVsbCBEdXBsZXgsIEZsb3cg
Q29udHJvbDogUlggDQpNYXkgMjkgMTc6NDI6MjkgcDM0IFsgIDI1MS40ODEz
OTldIHByb2Nlc3MgYHN5c2xvZ2QnIGlzIHVzaW5nIG9ic29sZXRlIHNldHNv
Y2tvcHQgU09fQlNEQ09NUEFUIA0KTWF5IDI5IDE3OjQ2OjQyIHAzNCBbICA1
MDQuMDc0MTcxXSBtdHJyOiBubyBtb3JlIE1UUlJzIGF2YWlsYWJsZSANCg==

---1463747160-925635164-1180535762=:13945--
