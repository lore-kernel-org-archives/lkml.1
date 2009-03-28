Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZC1Xke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZC1Xke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZC1Xk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:40:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZC1XkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:40:25 -0400
Date: Sun, 29 Mar 2009 00:40:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328234012.GC4957@elte.hu>
References: <1238251730.2526.2.camel@ht.satnam> <Pine.LNX.4.64.0903281508410.21235@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903281508410.21235@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Hugh Dickins <hugh@veritas.com> wrote:

> On Sat, 28 Mar 2009, Jaswinder Singh Rajput wrote:
> > The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
> >   Ingo Molnar (1):
> >         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > 
> > Jaswinder Singh Rajput (49):
> >       x86: process_32.c include inverse Xmas tree effect
> >       x86: signal.c include inverse Xmas tree effect
> >       x86: entry_32.S include inverse Xmas tree effect
> >       x86: traps.c include inverse Xmas tree effect
> >       x86: irq.c include inverse Xmas tree effect
> >       x86: irq_32.c include inverse Xmas tree effect
> >       x86: dumpstack.c include inverse Xmas tree effect
> >       x86: time_32.c include inverse Xmas tree effect
> >       x86: ioport.c include inverse Xmas tree effect
> >       x86: ldt.c include inverse Xmas tree effect
> >       x86: dumpstack_32.c include inverse Xmas tree effect
> >       x86: setup.c include inverse Xmas tree effect
> >       x86: i8259.c include inverse Xmas tree effect
> >       x86: irqinit_32.c include inverse Xmas tree effect
> >       x86: probe_roms_32.c include inverse Xmas tree effect
> >       x86: sys_i386_32.c include inverse Xmas tree effect
> >       x86: i386_ksyms_32.c include inverse Xmas tree effect
> >       x86: bootflag.c include inverse Xmas tree effect
> >       x86: e820.c include inverse Xmas tree effect
> >       x86: pci-dma.c include inverse Xmas tree effect
> >       x86: quirks.c include inverse Xmas tree effect
> >       x86: i8237.c include inverse Xmas tree effect
> >       x86: alternative.c include inverse Xmas tree effect
> >       x86: tsc.c include inverse Xmas tree effect
> >       x86: process.c include inverse Xmas tree effect
> >       x86: xsave.c include inverse Xmas tree effect
> >       x86: ptrace.c include inverse Xmas tree effect
> >       x86: ds.c include inverse Xmas tree effect
> >       x86: tls.c include inverse Xmas tree effect
> >       x86: step.c include inverse Xmas tree effect
> >       x86: stacktrace.c include inverse Xmas tree effect
> >       x86: reboot.c include inverse Xmas tree effect
> >       x86: msr.c include inverse Xmas tree effect
> >       x86: cpuid.c include inverse Xmas tree effect
> >       x86: early-quirks.c include inverse Xmas tree effect
> >       x86: smp.c include inverse Xmas tree effect
> >       x86: smpboot.c include inverse Xmas tree effect
> >       x86: tsc_sync.c include inverse Xmas tree effect
> >       x86: setup_percpu.c include inverse Xmas tree effect
> >       x86: trampoline_32.S include inverse Xmas tree effect
> >       x86: mpparse.c include inverse Xmas tree effect
> >       x86: module_32.c include inverse Xmas tree effect
> >       x86: doublefault_32.c include inverse Xmas tree effect
> >       x86: vm86_32.c include inverse Xmas tree effect
> >       ix86: early_printk.c include inverse Xmas tree effect
> >       x86: pcspeaker.c include inverse Xmas tree effect
> >       x86: head_32.c include inverse Xmas tree effect
> >       x86: head.c include inverse Xmas tree effect
> >       x86: init_task.c include inverse Xmas tree effect
> 
> Gasp.
> 
> Please find a better use for your time.
> 
> Imagine, there might be developers out there with real work
> to do in these files: all you are doing is throwing silly
> little obstacles in their way.

Actually, now is the right time to do such changes as we've just 
pushed all pending x86 changes upstream. And since these changes 
reduce the chance of future patch conflicts, they do help 
development. (in a small way)

Nevertheless i'd suggest to make this a single commit, to not 
clobber the shortlog with it.

	Ingo
