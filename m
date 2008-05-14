Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbYENTM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbYENTM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbYENTMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:12:17 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:20851 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYENTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nU4vJju9c0Mq43ohbNO6InFDYtO3NU3f6jiyrDDjmHxz8IW1UuNCJr8Yvdhzq5JyIYbi6KMa4EXOO6fpE9ZTMYWmhzIKxsLaagSeaZbfu3EigJvuA5urFFWZ1j4/hrxpNp3JrNMiKuVJyYi/sgEja9t3pZsQWVfhw9ZWYpzzXjY=
Message-ID: <64bb37e0805141212i7587a502vdff9af109b55c37b@mail.gmail.com>
Date: Wed, 14 May 2008 21:12:13 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:01 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

Nice! This one works for me again.

But somehow the NUMAness of my system is gone.

2.6.26-rc2-mm1:
[    0.000000] max_pfn_mapped = 1179648
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FB080, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT DFFD0100, 0064 (r1 A_M_I_ OEMXSDT   4000713
MSFT       97)
[    0.000000] ACPI: FACP DFFD0290, 00F4 (r3 A_M_I_ OEMFACP   4000713
MSFT       97)
[    0.000000] ACPI: DSDT DFFD0450, 4FC5 (r1  S0027 S0027000        0
INTL 20051117)
[    0.000000] ACPI: FACS DFFDE000, 0040
[    0.000000] ACPI: APIC DFFD0390, 0080 (r1 A_M_I_ OEMAPIC   4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD0410, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: OEMB DFFDE040, 0060 (r1 A_M_I_ AMI_OEM   4000713
MSFT       97)
[    0.000000] ACPI: HPET DFFD5420, 0038 (r1 A_M_I_ OEMHPET0  4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD5460, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: SRAT DFFD54A0, 0110 (r1 AMD    HAMMER          1
AMD         1)
[    0.000000] ACPI: SSDT DFFD55B0, 04F0 (r1 A_M_I_ POWERNOW        1
AMD         1)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXMs only cover 0MB of your 4608MB e820 RAM. Not used.
[    0.000000] SRAT: SRAT not used.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [000000000000e000 -  0000000000031fff] pages 24
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-9601db] TEXT DATA BSS
[    0.000000]   early res: 3 [37ec8000-37fefc27] RAMDISK
[    0.000000]   early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20003ffffff] PMD ->
[ffff81000c200000-ffff81000fbfffff] on node 0
[    0.000000] sizeof(struct page) = 56
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1179648
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   917456
[    0.000000]     0:  1048576 ->  1179648
[    0.000000] On node 0 totalpages: 1048431
[    0.000000]   DMA zone: 1948 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 899080 pages, LIFO batch:31
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus

with 2.6.25-rc3-mm1:
[    0.000000] end_pfn_map = 1179648
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FB080, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT DFFD0100, 0064 (r1 A_M_I_ OEMXSDT   4000713
MSFT       97)
[    0.000000] ACPI: FACP DFFD0290, 00F4 (r3 A_M_I_ OEMFACP   4000713
MSFT       97)
[    0.000000] ACPI: DSDT DFFD0450, 4FC5 (r1  S0027 S0027000        0
INTL 20051117)
[    0.000000] ACPI: FACS DFFDE000, 0040
[    0.000000] ACPI: APIC DFFD0390, 0080 (r1 A_M_I_ OEMAPIC   4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD0410, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: OEMB DFFDE040, 0060 (r1 A_M_I_ AMI_OEM   4000713
MSFT       97)
[    0.000000] ACPI: HPET DFFD5420, 0038 (r1 A_M_I_ OEMHPET0  4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD5460, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: SRAT DFFD54A0, 0110 (r1 AMD    HAMMER          1
AMD         1)
[    0.000000] ACPI: SSDT DFFD55B0, 04F0 (r1 A_M_I_ POWERNOW        1
AMD         1)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] Entering add_active_range(0, 0, 159) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 524288) 1 entries of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] Entering add_active_range(1, 524288, 917456) 2 entries
of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 80000000-120000000
[    0.000000] Entering add_active_range(1, 524288, 917456) 3 entries
of 3200 used
[    0.000000] Entering add_active_range(1, 1048576, 1179648) 3
entries of 3200 used
[    0.000000] NUMA: Using 31 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [000000000000e000 -  000000000001dfff] pages 10
[    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
[    0.000000]   NODE_DATA [0000000080000000 - 0000000080003fff]
[    0.000000]   bootmap [0000000080004000 -  0000000080017fff] pages 14

The system is a dual socket Opteron system, each processor has 2 GB of RAM.

I will try to debug this more tomorrow, but except the kernel now
thinks there is only one NUMA node the system works correct. It is
detecting the full 4GB of RAM.

This line from 2.6.26-rc2-mm1 really looks like the source of this:
[    0.000000] SRAT: PXMs only cover 0MB of your 4608MB e820 RAM. Not used.
There is no more than 4GB of RAM (but part of it is remapped...)

Torsten
