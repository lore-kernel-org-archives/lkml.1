Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKTJW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKTJW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYKTJWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:22:43 -0500
Received: from inhex.net ([193.33.178.145]:38140 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYKTJWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:22:42 -0500
Date: Thu, 20 Nov 2008 11:22:39 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28 git: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
	generic_get_mtrr+0xea/0x120()
Message-ID: <20081120092239.GA16613@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks. This is first time I've tried 2.6.28-git (cloned git a few hours ago). 
And got this:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffd0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 000000007ffde000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffde000 - 0000000080000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x7ffd0 max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xea/0x120()
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc5 #1
[    0.000000] Call Trace:
[    0.000000]  [<c012b86f>] warn_slowpath+0x6f/0x90
[    0.000000]  [<c0373031>] inet_rtm_newroute+0x21/0x50
[    0.000000]  [<c02593c4>] number+0x2b4/0x2c0
[    0.000000]  [<c0259ff3>] vsnprintf+0x393/0x670
[    0.000000]  [<c0144fd1>] up+0x11/0x40
[    0.000000]  [<c012c069>] release_console_sem+0x189/0x1d0
[    0.000000]  [<c01124da>] generic_get_mtrr+0xea/0x120
[    0.000000]  [<c04db85f>] mtrr_trim_uncached_memory+0x7d/0x374
[    0.000000]  [<c03a569a>] printk+0x17/0x1b
[    0.000000]  [<c011edbc>] pat_init+0x7c/0xa0
[    0.000000]  [<c01129ac>] post_set+0x1c/0x50
[    0.000000]  [<c03a569a>] printk+0x17/0x1b
[    0.000000]  [<c04d7b52>] e820_end_pfn+0xb5/0xd3
[    0.000000]  [<c04d6016>] setup_arch+0x518/0x802
[    0.000000]  [<c04d8cc7>] reserve_early_overlap_ok+0x3f/0x47
[    0.000000]  [<c04cf5dc>] start_kernel+0x58/0x334
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-16000

Can I just ignore this?

-- 
WBR, Dmitry
