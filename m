Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbXCHVVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbXCHVVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXCHVVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:21:15 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:36573 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbXCHVVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:21:14 -0500
Date: Thu, 8 Mar 2007 23:21:13 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Marc Perkel <mperkel@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: More nVidia 4gb ram problems
Message-ID: <20070308212113.GC3883@mea-ext.zmailer.org>
References: <447507.15233.qm@web52510.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <447507.15233.qm@web52510.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Mar 08, 2007 at 12:07:16PM -0800, Marc Perkel wrote:
> Running FC6. When I try to format a Raid 1 device the
> server locks up when it creates the journal. However
> if I use just 2 gigs of ram then it doesn't lock up.
> Asus motherboard.
> 
> Please CC me as I'm not a list member.

Took some digging out of your log..

 AMD Athlon(tm)64 X2 Dual Core Processor  4800+ stepping 02

I have same CPU, though possibly a bit different board.
I didn't have success with 4 GB RAM until couple months
ago, when Asus did publish a new (beta) BIOS version that
did correctly configure memory hoisting in the system.

I don't override the  pci=  and  iommu=  options, they
should work just fine -- if the BIOS isn't entirely rotten.

I have used   mem=3000M  which lets system to work, but
of course wastes a gigabyte of memory..

  /Matti Aarnio

> Linux version 2.6.19-1.2911.6.5.fc6 (brewbuilder@hs20-bc1-6.build.redhat.com) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Sun Mar 4 16:05:34 EST 2007
> Command line: ro root=LABEL=/ vga=1 pci=nommconf iommu=soft
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e5000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000abfc0000 (usable)
>  BIOS-e820: 00000000abfc0000 - 00000000abfce000 (ACPI data)
>  BIOS-e820: 00000000abfce000 - 00000000abff0000 (ACPI NVS)
>  BIOS-e820: 00000000abff0000 - 00000000ac000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
>  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 704448) 1 entries of 3200 used
> end_pfn_map = 1048576
> DMI 2.3 present.
> ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000fb870
> ACPI: XSDT (v001 A M I  OEMXSDT  0x04000619 MSFT 0x00000097) @ 0x00000000abfc0100
> ACPI: FADT (v003 A M I  OEMFACP  0x04000619 MSFT 0x00000097) @ 0x00000000abfc0290
> ACPI: MADT (v001 A M I  OEMAPIC  0x04000619 MSFT 0x00000097) @ 0x00000000abfc0390
> ACPI: MCFG (v001 A M I  OEMMCFG  0x04000619 MSFT 0x00000097) @ 0x00000000abfc0400
> ACPI: OEMB (v001 A M I  AMI_OEM  0x04000619 MSFT 0x00000097) @ 0x00000000abfce040
> ACPI: DSDT (v001  A0368 A0368001 0x00000001 INTL 0x02002026) @ 0x0000000000000000
> Scanning NUMA topology in Northbridge 24
> Number of nodes 1
> Node 0 MemBase 0000000000000000 Limit 00000000abfc0000
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 704448) 1 entries of 3200 used
> NUMA: Using 63 for the hash shift.
> Using node hash shift of 63
> Bootmem setup node 0 0000000000000000-00000000abfc0000
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> early_node_map[2] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->   704448
> On node 0 totalpages: 704351
>   DMA zone: 64 pages used for memmap
>   DMA zone: 1449 pages reserved
>   DMA zone: 2486 pages, LIFO batch:0
>   DMA32 zone: 10943 pages used for memmap
>   DMA32 zone: 689409 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
> Nvidia board detected. Ignoring ACPI timer override.
> If you got timer trouble try acpi_use_timer_override
......
