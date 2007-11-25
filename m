Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbXKYTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbXKYTtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 14:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbXKYTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 14:49:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbXKYTtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:49:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message followed by soft lockup)
Date: Sun, 25 Nov 2007 21:07:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200711222007.12497.elendil@planet.nl> <200711251411.16034.rjw@sisk.pl> <20071125134945.GB14171@stusta.de>
In-Reply-To: <20071125134945.GB14171@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711252107.23926.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 02:11:15PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 25 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> >...
> > > On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> > > > On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
> >...
> > >   - zillion other little improvements...
> > 
> > Sure, improvements are always possible. :-)
> > 
> > >   [ The average bug quality is not very high (bugs often lack critical
> > >     information) and this is really not reporters' fault!  The interface
> > >     should be kept as simple as possible but if the reporter wants to
> > >     find some help and hints they should be there. ]
> > 
> > IMO, if there's a user who has a problem with _our_ code, we should do our best
> > to help him even if he doesn't report the bug very well.  Also, if the problem
> > is not with the most recent kernel, we should at least ask the reporter to try
> > a newer version.
> 
> 
> Completely ACK'ed.
> 
> Also keep in mind:
> 
> Andrew is going through all new bug reports.
> People like Natalie or me also go through new bug reports.
> 
> Good bug reports are valuable contributions.
> Bug reporters are humans.
> In my experience, most bug reporters are more than willing to provide
> any kind of information or testing when requested.
> 
> And not to forget:
> All the problems with bug report quality are not better when the bug 
> report comes via email.
> 
> 
> > > * Bugs that sit in NEEDINFO state for more than i.e. one month should be
> > >   automatically closed.
> > 
> > I agree that we probably should do something like this.
>  
> Not automatically.

OK, say "as a rule".

> Often submitters answer the question that led to the NEEDINFO state but 
> don't change the state.
> 
> And I know this, since going through all bugs in the NEEDINFO state and 
> either closing them or removing the NEEDINFO is a simple and not too big 
> task I'm sometimes doing.

I think we can set a rule that NEEDINFO bugs with a developer request not
responded to by the reporter for a month are closable.  Everyone with
sufficient access rights who spots such a bug can close it.

> > > * After each major kernel release bugzilla should send a kind request for
> > >   retesting to all open bugs.
> > 
> > Good idea, IMO.
> 
> Good idea ... for pissing off bug submitters.
> 
> We have many bug reports in the Bugzilla with very responsive submitters 
> who wrote very good bug reports but have the bad luck that it's in an 
> area without a maintainer looking after the bug.

These are two different issues.

On the one hand, I don't see anything wrong with encouraging bug reporters to
test new kernels, especially if the reported problems depend on hardware, as it
is possible that the bug will get fixed as a result of a loosely related change
(like a fix for another bug etc.).  [Still, in such cases it would be good to
identify the change that fixes the problem anyway.]

OTOH, the situations in which good bug reports are not responded to are not
acceptable.  There should be a way to make developers take care of _their_
code, because by not doing so they hurt us all, big time.

> >...
> > >   [ also compare this with "Maintained" definition in MAINTAINERS file ]
> > > 
> > > * From maintainer/developer POV you really want to track bugs in public
> > >   (mailing list) so other people can jump in and help.
> > >
> > >   [ It is also important that the other developers see that you are active. ]
> > 
> > You can always ask on the list, pointing to the Bugzilla entry in question.
> 
> 
> You can also assign bugs for some component by default to some real or 
> dummy address that forwards everything from the Bugzilla bug (starting 
> with the initial bug report) to some mailing list.
> 
> And when people answer to this email, the answers will be tracked in 
> Bugzilla.

Yes.

> > > * We want bug tracking the other way around: everything goes through mailing
> > >   list first (including bugs filled to the bug tracker) and if not fixed
> > >   quickly, somebody (maintainer of the given part of code or a higher level
> > >   maintainer) replies cc:ing bugzilla so the new bug entry is added.
> > > 
> > >   Also this way we fix trivial/easy/medium bugs ASAP or reject invalid ones
> > >   without any bugzilla overhead.  We also add a new patch description tags:
> > >   - "Fixes-bug:" tag with reference to the original discussion
> > 
> > Alternatively, we can give a Bugzilla link here pointing to the entry which
> > contains a pointer to the original discussion.  [This may be more convenient,
> > since some bugs are reported multiple times and tracked separately to the point
> > in which it turns out that they really are the same.]
> 
> 
> It would be best if bugs would initially be entered in Bugzilla.

The Bugzilla has a considerable "barrier to entry" for new bug reporters, as
it pretends to require them to spend quite a lot of time on the bug report.

Also, some developers do not consider the Bugzilla as a useful thing and
wouldn't like to use it (which is why this thread has appeared, among other
things ;-)).

> If you have a permanent cookie with the Bugzilla authentification in 
> your browser the overhead of closing a bug is to click on the link in 
> the Bugzilla email plus 2 clicks in the browser.

Sure.

Greetings,
Rafael
