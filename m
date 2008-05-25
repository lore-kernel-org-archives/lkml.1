Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYEYVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYEYVCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYEYVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:02:26 -0400
Received: from 1wt.eu ([62.212.114.60]:1185 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYEYVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:02:25 -0400
Date: Sun, 25 May 2008 23:00:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Davi Leal <davi@leals.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: I am a volunteer
Message-ID: <20080525210051.GA5609@1wt.eu>
References: <200805251812.41552.davi@leals.com> <200805252023.22510.davi@leals.com> <20080525194721.GH6749@1wt.eu> <200805252244.53524.davi@leals.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805252244.53524.davi@leals.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 10:44:52PM +0200, Davi Leal wrote:
> Willy Tarreau wrote:
> > Davi Leal wrote:
> > > I am more motivated to do development than testing.
> >
> > And who do you think will test your dev then ?
> 
> My dev me, of course.  Your dev you, or me but only if I have time.

This is precisely one of our big problems right now. Software is almost
only tested by authors, which means that we accumulate a lot of bugs due
to lack of precise knowledge in every area. Locking bugs and lack of
pointer validation come to mind.

> > Testing very quickly involves development because you will notice bugs
> > first, then missing chunks of code to handle special conditions, and by
> > this time you will feel much better with kernel internals and will have
> > no problem starting on more complex tasks.
> 
> I just note I am already running 2.6.25.4 build by hand, etc. Has 2.6.25.4 
> some regression which I could test?  Note below my time constraints.

Rafael Wysocki regularly sends a compiled list of known regressions. A
lot of them require specific hardware to trigger a driver bug, but there
are others with reproducers (and BTW you might also have some of the
required hardware).

Arjan van de Ven has posted a list of the top 10 oopses (check
www.kerneloops.org). It's not always easy to trigger such bugs,
but you may find it interesting to read the functions spotted in
the stack traces and try to understand how they work together.

> > Also, we're wondering what motivates newcomers to directly dive into
> > development instead of testing. Would you please explain a bit about
> > your motivations ? It would help distribute more interesting work to
> > newcomers, or maybe assign them more credits if it is what they are
> > seeking.
> 
> In my case I am not looking for credit but for learning. I can only spend one 
> hour each day to this subject. Tasks which would require a deadline would be 
> a problem for me.

As Linus often says : "read the sources". Reading the code of all of a
call chain between a syscall and an oops can be *very* instructive. You
need serious motivation though. At first you will think that you don't
understand a damn thing. That's normal and expected. It does it to me
each time I stuff my nose in a file. You just need not to suppose what
a function or macro does, but to read it. You'll quickly understand what
the code does, and very likely both find stupid bugs and understand the
kernel internals.

> To start, I would like somebody point me to something easy to do, taking into 
> account such time constraints.

reading code is 100% compatible with time constraints, as there is no
deadline. You can even say that a bug that you don't look at may stay
there for years. And quite frankly, spending more than one hour every
evening on code is generally enough to give you a headache. But you
will progress very quickly.

> Something that would require the installation of Xen to be able to reproduce 
> and debug a specific bug via Xen serial port would be cool.

That's a good idea, though I have no clue how to proceed.

> Anyway just point me to something...

Please check the list for Arjan and Rafael's posts. Take something which
seems close to an area you would like to progress in. Maybe you're more
interested in writing drivers, file-systems, schedulers, VM, etc...

Regards,
Willy

