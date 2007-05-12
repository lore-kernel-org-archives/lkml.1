Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbXELWOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbXELWOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 18:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXELWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 18:14:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58455 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751892AbXELWOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 18:14:48 -0400
Date: Sun, 13 May 2007 00:14:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070512221446.GA761@elf.ucw.cz>
References: <200705122017.32792.rjw@sisk.pl> <20070512191709.GA428@elf.ucw.cz> <alpine.LFD.0.98.0705121239090.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705121239090.3986@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If you fail to do that, we'll see freezer failure, quickly, and catch
> > the simple bug.
> 
> "It's a feature to add crap to drivers and subsystems that don't care!"
> 
> That's a novel thing.
> 
> Maybe we could add other features too. Like a "IM_NOT_AN_IDIOT" flag that 
> every driver has to set in it's "struct device", so that the device 
> manager knows that it wasn't written by an idiot.

Well, it was initially SOMEONE_REVIEWIED_THIS flag (and thus pretty
neccessary for initial merge). Now it still serves as
SOMEONE_REVIEWIED_THIS flag, but I guess you could call it
IM_NOT_AN_IDIOT flag, too.

Well, we can go the other way around, but that means more careful
reviewing of incoming code. Yes, we can do it.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
