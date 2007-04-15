Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXDOJwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXDOJwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXDOJwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:52:10 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:57891
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXDOJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:52:08 -0400
Date: Sun, 15 Apr 2007 02:51:46 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415095146.GA30327@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415084447.GC24886@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:44:47AM +0200, Ingo Molnar wrote:
> I prefer such early releases to lkml _alot_ more than any private review 
> process. I released the CFS code about 6 hours after i thought "okay, 
> this looks pretty good" and i spent those final 6 hours on testing it 
> (making sure it doesnt blow up on your box, etc.), in the final 2 hours 
> i showed it to two folks i could reach on IRC (Arjan and Thomas) and on 
> various finishing touches. It doesnt get much faster than that and i 
> definitely didnt want to sit on it even one day longer because i very 
> much thought that Con and others should definitely see this work!
> 
> And i very much credited (and still credit) Con for the whole fairness 
> angle:
> 
> ||  i'd like to give credit to Con Kolivas for the general approach here:
> ||  he has proven via RSDL/SD that 'fair scheduling' is possible and that
> ||  it results in better desktop scheduling. Kudos Con!
> 
> the 'design consultation' phase you are talking about is _NOW_! :)
> 
> I got the v1 code out to Con, to Mike and to many others ASAP. That's 
> how you are able to comment on this thread and be part of the 
> development process to begin with, in a 'private consultation' setup 
> you'd not have had any opportunity to see _any_ of this.
> 
> In the BSD space there seem to be more 'political' mechanisms for 
> development, but Linux is truly about doing things out in the open, and 
> doing it immediately.

I can't even begin to talk about how screwed up BSD development is. Maybe
another time privately.

Ok, Linux development and inclusiveness can be improved. I'm not trying
to "call you out" (slang for accusing you with the sole intention to call
you crazy in a highly confrontative manner). This is discussed publically
here to bring this issue to light, open a communication channel as a means
to resolve it.

> Okay? ;-)

It's cool. We're still getting to know each other professionally and it's
okay to a certain degree to have a communication disconnect but only as
long as it clears. Your productivity is amazing BTW. But here's the
problem, there's this perception that NIH is the default mentality here
in Linux.

Con feels that this kind of action is intentional and has a malicious
quality to it as means of "churn squating" sections of the kernel tree.
The perception here is that there is that there is this expectation that
sections of the Linux kernel are intentionally "churn squated" to prevent
any other ideas from creeping in other than of the owner of that subsytem
(VM, scheduling, etc...) because of lack of modularity in the kernel.
This isn't an API question but a question possibly general code quality
and how maintenance () of it can .

This was predicted by folks and then this perception was *realized* when
you wrote the equivalent kind of code that has technical overlap with SDL
(this is just one dry example). To a person that is writing new code for
Linux, having one of the old guards write equivalent code to that of a
newcomer has the effect of displacing that person both with regards to
code and responsibility with that. When this happens over and over again
and folks get annoyed by it, it starts seeming that Linux development
seems elitist.

I know this because I heard (read) Con's IRC chats all the time about
these matters all of the time. This is not just his view but a view of
other kernel folks that differing views as to. The closing talk at OLS
2006 was highly disturbing in many ways. It went "Christoph" is right
everybody else is wrong which sends a highly negative message to new
kernel developers that, say, don't work for RH directly or any of the
other mainstream Linux companies. After a while, it starts seeming like
this kind of behavior is completely intentional and that Linux is
full of arrogant bastards.

What I would have done here was to contact Peter Williams, Bill Irwin
and Con about what your doing and reach a common concensus about how
to create something that would be inclusive of all of their ideas.
Discussions can technically heated but that's ok, the discussion is
happening and it brings down the wall of this perception. Bill and
Con are on oftc.net/#offtopic2. Riel is there as well as Peter Zijlstra.
It might be very useful, it might not be. Folks are all stubborn
about there ideas and hold on to them for dear life. Effective
leaders can deconstruct this hostility and animosity. I don't claim
to be one.

Because of past hostility to something like schedplugin, the hostility
and terseness of responses can be percieved simply as "I'm right,
you're wrong" which is condescending. This effects discussion and
outright destroys a constructive process if this happens continually
since it reenforces that view of "You're an outsider, we don't care
about you". Nobody is listening to each other at that point, folks get
pissed. Then they think about "I'm going to NIH this person with patc
X because he/she did the same here" which is dysfunctional.

Oddly enough, sometimes you're the best person to get a new idea
into the tree. What's not happening here is communication. That takes
sensitivity, careful listening which is a difficult skill, and then
understanding of the characters involved to unify creative energies.

That's a very difficult thing to do for folks that are use to working
solo. It take time to develop trust in those relationships so that
a true collaboration can happen. I know that there is a lot of
creativity in folks like Con and Bill. It would be wise to develop a
dialog with them to see if they can offload some of your work for you
(we all know you're really busy) yet have you be a key facilitator of
their and your ideas. That's a really tough thing to do and it requires
practice. Just imagine (assuming they can follow through) what could
have positively happened if there collective knowledge was leveraged
better. It's not all clear and rosy, but I think these people are more
on your side that you might realized and it might be a good thing to
discover that.

This is tough because I know the personalities involved and I know
kind of how people function and malfunction in this discussion on a
personal basis.

[We can continue privately. This not just about you but applicable
to open source development in general]

The tone of this email is intellectually critical (not ment as
personality attack) and calm. If I'm otherwise, them I'm a bastard. :)

bill

