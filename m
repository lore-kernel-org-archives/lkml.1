Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXL2WuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXL2WuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXL2WuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:50:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48253 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXL2WuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:50:08 -0500
Date: Sat, 29 Dec 2007 23:48:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071229234820.GB17823@ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <200712262123.37152.oliver@neukum.org> <20071226203258.GE8094@elf.ucw.cz> <200712270015.40165.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712270015.40165.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Is there an easy way to tell if all the devices are runtime suspended?
> > > 
> > > Do you really want to know whether they are suspended or whether they
> > > could be suspended?
> > 
> > If they are suspended.
> > 
> > My plan is: let the drivers autosuspend on their own. If I see all of
> > them are autosuspended, then it looks like great time to put whole
> > system into s2ram...
> 
> Your calculation of cost/benefit will be wrong. A driver will have timeouts
> based on the cost of a suspend/resume cycle of that device only.
> You'd have to calculate of keeping the whole system awake against that.

Hmm, right. Driver probably should have chance to autosuspend but tell
the core that whole system probably should not sleep... Hmm....

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
