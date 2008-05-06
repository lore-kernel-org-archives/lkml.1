Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYEFBc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYEFBc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYEFBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:32:16 -0400
Received: from www.tglx.de ([62.245.132.106]:34400 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYEFBcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:32:15 -0400
Date: Tue, 6 May 2008 03:30:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210032701.17132.98.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805060258360.3318@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>  <1210003265.17132.6.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>  <1210004376.17132.14.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
  <1210007084.17132.32.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>  <1210013938.17132.55.camel@localhost.localdomain>  <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>  <1210025532.17132.82.camel@localhost.localdomain>
  <20080505234743.GA11433@elte.hu> <1210032701.17132.98.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Daniel Walker wrote:
> On Tue, 2008-05-06 at 01:47 +0200, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > I think dropping ports (temporarily) is perfectly reasonable. There is 
> > > no reason to hamper forward development just to keep old architecture 
> > > ports in the tree.
> > 
> > You are missing the point: a lot of people (those who wrote the brunt of 
> > the -rt tree and who maintained it over the years and who maintain it 
> > today) think it's not reasonable and have stated it very clearly to you 
> > that it's a bug. Keeping things alive is not preventing forward 
> > development.
> 
> That has always been my intention. I've never said the arch code would
> be permanently gone. 

Get it. Dropping it means bitrot.

The responsible maintainers keep that (maybe stale) code at least in
sync as far as the obvious fixups are concerned.

Your way of chosing the least effort approach and justifying it with
handwaving arguments is just disgusting.
 
> > Since it's code that you regard stale it shouldnt be all that hard to 
> > fix it up - in general it's much easier to fix a bug than to talk it out 
> > of existence, even if you disagree with a maintainer about how 
> > significant a bug is.
> 
> It shouldn't be hard, but it's too much to do all in one go. It's better
> from my perspective to do it in parts, given that there is significant
> refactoring to do per arch, if we solidify x86 then we can better
> refactor the other architectures. Better to do the split up once vs.
> many times.

Ah, it's too much in one go. But we should accept an "all in one go"
refactoring of the code we maintained over years including your
decision to drop fully functional ports (FYI, I've verified it) just
because you define that it's the best way to go.

Again, there is a choice.

1) Work with us - the maintainers and major contributors to preempt-rt -
   in a way which is useful for the project and the community

2) Hold on to your private "superior" uber queue and STFU.

> Not to mention this has not been discussed until now. My bisect tree was
> all but ignored until just recently.

It will be ignored for ever until you decide to work with us instead
of requesting that we drop our work in favour of your incomplete and
buggy hackery.

> > This issue is clearly not central to your refactoring (it cannot be, 
> > it's all about stale code), so by inflexibly insisting on your opinion 
> > against the (well-explained) opinion of the maintainers you'll just 
> > waste their time and make it more difficult for them to work with you, 
> > for no good reason.
> 
> I'm simply making sure their argument is widely known and potentially
> discussed on list instead of in a back room..

I'm impressed by your selfless efforts to save the world from the
ongoing preempt-rt conspiracy.

Thanks,

	tglx
