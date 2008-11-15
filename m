Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYKOK1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYKOK1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYKOK1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:27:21 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:39134 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYKOK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:27:20 -0500
Date: Sat, 15 Nov 2008 05:27:18 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: bios bug?
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <200811150527.18727.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel 2.6.28-rc4, amd 9550 phenom, 4GB ram on ASUS M2N LSI Deluxe mobo. 

While it doesn't appear to be bothering anything, my dmesg contains this:

[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it 
around.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 
generic_get_mtrr+0x11c/0x130()
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc4 #1
[    0.000000] Call Trace:
[    0.000000]  [<c04284a6>] warn_slowpath+0x76/0x90
[    0.000000]  [<c0511c07>] vsnprintf+0x2e7/0x680
[    0.000000]  [<c04291fb>] printk+0x1b/0x20
[    0.000000]  [<c041b6ec>] pat_init+0x7c/0xa0
[    0.000000]  [<c040fe1c>] post_set+0x1c/0x50
[    0.000000]  [<c0428c4d>] release_console_sem+0x18d/0x1c0
[    0.000000]  [<c041046c>] generic_get_mtrr+0x11c/0x130
[    0.000000]  [<c072e01a>] mtrr_trim_uncached_memory+0x7a/0x330
[    0.000000]  [<c04291fb>] printk+0x1b/0x20
[    0.000000]  [<c072ad45>] e820_end_pfn+0xc5/0xf0
[    0.000000]  [<c0729120>] setup_arch+0x420/0xb60
[    0.000000]  [<c072c26b>] reserve_early_overlap_ok+0x4b/0x60
[    0.000000]  [<c07229c8>] start_kernel+0x58/0x2e0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

The next bios from ASUS doesn't get the memory configured into dual channel & 
crashes at grub load or there abouts.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Losing your drivers' license is just God's way of saying "BOOGA, BOOGA!"
