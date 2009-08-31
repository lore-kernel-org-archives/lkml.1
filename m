Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZHaIgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZHaIgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZHaIgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:36:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48297 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZHaIgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:36:35 -0400
Date: Mon, 31 Aug 2009 10:35:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] tracing/syscalls: The next bunch
Message-ID: <20090831083512.GC15619@elte.hu>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com> <20090829104334.GA17156@elte.hu> <20090829233304.GA6101@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829233304.GA6101@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Aug 29, 2009 at 12:43:34PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > Here is another bunch of syscalls tracing patches.
> > 
> > i have tested them, and something in this batch, when merged into 
> > tip/master:
> > 
> > 0dd7b74: tracing: Fix double CPP substitution in TRACE_EVENT_FN
> > 66c6e29: Merge branch 'tracing/core' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing into tracing/core
> > 117226d: tracing: Remove FTRACE_SYSCALL_MAX definitions
> > 57421db: tracing: Convert event tracing code to use NR_syscalls
> > a5a2f8e: tracing: Define NR_syscalls for x86_64
> > dd86dda: tracing: Define NR_syscalls for x86 (32)
> > cc3b13c: tracing: Don't trace kernel thread syscalls
> > cd0980f: tracing: Check invalid syscall nr while tracing syscalls
> > 7515bf5: tracing: Add syscall tracepoints - s390 arch update
> 
> Argh, I've just tested a merge of tip:tracing/core into tip:master 
> and I can't reproduce the hang, neither in x86-64 SMP nor in a 
> pentium III :-(

I'll re-try it again, maybe i'll find a config with better 
reproducibility. Also, lots of stuff was merged recently, maybe 
there was some other bit interacting.

	Ingo
