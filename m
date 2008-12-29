Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbYL2OuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbYL2OuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYL2OuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:50:00 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:64211 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYL2OuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:50:00 -0500
Date: Mon, 29 Dec 2008 09:52:54 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: You are fussing about bug reports, here is one.  Seems like a shrug,
 but...
To: linux-kernel@vger.kernel.org
Message-id: <200812290952.54095.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28.final, has existed most of the way through the 28-rc series.  This ASUS 
mobo is a $250+ mobo, latest (working bios, the beta does work at all) and 
has a quad core Phenom with 4GB of dram on it.

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 
generic_get_mtrr+0x11c/0x130()
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28 #1
[    0.000000] Call Trace:
[    0.000000]  [<c04267b6>] warn_slowpath+0x76/0x90
[    0.000000]  [<c050dd97>] vsnprintf+0x2e7/0x680
[    0.000000]  [<c042750b>] printk+0x1b/0x20
[    0.000000]  [<c0419e7c>] pat_init+0x7c/0xa0
[    0.000000]  [<c040e43c>] post_set+0x1c/0x50
[    0.000000]  [<c0426f5d>] release_console_sem+0x18d/0x1c0
[    0.000000]  [<c040ea8c>] generic_get_mtrr+0x11c/0x130
[    0.000000]  [<c0712eda>] mtrr_trim_uncached_memory+0x7a/0x330
[    0.000000]  [<c042750b>] printk+0x1b/0x20
[    0.000000]  [<c070fd45>] e820_end_pfn+0xc5/0xf0
[    0.000000]  [<c070e120>] setup_arch+0x420/0xb60
[    0.000000]  [<c071126b>] reserve_early_overlap_ok+0x4b/0x60
[    0.000000]  [<c07079c8>] start_kernel+0x58/0x2e0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

What it seems to be is useless noise, and only ASUS knows if it will be fixed.  
As for reporting this to ASUS, has anyone a contact address?, their website 
has none that works.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Footnotes are for things you believe don't really belong in LDP manuals,
but want to include anyway.
	-- Joel N. Weber II discussing the 'make' chapter of LPG
