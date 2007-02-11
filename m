Return-Path: <linux-kernel-owner+w=401wt.eu-S1750732AbXBKRCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750732AbXBKRCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXBKRCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:02:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1392 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732AbXBKRCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:02:14 -0500
Date: Sun, 11 Feb 2007 17:01:27 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>, nigel@nigel.suspend2.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211170126.GA4136@ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <45CE533C.4010108@shaw.ca> <200702110144.17783.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702110144.17783.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > -ENOSYS is just not acceptable.
> > 
> > Well, it's probably more acceptable than silently doing nothing and the 
> > device failing or locking up the machine on resume, but I couldn't agree 
> > more that it's not what we want to be encouraging. Perfect may be the 
> > enemy of the good, but "works except no power management" is hardly what 
> > I would call good these days, more like pretty sloppy..
> 
> I think there are situations in which it can be justified, like:
> - The driver is not entirely finished, but we want to merge it early, because
> of many potential users,
> - The driver has only a few users who aren't interested in the suspend/resume
> functionality,
> - The device is undocumented and we don't know how to make it handle the
> suspend/resume (we may learn that in the future or not).
> 
> For this reason I 100% agree that we should _encourage_ implementing .suspend
> and .resume, but we should not make it an unbreakable rule cast in stone.

No rules are ever unbreakable, so that should be okay. 'Make it
suspend, if you can't for some good reason, at least return -ENOSYS
from .suspend' sounds good to me.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
