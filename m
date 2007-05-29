Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXE2OPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXE2OPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXE2OPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:15:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3243 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbXE2OPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:15:07 -0400
Date: Tue, 29 May 2007 14:14:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, M Macnair <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529141456.GC5840@ucw.cz>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529131501.GA9899@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I have two embedded boards (one ARM, one PowerPC), running two
> > different versions of 2.6.  They have no hard drives, keyboards or
> > mice.  They each have a NIC, but I understand these make no
> > contribution to the entropy pool.
> > 
> > 	if [ -f $random_seed ]; then
> > 		cat $random_seed >/dev/urandom  # should seed the pool
> > 	fi
> > 	dd if=/dev/urandom of=$random_seed count=1 2>/dev/null # save some
> > data from urandom for next boot
> >
> > I have rebooted my boards many times, and after each boot I read the
> > contents of $random_seed.  Whilst it does not happen every time, the
> > contents of $random_seed are /often the same/.  To give you a feel:
> > rebooted 11 times, got a total of 3 different outputs.
> 
> Ok, so this is telling me a couple of things.  First of all, if you're
> only getting three outputs, it means that you don't have any
> peripherals feeding entropy into the system from the boot sequence.
> Without any hard drives, keyboards or mice, and a NIC whose device
> driver hasn't been configured to feed entropy, you're definitely
> hosed.

Can we get at least time-of-boot from rtc clock to the pool? We really
should not be getting identical outputs...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
