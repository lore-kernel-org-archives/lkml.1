Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZFKWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZFKWEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbZFKWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:04:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbZFKWEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:04:13 -0400
Date: Fri, 12 Jun 2009 00:03:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
Message-ID: <20090611220307.GA16180@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com> <4A3143E3.3090705@kernel.org> <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI> <20090611214342.GA12762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611214342.GA12762@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i also get this different warning, again:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x2b/0x71()
[    0.000000] Hardware name: System Product Name
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Tainted: G        W  2.6.30-tip-03087-g0bb2618-dirty #52506
[    0.000000] Call Trace:
[    0.000000]  [<81032588>] warn_slowpath_common+0x60/0x90
[    0.000000]  [<810325c5>] warn_slowpath_null+0xd/0x10
[    0.000000]  [<819d1bc0>] alloc_arch_preferred_bootmem+0x2b/0x71
[    0.000000]  [<819d1c31>] ___alloc_bootmem_nopanic+0x2b/0x9a
[    0.000000]  [<81050a0a>] ? lock_release+0xac/0xb2
[    0.000000]  [<819d1d4c>] ___alloc_bootmem+0xe/0x2d
[    0.000000]  [<819d1e9f>] __alloc_bootmem+0xa/0xc
[    0.000000]  [<819d7c63>] alloc_bootmem_cpumask_var+0x21/0x26
[    0.000000]  [<819d0cc8>] early_irq_init+0x15/0x10d
[    0.000000]  [<819bb75a>] start_kernel+0x167/0x326
[    0.000000]  [<819bb06b>] __init_begin+0x6b/0x70
[    0.000000] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] CPU 0 irqstacks, hard=821e6000 soft=821e7000

	Ingo
