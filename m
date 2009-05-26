Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZEZInY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZEZInY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZEZInQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:43:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56916 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZEZInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:43:15 -0400
Date: Tue, 26 May 2009 10:43:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: nigel@tuxonice.net, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090526084313.GB29563@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090525123228.GA13446@elf.ucw.cz> <1243287557.16743.114.camel@nigel-laptop> <200905260029.25847.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905260029.25847.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-05-26 00:29:24, Oliver Neukum wrote:
> Am Montag, 25. Mai 2009 23:39:17 schrieb Nigel Cunningham:
> > > If there's not enough swap available, swsusp should freeze, realize
> > > there's no swap, unfreeze and continue. I do not see reliability
> > > problem there.
> >
> > If there's not enough storage available (I'm also thinking of the file
> > allocator Oliver wants), freeing some memory may get you in a position
> 
> No, I do want a dedicated partition. Going to a filesystem is just hiding
> the problem. Filesystems can return -ENOSPC.
> I also want my sytem to reliably hibernate if the filesystem to hold
> the image happens to be remounted ro or to be undergoing a filesystem
> check.
> 
> For full reliability you simply need a reservation. In addition that's
> the fastest solution, too. A simple linear write to an unfragmented
> area.
> The typical system today has three orders of magnitude more disk
> than ram. Do you really have a sytem you want to hibernate that has
> less than 2two orders of magnitude more disk than ram?

My x60 has 60GB disk and 2GB ram. And yes, I'd prefer not to waste 2GB
of disk space...

Yes, linear write is faster, but it the difference will be lost in noise.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
