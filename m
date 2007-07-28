Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbXG1Vc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbXG1Vc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXG1Vcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:32:50 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:55258
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXG1Vcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:32:50 -0400
Date: Sat, 28 Jul 2007 14:32:32 -0700
To: Diego Calleja <diegocg@gmail.com>
Cc: jos poortvliet <jos@mijnkamer.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, ck@vds.kolivas.org,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Message-ID: <20070728213232.GG32582@gnuppy.monkey.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org> <200707282128.39906.jos@mijnkamer.nl> <20070728200705.GF32582@gnuppy.monkey.org> <20070728230609.43273a75.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728230609.43273a75.diegocg@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 11:06:09PM +0200, Diego Calleja wrote:
> So your argument is that SD shouldn't have been merged either, because it
> would have resulted in one scheduler over the other?

My argument is that schedule development is open ended. Although having
a central scheduler to hack is a a good thing, it shouldn't lock out or
supress development from other groups that might be trying to solve the
problem in unique ways.

This can be accomplished in a couple of ways:

1) scheduler modularity

Clearly Con is highly qualified to experiement with scheduler code and
this should be technically facilitate by some means if not a maintainer.
He's only a part time maintainer and nobody helped him with this stuff
nor did they try to understand what his scheduler was trying to do other
than Tong Li.

2) better code modularity

Now, cleaner code would help with this a lot. If that was in place, we
might not need (1) and pluggable scheduler. It would limit the amount
of refactoring for folks so that their code can drop in easier. There's
a significant amount of churn that it locks out developers by default
since they have to constantly clean up the code in question while another
developer can commit without consideration to how it effects others.
That's their right as a maintainer, but also as maintainer, they should
give proper amount of consideration to how others might intend to extend
the code so that development remains "inclusive".

This notion of "open source, open development" is false when working
under those circumstances.

> > where capable but one is locked out now because of the choices of
> > current high level kernel developers in Linux.
> 
> Well, there are two schedulers...it's obvious that "high level kernel
> developers" needed to chose one.

I think that's kind of a bogus assumption from the very get go. Scheduling
in Linux is one of the most unevolved systems in the kernel that still
could go through a large transformation and get big gains like what
we've had over the last few months. This evident with both schedulers,
both do well and it's a good thing overall the CFS is going in.

Now, the way it happened is completely screwed up in so many ways that I
don't see how folks can miss it. This is not just Ingo versus Con, this
is the current Linux community and how it makes decision from the top down
and the current cultural attitude towards developers doing things that
are:

1) architecturally significant

which they will get flamed to death by the establish Linux kernel culture
before they can get any users to report bugs after their posting on lkml.

2) conceptual different

which is subject to the reasons above, but also get flamed to death unless
it comes from folks internal to the Linux development processes.

When groups get to a certain size like it has, there needs to be a
revision of development processes so that they can scale and be "inclusive"
to the overall spirit the Linux development process. When that breaks down,
we get situations like what we have with Con leaving development. Other
developers like me get turned off to the situation, also feel the same as
Con and stop Linux development. That's my current status as well.

> The main problem is clearly that no scheduler was clearly better than the
> other. This remembers me of the LVM2/MD vs EVMS in the 2.5 days - both
> of them were good enought, but only one of them could be merged. The
> difference is that EVMS developers didn't get that annoyed, and not only
> they didn't quit but they continued developing their userspace tools to
> make it work with the solution included in the kernel

That's a good point to have folks not go down that particular path. But
Con was kind of put down during the arguments with Ingo about his
assumptions of the problems and then was personally crapped on by having
his own idea under go a a complete reversal in opinion by Ingo, with
Ingo then doing this own version of Con's work displacing him

How would you feel in that situation ? I'd be pretty damn pissed.

[For the record Peter Zijlstra did the same thing to me which is annoying,
but since he's my buddy doesn't get as rude as the above situation, included
me in every private mail about his working so that I don't feel like RH
is paying him to undermine my brilliance, it's ok :)]

bill

