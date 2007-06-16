Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbXFPBU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbXFPBU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbXFPBUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:20:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:58283 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbXFPBUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:20:16 -0400
Date: Sat, 16 Jun 2007 03:32:36 +0200
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070616013236.GA16016@flower.upol.cz>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615234202.GP3588@stusta.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 01:42:02AM +0200, Adrian Bunk wrote:
> On Fri, Jun 15, 2007 at 04:20:57PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 14 Jun 2007, Oleg Verych wrote:
> > > 
> > > I'm seeing this long (198) thread and just have no idea how it has
> > > ended (wiki? hand-mailing?).
> > 
> > I'm hoping it's not "ended".
> > 
> > IOW, I really don't think we _resolved_ anything, although the work that 
> > Adrian started is continuing through the wiki and other people trying to 
> > track regressions, and that was obviously something good.
> > 
> > But I don't think we really know where we want to take this thing in the 
> > long run. I think everybody wants a better bug-tracking system, but 
> > whether something that makes people satisfied can even be built is open. 
> > It sure doesn't seem to exist right now ;)
> 
> The problem is not the bug tracking system, be it manual tracking in a 
> text file or a Wiki or be it in Bugzilla or any other bug tracking 
> system.
> 
> One problem is the lack of experienced developers willing to debug bug 
> reports.

*debug*

I hope you saw what subject i've chosen to bring this discussion back.
Yes, "tracking", as the first brick for big wall.

Your arguments about developers and users, you've said already, but i've
asked different questions, have i?

Lets look on regular automatic report, like this one:

Message-ID: <E1Hz5HK-0007uB-MO@merkel.debian.org>
Xref: news.gmane.org gmane.linux.debian.devel.general:116248
Archived-At: <http://permalink.gmane.org/gmane.linux.debian.devel.general/116248

And what we see? Basic packages, like ``dpkg'', ``grub'', ``mc'' are
in the list, requesting help. And as you can see for quite some time.
And it's *OK*, because distribution is working, development is going on.
Sometimes slowly, sometimes with delays.

> But what really annoyed me was the missing integration of regression 
> tracking into the release process, IOW how _you_ handled the regression 
> lists.

So, _tracking_ or _debugging_?

> If we want to offer something less of a disaster than 2.6.21, and if we 
> want to encourage people to start and continue testing -rc kernels, we 
> must try to fix as many reported regressions as reasonably possible.

*tracking*

Despite of tools, Debian have such thing as long release cycles, so
called ``Debian sickness''. And reason, i see, is what you've just
pointed out: less disaster, zer0 RC bugs. Plus everybody is volunteer,
big chunk of bureaucracy-based decisions. And all this for about
15000 packages.

* + reporting*

One side Linux is facing is hardware, and that kind of thing is very-very
diverse. LKML traffic is huge, yet there's no suitable tracking and
reporting *tool*.

> This means going through every single point in the regression list 
> asking "Have we tried everything possible to solve this regression?". 
> There are very mysterious regressions and there are regressions that 
> might simply be reported too late. But if at the time of the final 
> release 3 week old regressions hadn't been debugged at all there's 
> definitely room for improvement. And mere mortals like me reminding 
> people is often not enough, sometimes an email by Linus Torvalds himself 
> asking a patch author or maintainer to look after a regression might be 
> required.

*social* (first approximation)

That's a social problem, just like Debian loosing good kernel team members.

For example you feel, that you've wasted time. But after all, if you've
came up with some kind of tool, everybody else could take it. No
problems, useful ideas must and will evolve. But _ideally_ this must not be
from ground zero every time. _Ideally_ from technical, not personal
point of view ;).

That's why people in Debian have started *team* maintenance with alioth. 

Unfortunately problems with individuals in big machine with bad people,
got randomly elected, can't be solved (IMHO). Even LKML's rule "patches
are welcome", that is very technical, thus good, doesn't work there.

Finally, read the end of 2.6.21 release message ;)

> And a low hanging fruit to improve the release would be if you could 
> release one last -rc, wait for 48 hours, and then release either this 
> -rc unchanged as -final or another -rc (and wait another 48 hours).
> There were at least two different regressions people ran into in 2.6.21 
> who successfully tested -rc7.

What about Linus' tree is a development tree, Andrew's one is a "crazy
development one" (quoting Linus)?

What about open (web page still exists) position on bug manager in
Google?

What about *volunteers* working from both developer's and user's
sides? What about "release is a reward" for everybody?

Balanced eco-system will oscillate. Be it .19(---++), .20(-++++),
.21(----+) *relese*. That's natural, unless pushed to extremes.

I think, i can trust Linus in it, and you are welcome too.

*tools*

That's why i'm talking about tools, and started to discuss them.

My last try: reportbug (there's "-ng" one also), Debian BTS.

Adrian, what can/must be done to adopt them? If not, your experience may
provide information about "why?" (re-consider my first mail about
background, please).
____
