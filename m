Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYCIJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYCIJYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYCIJYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 05:24:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4471 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752475AbYCIJX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 05:23:29 -0400
Date: Sun, 9 Mar 2008 00:36:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080308233604.GA3866@ucw.cz>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307085341.GA23814@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Presumably any hw issues would get noticed (like missing interrupt) 
> > > and trigger the error handler, so it looks like this IO is still 
> > > stuck in the queue somewhere. That mainly points the finger at AS, 
> > > but given that you cannot reproduce I'm not sure how best to proceed 
> > > with this...
> > 
> > me neither... just wanted to give notice that something's brewing in 
> > this area. Will know more after tonight's qa series i guess, if it 
> > gets above 100 bootups ;-)
> 
> no luck - a few hundred successful randconfig bootups overnight (with a 
> rather complex userspace startup to full X plus networking, and the 
> testbox is used via the network to compile the next random kernel as 
> well - etc.) and no failure at all. So there's not much we can do at 
> this point - i'll keep you updated if anything new happens in the tests.

How many machines are there in your test farm? Would it be possible to
make the neccessary scripts available somewhere? I guess I could make
one or two machines do some automated testing...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
