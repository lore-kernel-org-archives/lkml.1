Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbYEAXO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbYEAXO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYEAXOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:14:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbYEAXOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:14:15 -0400
Date: Wed, 30 Apr 2008 18:13:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080430181338.6180a972@infradead.org>
In-Reply-To: <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
	<20080501084919.8ac6dbdd.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 08:49:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Granted that compared to x86 there's not a sizable portion of users 
> > crazy enough to run Linux on powerpc machines...
> 
> Another fallacy which Arjan is pushing (even though he doesn't appear
> to have realised it) is "all hardware is the same".

no I'm pushing "some classes of hardware are much more popular/relevant
than others".


 
> Well, it isn't.  And most of our bugs are hardware-specific.  So, I'd
> venture, most of our bugs don't affect most people.  So, over time, by
> Arjan's "important to enough people" observation we just get more and
> more and more unfixed bugs.

I did not say "most people". I believe "most people" aren't hitting
bugs right now (or there would be a lot more screaming).
What I do believe is that *within the bugs that hit*, even the hardware
specific ones, there's a clear prioritization by how many people hit
the bug (or have the hardware in general).

> 
> And I believe this effect has been occurring.
> 

> And please stop regaling us with this kerneloops.org stuff.  It just
> isn't very interesting, useful or representative when considering the
> whole problem.  Very few kernel bugs result in a trace, and when they
> do they are usually easy to fix and, because of this, they will get
> fixed, often quickly.  I expect
> netdevwatchdogeth0transmittimedout.org would tell a different story.

now that's a fallacy of your own.. if you care about that one, it's 1)
trivial to track and/or 2) could contain a WARN_ON_ONCE(), at which
point it's automatically tracked. (and more useful information I
suspect, since it suddenly has a full backtrace including driver info
in it)
By your argument we should work hard to make sure we're better at
creating traces for cases we detect something goes wrong.
(I would not argue against that fwiw)

> I figure that after a bug is reported we have maybe 24 to 48 hours to
> send a good response before our chances of _ever_ fixing it have
> begun to decline sharply due to the clever minds at the other end.
> 
> Which leads us to Arjan's third fallacy:
> 
>    "How many bugs that a sizable portion of users will hit in reality
>    are there?" is the right question to ask...
> 
> well no, it isn't.  Because approximately zero of the hardware bugs

if it's a hardware bug there's little we can do.
If it's a hardware specific bug, yeah then it becomes a function of how
popular that hardware is.

> affect a sizeable portion of users.  With this logic we will end up
> with more and more and more and more bugs each of which affect a tiny
> number of users. Hundreds of different bugs.  You know where this
> process ends up.

Given that a normal PC has maybe 10 components... 
yes we don't want bugcreep that affects common hardware over time.
At the same time, by your argument, a bug that hits a piece of hardware
of which 5 are made (or left on this planet) is equally important to
a bug in something that 
> 
> Arjan's fourth fallacy: "We don't make (effective) prioritization
> decisions." lol.  This implies that someone somewhere once sat down
> and wondered which bug he should most effectively work on.  Well, we
> don't do that.  We ignore _all_ the bugs in favour of busily writing
> new ones

This statement is so rediculous and self contradicting to what you
said before that I'm not even going to respond to it. 
