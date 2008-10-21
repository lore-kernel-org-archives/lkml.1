Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYJUTw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYJUTw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJUTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:52:18 -0400
Received: from bytemail.bytemark.co.uk ([80.68.81.165]:57162 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJUTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:52:17 -0400
Message-ID: <48FE32E2.5000601@bytemark.co.uk>
Date: Tue, 21 Oct 2008 20:52:02 +0100
From: Alex Howells <alex@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk> <20081020202147.GA20788@kroah.com>
In-Reply-To: <20081020202147.GA20788@kroah.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=B188A23A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> What do you mean?  The .y marking of releases right now doesn't show you
> this?

Sorry, perhaps I wasn't clear with regards "bugs" vs. "regressions" as
someone else pointed out in a reply :)

> The "longevity" of a release series has no real correlation to it's "bug
> free"ness of it in any strict sense of the word.  Just look at the
> percentage of fixes in any normal release for "bugs" to get a concrete
> feel for that (hint, it's in the thousands).

Okay, sure.

> What is frustrating about it right now?  It is _strongly_ recommended
> that if you are following the kernel.org tree, for you to rely on the
> -stable releases.  It is best if you can upgrade to the latest branch of
> the stable releases when they come out, moving to the latest major
> release when possible, as you usually only have a month or so when they
> start up before the previous branch's stable tree stops being
> maintained.

That was what I was inviting people to solve, actually.

What I don't think is 100% clear right now is which kernels are still
actively maintained, and which are not.  When does a kernel become EoL?
This is different for things like 2.6.16.x and 2.6.27.x to others?
Perhaps this could be a part of the version numbering scheme?

I'm speaking only from personal experience here, but have had hideous
issues getting a "one kernel fits all" solution for boxes at work.
Requirements for me to put a kernel on a given server would be:

    *  supports the hardware
    *  no security holes [in options I enable]
    *  works reliably, under load/stress.

Now I wouldn't call myself an 'expert' by any means, so please forgive
me in advance if I'm wrong in any of the following...

A lot of the problems I've spotted have been traced (kind thanks to
Daniel Drake, Francois Romieu and others) to the network drivers,
particularly forcedeth/r8169 NICs actually but some e1000 stuff too.
Filing bugs and getting those issues fixed for everyone is important,
but sometimes the question remains "Why upgrade when 2.6.16.xx meets the
criteria above? Can we be sure 2.6.24.xx will be as stable?".

There is nothing stopping you setting aside a couple of boxes and
checking the latest -stable for testing purposes, for planning where you
*will* go when 2.6.16.xx stops being maintained, and filing any bugs you
spot along the way to try and contribute to this effort.

This mostly came about because we have a large-ish number of boxes
currently tracking 2.6.16.xx and that works *very* well for us.
Discovering that 2.6.16 would be maintained in such a way was tough
though as I'm only a fairly recent subscriber to LKML.

So with regards to supported kernels, the following springs to mind:

   *  how long is kernel 2.6.xx supported?
   *  is kernel 2.6.xx one of the "longer term" supported ones?
   *  what are the requirements for a maintainer to push a
      new release, a la 2.6.xx.yy? Is it based on time elapsed,
      severity of any fixes included?
   *  how do we define "support" in this context?
      does it mean security problems discovered/fixed *after*
      development focus has moved on to new stuff is backported?
      does it mean [critical] bug fixes? regression fixes?

> Some times I think I need to put up a big .SVG drawing of all of the
> releases, showing which ones are currently being maintained, and which
> ones aren't just to make it easier.  I wonder if firefox could show it
> properly, would that help out?

It would :)  Thanks for your response.

Alex
