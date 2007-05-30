Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbXE3PoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbXE3PoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXE3Pn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:43:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4170 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753057AbXE3Pn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:43:56 -0400
Date: Wed, 30 May 2007 15:43:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070530154345.GB4772@ucw.cz>
References: <1180059605.3997.100.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> <1180062040.3997.112.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org> <1180067587.3997.136.camel@nigel.suspend2.net> <465C366C.2070900@rtr.ca> <1180473765.20718.47.camel@nigel.suspend2.net> <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org> <20070530114920.GB26326@elf.ucw.cz> <20070530124027.GA27942@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530124027.GA27942@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (Trimmed the Cc:s quite heavily - I think this has gone somewhere beyond 
> the original point)
> 
> > Notice that we want to be able to suspend while hibernating -- for
> > suspend to both behaviour. So drivers may _not_ rely on system being
> > runnable.
> 
> So keep the driver layers read-only and unfreeze the processes after 
> doing the atomic copy.

To read firmware you probably need to _write_ atimes.

Anyway, make-disks-read-only patch would be welcome. I just think it
is going to be more complex than freezer.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
