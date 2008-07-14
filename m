Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYGNJMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYGNJMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYGNJMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:12:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:25172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbYGNJMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,358,1212390000"; 
   d="scan'208";a="417353892"
Subject: Re: ACPI Error under 2.6.26-rc*
From: Zhang Rui <rui.zhang@intel.com>
To: Andre Prendel <andre_prendel@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       kernel-testers@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080714080914.GA4965@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag>
	 <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt>
	 <1215739682.1617.32.camel@rzhang-dt>
	 <20080714080914.GA4965@linux.int.dgn.ag>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Jul 2008 17:11:41 +0800
Message-Id: <1216026701.1617.82.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 16:09 +0800, Andre Prendel wrote:
> On Fri, Jul 11, 2008 at 09:28:02AM +0800, Zhang Rui wrote:
> > On Fri, 2008-07-11 at 09:20 +0800, Zhang Rui wrote:
> > > On Fri, 2008-07-11 at 04:55 +0800, Rafael J. Wysocki wrote:
> > > > [Adding CCs.]
> > > >
> > > > On Wednesday, 9 of July 2008, Andre Prendel wrote:
> > > > > Hi,
> > > > >
> > > > > I have had some ACPI Problems working under the 2.6.26-rc's in
> the
> > > > last weeks.
> > > > > Power off does not work well. "System halted" is the last
> output,
> > > > but power is
> > > > > not switch off. The lastest stable kernel (2.6.25.10) works
> fine for
> > > > me. After
> > > > > that I tried 2.6.26-rc1 and the error occurs. AFAIR I had
> these
> > > > problems with
> > > > > all 2.6.26-rc's until 2.6.26-rc8-git4. I did not tested newer
> ones.
> > > > >
> > > > > Dmesg output is attached.
> > > > >
> > > > > Andre
> > > > >
> > > > > ----------------------------------
> > > > > [    0.000000] Linux version 2.6.26-rc1 (andre@ubuntu) (gcc
> version
> > > > 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #8 SMP Tue
> Jul 8
> > > > 22:28:14 CEST 2008
> > > > > [    0.000000] BIOS-provided physical RAM map:
> > > > > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00
> > > > (usable)
> > > > > [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000
> > > > (reserved)
> > > > > [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000
> > > > (reserved)
> > > > > [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000
> > > > (usable)
> > > > > [    0.000000]  BIOS-e820: 0000000021ff0000 - 0000000021ff8000
> (ACPI
> > > > data)
> > > > > [    0.000000]  BIOS-e820: 0000000021ff8000 - 0000000022000000
> (ACPI
> > > > NVS)
> > > > > [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000
> > > > (reserved)
> > > > > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
> > > > (reserved)
> > > > > [    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000
> > > > (reserved)
> > > > > [    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000
> > > > (reserved)
> > > > > [    0.000000] x86: PAT support disabled.
> > > > > [    0.000000] 511MB LOWMEM available.
> > > > > [    0.000000] Entering add_active_range(0, 0, 131056) 0
> entries of
> > > > 256 used
> > > > > [    0.000000] Zone PFN ranges:
> > > > > [    0.000000]   DMA             0 ->     4096
> > > > > [    0.000000]   Normal       4096 ->   131056
> > > > > [    0.000000] Movable zone start PFN for each node
> > > > > [    0.000000] early_node_map[1] active PFN ranges
> > > > > [    0.000000]     0:        0 ->   131056
> > > > > [    0.000000] On node 0 totalpages: 131056
> > > > > [    0.000000]   DMA zone: 32 pages used for memmap
> > > > > [    0.000000]   DMA zone: 0 pages reserved
> > > > > [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> > > > > [    0.000000]   Normal zone: 991 pages used for memmap
> > > > > [    0.000000]   Normal zone: 125969 pages, LIFO batch:31
> > > > > [    0.000000]   Movable zone: 0 pages used for memmap
> > > > > [    0.000000] DMI 2.3 present.
> > > > > [    0.000000] ACPI: RSDP 000FA340, 0014 (r0 AMI   )
> > > > > [    0.000000] ACPI:      21FF0000, 0000 (r0
> > > > 0             0)
> > > > > [    0.000000] ACPI Error (tbutils-0472): Invalid length 0x0
> in
> > > > RSDT/XSDT [20080321]
> > >
> > > Please attach the acpidump output using the latest pmtools at
> > > http://www.lesswatts.org/patches/linux_acpi/
> > >
> > Please also attach the dmesg output of a working kernel.
> 
> Hello Rui,
> 
> that's quite strange. Booting the system to get an acpidump I have
> looked at the dmesg output and there is no ACPI Error like the one
> above. There is only an ACPI Exeption.
> 
> [...]
> Jul 13 22:00:18 ubuntu kernel: [    0.104111] ACPI: Core revision
> 20080321
> Jul 13 22:00:18 ubuntu kernel: [    0.104259] ACPI Exception
> (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI
> tables [20080321]
> [...]
> 
> Booting again I found the error again
> 
> [...]
> Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI Error
> (tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20080321]
> [...]
> 
> and acpidump says:
> root@ubuntu:/home/andre/src/acpi/pmtools-20071116/acpidump#
> ./acpidumpACPI tables were not found. If you know location of RSD PTR
> table (from dmesg, etc), supply it with either --addr or -a option
> 
> Linux 2.6.25.10 always works.

It seems that OS failed to get the correct RSDT address (0x1fff0000),
although the RSDP is found correctly. (﻿ACPI: RSDP 000FA340, 0014)

please run "./acpidump --addr 0xFA340 --length 0x14 > rsdp_xxx",
and attach the rsdp for all of the three cases (good, ACPI Error, ACPI
Exception).

thanks,
rui

