Return-Path: <linux-kernel-owner+w=401wt.eu-S1763639AbXFASvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763639AbXFASvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762443AbXFASvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:51:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762018AbXFASvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:51:43 -0400
Date: Fri, 1 Jun 2007 20:51:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070601185123.GA5129@elte.hu>
References: <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com> <20070530134907.GA27085@elte.hu> <1180544796.32594.184.camel@imap.mvista.com> <1180545380.2958.1.camel@lappy> <1180545913.32594.194.camel@imap.mvista.com> <20070601131249.GA17059@elte.hu> <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy> <1180714263.15884.52.camel@imap.mvista.com> <1180723421.5676.8.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180723421.5676.8.camel@lappy>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2007-06-01 at 09:11 -0700, Daniel Walker wrote:
> > On Fri, 2007-06-01 at 17:52 +0200, Peter Zijlstra wrote:
> 
> > > The whole issue is that you don't have any control over what clocksource
> > > you'll end up with. If it so happens that pmtimer gets selected your
> > > whole box will crawl if its used liberaly, like the patch under
> > > discussion does.
> > 
> > You can have control over it, which I think the whole point of this
> > discussion ..
> 
> No you don't, clocksource will gladly discard the TSC when its not 
> found stable enough (the majority of the systems today). While it 
> would be good enough for sched_clock().

yeah, precisely. [ There is another thing as well: most embedded 
architectures do not even implement LOCKDEP_SUPPORT today, so it wouldnt 
be possible to enable lockstat on them anyway. So this whole topic is 
ridiculous to begin with. How about fixing some real, non-imaginery bugs 
instead? ;-) ]

	Ingo
