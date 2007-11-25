Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbXKYVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbXKYVKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXKYVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:10:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXKYVK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:10:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 22:28:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200711222007.12497.elendil@planet.nl> <200711252107.23926.rjw@sisk.pl> <20071125203236.GA18284@stusta.de>
In-Reply-To: <20071125203236.GA18284@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711252228.07312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 09:07:23PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 25 of November 2007, Adrian Bunk wrote:
> > > On Sun, Nov 25, 2007 at 02:11:15PM +0100, Rafael J. Wysocki wrote:
> > > > On Sunday, 25 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> > > >...
> > > > > On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> > > > > > On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> > > >...
> >...
> > > > > * After each major kernel release bugzilla should send a kind request for
> > > > >   retesting to all open bugs.
> > > > 
> > > > Good idea, IMO.
> > > 
> > > Good idea ... for pissing off bug submitters.
> > > 
> > > We have many bug reports in the Bugzilla with very responsive submitters 
> > > who wrote very good bug reports but have the bad luck that it's in an 
> > > area without a maintainer looking after the bug.
> > 
> > These are two different issues.
> > 
> > On the one hand, I don't see anything wrong with encouraging bug reporters to
> > test new kernels, especially if the reported problems depend on hardware, as it
> > is possible that the bug will get fixed as a result of a loosely related change
> > (like a fix for another bug etc.).  [Still, in such cases it would be good to
> > identify the change that fixes the problem anyway.]
> 
> It's not that much a different issue:
> 
> If there was for each bug a maintainer looking soon after it, we should 
> not have many bugs open for a longer time.

Apart from the bugs that no one has any idea how to fix. :-)

> > OTOH, the situations in which good bug reports are not responded to are not
> > acceptable.  There should be a way to make developers take care of _their_
> > code, because by not doing so they hurt us all, big time.
> 
> There are two different cases:
> - no maintainer at all
> - maintainer is too busy with other stuff for looking at bug reports
> 
> But both cases boil down to the point of how to find maintainers...

Agreed.

> > > > > * We want bug tracking the other way around: everything goes through mailing
> > > > >   list first (including bugs filled to the bug tracker) and if not fixed
> > > > >   quickly, somebody (maintainer of the given part of code or a higher level
> > > > >   maintainer) replies cc:ing bugzilla so the new bug entry is added.
> > > > > 
> > > > >   Also this way we fix trivial/easy/medium bugs ASAP or reject invalid ones
> > > > >   without any bugzilla overhead.  We also add a new patch description tags:
> > > > >   - "Fixes-bug:" tag with reference to the original discussion
> > > > 
> > > > Alternatively, we can give a Bugzilla link here pointing to the entry which
> > > > contains a pointer to the original discussion.  [This may be more convenient,
> > > > since some bugs are reported multiple times and tracked separately to the point
> > > > in which it turns out that they really are the same.]
> > > 
> > > 
> > > It would be best if bugs would initially be entered in Bugzilla.
> > 
> > The Bugzilla has a considerable "barrier to entry" for new bug reporters, as
> > it pretends to require them to spend quite a lot of time on the bug report.
> 
> First of all, Bugzilla is a quite often used bug tracker in the open 
> source world [1], so many users already know it.
> 
> But more important, "it pretends to require them to spend" isn't true 
> because there's no pretending - we actually often require bug reporters 
> to spend a lot of time on the bug report (e.g. when asking for 
> bisecting).

But not *initially*.

We should not confuse *debugging* with *reporting bugs*.  While the former is
actually more difficult and more time consuming than writing the code in which
the bug is present, the latter should be as simple as sending an email.

> I'm also sometimes writing bug reports in different areas, and in my 
> experience it doesn't matter whether it's web-based Bugzilla, the 
> email-based Debian bug tracker or whatever else system - the time spent 
> on a good bug report is not spend on pasting the text whereever or on 
> clicking on a few boxes, the time is spent on tracking the issue down 
> and writing a good bug report.

Apparently, you are expecting the reporters do *debug* problems, while they need
not be aware of how to do that.

IMHO, we should make reporting problems as simple as reasonably possible and
once we've learnt that a bug is present (call it a "bug notification" or
whatever if you think that "bug report" is not the right name), we can instruct
the reporter to provide us with more information, as needed.

For example, "my box doesn't boot with 2.6.24-rc3" is the kind of information
which should be sufficient for everyone on this list to come to the conclusion
that there _is_ a problem without any additional information. ;-)  [Of course,
the additional information will be needed to debug the problem.]

> What matters for a bug reporter is to get a solution for his problem 
> within a reasonable amount of time.

Still, it's annoying if you attach tons of information to the report and that
information does not turn out to be useful.

> > Also, some developers do not consider the Bugzilla as a useful thing and
> > wouldn't like to use it (which is why this thread has appeared, among other
> > things ;-)).
> >...
> 
> And that's part of the problem.
> 
> Bugzilla is a usable tool, but it isn't the only tool available.
> 
> If there was one tool all developers would be willing to use that would 
> be a reason why we should switch to whatever tool this is.

The choice of the tool should be a result of the choice of a *method*.  IOW,
we have to know our needs and choose the tool that satisfies them or write one
if it doesn't exist.

For now, IMHO, we don't really know what we need.

Greetings,
Rafael
