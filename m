Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZBWCw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZBWCw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZBWCwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:52:21 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54152 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbZBWCwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:52:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMFAJeeoUlMQWXi/2dsb2JhbACBbtIihA8G
Date: Sun, 22 Feb 2009 21:47:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223024716.GC5430@Krystal>
References: <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090222121821.3599.A69D9226@jp.fujitsu.com> <1235302660.4632.4.camel@laptop> <20090222160405.GA17875@Krystal> <20090222191707.GA5632@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090222191707.GA5632@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:35:29 up 1 day, 18:09,  3 users,  load average: 0.84, 0.56,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > > so I wonder why don't we create linux-tracing new mailing 
> > > > list.
> 
> Discussions related to upstream Linux tracing are generally 
> conducted on lkml.
> 
> > > Yes, lets hide it from general view, sounds like a brilliant 
> > > plan.
> > 
> > I guess Kosaki's point is that there may be a disconnect 
> > between the work that is done on the LTTng side and the ftrace 
> > side. [...]
> 
> Could you please list the items we need to extend the tracing 
> framework in kernel/tracing/* with so that we can support the 
> aspects of LTTng you consider important and upstream-worthy?
> 
> As i've mentioned it in the past, i'm definitely interested in 
> helping such an effort to further improve Linux tracing.
> 
> 	Ingo

Hi Ingo,

I have not merged the "binary trace buffer to ascii" code done by
Fujitsu yet because I still have to review it, but when it's ready, I
will be ready to post everything that has been identified as wish list
for a tracer v2. It includes a very generic buffering infrastructure
which have been evolving for the past 4 years (and reviewed on LKML a
couple of times in the past).

So, either I start to merge this last feature, or I can start posting
right away without the "binary buffer to ascii" module. The standard
mechanism used in LTTng is binary-only, very high speed, and uses a
userspace application to transform binary data into text.

That will let us figure out what overlaps between ftrace and LTTng and
find out how those two can fit together.

Note that for the moment, LTTng sits in the /ltt directory of the kernel
tree, so even if we have both tracers at some point, we should not step
on each other's foot. That could let us room to figure out how to
incrementally combine those tracers if that makes sense.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
