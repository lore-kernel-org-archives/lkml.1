Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbYEAR0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbYEAR0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbYEAR0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:26:11 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42857 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbYEAR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:26:09 -0400
Date: Thu, 1 May 2008 13:24:34 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501172434.GB17365@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 08:49:19AM -0700, Andrew Morton wrote:
> Another fallacy which Arjan is pushing (even though he doesn't appear to
> have realised it) is "all hardware is the same".
> 
> Well, it isn't.  And most of our bugs are hardware-specific.  So, I'd
> venture, most of our bugs don't affect most people.  So, over time, by
> Arjan's "important to enough people" observation we just get more and more
> and more unfixed bugs.
> 
> And I believe this effect has been occurring.

So the question is if we have a thousand bugs which only affect one
person each, and 70 million Linux users, how much should we beat up
ourselves that 1,000 people can't use a particular version of the
Linux kernel, versus the 99.9% of the people for which the kernel
works just fine?

Sometimes, we can't make everyone happy.

At the recent Linux Collaboration Summit, we had a local user walk up
to a microphone, and loosely paraphrased, said, "WHINE WHINE WHINE
WHINE I have have a $30 DVD drive that doesn't work with Linux.  WHINE
WHINE WHINE WHINE WHINE What are *you* going to do to fix my problem?"

Some people like James responded very diplomatically, with "Well, you
have to understand, the developer might not have your hardware, and
there's a lot of broken out here, etc., etc."  What I wanted to tell
this user was, "Ask not what the Linux development community can do
for you.  Ask what *you* can do for Linux?"  Suppose this person had
filed a kernel bugzilla bug, and it was one of the hundreds or
thousands of non-handled bugs.  Sure, it's a tragedy that bugs pile
up.  But if they pile up because of crappy hardware, that's not a
major tragedy.  If we can figure out how to blacklist it, and move on,
we should do so.  

> And why can't they work on the bug?  Usually, because they found a
> workaround.  People aren't going to spend months sitting in front of a
> non-functional computer waiting for kernel developers to decide if their
> machine is important enough to fix.  They will find a workaround.  They
> will buy new hardware.

Hey, in this particular case, if this user worked around the problem
by buying new hardware, it was probably the right solution.  As far as
we know we don't have a systematic problem where huge numbers DVD
drives aren't working, so if there are a few odd ball ones that are
out there, we just CAN'T self-flagellate ourselves that we're not
fixing all bugs, and letting some bugs pile up.

> Which leads us to Arjan's third fallacy:
> 
>    "How many bugs that a sizable portion of users will hit in reality
>    are there?" is the right question to ask...
> 
> well no, it isn't.  Because approximately zero of the hardware bugs affect
> a sizeable portion of users.  With this logic we will end up with more and
> more and more and more bugs each of which affect a tiny number of users. 
> Hundreds of different bugs.  You know where this process ends up.

... and maybe we can't solve hardware bugs.  Or that crappy hardware
isn't worth holding back Linux development.  And I'm not sure ignoring
it is that horrible of a thing.  And in practice, if it's a hardware
bug in something which is very common, it *will* get noticed very
quickly and fixed.  But if it's in a hardware bug in some rare piece
of hardware, the user is going to have to either (a) help us fix it,
or (b) decide that his time is more valuable and that buying another
$30 DVD drive might be a better use of his and our time.

Back when I was the serial driver maintainer, I certainly made those
kinds of triage decisions.  I knew the serial driver was working on
the vast majority of the Linux users, because if it broke in a major
ways, I would hear about it, in spades and get lots and lots of hate
mail.  And there were plenty of crappy ISA boards out there; and I
would help them out when I could, and sometimes spend more volunteer
time helping them by changing one or two outb() to outb_p()'s (yes,
that really made a difference; remember, we're talking about crappy PC
class hardware with hardware bugs), but at the end of the day, past a
certain point, even with a willing and cooperative end-user, I would
have to call it a day, and give up, and tell them to get another
serial card.  (And back in the days of ISA boards, we couldn't even
use blacklists.)

And you know what?  Linux didn't collapse into a steaming pile of dung
when I did that.  We're all volunteers, and we need to recognize there
are limits to what we can do --- otherwise, it will way to easy to
burn out and become a bitter shell of a maintainer....

Even BSD fan boys will realize that in BSD land, you have to do even
more of this; if there's random broken hardware, or simply a lack of a
device driver, very often your only recourse is to work around the
problem by buying another serial card, or wifi card, or whatever.  And
this happens much more with BSD than Linux, simply because they
support fewer devices to begin with.

					- Ted

P.S.  We should really try to categorize bugs so we can figure out
what percentage of the bugs are device driver bugs, and what
percentage are core kernel bugs, which are "if you stress the system
too badly" sort of bugs, or "if you do something bad like yank the USB
stick without unmounting the filesystem first" sort of thing.  I think
if we did this, the numbers wouldn't look quite so scary, because it's
things like device driver problems with wierd sh*t bugs are not
comparable with core functionality bugs in the SLUB allocator, for
example.

