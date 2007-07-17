Return-Path: <linux-kernel-owner+w=401wt.eu-S935442AbXGQVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442AbXGQVcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbXGQVc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:32:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbXGQVc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:32:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:40:21 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <87bqeag369.fsf@jbms.ath.cx> <Pine.LNX.4.64.0707171404330.2467@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707171404330.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172340.23656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 23:06, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:
> 
> > david@lang.hm writes:
> >
> > [snip]
> >
> >>>> * figure out which devices can wake up
> >>>> * put devices into low power states (wake-up devices are placed in the Dx
> >>>> states compatible with the wake capability, the others are powered off)
> >
> >> this can't be done by the image-saving kernel if that kernel doesn't know about
> >> the device.
> >
> > The image-saving kernel can be made to know about all of the "wake up"
> > devices; all other devices should have already been powered off by the
> > "hibernated" kernel.
> 
> not nessasarily.

More than that.  The hibernated kernel should not power off any devices,
because that is _wasteful_ (unless, of course, the powering off a device is the
only way to quiesce it).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
