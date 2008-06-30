Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYF3M43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYF3M43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYF3M4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:56:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYF3M4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:56:20 -0400
Date: Mon, 30 Jun 2008 14:56:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, npiggin@suse.de,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
Message-ID: <20080630125601.GC4011@elte.hu>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <1214599896.12348.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214599896.12348.9.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2008-06-27 at 14:29 -0600, Gregory Haskins wrote:
> > Hi Ingo,
> >   The following patches apply to linux-tip/sched/devel and enhance the
> > performance of the kernel (specifically in PREEMPT_RT, though they do
> > not regress mainline performance as far as I can tell).  They offer
> > somewhere between 50-100% speedups in netperf performance, depending
> > on the test.
> > 
> > Should you be interested in these patches, you can optionally pull them
> > from git at the following URL:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched-devel
> > 
> > Comments/feedback/bugfixes welcome
> 
> Seem reasonable to me,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/devel - thanks guys.

I have also merged tip/sched/devel.smp-group-balance into 
tip/sched/devel, those changes have held up fine in testing, with little 
problems.

	Ingo
