Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZBWIxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZBWIxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZBWIxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:53:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZBWIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:53:14 -0500
Date: Mon, 23 Feb 2009 09:52:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223085243.GF9582@elte.hu>
References: <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090222121821.3599.A69D9226@jp.fujitsu.com> <1235302660.4632.4.camel@laptop> <20090222160405.GA17875@Krystal> <20090222191707.GA5632@elte.hu> <20090223024716.GC5430@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223024716.GC5430@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > > > so I wonder why don't we create linux-tracing new mailing 
> > > > > list.
> > 
> > Discussions related to upstream Linux tracing are generally 
> > conducted on lkml.
> > 
> > > > Yes, lets hide it from general view, sounds like a brilliant 
> > > > plan.
> > > 
> > > I guess Kosaki's point is that there may be a disconnect 
> > > between the work that is done on the LTTng side and the ftrace 
> > > side. [...]
> > 
> > Could you please list the items we need to extend the tracing 
> > framework in kernel/tracing/* with so that we can support the 
> > aspects of LTTng you consider important and upstream-worthy?
> > 
> > As i've mentioned it in the past, i'm definitely interested in 
> > helping such an effort to further improve Linux tracing.
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> I have not merged the "binary trace buffer to ascii" code done 
> by Fujitsu yet because I still have to review it, but when 
> it's ready, I will be ready to post everything that has been 
> identified as wish list for a tracer v2. It includes a very 
> generic buffering infrastructure which have been evolving for 
> the past 4 years (and reviewed on LKML a couple of times in 
> the past).
> 
> So, either I start to merge this last feature, or I can start 
> posting right away without the "binary buffer to ascii" 
> module. The standard mechanism used in LTTng is binary-only, 
> very high speed, and uses a userspace application to transform 
> binary data into text.
> 
> That will let us figure out what overlaps between ftrace and 
> LTTng and find out how those two can fit together.
> 
> Note that for the moment, LTTng sits in the /ltt directory of 
> the kernel tree, so even if we have both tracers at some 
> point, we should not step on each other's foot. That could let 
> us room to figure out how to incrementally combine those 
> tracers if that makes sense.

I think you got me wrong Mathieu. The way to combine those two 
tracers is to do it _before_ it gets merged upstream. We 
obviously dont want to parallel tracing frameworks in the 
upstream kernel.

So ... please lets work on that, okay?

	Ingo
