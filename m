Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbXGLTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbXGLTxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbXGLTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:53:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3310 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757644AbXGLTxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:53:08 -0400
Date: Thu, 12 Jul 2007 19:52:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: caglar@pardus.org.tr, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
Message-ID: <20070712195255.GA6015@ucw.cz>
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr> <46928066.7000705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46928066.7000705@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Your SMART log shows 309 reallocated sectors. That seems somewhat high..
> > 
> > Ah sorry to misinterpret the content:), its a quiet new piece of hardware (at 
> > most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases 
> > (currently its increased to 313) and although i'm not 100 percent sure these 
> > errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these 
> > cause according to kern.log these only visible with 2.6.22+) 
> 
> OS and driver can't really do much about the reallocation event.  Some
> number of reallocations is okay but if you it going up constantly, you
> probably have a dying disk.

Hmm... cut the power while writing is doable from OS and might force
reallocations?

You might want to check if number of reallocated sectors increases
with shutdowns/reboots.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
