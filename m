Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbXKYNuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbXKYNuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 08:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXKYNuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 08:50:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38029 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752971AbXKYNt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 08:49:59 -0500
Date: Sun, 25 Nov 2007 14:49:45 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: kernel bugzilla is FPOS (was: Re: "buggy cmd640" message
	followed by soft lockup)
Message-ID: <20071125134945.GB14171@stusta.de>
References: <200711222007.12497.elendil@planet.nl> <200711242007.52430.rjw@sisk.pl> <200711250126.11603.bzolnier@gmail.com> <200711251411.16034.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711251411.16034.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 02:11:15PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 25 of November 2007, Bartlomiej Zolnierkiewicz wrote:
>...
> > On Saturday 24 November 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
>...
> >   - zillion other little improvements...
> 
> Sure, improvements are always possible. :-)
> 
> >   [ The average bug quality is not very high (bugs often lack critical
> >     information) and this is really not reporters' fault!  The interface
> >     should be kept as simple as possible but if the reporter wants to
> >     find some help and hints they should be there. ]
> 
> IMO, if there's a user who has a problem with _our_ code, we should do our best
> to help him even if he doesn't report the bug very well.  Also, if the problem
> is not with the most recent kernel, we should at least ask the reporter to try
> a newer version.


Completely ACK'ed.

Also keep in mind:

Andrew is going through all new bug reports.
People like Natalie or me also go through new bug reports.

Good bug reports are valuable contributions.
Bug reporters are humans.
In my experience, most bug reporters are more than willing to provide
any kind of information or testing when requested.

And not to forget:
All the problems with bug report quality are not better when the bug 
report comes via email.


> > * Bugs that sit in NEEDINFO state for more than i.e. one month should be
> >   automatically closed.
> 
> I agree that we probably should do something like this.


Not automatically.

Often submitters answer the question that led to the NEEDINFO state but 
don't change the state.

And I know this, since going through all bugs in the NEEDINFO state and 
either closing them or removing the NEEDINFO is a simple and not too big 
task I'm sometimes doing.


> > * After each major kernel release bugzilla should send a kind request for
> >   retesting to all open bugs.
> 
> Good idea, IMO.


Good idea ... for pissing off bug submitters.

We have many bug reports in the Bugzilla with very responsive submitters 
who wrote very good bug reports but have the bad luck that it's in an 
area without a maintainer looking after the bug.


>...
> >   [ also compare this with "Maintained" definition in MAINTAINERS file ]
> > 
> > * From maintainer/developer POV you really want to track bugs in public
> >   (mailing list) so other people can jump in and help.
> >
> >   [ It is also important that the other developers see that you are active. ]
> 
> You can always ask on the list, pointing to the Bugzilla entry in question.


You can also assign bugs for some component by default to some real or 
dummy address that forwards everything from the Bugzilla bug (starting 
with the initial bug report) to some mailing list.

And when people answer to this email, the answers will be tracked in 
Bugzilla.


> > * We want bug tracking the other way around: everything goes through mailing
> >   list first (including bugs filled to the bug tracker) and if not fixed
> >   quickly, somebody (maintainer of the given part of code or a higher level
> >   maintainer) replies cc:ing bugzilla so the new bug entry is added.
> > 
> >   Also this way we fix trivial/easy/medium bugs ASAP or reject invalid ones
> >   without any bugzilla overhead.  We also add a new patch description tags:
> >   - "Fixes-bug:" tag with reference to the original discussion
> 
> Alternatively, we can give a Bugzilla link here pointing to the entry which
> contains a pointer to the original discussion.  [This may be more convenient,
> since some bugs are reported multiple times and tracked separately to the point
> in which it turns out that they really are the same.]


It would be best if bugs would initially be entered in Bugzilla.

If you have a permanent cookie with the Bugzilla authentification in 
your browser the overhead of closing a bug is to click on the link in 
the Bugzilla email plus 2 clicks in the browser.


>...
> Greetings,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

