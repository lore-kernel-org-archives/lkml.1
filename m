Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYGKAC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYGKAC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYGKACV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:02:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYGKACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:02:20 -0400
Date: Thu, 10 Jul 2008 20:02:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
In-Reply-To: <20080710132832.38cc5048.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Jul 2008, Randy Dunlap wrote:

> [I'm dropping good comments, just making more comments.]

This is why I CC'd you ;-)

>
> > > +  set_ftrace_notrace: This has the opposite effect that
> > > +		set_ftrace_filter has. Any function that is added
> > > +		here will not be traced. If a function exists
> > > +		in both set_ftrace_filter and set_ftrace_notrace
> >
> >                                                                 (comma)
> >
> > > +		the function will _not_ bet traced.
>
> 		                        be

Sorry, it has a gambling problem.

>
> > > +  stacktrace - This is one of the options that changes the trace itself.
> >
> >                                                   change
>
> 	                                            changes :)  [subject is "This", singular]

Woot! I'm actually right?? Nah, this can't be. Maybe my mom did speak good
english. ;-)


>
> >
> > > +		When a trace is recorded, so is the stack of functions.
> > > +		This allows for back traces of trace sites.
> > > +
> > > +sched_switch
> > > +------------
> > > +
> > > +This tracer simply records schedule switches. Here's an example
> > > +on how to implement it.
>
>      of

OK

>
> >
> >              use?
> >
> > [...]
> > > +Here we traced a 50 microsecond latency. But we also see all the
> > > +functions that were called during that time. Note that enabling
> >
> >                                                           by enabling?
> >
> > > +function tracing we endure an added overhead. This overhead may
> >
> >                    (comma)
> >
> > > +extend the latency times. But never the less, this trace has provided
>
>                                    nevertheless,

It is one word? I wrote that first and then thought that it was wrong.

>
> > > +some very helpful debugging.
> >
> >                      debugging information?

Sure.

> >
> > > +
> > > +
> > > +preemptoff
> > > +----------
> > > +
> > > +When preemption is disabled we may be able to receive interrupts but
> >
> >                               (comma)
> >
> > > +the task can not be preempted and a higher priority task must wait
>
>               cannot

OK

>
> > > +for preemption to be enabled again before it can preempt a lower
> > > +priority task.
> > > +
> > > +The preemptoff tracer traces the places that disables preemption.
> >
> >                                                 disable
> >
> > > +Like the irqsoff, it records the maximum latency that preemption
> > > +was disabled. The control of preemptoff is much like the irqsoff.
>
>
> > > +Since this tracer only deals with RT tasks, we will run this slightly
> > > +different than we did with the previous tracers. Instead of performing
>
>      differently

OK

>
> > > +an 'ls' we will run 'sleep 1' under 'chrt' which changes the
> >
> >           (comma)
> >
> > > +priority of the task.
>
> > [...]
> > > +Where as the setting of the NEED_RESCHED bit happens on the
>
>      Whereas

OK

>
> > > +task's stack. But because we are in a hard interrupt, the test
>
>                  ^?  That's not a complete sentence.

I rewrote this part. So I'm not ignoring these comments.

>
> > > +is with the interrupts stack which has that to be false. We don't
>
>                  interrupt
> >
> >                                           ^^^^
> > Superfluous that? Don't understand that sentence.
> >
> > > +see the 'N' until we switch back to the task's stack.
> > [...]
> > > +When dynamic ftrace is initialized, it calls kstop_machine to make it
>
>                                                                         ^^ what is "it"?

s/it/the machine/

>
> > > +act like a uniprocessor so that it can freely modify code without
> > > +worrying about other processors executing that same code.  At
> > > +initialization, the mcount calls are change to call a "record_ip"
> >
> >                                         changed
> >
> > > +function.  After this, the first time a kernel function is called,
> > > +it has the calling address saved in a hash table.
> > [...]
> > > +Two files that contain to the enabling and disabling of recorded
> > > +functions are:
> >
> > Can this be expressed somewhat differently?
>
>   or drop "to".

I rewrote this part too.

>
> >
> > > +
> > > +  set_ftrace_filter
> > > +
> > > +and
> > > +
> > > +  set_ftrace_notrace
> > > +
> > > +A list of available functions that you can add to this files is listed
> >
> >                                                      these
> >
> > > +in:
> > > +
> > > +   available_filter_functions
> > [...]
> > > +Perhaps this isn't enough. The filters also allow simple wild cards.
> > > +Only the following is currently available
>
>      Only the following are currently available:

OK

>
> > > +
> > > +  <match>*  - will match functions that begins with <match>
> >
> >                                            begin
> >
> > > +  *<match>  - will match functions that end with <match>
> > > +  *<match>* - will match functions that have <match> in it


Thanks Randy, once again you helped me out in my documentation.

-- Steve

