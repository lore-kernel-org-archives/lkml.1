Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXLMP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXLMP6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXLMP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:58:09 -0500
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:49546 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752671AbXLMP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:58:05 -0500
X-Greylist: delayed 1732 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 10:58:04 EST
Message-ID: <47614FCC.3090009@vlnb.net>
Date: Thu, 13 Dec 2007 18:29:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Possible recursive locking detected with XFS
Content-Type: multipart/mixed;
 boundary="------------090406000303050106050509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090406000303050106050509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've just got it while running "dbench 200" over a XFS mounted 
partition. Kernel is 2.6.23. See the attachment.

Regards,
Vlad

--------------090406000303050106050509
Content-Type: text/plain;
 name="kernel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel"

Dec 13 16:17:20 tst kernel: [    0.000000] Linux version 2.6.23-dbg (v@ws) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #17 SMP PREEMPT Thu Oct 25 22:19:38 MSD 2007
Dec 13 16:17:20 tst kernel: [    0.000000] BIOS-provided physical RAM map:
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Dec 13 16:17:20 tst kernel: [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Dec 13 16:17:20 tst kernel: [    0.000000] 2047MB LOWMEM available.
Dec 13 16:17:20 tst kernel: [    0.000000] found SMP MP-table at 000ff780
Dec 13 16:17:20 tst kernel: [    0.000000] Zone PFN ranges:
Dec 13 16:17:20 tst kernel: [    0.000000]   DMA             0 ->     4096
Dec 13 16:17:20 tst kernel: [    0.000000]   Normal       4096 ->   524272
Dec 13 16:17:20 tst kernel: [    0.000000] Movable zone start PFN for each node
Dec 13 16:17:20 tst kernel: [    0.000000] early_node_map[1] active PFN ranges
Dec 13 16:17:20 tst kernel: [    0.000000]     0:        0 ->   524272
Dec 13 16:17:20 tst kernel: [    0.000000] DMI 2.3 present.
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: RSDP 000F5070, 0014 (r0 ACPIAM)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: RSDT 7FFF0000, 0030 (r1 A M I  OEMRSDT   9000318 MSFT       97)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: FACP 7FFF0200, 0081 (r2 A M I  OEMFACP   9000318 MSFT       97)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: DSDT 7FFF0420, 2CB5 (r1  0ABBP 0ABBP004        4 INTL  2002026)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: FACS 7FFFF000, 0040
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: APIC 7FFF0390, 0084 (r1 A M I  OEMAPIC   9000318 MSFT       97)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: OEMB 7FFFF040, 0040 (r1 A M I  AMI_OEM   9000318 MSFT       97)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Dec 13 16:17:20 tst kernel: [    0.000000] Processor #0 15:2 APIC version 20
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Dec 13 16:17:20 tst kernel: [    0.000000] Processor #1 15:2 APIC version 20
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Dec 13 16:17:20 tst kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
Dec 13 16:17:20 tst kernel: [    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec80400] gsi_base[48])
Dec 13 16:17:20 tst kernel: [    0.000000] IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec 13 16:17:20 tst kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Dec 13 16:17:20 tst kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 3 I/O APICs
Dec 13 16:17:20 tst kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec 13 16:17:20 tst kernel: [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Dec 13 16:17:20 tst kernel: [    0.000000] Built 1 zonelists in Zone order.  Total pages: 516081
Dec 13 16:17:20 tst kernel: [    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.23d ro root=301 nmi_watchdog=1 resume=/dev/hdc1 console=ttyS0,115200n8
Dec 13 16:17:20 tst kernel: [    0.000000] Enabling fast FPU save and restore... done.
Dec 13 16:17:20 tst kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Dec 13 16:17:20 tst kernel: [    0.000000] Initializing CPU#0
Dec 13 16:17:20 tst kernel: [    0.000000] CPU 0 irqstacks, hard=78516000 soft=7850e000
Dec 13 16:17:20 tst kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Dec 13 16:17:20 tst kernel: [    0.000000] Detected 2396.038 MHz processor.
Dec 13 16:17:20 tst kernel: [   53.344012] Console: colour VGA+ 80x25
Dec 13 16:17:20 tst kernel: [   53.344040] console [ttyS0] enabled
Dec 13 16:17:20 tst kernel: [   53.662188] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Dec 13 16:17:20 tst kernel: [   53.669918] ... MAX_LOCKDEP_SUBCLASSES:    8
Dec 13 16:17:20 tst kernel: [   53.674177] ... MAX_LOCK_DEPTH:          30
Dec 13 16:17:20 tst kernel: [   53.678350] ... MAX_LOCKDEP_KEYS:        2048
Dec 13 16:17:20 tst kernel: [   53.682695] ... CLASSHASH_SIZE:           1024
Dec 13 16:17:20 tst kernel: [   53.687127] ... MAX_LOCKDEP_ENTRIES:     8192
Dec 13 16:17:20 tst kernel: [   53.691553] ... MAX_LOCKDEP_CHAINS:      16384
Dec 13 16:17:20 tst kernel: [   53.695983] ... CHAINHASH_SIZE:          8192
Dec 13 16:17:20 tst kernel: [   53.700330]  memory used by lock dependency info: 1024 kB
Dec 13 16:17:20 tst kernel: [   53.705714]  per task-struct memory footprint: 1680 bytes
Dec 13 16:17:20 tst kernel: [   53.711100] ------------------------
Dec 13 16:17:20 tst kernel: [   53.714666] | Locking API testsuite:
Dec 13 16:17:20 tst kernel: [   53.718234] ----------------------------------------------------------------------------
Dec 13 16:17:20 tst kernel: [   53.726302]                                  | spin |wlock |rlock |mutex | wsem | rsem |
Dec 13 16:17:20 tst kernel: [   53.734467]   --------------------------------------------------------------------------
Dec 13 16:17:20 tst kernel: [   53.742548]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.751347]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.760108]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.768896]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.777683]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.786505]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.795326]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.804139]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.812874]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.821609]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.830370]   --------------------------------------------------------------------------
Dec 13 16:17:20 tst kernel: [   53.838560]               recursive read-lock:             |  ok  |             |  ok  |
Dec 13 16:17:20 tst kernel: [   53.846887]            recursive read-lock #2:             |  ok  |             |  ok  |
Dec 13 16:17:20 tst kernel: [   53.855216]             mixed read-write-lock:             |  ok  |             |  ok  |
Dec 13 16:17:20 tst kernel: [   53.863553]             mixed write-read-lock:             |  ok  |             |  ok  |
Dec 13 16:17:20 tst kernel: [   53.871881]   --------------------------------------------------------------------------
Dec 13 16:17:20 tst kernel: [   53.879950]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.886555]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.893161]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.899758]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.906354]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.912960]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.919565]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.926153]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.932759]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.939356]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.946065]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.952671]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.959276]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.965882]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.972486]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.979092]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.985698]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.992364]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   53.998969]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.005574]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.012181]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.018785]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.025390]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.031996]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.038602]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.045207]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.051813]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.058418]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.065023]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.071629]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.078235]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.084841]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.091445]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.098094]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.104699]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.111305]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.117910]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.124516]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.131147]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.137779]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.144410]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.151042]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.157656]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.164262]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.170866]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.177473]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
Dec 13 16:17:20 tst kernel: [   54.184077]       hard-irq read-recursion/123:  ok  |
Dec 13 16:17:20 tst kernel: [   54.189247]       soft-irq read-recursion/123:  ok  |
Dec 13 16:17:20 tst kernel: [   54.194414]       hard-irq read-recursion/132:  ok  |
Dec 13 16:17:20 tst kernel: [   54.199643]       soft-irq read-recursion/132:  ok  |
Dec 13 16:17:20 tst kernel: [   54.204819]       hard-irq read-recursion/213:  ok  |
Dec 13 16:17:20 tst kernel: [   54.209989]       soft-irq read-recursion/213:  ok  |
Dec 13 16:17:20 tst kernel: [   54.215157]       hard-irq read-recursion/231:  ok  |
Dec 13 16:17:20 tst kernel: [   54.220325]       soft-irq read-recursion/231:  ok  |
Dec 13 16:17:20 tst kernel: [   54.225493]       hard-irq read-recursion/312:  ok  |
Dec 13 16:17:20 tst kernel: [   54.230662]       soft-irq read-recursion/312:  ok  |
Dec 13 16:17:20 tst kernel: [   54.235830]       hard-irq read-recursion/321:  ok  |
Dec 13 16:17:20 tst kernel: [   54.240999]       soft-irq read-recursion/321:  ok  |
Dec 13 16:17:20 tst kernel: [   54.246211] -------------------------------------------------------
Dec 13 16:17:20 tst kernel: [   54.252461] Good, all 218 testcases passed! |
Dec 13 16:17:20 tst kernel: [   54.256807] ---------------------------------
Dec 13 16:17:20 tst kernel: [   54.262293] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Dec 13 16:17:20 tst kernel: [   54.271443] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Dec 13 16:17:20 tst kernel: [   54.359088] Memory: 2022124k/2097088k available (2463k kernel code, 74432k reserved, 1129k data, 524k init, 0k highmem)
Dec 13 16:17:20 tst kernel: [   54.369857] virtual kernel memory layout:
Dec 13 16:17:20 tst kernel: [   54.369858]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
Dec 13 16:17:20 tst kernel: [   54.369860]     vmalloc : 0xf8800000 - 0xfffb3000   ( 119 MB)
Dec 13 16:17:20 tst kernel: [   54.369861]     lowmem  : 0x78000000 - 0xf7ff0000   (2047 MB)
Dec 13 16:17:20 tst kernel: [   54.369862]       .init : 0x78488000 - 0x7850b000   ( 524 kB)
Dec 13 16:17:20 tst kernel: [   54.369863]       .data : 0x78367cf6 - 0x78482454   (1129 kB)
Dec 13 16:17:20 tst kernel: [   54.369865]       .text : 0x78100000 - 0x78367cf6   (2463 kB)
Dec 13 16:17:20 tst kernel: [   54.408257] Checking if this processor honours the WP bit even in supervisor mode... Ok.
Dec 13 16:17:20 tst kernel: [   54.476957] Calibrating delay using timer specific routine.. 4796.36 BogoMIPS (lpj=2398180)
Dec 13 16:17:20 tst kernel: [   54.485618] Mount-cache hash table entries: 512
Dec 13 16:17:20 tst kernel: [   54.491061] CPU: Trace cache: 12K uops, L1 D cache: 8K
Dec 13 16:17:20 tst kernel: [   54.496233] CPU: L2 cache: 512K
Dec 13 16:17:20 tst kernel: [   54.499384] CPU: Physical Processor ID: 0
Dec 13 16:17:20 tst kernel: [   54.503478] Intel machine check architecture supported.
Dec 13 16:17:20 tst kernel: [   54.508704] Intel machine check reporting enabled on CPU#0.
Dec 13 16:17:20 tst kernel: [   54.514277] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
Dec 13 16:17:20 tst kernel: [   54.520285] CPU0: Thermal monitoring enabled
Dec 13 16:17:20 tst kernel: [   54.524567] Compat vDSO mapped to ffffe000.
Dec 13 16:17:20 tst kernel: [   54.528765] Checking 'hlt' instruction... OK.
Dec 13 16:17:20 tst kernel: [   54.537264] lockdep: not fixing up alternatives.
Dec 13 16:17:20 tst kernel: [   54.541900] ACPI: Core revision 20070126
Dec 13 16:17:20 tst kernel: [   54.552016] CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Dec 13 16:17:20 tst kernel: [   54.557743] lockdep: not fixing up alternatives.
Dec 13 16:17:20 tst kernel: [   54.562371] Booting processor 1/1 eip 2000
Dec 13 16:17:20 tst kernel: [   54.566473] CPU 1 irqstacks, hard=78517000 soft=7850f000
Dec 13 16:17:20 tst kernel: [   54.582033] Initializing CPU#1
Dec 13 16:17:20 tst kernel: [   54.642774] Calibrating delay using timer specific routine.. 4791.12 BogoMIPS (lpj=2395562)
Dec 13 16:17:20 tst kernel: [   54.642801] CPU: Trace cache: 12K uops, L1 D cache: 8K
Dec 13 16:17:20 tst kernel: [   54.642805] CPU: L2 cache: 512K
Dec 13 16:17:20 tst kernel: [   54.642808] CPU: Physical Processor ID: 0
Dec 13 16:17:20 tst kernel: [   54.642821] Intel machine check architecture supported.
Dec 13 16:17:20 tst kernel: [   54.642828] Intel machine check reporting enabled on CPU#1.
Dec 13 16:17:20 tst kernel: [   54.642832] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
Dec 13 16:17:20 tst kernel: [   54.642836] CPU1: Thermal monitoring enabled
Dec 13 16:17:20 tst kernel: [   54.643131] CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Dec 13 16:17:20 tst kernel: [   54.693512] Total of 2 processors activated (9587.48 BogoMIPS).
Dec 13 16:17:20 tst kernel: [   54.699908] ENABLING IO-APIC IRQs
Dec 13 16:17:20 tst kernel: [   54.703511] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec 13 16:17:20 tst kernel: [   54.820587] APIC timer registered as dummy, due to nmi_watchdog=1!
Dec 13 16:17:20 tst kernel: [   54.828039] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Dec 13 16:17:20 tst kernel: [   54.854258] Brought up 2 CPUs
Dec 13 16:17:20 tst kernel: [   54.857892] khelper used greatest stack depth: 3064 bytes left
Dec 13 16:17:20 tst kernel: [   54.863818] khelper used greatest stack depth: 3008 bytes left
Dec 13 16:17:20 tst kernel: [   54.870013] NET: Registered protocol family 16
Dec 13 16:17:20 tst kernel: [   54.875483] ACPI: bus type pci registered
Dec 13 16:17:20 tst kernel: [   54.879649] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
Dec 13 16:17:20 tst kernel: [   54.886012] PCI: Using configuration type 1
Dec 13 16:17:20 tst kernel: [   54.890211] Setting up standard PCI resources
Dec 13 16:17:20 tst kernel: [   54.943795] ACPI: Interpreter enabled
Dec 13 16:17:20 tst kernel: [   54.947479] ACPI: (supports S0 S5)
Dec 13 16:17:20 tst kernel: [   54.950978] ACPI: Using IOAPIC for interrupt routing
Dec 13 16:17:20 tst kernel: [   54.984730] ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec 13 16:17:20 tst kernel: [   54.990548] PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
Dec 13 16:17:20 tst kernel: [   54.996994] PCI quirk: region 0500-053f claimed by ICH4 GPIO
Dec 13 16:17:20 tst kernel: [   55.005631] PCI: Transparent bridge - 0000:00:1e.0
Dec 13 16:17:20 tst kernel: [   55.019230] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Dec 13 16:17:20 tst kernel: [   55.026987] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Dec 13 16:17:20 tst kernel: [   55.035917] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Dec 13 16:17:20 tst kernel: [   55.043699] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Dec 13 16:17:20 tst kernel: [   55.051449] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Dec 13 16:17:20 tst kernel: [   55.059200] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Dec 13 16:17:20 tst kernel: [   55.066943] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Dec 13 16:17:20 tst kernel: [   55.075878] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Dec 13 16:17:20 tst kernel: [   55.085090] Linux Plug and Play Support v0.97 (c) Adam Belay
Dec 13 16:17:20 tst kernel: [   55.090917] pnp: PnP ACPI init
Dec 13 16:17:20 tst kernel: [   55.094015] ACPI: bus type pnp registered
Dec 13 16:17:20 tst kernel: [   55.109861] pnp: PnP ACPI: found 14 devices
Dec 13 16:17:20 tst kernel: [   55.114054] ACPI: ACPI bus type pnp unregistered
Dec 13 16:17:20 tst kernel: [   55.119971] SCSI subsystem initialized
Dec 13 16:17:20 tst kernel: [   55.124378] usbcore: registered new interface driver usbfs
Dec 13 16:17:20 tst kernel: [   55.130233] usbcore: registered new interface driver hub
Dec 13 16:17:20 tst kernel: [   55.135840] usbcore: registered new device driver usb
Dec 13 16:17:20 tst kernel: [   55.141664] PCI: Using ACPI for IRQ routing
Dec 13 16:17:20 tst kernel: [   55.145864] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Dec 13 16:17:20 tst kernel: [   55.171434] Time: tsc clocksource has been installed.
Dec 13 16:17:20 tst kernel: [   55.179668] pnp: 00:09: iomem range 0xffa00000-0xffeffbff has been reserved
Dec 13 16:17:20 tst kernel: [   55.186642] pnp: 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.193971] pnp: 00:0b: ioport range 0x680-0x6ff has been reserved
Dec 13 16:17:20 tst kernel: [   55.200177] pnp: 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.207495] pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.214825] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.221277] pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.228151] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.234945] pnp: 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
Dec 13 16:17:20 tst kernel: [   55.273920] PCI: Bridge: 0000:02:1d.0
Dec 13 16:17:20 tst kernel: [   55.277597]   IO window: a000-cfff
Dec 13 16:17:20 tst kernel: [   55.281020]   MEM window: fe700000-fe9fffff
Dec 13 16:17:20 tst kernel: [   55.285217]   PREFETCH window: ff800000-ff8fffff
Dec 13 16:17:20 tst kernel: [   55.289850] PCI: Bridge: 0000:02:1f.0
Dec 13 16:17:20 tst kernel: [   55.293525]   IO window: 9000-9fff
Dec 13 16:17:20 tst kernel: [   55.296949]   MEM window: fe600000-fe6fffff
Dec 13 16:17:20 tst kernel: [   55.301146]   PREFETCH window: ff700000-ff7fffff
Dec 13 16:17:20 tst kernel: [   55.305779] PCI: Bridge: 0000:00:02.0
Dec 13 16:17:20 tst kernel: [   55.309455]   IO window: 9000-cfff
Dec 13 16:17:20 tst kernel: [   55.312879]   MEM window: fe600000-feafffff
Dec 13 16:17:20 tst kernel: [   55.317075]   PREFETCH window: ff700000-ff9fffff
Dec 13 16:17:20 tst kernel: [   55.321717] PCI: Bridge: 0000:00:1e.0
Dec 13 16:17:20 tst kernel: [   55.325394]   IO window: 8000-8fff
Dec 13 16:17:20 tst kernel: [   55.328816]   MEM window: fc500000-fe5fffff
Dec 13 16:17:20 tst kernel: [   55.333013]   PREFETCH window: ff600000-ff6fffff
Dec 13 16:17:20 tst kernel: [   55.337831] NET: Registered protocol family 2
Dec 13 16:17:20 tst kernel: [   55.353425] IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
Dec 13 16:17:20 tst kernel: [   55.361382] TCP established hash table entries: 65536 (order: 9, 2883584 bytes)
Dec 13 16:17:20 tst kernel: [   55.377484] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
Dec 13 16:17:20 tst kernel: [   55.392412] TCP: Hash tables configured (established 65536 bind 65536)
Dec 13 16:17:20 tst kernel: [   55.398994] TCP reno registered
Dec 13 16:17:20 tst kernel: [   55.407856] Machine check exception polling timer started.
Dec 13 16:17:20 tst kernel: [   55.417278] Initializing RT-Tester: OK
Dec 13 16:17:20 tst kernel: [   55.421074] audit: initializing netlink socket (disabled)
Dec 13 16:17:20 tst kernel: [   55.426560] audit(1197562580.707:1): initialized
Dec 13 16:17:20 tst kernel: [   55.432376] VFS: Disk quotas dquot_6.5.1
Dec 13 16:17:20 tst kernel: [   55.436346] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Dec 13 16:17:20 tst kernel: [   55.443494] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
Dec 13 16:17:20 tst kernel: [   55.450902] io scheduler noop registered
Dec 13 16:17:20 tst kernel: [   55.454825] io scheduler anticipatory registered
Dec 13 16:17:20 tst kernel: [   55.459441] io scheduler deadline registered (default)
Dec 13 16:17:20 tst kernel: [   55.464654] io scheduler cfq registered
Dec 13 16:17:20 tst kernel: [   55.470663] input: Power Button (FF) as /devices/virtual/input/input0
Dec 13 16:17:20 tst kernel: [   55.477136] ACPI: Power Button (FF) [PWRF]
Dec 13 16:17:20 tst kernel: [   55.481603] input: Power Button (CM) as /devices/virtual/input/input1
Dec 13 16:17:20 tst kernel: [   55.488053] ACPI: Power Button (CM) [PWRB]
Dec 13 16:17:20 tst kernel: [   55.492466] input: Sleep Button (CM) as /devices/virtual/input/input2
Dec 13 16:17:20 tst kernel: [   55.498913] ACPI: Sleep Button (CM) [SLPB]
Dec 13 16:17:20 tst kernel: [   55.503825] ACPI: Processor [CPU1] (supports 8 throttling states)
Dec 13 16:17:20 tst kernel: [   55.510039] ACPI: Processor [CPU2] (supports 8 throttling states)
Dec 13 16:17:20 tst kernel: [   55.516225] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Dec 13 16:17:20 tst kernel: [   55.525964] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Dec 13 16:17:20 tst kernel: [   55.671419] Real Time Clock Driver v1.12ac
Dec 13 16:17:20 tst kernel: [   55.675711] intel_rng: FWH not detected
Dec 13 16:17:20 tst kernel: [   55.679676] Linux agpgart interface v0.102
Dec 13 16:17:20 tst kernel: [   55.684080] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Dec 13 16:17:20 tst kernel: [   55.692034] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Dec 13 16:17:20 tst kernel: [   55.698548] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Dec 13 16:17:20 tst kernel: [   55.706408] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Dec 13 16:17:20 tst kernel: [   55.712863] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Dec 13 16:17:20 tst kernel: [   55.719658] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Dec 13 16:17:20 tst kernel: [   55.726017] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Dec 13 16:17:20 tst kernel: [   55.734239] ICH3: IDE controller at PCI slot 0000:00:1f.1
Dec 13 16:17:20 tst kernel: [   55.739652] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
Dec 13 16:17:20 tst kernel: [   55.745325] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
Dec 13 16:17:20 tst kernel: [   55.752751] ICH3: chipset revision 2
Dec 13 16:17:20 tst kernel: [   55.756330] ICH3: not 100% native mode: will probe irqs later
Dec 13 16:17:20 tst kernel: [   55.762092]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
Dec 13 16:17:20 tst kernel: [   55.769371]     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
Dec 13 16:17:20 tst kernel: [   55.867687] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Dec 13 16:17:20 tst kernel: [   55.867698] Could not switch to high resolution mode on CPU 1
Dec 13 16:17:20 tst kernel: [   55.885499]  lapic is not functional.
Dec 13 16:17:20 tst kernel: [   55.889171] Could not switch to high resolution mode on CPU 0
Dec 13 16:17:20 tst kernel: [   56.064662] hda: QUANTUM FIREBALLP AS20.5, ATA DISK drive
Dec 13 16:17:20 tst kernel: [   56.681391] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 13 16:17:20 tst kernel: [   56.955701] hdc: QUANTUM FIREBALLP LM20.5, ATA DISK drive
Dec 13 16:17:20 tst kernel: [   57.572527] ide1 at 0x170-0x177,0x376 on irq 15
Dec 13 16:17:20 tst kernel: [   57.584630] hda: max request size: 128KiB
Dec 13 16:17:20 tst kernel: [   57.588869] hda: 40132503 sectors (20547 MB) w/1902KiB Cache, CHS=39813/16/63, UDMA(100)
Dec 13 16:17:20 tst kernel: [   57.597080] hda: cache flushes not supported
Dec 13 16:17:20 tst kernel: [   57.601507]  hda: hda1 hda2
Dec 13 16:17:20 tst kernel: [   57.611845] khelper used greatest stack depth: 2940 bytes left
Dec 13 16:17:20 tst kernel: [   57.612442] hdc: max request size: 128KiB
Dec 13 16:17:20 tst kernel: [   57.612746] hdc: 40132503 sectors (20547 MB) w/1900KiB Cache, CHS=39813/16/63, UDMA(66)
Dec 13 16:17:20 tst kernel: [   57.612756] hdc: cache flushes not supported
Dec 13 16:17:20 tst kernel: [   57.612920]  hdc: hdc1 hdc2
Dec 13 16:17:20 tst kernel: [   57.637982] ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 50 (level, low) -> IRQ 17
Dec 13 16:17:20 tst kernel: [   72.747542] scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
Dec 13 16:17:20 tst kernel: [   72.747545]         <Adaptec AIC7902 Ultra320 SCSI adapter>
Dec 13 16:17:20 tst kernel: [   72.747546]         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Dec 13 16:17:20 tst kernel: [   72.768360] ACPI: PCI Interrupt 0000:04:03.1[B] -> GSI 51 (level, low) -> IRQ 18
Dec 13 16:17:20 tst kernel: [   76.631364] scsi_scan_0 used greatest stack depth: 2520 bytes left
Dec 13 16:17:20 tst kernel: [   87.882196] scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
Dec 13 16:17:20 tst kernel: [   87.882198]         <Adaptec AIC7902 Ultra320 SCSI adapter>
Dec 13 16:17:20 tst kernel: [   87.882200]         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Dec 13 16:17:20 tst kernel: [   87.904660] PNP: PS/2 Controller [PNP0f03:PS2M] at 0x60,0x64 irq 12
Dec 13 16:17:20 tst kernel: [   87.904825] scsi 1:0:0:0: Direct-Access     SEAGATE  ST373455LW       0003 PQ: 0 ANSI: 3
Dec 13 16:17:20 tst kernel: [   87.904849]  target1:0:0: asynchronous
Dec 13 16:17:20 tst kernel: [   87.904852] scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
Dec 13 16:17:20 tst kernel: [   87.904944]  target1:0:0: Beginning Domain Validation
Dec 13 16:17:20 tst kernel: [   87.907862]  target1:0:0: wide asynchronous
Dec 13 16:17:20 tst kernel: [   87.910049]  target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
Dec 13 16:17:20 tst kernel: [   87.946799] PNP: PS/2 controller doesn't have KBD irq; using default 1
Dec 13 16:17:20 tst kernel: [   87.955382] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec 13 16:17:20 tst kernel: [   87.960375] serio: i8042 AUX port at 0x60,0x64 irq 12
Dec 13 16:17:20 tst kernel: [   87.965732] mice: PS/2 mouse device common for all mice
Dec 13 16:17:20 tst kernel: [   87.994346]  target1:0:0: Ending Domain Validation
Dec 13 16:17:20 tst kernel: [   88.219243] md: raid0 personality registered for level 0
Dec 13 16:17:20 tst kernel: [   88.224562] EDAC MC: Ver: 2.1.0 Oct 19 2007
Dec 13 16:17:20 tst kernel: [   88.229968] EDAC e7xxx: error reporting device not found:vendor 8086 device 0x2541 (broken BIOS?)
Dec 13 16:17:20 tst kernel: [   88.241336] TCP bic registered
Dec 13 16:17:20 tst kernel: [   88.244449] NET: Registered protocol family 1
Dec 13 16:17:20 tst kernel: [   88.248983] NET: Registered protocol family 10
Dec 13 16:17:20 tst kernel: [   88.253754] lo: Disabled Privacy Extensions
Dec 13 16:17:20 tst kernel: [   88.258113] NET: Registered protocol family 17
Dec 13 16:17:20 tst kernel: [   88.262584] Testing NMI watchdog ... OK.
Dec 13 16:17:20 tst kernel: [   88.287453] Starting balanced_irq
Dec 13 16:17:20 tst kernel: [   88.290949] Using IPI No-Shortcut mode
Dec 13 16:17:20 tst kernel: [   88.295710] scsi: waiting for bus probes to complete ...
Dec 13 16:17:20 tst kernel: [   91.635528] sd 1:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
Dec 13 16:17:20 tst kernel: [   91.643690] sd 1:0:0:0: [sda] Write Protect is off
Dec 13 16:17:20 tst kernel: [   91.650350] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Dec 13 16:17:20 tst kernel: [   91.659576] sd 1:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
Dec 13 16:17:20 tst kernel: [   91.667738] sd 1:0:0:0: [sda] Write Protect is off
Dec 13 16:17:20 tst kernel: [   91.674363] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Dec 13 16:17:20 tst kernel: [   91.682900]  sda: sda1 sda2 sda3 sda4 < sda5 >
Dec 13 16:17:20 tst kernel: [   91.701403] sd 1:0:0:0: [sda] Attached SCSI disk
Dec 13 16:17:20 tst kernel: [   91.706633] scsi_scan_1 used greatest stack depth: 1924 bytes left
Dec 13 16:17:20 tst kernel: [   91.707350] md: Autodetecting RAID arrays.
Dec 13 16:17:20 tst kernel: [   91.748018] md: autorun ...
Dec 13 16:17:20 tst kernel: [   91.750828] md: considering hdc2 ...
Dec 13 16:17:20 tst kernel: [   91.754445] md:  adding hdc2 ...
Dec 13 16:17:20 tst kernel: [   91.757715] md:  adding hda2 ...
Dec 13 16:17:20 tst kernel: [   91.761005] md: created md0
Dec 13 16:17:20 tst kernel: [   91.763816] md: bind<hda2>
Dec 13 16:17:20 tst kernel: [   91.766610] md: bind<hdc2>
Dec 13 16:17:20 tst kernel: [   91.769374] md: running: <hdc2><hda2>
Dec 13 16:17:20 tst kernel: [   91.773408] md0: setting max_sectors to 8, segment boundary to 2047
Dec 13 16:17:20 tst kernel: [   91.779679] blk_queue_segment_boundary: set to minimum fff
Dec 13 16:17:20 tst kernel: [   91.785167] raid0: looking at hdc2
Dec 13 16:17:20 tst kernel: [   91.788576] raid0:   comparing hdc2(18065024) with hdc2(18065024)
Dec 13 16:17:20 tst kernel: [   91.794687] raid0:   END
Dec 13 16:17:20 tst kernel: [   91.797223] raid0:   ==> UNIQUE
Dec 13 16:17:20 tst kernel: [   91.800366] raid0: 1 zones
Dec 13 16:17:20 tst kernel: [   91.803075] raid0: looking at hda2
Dec 13 16:17:20 tst kernel: [   91.806479] raid0:   comparing hda2(18065024) with hdc2(18065024)
Dec 13 16:17:20 tst kernel: [   91.812591] raid0:   EQUAL
Dec 13 16:17:20 tst kernel: [   91.815300] raid0: FINAL 1 zones
Dec 13 16:17:20 tst kernel: [   91.818531] raid0: done.
Dec 13 16:17:20 tst kernel: [   91.821075] raid0 : md_size is 36130048 blocks.
Dec 13 16:17:20 tst kernel: [   91.825612] raid0 : conf->hash_spacing is 36130048 blocks.
Dec 13 16:17:20 tst kernel: [   91.831100] raid0 : nb_zone is 1.
Dec 13 16:17:20 tst kernel: [   91.834416] raid0 : Allocating 4 bytes for hash.
Dec 13 16:17:20 tst kernel: [   91.839254] md: ... autorun DONE.
Dec 13 16:17:20 tst kernel: [   91.876228] kjournald starting.  Commit interval 5 seconds
Dec 13 16:17:20 tst kernel: [   91.876349] EXT3-fs: mounted filesystem with ordered data mode.
Dec 13 16:17:20 tst kernel: [   91.876402] VFS: Mounted root (ext3 filesystem) readonly.
Dec 13 16:17:20 tst kernel: [   91.877172] Freeing unused kernel memory: 524k freed
Dec 13 16:17:20 tst kernel: [   91.877244] Write protecting the kernel read-only data: 875k
Dec 13 16:17:20 tst kernel: [   92.655158] mount used greatest stack depth: 1680 bytes left
Dec 13 16:17:20 tst kernel: [   92.792468] awk used greatest stack depth: 1600 bytes left
Dec 13 16:17:20 tst kernel: [   95.049623] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 19
Dec 13 16:17:20 tst kernel: [   95.347541] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Dec 13 16:17:20 tst kernel: [   95.347549] Copyright (c) 1999-2006 Intel Corporation.
Dec 13 16:17:20 tst kernel: [   95.347796] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 28 (level, low) -> IRQ 20
Dec 13 16:17:20 tst kernel: [   95.446444] e1000: 0000:03:01.0: e1000_check_options: Interrupt Throttling Rate (ints/sec) turned off
Dec 13 16:17:20 tst kernel: [   95.446832] e1000: 0000:03:01.0: e1000_probe: (PCI:66MHz:32-bit) 00:30:48:72:50:f2
Dec 13 16:17:20 tst kernel: [   95.587888] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Dec 13 16:17:20 tst kernel: [   95.588077] ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 29 (level, low) -> IRQ 21
Dec 13 16:17:20 tst kernel: [   95.893000] e1000: 0000:03:02.0: e1000_probe: (PCI:66MHz:32-bit) 00:30:48:72:50:f3
Dec 13 16:17:20 tst kernel: [   96.080088] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
Dec 13 16:17:20 tst kernel: [   96.981772] sd 1:0:0:0: Attached scsi generic sg0 type 0
Dec 13 16:17:20 tst kernel: [   96.990620] USB Universal Host Controller Interface driver v3.0
Dec 13 16:17:20 tst kernel: [   96.990879] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 22
Dec 13 16:17:20 tst kernel: [   96.990920] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Dec 13 16:17:20 tst kernel: [   96.992318] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Dec 13 16:17:20 tst kernel: [   96.992476] uhci_hcd 0000:00:1d.0: irq 22, io base 0x0000e000
Dec 13 16:17:20 tst kernel: [   96.993506] usb usb1: configuration #1 chosen from 1 choice
Dec 13 16:17:20 tst kernel: [   96.993821] hub 1-0:1.0: USB hub found
Dec 13 16:17:20 tst kernel: [   96.993892] hub 1-0:1.0: 2 ports detected
Dec 13 16:17:20 tst kernel: [   97.115184] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 23
Dec 13 16:17:20 tst kernel: [   97.115303] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Dec 13 16:17:20 tst kernel: [   97.120103] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Dec 13 16:17:20 tst kernel: [   97.120198] uhci_hcd 0000:00:1d.1: irq 23, io base 0x0000e400
Dec 13 16:17:20 tst kernel: [   97.121005] usb usb2: configuration #1 chosen from 1 choice
Dec 13 16:17:20 tst kernel: [   97.121260] hub 2-0:1.0: USB hub found
Dec 13 16:17:20 tst kernel: [   97.121305] hub 2-0:1.0: 2 ports detected
Dec 13 16:17:20 tst kernel: [   97.223882] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
Dec 13 16:17:20 tst kernel: [   97.223926] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Dec 13 16:17:20 tst kernel: [   97.230639] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Dec 13 16:17:20 tst kernel: [   97.230729] uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000e800
Dec 13 16:17:20 tst kernel: [   97.234123] usb usb3: configuration #1 chosen from 1 choice
Dec 13 16:17:20 tst kernel: [   97.234965] hub 3-0:1.0: USB hub found
Dec 13 16:17:20 tst kernel: [   97.235020] hub 3-0:1.0: 2 ports detected
Dec 13 16:17:20 tst kernel: [   98.239871] FDC 0 is a post-1991 82077
Dec 13 16:17:20 tst kernel: [   98.262789] parport_pc 00:08: reported by Plug and Play ACPI
Dec 13 16:17:20 tst kernel: [   98.262983] parport0: PC-style at 0x378, irq 7 [PCSPP]
Dec 13 16:17:20 tst kernel: [   98.493450] md: Autodetecting RAID arrays.
Dec 13 16:17:20 tst kernel: [   98.493457] md: autorun ...
Dec 13 16:17:20 tst kernel: [   98.493459] md: ... autorun DONE.
Dec 13 16:17:20 tst kernel: [   98.550322] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Dec 13 16:17:20 tst kernel: [   99.301348] EXT3 FS on hda1, internal journal
Dec 13 16:17:20 tst kernel: [   99.399597] kjournald starting.  Commit interval 5 seconds
Dec 13 16:17:20 tst kernel: [   99.399953] EXT3 FS on md0, internal journal
Dec 13 16:17:20 tst kernel: [   99.399971] EXT3-fs: mounted filesystem with ordered data mode.
Dec 13 16:17:20 tst kernel: [   99.601744] SGI XFS with ACLs, security attributes, realtime, no debug enabled
Dec 13 16:17:20 tst kernel: [   99.603273] SGI XFS Quota Management subsystem
Dec 13 16:17:20 tst kernel: [   99.620839] XFS mounting filesystem sda1
Dec 13 16:17:20 tst kernel: [   99.656581] kjournald starting.  Commit interval 5 seconds
Dec 13 16:17:20 tst kernel: [   99.656923] EXT3 FS on sda3, internal journal
Dec 13 16:17:20 tst kernel: [   99.656939] EXT3-fs: mounted filesystem with ordered data mode.
Dec 13 16:17:20 tst kernel: [  102.464324] Adding 1048568k swap on /boot/swapfile.  Priority:-1 extents:315 across:1962812k
Dec 13 16:17:20 tst kernel: [  102.649851] rc.sysinit used greatest stack depth: 1396 bytes left
Dec 13 16:17:20 tst kernel: [  104.271930] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
Dec 13 16:17:20 tst kernel: [  108.740087] ADDRCONF(NETDEV_UP): eth1: link is not ready
Dec 13 16:17:21 tst kernel: [  113.812680] w83627hf: Found W83627HF chip at 0x290
Dec 13 16:17:26 tst kernel: [  118.791911] input: PC Speaker as /devices/platform/pcspkr/input/input3
Dec 13 16:17:26 tst kernel: [  118.810752] RAMDISK driver initialized: 1 RAM disks of 1743200K size 512 blocksize
Dec 13 16:30:45 tst kernel: [  917.365831] 
Dec 13 16:30:45 tst kernel: [  917.365836] =============================================
Dec 13 16:30:45 tst kernel: [  917.372856] [ INFO: possible recursive locking detected ]
Dec 13 16:30:45 tst kernel: [  917.378269] 2.6.23-dbg #17
Dec 13 16:30:45 tst kernel: [  917.381435] ---------------------------------------------
Dec 13 16:30:45 tst kernel: [  917.386838] dbench/3538 is trying to acquire lock:
Dec 13 16:30:45 tst kernel: [  917.391687]  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
Dec 13 16:30:45 tst kernel: [  917.400262] 
Dec 13 16:30:45 tst kernel: [  917.400264] but task is already holding lock:
Dec 13 16:30:45 tst kernel: [  917.406116]  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
Dec 13 16:30:45 tst kernel: [  917.414503] 
Dec 13 16:30:45 tst kernel: [  917.414505] other info that might help us debug this:
Dec 13 16:30:45 tst kernel: [  917.421242] 3 locks held by dbench/3538:
Dec 13 16:30:45 tst kernel: [  917.425178]  #0:  (&inode->i_mutex){--..}, at: [<783626a6>] mutex_lock+0x1c/0x1f
Dec 13 16:30:45 tst kernel: [  917.432805]  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
Dec 13 16:30:45 tst kernel: [  917.441696]  #2:  (&type->s_umount_key#17){----}, at: [<78191411>] writeback_inodes+0x88/0xd5
Dec 13 16:30:45 tst kernel: [  917.450578] 
Dec 13 16:30:45 tst kernel: [  917.450582] stack backtrace:
Dec 13 16:30:45 tst kernel: [  917.455011]  [<78103d59>] show_trace_log_lvl+0x1a/0x30
Dec 13 16:30:45 tst kernel: [  917.460279]  [<7810488d>] show_trace+0x12/0x14
Dec 13 16:30:45 tst kernel: [  917.464759]  [<781048a5>] dump_stack+0x16/0x18
Dec 13 16:30:45 tst kernel: [  917.469262]  [<7813f883>] __lock_acquire+0xdd1/0x106e
Dec 13 16:30:45 tst kernel: [  917.474360]  [<7813fb89>] lock_acquire+0x69/0x82
Dec 13 16:30:45 tst kernel: [  917.479000]  [<78136184>] down_write_nested+0x40/0x88
Dec 13 16:30:45 tst kernel: [  917.484195]  [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
Dec 13 16:30:45 tst kernel: [  917.489180]  [<f89d13b7>] xfs_inactive+0x329/0x4ed [xfs]
Dec 13 16:30:45 tst kernel: [  917.494565]  [<f89dc052>] xfs_fs_clear_inode+0x7a/0xbe [xfs]
Dec 13 16:30:45 tst kernel: [  917.500415]  [<78188a78>] clear_inode+0xb2/0x14d
Dec 13 16:30:45 tst kernel: [  917.505078]  [<78188c0b>] generic_delete_inode+0xf8/0x105
Dec 13 16:30:45 tst kernel: [  917.510513]  [<78188d27>] generic_drop_inode+0x10f/0x141
Dec 13 16:30:45 tst kernel: [  917.515854]  [<78188226>] iput+0x5f/0x66
Dec 13 16:30:45 tst kernel: [  917.519836]  [<781911ae>] sync_sb_inodes+0x1f6/0x25c
Dec 13 16:30:45 tst kernel: [  917.525032]  [<7819142f>] writeback_inodes+0xa6/0xd5
Dec 13 16:30:45 tst kernel: [  917.530070]  [<7815c9f3>] balance_dirty_pages_ratelimited_nr+0xdd/0x204
Dec 13 16:30:45 tst kernel: [  917.536716]  [<781580e4>] generic_file_buffered_write+0x2e2/0x69c
Dec 13 16:30:45 tst kernel: [  917.542855]  [<f89db3fe>] xfs_write+0x619/0xaab [xfs]
Dec 13 16:30:45 tst kernel: [  917.547990]  [<f89d776e>] xfs_file_aio_write+0x70/0x7c [xfs]
Dec 13 16:30:45 tst kernel: [  917.553770]  [<78175d65>] do_sync_write+0xd0/0x106
Dec 13 16:30:45 tst kernel: [  917.558620]  [<78176552>] vfs_write+0x8b/0x149
Dec 13 16:30:45 tst kernel: [  917.563113]  [<78176bc4>] sys_write+0x3d/0x64
Dec 13 16:30:45 tst kernel: [  917.567526]  [<78102ca2>] sysenter_past_esp+0x5f/0x99
Dec 13 16:30:45 tst kernel: [  917.572635]  =======================
Dec 13 16:46:11 tst kernel: [ 1842.236343] dbench used greatest stack depth: 796 bytes left
Dec 13 16:46:11 tst kernel: [ 1842.248527] dbench used greatest stack depth: 544 bytes left
Dec 13 16:46:13 tst kernel: [ 1845.027574] dbench used greatest stack depth: 528 bytes left

--------------090406000303050106050509--
