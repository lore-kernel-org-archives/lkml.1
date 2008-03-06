Return-Path: <linux-kernel-owner+w=401wt.eu-S1765957AbYCFMAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765957AbYCFMAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760161AbYCFL7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:59:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40578 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799AbYCFL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:59:40 -0500
Date: Thu, 6 Mar 2008 11:43:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080306104334.GB1337@elf.ucw.cz>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <20080305093610.GA700@atrey.karlin.mff.cuni.cz> <20080305093923.GA2049@atrey.karlin.mff.cuni.cz> <200803052312.37996.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803052312.37996.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > > (If I try to suspend to disk, I get a rather nasty oops; goes away
> > > > with mem=3G. Related?)
> > > 
> > > The nasty oops is in swsusp_save+0x298 . 
> > > 
> > > rdx=0xffff810000001008 
> > > rdi=0xffff81000c001008
> > > rdi=0x0000000131613000
> > 
> > Rafael, this seems to be similar to some problem you were trying to
> > solve... something with numa... I could not find it in
> > bugzilla.kernel.org... do you remember details by chance?
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9966
> 
> [Just have a look at the list of regressions from 2.6.24. ;-)]

I searched that one, that's why I discovered those two
duplicates. .. unfortunately, my problem is different.

> In fact, I didn't even try to solve it myself, but asked some knwoledgeable
> people (CCed) for advice.  No one responded, unfortunately ...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
