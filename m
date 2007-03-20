Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXCTRUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXCTRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXCTRUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:20:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58397 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbXCTRUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:20:30 -0400
Date: Tue, 20 Mar 2007 18:20:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320172023.GA2593@elf.ucw.cz>
References: <20070320123245.GA19019@elf.ucw.cz> <200703201805.58299.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703201805.58299.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...and cause is really simple.
> > 
> > During resume, we do not know that "reboot" method was used, so we
> > assume plaform and make the led blink...
> > 
> > Unfortunately I see no easy solution, and this may/will cause other
> > problems -- in case of broken bios and user telling us not to call
> > that bios, we'll call it anyway.
> > 
> > (Ouch and I think this is regression after 2.6.20?)
> 
> I'm not sure, will check that later.
> 
> The solution would be to pass the information about the suspend mode used
> in the image header, I think (that's what uswsusp does after my recent patch).

Yes, we could do that.

OTOH, we could simply avoid calling the platform code in resume
path. It worked ok for a long while, and it seems to have no
downsides...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
