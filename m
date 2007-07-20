Return-Path: <linux-kernel-owner+w=401wt.eu-S936462AbXGTWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936462AbXGTWxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXGTWxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:53:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbXGTWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:53:01 -0400
Date: Fri, 20 Jul 2007 15:51:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <46A13A62.5020502@garzik.org>
Message-ID: <alpine.LFD.0.999.0707201546140.27249@woody.linux-foundation.org>
References: <1184970779.4012.38.camel@chaos> <46A1396F.4090204@garzik.org>
 <20070720224033.GA12358@elte.hu> <46A13A62.5020502@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Jeff Garzik wrote:

> Ingo Molnar wrote:
> > * Jeff Garzik <jeff@garzik.org> wrote:
> > 
> > > I agree with Andi...  it's quite nice to be able to leave some arch/i386
> > > stuff, and not carry it over to arch/x86-64.
> > 
> > we can leave those few items in arch/x86 just as much. No need to keep
> > around a legacy tree for that.
> 
> By extension it makes doing that sort of thing, in general, more difficult.
> Which is IMO not desirable.

I think it's *much* harder to carry legacy things around in an old tree 
that almost nobody even uses any more (probably not true yet, but for most 
of the main developers, I bet it will be true in a year). Especially one 
that just duplicates 99% of the stuff.

There really isn't that much legacy crud. There are things like random 
quirks, but every time I hear the (theoretical) argument about how much 
time and effort we save by having it duplicated somewhere else, I think 
about all the time we definitely waste by fixing the same bug twice (and 
worry about the cases where we don't).

			Linus
