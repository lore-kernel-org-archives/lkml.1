Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYGAPds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYGAPds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYGAPdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:33:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbYGAPdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:33:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
Date: Tue, 1 Jul 2008 17:35:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080701072911.GA6564@digi.com> <200807011617.55501.rjw@sisk.pl> <20080701151415.GA17688@digi.com>
In-Reply-To: <20080701151415.GA17688@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807011735.05618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Uwe Kleine-König wrote:
> Hello Rafael,
> 
> Rafael J. Wysocki wrote:
> > On Tuesday, 1 of July 2008, Uwe Kleine-König wrote:
> > > include/linux/pm.h claims:
> > >
> > >       A minimally power-aware driver treats all messages as SUSPEND
> > >       [...].
> > >
> > > This was introduced in commit 82bb67f2 by David Brownell.  At this time
> > > PM_EVENT_HIBERNATE didn't exist.  This was added in 3a2d5b70 by Rafael
> > > J. Wysocki without updating the above sentence.  I think a minimally
> > > power-aware driver should treat all messages as HIBERNATE, shouldn't it?
> > 
> > No, I don't think so.  In the majority of cases, SUSPEND is equivalent to the
> > combination of FREEZE and HIBERNATE.
> I didn't get that.  I thought SUSPEND is suspend-to-ram and HIBERNATE is
> suspend-to-disk, so HIBERNATE is the "deeper sleep".
> With that I might have to do less on SUSPEND because some state might be
> preserved after the machine comes up again.
> 
> > Still, this is going to change anyway with the introduction of the new
> > suspend/hibernation callbacks that are scheduled for 2.6.27.
> in next?

Yes.

Thanks,
Rafael
