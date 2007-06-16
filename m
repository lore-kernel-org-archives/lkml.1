Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXFPCzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXFPCzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXFPCzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:55:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36465 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXFPCzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:55:03 -0400
Date: Sat, 16 Jun 2007 04:55:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070616025516.GR3588@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070616013236.GA16016@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 03:32:36AM +0200, Oleg Verych wrote:
> On Sat, Jun 16, 2007 at 01:42:02AM +0200, Adrian Bunk wrote:
> > On Fri, Jun 15, 2007 at 04:20:57PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 14 Jun 2007, Oleg Verych wrote:
> > > > 
> > > > I'm seeing this long (198) thread and just have no idea how it has
> > > > ended (wiki? hand-mailing?).
> > > 
> > > I'm hoping it's not "ended".
> > > 
> > > IOW, I really don't think we _resolved_ anything, although the work that 
> > > Adrian started is continuing through the wiki and other people trying to 
> > > track regressions, and that was obviously something good.
> > > 
> > > But I don't think we really know where we want to take this thing in the 
> > > long run. I think everybody wants a better bug-tracking system, but 
> > > whether something that makes people satisfied can even be built is open. 
> > > It sure doesn't seem to exist right now ;)
> > 
> > The problem is not the bug tracking system, be it manual tracking in a 
> > text file or a Wiki or be it in Bugzilla or any other bug tracking 
> > system.
> > 
> > One problem is the lack of experienced developers willing to debug bug 
> > reports.
> 
> *debug*
> 
> I hope you saw what subject i've chosen to bring this discussion back.
> Yes, "tracking", as the first brick for big wall.

Tracking regressions is not a real problem.
Especially since it doesn't require much technical knowledge.

> Your arguments about developers and users, you've said already, but i've
> asked different questions, have i?
> 
> Lets look on regular automatic report, like this one:
> 
> Message-ID: <E1Hz5HK-0007uB-MO@merkel.debian.org>
> Xref: news.gmane.org gmane.linux.debian.devel.general:116248
> Archived-At: <http://permalink.gmane.org/gmane.linux.debian.devel.general/116248
> 
> And what we see? Basic packages, like ``dpkg'', ``grub'', ``mc'' are
> in the list, requesting help. And as you can see for quite some time.
> And it's *OK*, because distribution is working, development is going on.
> Sometimes slowly, sometimes with delays.

I sent weekly regression reports.
Not automatically generated but manually - but that doesn't matter.

The problem is that sending reports itself does not fix anything.

> > But what really annoyed me was the missing integration of regression 
> > tracking into the release process, IOW how _you_ handled the regression 
> > lists.
> 
> So, _tracking_ or _debugging_?

_debugging_ (can be indirectly by poking other people to do debugging)

> > If we want to offer something less of a disaster than 2.6.21, and if we 
> > want to encourage people to start and continue testing -rc kernels, we 
> > must try to fix as many reported regressions as reasonably possible.
> 
> *tracking*

no, *debugging*

I tracked regressions for the 2.6.21 disaster, and the not debugged 
regressions that I had tracked are exactly where we should be better.

>...
> > This means going through every single point in the regression list 
> > asking "Have we tried everything possible to solve this regression?". 
> > There are very mysterious regressions and there are regressions that 
> > might simply be reported too late. But if at the time of the final 
> > release 3 week old regressions hadn't been debugged at all there's 
> > definitely room for improvement. And mere mortals like me reminding 
> > people is often not enough, sometimes an email by Linus Torvalds himself 
> > asking a patch author or maintainer to look after a regression might be 
> > required.
> 
> *social* (first approximation)

Yes.

> That's a social problem, just like Debian loosing good kernel team members.

Different social problem.

> For example you feel, that you've wasted time. But after all, if you've
> came up with some kind of tool, everybody else could take it. No
> problems, useful ideas must and will evolve. But _ideally_ this must not be
> from ground zero every time. _Ideally_ from technical, not personal
> point of view ;).

As I expected, someone else has picked up regression tracking.
And other from what you claim, this did not require any kind of tool.

> That's why people in Debian have started *team* maintenance with alioth. 

The problem for the Linux kernel is that for a better bug handling you'd 
need people willing to learn other people's code and to do the hard work 
of debugging bug reports. E.g. writing a new filesystem is simply much 
more fun than learning and debugging other people's code in some old 
filesystem.

Talking about "team maintenance" sounds nice, but the problem in the 
kernel starts with code that has zero maintainers. And if there's 
already a maintainer, it's unlikely that he'll not accept patches from 
some new person debugging bug reports. But how to find people who will 
become good maintainers?

> Unfortunately problems with individuals in big machine with bad people,
> got randomly elected, can't be solved (IMHO). Even LKML's rule "patches
> are welcome", that is very technical, thus good, doesn't work there.

Debian has it's own problems, Linux kernel development at least has a 
working structure for getting decisions and regular releases.

> Finally, read the end of 2.6.21 release message ;)
> 
> > And a low hanging fruit to improve the release would be if you could 
> > release one last -rc, wait for 48 hours, and then release either this 
> > -rc unchanged as -final or another -rc (and wait another 48 hours).
> > There were at least two different regressions people ran into in 2.6.21 
> > who successfully tested -rc7.
> 
> What about Linus' tree is a development tree, Andrew's one is a "crazy
> development one" (quoting Linus)?
> 
> What about open (web page still exists) position on bug manager in
> Google?
> 
> What about *volunteers* working from both developer's and user's
> sides? What about "release is a reward" for everybody?

People aren't that dumb that some empty words like "release is a reward"
would change anything.

> Balanced eco-system will oscillate. Be it .19(---++), .20(-++++),
> .21(----+) *relese*. That's natural, unless pushed to extremes.
> 
> I think, i can trust Linus in it, and you are welcome too.
> 
> *tools*
> 
> That's why i'm talking about tools, and started to discuss them.
> 
> My last try: reportbug (there's "-ng" one also), Debian BTS.
> 
> Adrian, what can/must be done to adopt them? If not, your experience may
> provide information about "why?" (re-consider my first mail about
> background, please).

Bug tracking for the kernel is more or less working.
The main problem is getting people to debug bug reports.

We need the main problem fixed, not a different tool in an area that is 
not the main problem.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

