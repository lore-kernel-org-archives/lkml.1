Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXGDXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXGDXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXGDXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:25:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51655 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754841AbXGDXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:25:18 -0400
Date: Thu, 5 Jul 2007 01:25:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: nigel@suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070704232513.GA2695@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050856.25570.nigel@nigel.suspend2.net> <20070704230109.GA1770@elf.ucw.cz> <200707050910.21852.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707050910.21852.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > > Beep_flags should be removed too if you're sticking with /proc.
> > > > 
> > > > Fixed.
> > > 
> > > Ta.  But you didn't answer the question - why /proc and not sysfs?
> > 
> > Do you seriously advocate setting two bits of one variable from /proc,
> > and one more bit from /sys?
> 
> That's partly why I had a separate variable - retaining proc only because it's 
> existing functionality, using sysfs for the new code. Remember, too, that 

/proc is not deprecated _that_ much, and notice that this is sysctl,
not regular procfs code.

Yes, I see why you did it that way, but I also think you overdisgned
it a bit. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
