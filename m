Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYAWCF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYAWCF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 21:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYAWCFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 21:05:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38165 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYAWCFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 21:05:19 -0500
Date: Wed, 23 Jan 2008 11:04:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
In-Reply-To: <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080123105810.F295.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi mel

> Hi 
> 
> > A fix[1] was merged to the x86.git tree that allowed NUMA kernels to boot
> > on normal x86 machines (and not just NUMA-Q, Summit etc.). I took a look
> > at the restrictions on setting NUMA on x86 to see if they could be lifted.
> 
> Interesting!
> 
> I will test tomorrow.

Hmm...
It doesn't works on my machine.

panic at booting at __free_pages_ok() with blow call trace.

[<hex number>] free_all_bootmem_core
[<hex number>] mem_init
[<hex number>] alloc_large_system_hash
[<hex number>] inode_init_early
[<hex number>] start_kernel
[<hex number>] unknown_bootoption

my machine spec
	CPU:   Pentium4 with HT
	MEM:   512M

I will try more investigate.
but I have no time for a while, sorry ;-)


BTW:
when config sparse mem turn on instead discontig mem.
panic at booting at get_pageblock_flags_group() with below call stack.

free_initrd
	free_init_pages
		free_hot_cold_page



- kosaki


