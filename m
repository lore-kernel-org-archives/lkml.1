Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbXK3Ngk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbXK3Ngk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXK3Nga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:36:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbXK3Nga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:36:30 -0500
Date: Fri, 30 Nov 2007 14:35:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071130133546.GB29679@elte.hu>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071130125628.GA30773@lazybastard.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Thu, 15 November 2007 20:36:12 +0100, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > pick up the latest latency tracer patch from:
> > 
> > sorry, wrong URLs, the correct links are:
> > 
> >    http://redhat.com/~mingo/latency-tracing-patches/latency-tracer-v2.6.24-rc2-git5-combo.patch
> >    http://redhat.com/~mingo/latency-tracing-patches/trace-cmd.c
> 
> Don't seem to work with plain 2.6.23:
> 
> kernel/sched.c:3384: warning: ‘struct prio_array’ declared inside parameter list
> kernel/sched.c:3384: warning: its scope is only this definition or declaration, which is probably not what you want
> kernel/sched.c: In function ‘trace_array’:
> kernel/sched.c:3391: error: dereferencing pointer to incomplete type
> kernel/sched.c:3393: error: dereferencing pointer to incomplete type
> kernel/sched.c:3393: error: dereferencing pointer to incomplete type
> kernel/sched.c:3396: error: dereferencing pointer to incomplete type
> kernel/sched.c:3396: error: dereferencing pointer to incomplete type
> kernel/sched.c: In function ‘trace_all_runnable_tasks’:
> kernel/sched.c:3407: error: ‘struct rq’ has no member named ‘active’
> make[1]: *** [kernel/sched.o] Error 1
> 
> And I cannot find a definition of struct prio_array in current git
> either.  Is another patch needed?

change that to rt_prio_array in the code.

	Ingo
