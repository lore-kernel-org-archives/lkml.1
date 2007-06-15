Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXFOXl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXFOXl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbXFOXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:41:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36387 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756268AbXFOXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:41:48 -0400
Date: Sat, 16 Jun 2007 01:42:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070615234202.GP3588@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 04:20:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 14 Jun 2007, Oleg Verych wrote:
> > 
> > I'm seeing this long (198) thread and just have no idea how it has
> > ended (wiki? hand-mailing?).
> 
> I'm hoping it's not "ended".
> 
> IOW, I really don't think we _resolved_ anything, although the work that 
> Adrian started is continuing through the wiki and other people trying to 
> track regressions, and that was obviously something good.
> 
> But I don't think we really know where we want to take this thing in the 
> long run. I think everybody wants a better bug-tracking system, but 
> whether something that makes people satisfied can even be built is open. 
> It sure doesn't seem to exist right now ;)

The problem is not the bug tracking system, be it manual tracking in a 
text file or a Wiki or be it in Bugzilla or any other bug tracking 
system.

One problem is the lack of experienced developers willing to debug bug 
reports.

But what really annoyed me was the missing integration of regression 
tracking into the release process, IOW how _you_ handled the regression 
lists.

If we want to offer something less of a disaster than 2.6.21, and if we 
want to encourage people to start and continue testing -rc kernels, we 
must try to fix as many reported regressions as reasonably possible.

This means going through every single point in the regression list 
asking "Have we tried everything possible to solve this regression?". 
There are very mysterious regressions and there are regressions that 
might simply be reported too late. But if at the time of the final 
release 3 week old regressions hadn't been debugged at all there's 
definitely room for improvement. And mere mortals like me reminding 
people is often not enough, sometimes an email by Linus Torvalds himself 
asking a patch author or maintainer to look after a regression might be 
required.

And a low hanging fruit to improve the release would be if you could 
release one last -rc, wait for 48 hours, and then release either this 
-rc unchanged as -final or another -rc (and wait another 48 hours).
There were at least two different regressions people ran into in 2.6.21 
who successfully tested -rc7.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

