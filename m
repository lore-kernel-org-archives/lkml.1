Return-Path: <linux-kernel-owner+w=401wt.eu-S1750713AbXBKTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750713AbXBKTmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbXBKTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:42:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51568 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750713AbXBKTmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:42:13 -0500
Date: Sun, 11 Feb 2007 20:42:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>, nigel@nigel.suspend2.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211194202.GC15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702102320.39531.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Can we start to NAK new drivers that don't have proper power management
> > > > implemented? There really is no excuse for writing a new driver and not
> > > > putting .suspend and .resume methods in anymore, is there?
> > > 
> > > to a large degree, a device driver that doesn't suspend is better than
> > > no device driver at all, right?
> > > now.. if you want to make the core warn about it, that's very fair
> > 
> > Well, driver that is broken on SMP is arguably better than no driver
> > at all, yet we'd probably avoid merging that. It would be nice to
> > start including suspend in 'must work' list...
> 
> What about this:
> 
> "If the device requires that, implement .suspend and .resume or at least
> define .suspend that will always return -ENOSYS (then people will know they
> have to unload the driver before the suspend).  Similarly, if you aren't sure
> whether or not the device requires .suspend and .resume, define .suspend that
> will always return -ENOSYS."

Sounds ok to me. Where should this text go?
Documentation/SubmittingDrivers ?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
