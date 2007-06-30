Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXF3TLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXF3TLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXF3TLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:11:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52317 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbXF3TLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:11:12 -0400
Date: Sat, 30 Jun 2007 12:11:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070630101112.GA10444@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706290827.13024.nigel@nigel.suspend2.net> <20070629223505.GB6732@elf.ucw.cz> <200706301215.20334.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706301215.20334.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> > > 
> > > Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> > > variable (I assume this is what you're thinking of), we only create cause for 
> > > confusion. A variable should for debugging or for controlling quirks, not for 
> > > both at the same time.
> > 
> > Cause for confusion? We are currently using 2 bits of that variable,
> > and we want to add one more bit. I seriously doubt that can confuse
> > anyone.
> 
> Well, indeed it would be more elegant to rename the existing flags variable
> and use another bit out of it, but I personally don't think it's _that_
> important.  At least, I don't think we should block the patch
> because of that.

It is not _that_ important.

> BTW, has anyone confirmed that it works on i386?

If you have patch somewhere nearby, I can test it on i386 and make it
use just one flags variable.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
