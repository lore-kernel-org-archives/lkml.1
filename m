Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYH2Irv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYH2Irv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYH2Irm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:47:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:41321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751186AbYH2Irl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:47:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Jph8XxpdJKkEElnY804uQIClaXW/lpQBwPxi/Ii
	CW5y2lfa3wy/NS
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1219997165.17355.42.camel@twins>
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
	 <1219997165.17355.42.camel@twins>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 10:47:29 +0200
Message-Id: <1219999649.4928.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 10:06 +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-29 at 09:56 +0200, Mike Galbraith wrote:
> >
> > It bothers me some too.  You have to patch/re-compile the kernel if you
> > need to turn it off and don't have SCHED_DEBUG enabled (not free).
> 
> /proc/sys/kernel/sched_rt_{runtime,period}_us don't require SCHED_DEBUG.
> If they are in any way non-functional on SCHED_DEBUG=n then that's a
> clear bug.

Gee, you're right.  I guess my eyeballs didn't want to see them without
their friends.

	-Mike

