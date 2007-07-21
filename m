Return-Path: <linux-kernel-owner+w=401wt.eu-S935929AbXGUJDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935929AbXGUJDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXGUJCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:02:55 -0400
Received: from ozlabs.org ([203.10.76.45]:33951 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbXGUJCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:02:55 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1185005750.4012.100.camel@chaos>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de>
	 <1185005750.4012.100.camel@chaos>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 19:02:29 +1000
Message-Id: <1185008549.6344.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 10:15 +0200, Thomas Gleixner wrote:
> On Sat, 2007-07-21 at 07:37 +0200, Andi Kleen wrote: 
> > On Saturday 21 July 2007 00:32, Thomas Gleixner wrote:
> > > We are pleased to announce a project we've been working on for some
> > > time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> > > to solicit feedback about it.
> > 
> > Well you know my position on this. I think it's a bad idea because
> > it means we can never get rid of any old junk. IMNSHO arch/x86_64
> > is significantly cleaner and simpler in many ways than arch/i386 and I would
> > like to preserve that. Also in general arch/x86_64 is much easier to hack
> > than arch/i386 because it's easier to regression test and in general
> > has to care about much less junk. And I don't 
> > know of any way to ever fix that for i386 besides splitting the old
> > stuff off completely.
> 
> I disagree of course. 
> 
> I worked on both trees quite intensive over the last years and I broke
> x86_64 more than once when hacking on i386 and vice versa. 

Me too.

At the very least I'd like to see asm-x86/ for headers used by both.

That said, the merge is exactly as I'd have done it.  So if this were a
democracy, I'd vote in favour.

Cheers,
Rusty.

