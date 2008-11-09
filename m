Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYKILgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYKILgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYKILgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:36:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42692 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYKILgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:36:00 -0500
Date: Sun, 9 Nov 2008 12:37:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Message-ID: <20081109113736.GE6094@elf.ucw.cz>
References: <200811081353.34442.rjw@sisk.pl> <20081108125952.GB21405@elf.ucw.cz> <200811081412.21736.rjw@sisk.pl> <20081108215458.1799896b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108215458.1799896b.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-08 21:54:58, Andrew Morton wrote:
> On Sat, 8 Nov 2008 14:12:21 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, 8 of November 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > This would be good to have in .28 IMO.
> > > 
> > > Actually, this makes sense even for .27-stable, AFAICT.
> > 
> > Yes, it does, but it has to be merged first. :-)
> 
> It applies to 2.6.26 (at least).  Is there no need for it in kernels
> earlier than 2.6.27.x?

It would be nice to fix it there, too. (OTOH that config never worked
and we did not see huge pile of complains, so I guess the world would
not fall down if it was not in 2.6.26...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
