Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYLLKPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYLLKPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYLLKOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:14:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYLLKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:14:54 -0500
Date: Fri, 12 Dec 2008 11:14:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt
	triggering on output
Message-ID: <20081212101448.GE18152@elte.hu>
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493EF797.7090603@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Frederic Weisbecker wrote:
> > This patchset adds all the features to draw hardirq triggering on output
> > for the function graph tracer.
> > An example is given on the third patch.
> > 
> > Just one question, on recordmcount.pl:
> > 
> > my %text_sections = (
> >       ".text" => 1,
> >       ".sched.text" => 1,
> >       ".spinlock.text" => 1,
> > 
> > The .sched.text section is included inside .text, it's a subsection, I'm not sure
> > it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
> > 
> > The stat of the patchset:
> > 
> >  arch/x86/kernel/apic.c               |    3 +-
> >  arch/x86/kernel/irq_64.c             |    3 +-
> >  arch/x86/kernel/vmlinux_64.lds.S     |    1 +
> >  include/asm-generic/vmlinux.lds.h    |   10 +++++
> >  include/linux/ftrace.h               |   11 ++++++
> >  kernel/trace/trace_functions_graph.c |   66 +++++++++++++++++++++++++++++++--
> >  scripts/recordmcount.pl              |    1 +
> >  7 files changed, 89 insertions(+), 6 deletions(-)

applied to tip/tracing/function-graph-tracer, thanks Frederic!

The output looks really nice.

	Ingo
