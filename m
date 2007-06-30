Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbXGAKhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbXGAKhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 06:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbXGAKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 06:37:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53912 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755565AbXGAKhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 06:37:19 -0400
Date: Sun, 1 Jul 2007 01:03:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, michal.k.k.piotrowski@gmail.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Message-ID: <20070630230302.GA1855@elf.ucw.cz>
References: <200706300859.47133.arvidjaar@mail.ru> <200706302237.50567.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706302237.50567.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ACPI Error (event-0305): No installed handler for fixed event [00000002 
> > 20070125]
> > 
> > And SysRq was functioning.
> 
> That probably means that there's a deadlock somewhere in there.
> 
> > Unfortunately I do not have serial console so I  
> > copy manually stacks from several last screens of output; I have tried to 
> > make a photo but right now my kbluetooth is refusing to work at all so I 
> > cannot transfer them :( (but I suspect quality would be too bad anyway)
> > 
> > laptop_mode D
> > 	io_schedule+0xe/0x20
> 
> Looks suspicious to me.  Can you identify what line of code this points to?

Actually, I see laptop_mode being locked. laptop_mode does disk
spindowns, which is somehow unusual. Does it happen w/o laptop mode?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
