Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbYCFUVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbYCFUVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763677AbYCFUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:20:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3508 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756159AbYCFUUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:20:21 -0500
Date: Thu, 6 Mar 2008 16:55:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Message-ID: <20080306155553.GA3908@ucw.cz>
References: <200803041230.42152.david-b@pacbell.net> <Pine.LNX.4.44L0.0803041558070.15986-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803041558070.15986-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-04 16:00:51, Alan Stern wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
> 
> > > What's wrong with a superfluous probe at resume time, besides the waste 
> > > of a few milliseconds?
> > 
> > I'm more concerned with the undesirable removal of devices at suspend
> > time ... ones with mounted filesystems etc.
> 
> On that we can agree.  The removal is done if the host doesn't define a 
> resume method.  There doesn't seem to be any point to that, given that 
> the probing during resume will determine whether a card has in fact 
> been removed.

Hmm, if the driver is sleeping too deeply, user might have removed the
card and put in different one, without driver noticing. That would be
_bad_.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
