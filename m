Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYH2H5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYH2H5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYH2H4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:56:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:39334 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752116AbYH2H4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:56:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4NSoic4m40S+ztKwfZVtGu6XmqdiysftAWjaqv9
	cxTzzMKQhiJnI5
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0808281448170.18124@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl>
	 <200808290036.35817.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
	 <200808290134.35093.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
	 <48B6EB6F.2050802@compro.net>
	 <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0808281448170.18124@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 09:56:47 +0200
Message-Id: <1219996607.5079.142.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 14:53 -0400, Steven Rostedt wrote:
> On Thu, 28 Aug 2008, Linus Torvalds wrote:
> > 
> > And I'm not really interested. Quite frankly, I suspect the "we want to 
> > run something like pulseaudio with RT priorities" camp is the more common 
> > one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
> > understandable.
> 
> The fact that it actually limits a SCHED_FIFO task group, over a single 
> task thread does bother me a little.

It bothers me some too.  You have to patch/re-compile the kernel if you
need to turn it off and don't have SCHED_DEBUG enabled (not free).

I tripped over this recently while regression testing.  I didn't expect
a gaggle of SCHED_RR tasks to be throttled on an otherwise idle box.
Hitting that perturbed test results in an unexpected manner, and sent me
off on a tangent.

	-Mike

