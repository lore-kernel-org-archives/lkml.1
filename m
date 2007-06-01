Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXFANNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXFANNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXFANNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:13:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbXFANNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:13:15 -0400
Date: Fri, 1 Jun 2007 15:12:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070601131249.GA17059@elte.hu>
References: <20070529125248.877196281@chello.nl> <20070529130107.112347096@chello.nl> <1180470525.32594.71.camel@imap.mvista.com> <20070530132431.GA23947@elte.hu> <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com> <20070530134907.GA27085@elte.hu> <1180544796.32594.184.camel@imap.mvista.com> <1180545380.2958.1.camel@lappy> <1180545913.32594.194.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180545913.32594.194.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Wed, 2007-05-30 at 19:16 +0200, Peter Zijlstra wrote:

> > I think you are mistaken here; the two are similar but not 
> > identical.
> > 
> > I see sched_clock() as fast first, accurate second. Whereas the 
> > clocksource thing is accurate first, fast second.
> 
> This is true .. However, if there is a speed different it's small.

Ugh. Have you ever compared pmtimer (or even hpet) against TSC based 
sched_clock()? What you write is so wrong that it's not even funny. You 
keep repeating this nonsense despite having been told multiple times 
that you are dead wrong.

	Ingo
