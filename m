Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXKZQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXKZQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbXKZQzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:55:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4030 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757516AbXKZQzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:55:43 -0500
Date: Mon, 26 Nov 2007 16:55:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Josh Goldsmith <joshin@hotmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Message-ID: <20071126165538.GB5167@ucw.cz>
References: <200711252255.lAPMtms7024172@harpo.it.uu.se> <BLU103-DAV108D2CF484C615A66784ACD6750@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU103-DAV108D2CF484C615A66784ACD6750@phx.gbl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-11-25 22:28:03, Josh Goldsmith wrote:
> Thanks for the response Mikael.
> 
> Is your 486 running a IDE disk on a normal interface or 
> via USB?  I wonder if the NSLU2 only having I/O via USB 
> might be significant.  Also, this is a 2.6 kernel and 

I'd suspect USB is significant here. Talk to Olivier Neukum (sp?),iirc
he was trying to fix swapping over usb.

							Pavel

> >I'm no VM tuning expert, but I have and still do heavy 
> >compile
> >jobs on similarly configured machines, with no OOM 
> >problems:
> >
> >I regularly build 2.6 kernels and occasionally also gcc 
> >on a
> >100MHz 486 with 28MB of RAM and perhaps 500MB of swap. 
> >It runs
> >a standard but stripped down Fedora Core 4 user-space, 
> >with ext3
> >file systems and a kernel that doesn't include anything 
> >non-essential.
> >The machine will swap madly, but the OOM killer never 
> >triggers.
> >(All system settings are FC4 defaults. I haven't 
> >touched them.)
> >
> >In the past I did a fair amount of package rebuilds and 
> >test suite
> >runs on an NSLU2 myself, with a 2.4 Linksys/Openslug 
> >kernel, ext3,
> >and a 1GB or perhaps 2GB swap partition on a disk 
> >attached via a
> >USB2-to-PATA enclosure. Even when swapping heavily the 
> >OOM killer
> >wouldn't trigger.
> >
> 
> -
> To unsubscribe from this list: send the line 
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
