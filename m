Return-Path: <linux-kernel-owner+w=401wt.eu-S1752006AbXCTWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbXCTWKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXCTWKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:10:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52436 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752006AbXCTWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:10:38 -0400
Date: Tue, 20 Mar 2007 23:10:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320221032.GM3545@elf.ucw.cz>
References: <20070320123245.GA19019@elf.ucw.cz> <200703201805.58299.rjw@sisk.pl> <20070320172023.GA2593@elf.ucw.cz> <200703202203.27009.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202203.27009.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, we could do that.
> > 
> > OTOH, we could simply avoid calling the platform code in resume
> > path. It worked ok for a long while, and it seems to have no
> > downsides...
> 
> No, we have always done it, actually, but not in this particular place. ;-)
> 
> In theory, avoiding it could be problematic, because of the pm_ops->finish()
> that gets called after the image has been restored (if the platform mode was
> used for suspending).  Still, I think we can try.

If we can return to the method "how we did it in 2.6.20", that would
indeed be preffered ;-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
