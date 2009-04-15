Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZDORqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZDORqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZDORp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:45:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41418 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZDORp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:45:59 -0400
Date: Wed, 15 Apr 2009 19:45:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com
Subject: Re: GFS2: Tracing support for review
Message-ID: <20090415174544.GA17593@elte.hu>
References: <1239810905.29604.60.camel@localhost.localdomain> <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> > index 7f9521c..0939609 100644
> > --- a/kernel/perf_counter.c
> > +++ b/kernel/perf_counter.c
> > @@ -2590,6 +2590,7 @@ void perf_tpcounter_event(int event_id)
> >  
> >  	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs, 0);
> >  }
> > +EXPORT_SYMBOL_GPL(perf_tpcounter_event);
> 
> Again, please submit that in another patch.

Yeah, we can stick this into tip:perfcounters/core no problem.

	Ingo
