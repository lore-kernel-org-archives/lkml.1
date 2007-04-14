Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXDNQKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXDNQKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbXDNQKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:10:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXDNQKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:10:11 -0400
Date: Sat, 14 Apr 2007 18:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414160939.GB3099@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704141809.58737.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> > i'm pleased to announce the first release of the "Modular Scheduler 
> > Core and Completely Fair Scheduler [CFS]" patchset:
> 
> Currently im using Linus's current git + your extra patches + CFS for 
> a while. Kaffeine constantly freezes (and uses %80+ CPU time) [1] if i 
> seek forward/backward while its playing a video with some workload 
> (checking out SVN repositories, compiling something). Stopping other 
> process didn't help kaffeine so it stays freezed stated until i kill 
> it.

hm, could you try to strace it and/or attach gdb to it and figure out 
what's wrong? (perhaps involving the Kaffeine developers too?) As long 
as it's not a kernel level crash i cannot see how the scheduler could 
directly cause this - other than by accident creating a scheduling 
pattern that triggers a user-space bug more often than with other 
schedulers.

> [1] http://cekirdek.pardus.org.tr/~caglar/psaux

looks quite weird!

	Ingo
