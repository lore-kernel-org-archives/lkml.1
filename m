Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbXGDXBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbXGDXBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXGDXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:01:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34041 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758510AbXGDXBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:01:13 -0400
Date: Thu, 5 Jul 2007 01:01:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: nigel@suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070704230109.GA1770@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050834.17747.nigel@nigel.suspend2.net> <20070704224859.GC2491@elf.ucw.cz> <200707050856.25570.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707050856.25570.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > @@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char 
> > > >  
> > > >  __setup("acpi_sleep=", acpi_sleep_setup);
> > > >  
> > > > +/* Ouch, we want to delete this. We already have better version in 
> > > userspace, in 
> > > > +   s2ram from suspend.sf.net project */
> > > 
> > > Do we? This version has advantages in not requiring any userspace app and 
> in 
> > > being able to work even if you can't yet get as far as having
> > 
> > Take a look at the file. It has whitelist with just one entry, too
> > bad.
> 
> The contents of the whitelist are irrelevant. My laptop needs this 
> functionality, but I haven't bothered to send you a whitelist entry, in part 
> because I don't use s2ram.
> 
> Regardless of that, if you had read the whole comment (you've deleted half of 
> it), you would have noticed that I ended up changing my mind and instead 
> saying "Why not just delete the __setup now, or at least put it in the 
> deprecated file?"

That should be  certainly done in separate patch, right? It is on my
todolist somewhere now.

> > > > @@ -124,7 +124,7 @@ real_save_cr3:	.long 0
> > > >  real_save_cr4:	.long 0
> > > >  real_magic:	.long 0
> > > >  video_mode:	.long 0
> > > > -video_flags:	.long 0
> > > > +realmode_flags:	.long 0
> > > >  beep_flags:	.long 0
> > > >  real_efer_save_restore:	.long 0
> > > >  real_save_efer_edx: 	.long 0
> > > 
> > > Beep_flags should be removed too if you're sticking with /proc.
> > 
> > Fixed.
> 
> Ta.  But you didn't answer the question - why /proc and not sysfs?

Do you seriously advocate setting two bits of one variable from /proc,
and one more bit from /sys?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
