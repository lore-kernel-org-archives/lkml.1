Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYCWVaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYCWVaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 17:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYCWVaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 17:30:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbYCWVaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 17:30:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Date: Sun, 23 Mar 2008 22:29:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <200803170018.52663.rjw@sisk.pl> <alpine.DEB.1.00.0803232004300.13579@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803232004300.13579@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803232229.42788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please have a look at the latest report:
http://lkml.org/lkml/2008/3/21/516

On Sunday, 23 of March 2008, Christian Kujau wrote:
> On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> > Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> > Submitter	: Linas Žvirblis <0x0007@gmail.com>
> > Date		: 2008-02-13 22:38 (33 days old)
> > References	: http://lkml.org/lkml/2008/2/13/566
> 
> Linas did not respond any more, and you closed the bug :)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10051
> > Subject		: Spurious messages at boot, eventually hangs the usb subsustem
> > Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> > Date		: 2008-02-20 09:10 (26 days old)
> 
> Hm, Jean-Luc said:
> >  ------- Comment  #4 From Jean-Luc Coulon  2008-03-09 22:50:19   ----
> >  BTW, I can normally boot my system since rc4
> 
> Close?

Yes, if he doesn't respond for a couple of days.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10086
> > Subject		: 2.6.25-rc2 + smartd = hang
> > Submitter	: Anders Eriksson <aeriksson@fastmail.fm>
> > Date		: 2008-02-22 17:51 (24 days old)
> > References	: http://lkml.org/lkml/2008/2/22/239
> > Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10086#c5 says it's fixed.

Yes, it's closed now.
 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
> > Subject		: INFO: possible circular locking in the resume
> > Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date		: 2008-02-27 (19 days old)
> > References	: http://lkml.org/lkml/2008/2/26/479
> > Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> 
> Gautham said on 2008-02-28 he has a patch - but did not post it. What now?

The reporter is unresponsive.  We're waiting for him to respond.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10146
> > Subject		: 2.6.25-rc: complete lockup on boot/start of X (bisected)
> > Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Date		: 2008-03-02 20:00 (15 days old)
> > References	: http://lkml.org/lkml/2008/3/2/91
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Seems to be fixed: http://lkml.org/lkml/2008/3/23/275

Yes, I've already updated the entry with this patch.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10152
> > Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
> > Submitter	: Gabriel C <nix.or.die@googlemail.com>
> > Date		: 2008-02-24 01:31 (22 days old)
> > References	: http://lkml.org/lkml/2008/2/23/380
> > 		  http://lkml.org/lkml/2008/2/24/281
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> 
> Seems to be fixed by: http://lkml.org/lkml/2008/3/22/66
> Which introduced a WARNNG:, fixed by the subsequent: 
> http://lkml.org/lkml/2008/3/23/199

This is not on the list any more.

BTW, the reports I send reflect the state of the Bugzilla entries.  The closed
entries will not be reported next time.

Thanks,
Rafael
