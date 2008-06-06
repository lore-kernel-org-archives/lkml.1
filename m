Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbYFFQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbYFFQiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYFFQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:38:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbYFFQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:38:04 -0400
Date: Fri, 6 Jun 2008 18:37:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606163733.GA18394@elte.hu>
References: <20080606071707.GB9708@elte.hu> <20080606072536.GA19334@elte.hu> <20080606003327.9ac0e91b.akpm@linux-foundation.org> <20080606074137.GA28962@elte.hu> <20080606004743.a78180c3.akpm@linux-foundation.org> <20080606082325.GA10826@elte.hu> <20080606013835.8dfd838b.akpm@linux-foundation.org> <20080606084949.GA28190@elte.hu> <20080606020109.c0db7a0c.akpm@linux-foundation.org> <20080606104701.GA9639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606104701.GA9639@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > what do you mean? We are testing commits that everybody will run and 
> > > are pre-filtering them for sanity and stability before they hit 
> > > linux-next.
> > 
> > One doesn't test commits - one tests a tree.  And the -tip tree is 
> > 2.6.26-rc5 plus a bunch of x86 changes. [...]
> 
> no, 90%+ of all bugs are not due to tree interaction effects but are 
> caused by individual commits, triggerable on a particular 
> system/workload. (Our historic regression list is the proof for that, 
> can give you itemized statistics if you want.)
> 
> also, the -tip tree is not "2.6.26-rc5 plus a bunch of x86 changes" but 
> v2.6.26-rc5-84-g39b945a plus 75 topic trees we maintain:
> 
> build, core/futex-64bit, core/kill-the-BKL, core/locking, core/percpu, 
> core/printk, core/rcu, core/rodata, core/softirq, core/softlockup, 
> core/stacktrace, core/urgent, cpus4096, genirq, hrtimers, kmemcheck, 
> out-of-tree, pci-for-jesse, safe-poison-pointers, sched, sched-devel, 
> scratch, stackprotector, timers/clockevents, timers/hpet, 
> timers/hrtimers, timers/nohz, timers/posixtimers, tip, tracing/ftrace, 
> tracing/ftrace-mergefixups, tracing/immediates, tracing/markers, 
> tracing/mmiotrace, tracing/mmiotrace-mergefixups, tracing/nmisafe, 
> tracing/sched_markers, tracing/stopmachine-allcpus, tracing/sysprof, 
> tracing/textedit, x86/apic, x86/apm, x86/bitops, x86/build, x86/checkme, 
> x86/cleanups, x86/cpa, x86/cpu, x86/defconfig, x86/gart, x86/i8259, 
> x86/intel, x86/irq, x86/irqstats, x86/kconfig, x86/ldt, x86/mce, 
> x86/memtest, x86/mmio, x86/mpparse, x86/nmi, x86/numa, x86/numa-fixes, 
> x86/pat, x86/pebs, x86/ptemask, x86/resumetrace, x86/scratch, x86/setup, 
> x86/threadinfo, x86/timers, x86/urgent, x86/uv, x86/vdso, x86/xen, 
> x86/xsave.
> 
> most of which are in linux-next (around 70%), or will be shortly in 
> linux-next (more than 90%).

we created some stats and in fact not 70% but 80% of all -tip commits 
are in linux-next right now.

Here are the full -tip commit stats (merge commits excluded):

  total commits in auto-next-branches: 617
  auto-branches commits in linux-next: 553
  total commits in tip/auto-latest:    686
  total commits in tip/master:         699

that propotion should go up to 90% on the next linux-next iteration. 
(barring any problems with the new topics)

	Ingo
