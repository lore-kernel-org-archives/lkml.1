Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZCUQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZCUQ1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZCUQ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:26:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZCUQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:26:50 -0400
Date: Sat, 21 Mar 2009 17:26:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH][GIT PULL] tracing: add function profiler
Message-ID: <20090321162630.GE11183@elte.hu>
References: <alpine.DEB.2.00.0903210036590.13615@gandalf.stny.rr.com> <20090321042633.1dfa536a.akpm@linux-foundation.org> <1237636623.4667.223.camel@laptop> <alpine.DEB.2.00.0903211146430.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903211146430.13615@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > If you want exact function count profiling we could try to do 
> > something perf counter based, eg. stick a software counter in 
> > the mcount thingy.
> 
> I'd like to get the function graph version working, in order to 
> calculate the times spent in each funtion, then I can see how we 
> can (if possible) convert it over to perf counters. :-/

the perf counters angle is definitely worth pursuing (for 
completeness of the scheme Peter is working on), but please lets not 
throw the baby out with the bath water: in-kernel histogram 
collection has real value.

It's _much_ faster than any user-space counter-part, especially for 
such things as branch tracing or function tracing.

	Ingo
