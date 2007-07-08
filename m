Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXGHVIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXGHVIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXGHVIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:08:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35424 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757265AbXGHVIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:08:24 -0400
Date: Sun, 8 Jul 2007 23:08:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070708210809.GD5401@elf.ucw.cz>
References: <200707082046.36864.rjw@sisk.pl> <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm all for changing this infrastructure, but in an organized way (ie. we
> > discuss what to do next, we do that and then we go to the next step) and in
> > the order that everyone will be comfortable with.
> > 
> > So, let's finish this thread and start over from discussing what needs to be
> > done, how (ie. in what order etc.) we are going to do that and who is going to
> > do what.  Shall we?
> 
> IMO we should start by using the new notifier chain and by implementing 
> a central "icebox" routine.  Then we can forbid device registration 
> during suspend.
> 
> It might also be a good idea to add a freezable keventd-like workqueue 
> specifically intended for things that need to block during a suspend.  
> Although maybe this will end up being unnecessary; it's too soon to 
> tell.

We actually had patches for freezeable workqueues at one point.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
