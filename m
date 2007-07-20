Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXGTKwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXGTKwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXGTKv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:51:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXGTKv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:51:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Date: Fri, 20 Jul 2007 12:59:42 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707181021300.3759-100000@iolanthe.rowland.org> <200707181647.32620.rjw@sisk.pl> <200707200740.38158.a1426z@gawab.com>
In-Reply-To: <200707200740.38158.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201259.44181.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 06:40, Al Boldi wrote:
> Rafael J. Wysocki wrote:
> > On Wednesday, 18 July 2007 16:29, Alan Stern wrote:
> > >
> > > Never mind.  It seems clear that this approach will suffer the same
> > > drawback as the proposal for removing the freezer from the
> > > suspend-to-RAM pathway.  Namely, device drivers will have to be changed
> > > to prevent user I/O requests from proceeding while devices are supposed
> > > to be quiescent or in a low-power state.
> >
> > I agree.
> >
> > > If a driver fails to handle this properly, its device could be
> > > reactivated in order to service a user request before the memory
> > > snapshot is made.  This could easily ruin the snapshot.
> >
> > That's why I've been saying for quite some time that we first need to take
> > care of the drivers. :-)
> >
> > IMO we've reached the point at which, whatever we want to do next, the
> > drivers are in the way.
> 
> Correct, but only if we want ACPI support.

No, in general.

> Granted, we need a separation of  
> the hibernate/suspend PM functions, but in the absence of ACPI, all we need 
> right now are dump/restore routines for the crashkernel.

IMO you aren't right, but I guess there's no point in trying to convince you.

> Next, we should be looking into reducing the kexec'd kernel environment size, 
> which currently, at 16MB, is way too big, and even at 1MB would be 
> problematic for small systems.
> 
> So, ACPI should really be the least of our worries, and the reason why people 
> are fixating on ACPI is probably because they have nothing else to fixate 
> on.

Yeah, right.  Please read the $subject message again.  And sorry, but IMO your
previous replies to it haven't addressed any of the original points.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
