Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXK0ADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXK0ADo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXK0ADg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:03:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbXK0ADf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:03:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Date: Tue, 27 Nov 2007 01:21:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200711252157.10212.rjw@sisk.pl> <200711262344.25223.rjw@sisk.pl> <20071126233052.GF917@stusta.de>
In-Reply-To: <20071126233052.GF917@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270121.43587.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Adrian Bunk wrote:
> On Mon, Nov 26, 2007 at 11:44:24PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, Adrian Bunk wrote:
> > > On Mon, Nov 26, 2007 at 01:51:37AM +0100, Rafael J. Wysocki wrote:
> > > > On Monday, 26 of November 2007, Adrian Bunk wrote:
> >...
> > > > > We will never get 100% of all bugs fixed.
> > > > > 
> > > > > Let's get back to the fact that we have many bug reports that could be 
> > > > > fixed within a reasonable amount of time but are not.
> > > > 
> > > > Do you have specific examples?
> > > 
> > > Take e.g. #3938
> > 
> > Are you sure that this one hasn't been fixed?  The reporter doesn't seem to be
> > responsive ...
> > 
> > > or #4039
> > 
> > Same here.
> 
> Saying "reporter doesn't seem to be responsive" is a joke if there was
> zero activity in solving any of these bugs for nearly three years.
> 
> They might (or might not) be fixed by chance now, but they should have
> been fixed in the beginning of 2005 as a result of the bug reports.
> 
> You can now claim these are too old, but you'll find for any bug age 
> bugs that both should be solvable for a developer knowing the kernel 
> code in question and that have not been seriously debugged.

Arguably, we can't be sure that the bug wasn't worked on just because there's
no confirmation of that in the Bugzilla.  It _probably_ wasn't, but in fact
that's uncertain.

OTOH, in both cases above you can't even assume that the appropriate developer
was _aware_ of the bug report.

Which, BTW, is a problem even with the Bugzilla as it is configured today: it
doesn't give you any guarantee that the bug report is heard of by the right
people (unless, of course, it's forwarded to them by Andrew, that is, but this
"mechanism" is not exactly a part of the Bugzilla itself ;-)).

For this reason, I'd like the maintainers/developers of every subsystem to
provide us with an address of a mailing list considered as appropriate for
sending bug reports related to this particular subsystem.  Then, we can make
the Bugzilla forward bug reports to these lists, so that Andrew or anyone else
need not handle that manually.

Now, if we have such lists set up for all subsystems, we'll be able to just
tell users to send bug reports there, either using the Bugzilla, or directly,
with the assumption that the right people get those reports.

Then, the "we didn't know about the report" kind of excuse won't be viable any
more and we'll be able to exert more directed pressure at the subsystems that
aren't good enough at handling bugs.

Greetings,
Rafael
