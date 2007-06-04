Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXFDLCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXFDLCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXFDLCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:02:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59905 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751795AbXFDLCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:02:15 -0400
Date: Mon, 4 Jun 2007 13:02:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070604110209.GJ4363@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com> <1180392482.4149.15.camel@nigel.suspend2.net> <20070529112952.GA23046@elf.ucw.cz> <200705291403.09773.rjw@sisk.pl> <20070529124052.GH23046@elf.ucw.cz> <1180444425.20718.33.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180444425.20718.33.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > They are already.
> > 
> > ...but will that place still be safe when we use other version of
> > kernel?
> 
> They'll be in the image too, won't they? Failing that, the information
> could be stored in the image header.
> 
> > Anyway, pagedirs are on the safe place, right? That means that we
> > swsusp should no longer clash with page allocation debugging... 
> 
> You mean DEBUG_PAGEALLOC? That can be overcome easily - I have code in
> current Suspend2 that works with DEBUG_PAGEALLOC. I handle the page
> fault, mapping the page and setting a flag in the fault handler to tell
> the atomic copy code to unmap the page again once it has been copied.

I meant debug_pagealloc, but no, I do not think we want to make page
fault handler more complex. Switching to 1:1 mapping tables should be
enough.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
