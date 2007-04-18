Return-Path: <linux-kernel-owner+w=401wt.eu-S2992499AbXDRULY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992499AbXDRULY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992502AbXDRULY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:11:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54659 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992499AbXDRULX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:11:23 -0400
Date: Wed, 18 Apr 2007 22:10:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Message-ID: <20070418201036.GA2112@elf.ucw.cz>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704131022.45315.rjw@sisk.pl> <46254666.2020308@tmr.com> <Pine.LNX.4.64.0704172045100.18821@localhost.localdomain> <46265F60.4040600@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46265F60.4040600@tmr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>One reason was that there are (were?) a number of machines which only 
> >>powered
> >>down properly using apm. It was discussed as part of shutting down after 
> >>power
> >>failure when your UPS is running out of power.
> >>    
> >
> >um ... what does APM have to do with legacy PM?  two different issues,
> >no?
> >  
> Since the patches are going into apm.c and apm was used for suspend and 
> poweroff before ACPI was a feature of the hardware, I assume there's a 
> relationship. As of 2.6.9 ACPI still couldn't power down one of my
>old

There is not. The patches should not affect you unless you use obscure
68000 driver.

We are removing infrastructure that has no users.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
