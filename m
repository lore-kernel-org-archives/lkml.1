Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXFLVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXFLVcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXFLVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:32:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53658 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbXFLVcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:32:12 -0400
Date: Tue, 12 Jun 2007 23:31:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070612213159.GB13747@elf.ucw.cz>
References: <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070610184348.GA4417@ucw.cz> <466EDF24.2000806@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EDF24.2000806@dgreaves.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>cu:~# mount -oremount,ro /huge
> >>cu:~# /usr/net/bin/hibernate
> >>[this works and resumes]
> >>
> >>cu:~# mount -oremount,rw /huge
> >>cu:~# /usr/net/bin/hibernate
> >>[this works and resumes too !]
> >>
> >>cu:~# touch /huge/tst
> >>cu:~# /usr/net/bin/hibernate
> >>[but this doesn't even hibernate]
> >
> >This is very probably separate problem... and you should have enough
> >data in dmesg to do something with it.
> 
> What makes you say it's a different problem - it's hanging at the same 
> point visually - it's just that one is pre suspend, one is post suspend.

Ok, I did not see the visuals.

> It all feels very related to me - the behaviour all hinges around the same 
> patch too.
> 
> I'll take a look in dmesg though...
> 
> David
> 
> PS, looks like some mail holdups somewhere...
> Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
> 	by mail.ukfsn.org (Postfix) with ESMTP id A9125E6AE9
> 	for <david@dgreaves.com>; Tue, 12 Jun 2007 15:41:23 +0100 (BST)
> Received: by spitz.ucw.cz (Postfix, from userid 0)
> 	id E05FC279F2; Sun, 10 Jun 2007 18:43:48 +0000 (UTC)
> Date: Sun, 10 Jun 2007 18:43:48 +0000

Yep, that's normal, spitz is 0.3kg machine connected over gprs. Okay,
I should probably try to sync it more often than once in two days.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
