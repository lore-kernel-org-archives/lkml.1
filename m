Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYL2Ujm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYL2Ujm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYL2Uhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:37:34 -0500
Received: from main.gmane.org ([80.91.229.2]:49236 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYL2Uhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:37:32 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: You are fussing about bug reports, here is one.  Seems like a
 shrug,   but...
Date: Mon, 29 Dec 2008 14:37:21 -0600
Message-ID: <49593501.1060705@shaw.ca>
References: <200812290952.54095.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <200812290952.54095.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> 2.6.28.final, has existed most of the way through the 28-rc series.  This ASUS 
> mobo is a $250+ mobo, latest (working bios, the beta does work at all) and 
> has a quad core Phenom with 4GB of dram on it.
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 
> generic_get_mtrr+0x11c/0x130()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28 #1
> [    0.000000] Call Trace:
> [    0.000000]  [<c04267b6>] warn_slowpath+0x76/0x90
> [    0.000000]  [<c050dd97>] vsnprintf+0x2e7/0x680
> [    0.000000]  [<c042750b>] printk+0x1b/0x20
> [    0.000000]  [<c0419e7c>] pat_init+0x7c/0xa0
> [    0.000000]  [<c040e43c>] post_set+0x1c/0x50
> [    0.000000]  [<c0426f5d>] release_console_sem+0x18d/0x1c0
> [    0.000000]  [<c040ea8c>] generic_get_mtrr+0x11c/0x130
> [    0.000000]  [<c0712eda>] mtrr_trim_uncached_memory+0x7a/0x330
> [    0.000000]  [<c042750b>] printk+0x1b/0x20
> [    0.000000]  [<c070fd45>] e820_end_pfn+0xc5/0xf0
> [    0.000000]  [<c070e120>] setup_arch+0x420/0xb60
> [    0.000000]  [<c071126b>] reserve_early_overlap_ok+0x4b/0x60
> [    0.000000]  [<c07079c8>] start_kernel+0x58/0x2e0
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> What it seems to be is useless noise, and only ASUS knows if it will be fixed.  
> As for reporting this to ASUS, has anyone a contact address?, their website 
> has none that works.

Well, as it says it's a BIOS bug.. and potentially a rather serious one, 
since bad MTRR settings can slow your system to a crawl by preventing 
proper caching or prevent all RAM from being used properly. The code 
that produces the warning fixes up the damage for you.

