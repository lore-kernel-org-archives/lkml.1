Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYH2IGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYH2IGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYH2IGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:06:18 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53833 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbYH2IGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:06:14 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1219996607.5079.142.camel@marge.simson.net>
References: <20080819103301.787700742@chello.nl>
	 <200808290036.35817.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
	 <200808290134.35093.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
	 <48B6EB6F.2050802@compro.net>
	 <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0808281448170.18124@gandalf.stny.rr.com>
	 <1219996607.5079.142.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 10:06:05 +0200
Message-Id: <1219997165.17355.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 09:56 +0200, Mike Galbraith wrote:
> On Thu, 2008-08-28 at 14:53 -0400, Steven Rostedt wrote:
> > On Thu, 28 Aug 2008, Linus Torvalds wrote:
> > > 
> > > And I'm not really interested. Quite frankly, I suspect the "we want to 
> > > run something like pulseaudio with RT priorities" camp is the more common 
> > > one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
> > > understandable.
> > 
> > The fact that it actually limits a SCHED_FIFO task group, over a single 
> > task thread does bother me a little.
> 
> It bothers me some too.  You have to patch/re-compile the kernel if you
> need to turn it off and don't have SCHED_DEBUG enabled (not free).

/proc/sys/kernel/sched_rt_{runtime,period}_us don't require SCHED_DEBUG.
If they are in any way non-functional on SCHED_DEBUG=n then that's a
clear bug.

