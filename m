Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXBKXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXBKXVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932570AbXBKXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:21:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60299 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932566AbXBKXVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:21:31 -0500
Date: Mon, 12 Feb 2007 00:21:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211232105.GG15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <20070211194202.GC15445@elf.ucw.cz> <20070211210258.0b8da53c@localhost.localdomain> <1171235428.4493.105.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171235428.4493.105.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > define .suspend that will always return -ENOSYS (then people will know they
> > > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > > whether or not the device requires .suspend and .resume, define .suspend that
> > > > will always return -ENOSYS."
> > > 
> > > Sounds ok to me. Where should this text go?
> > > Documentation/SubmittingDrivers ?
> > 
> > And testing/submitting drivers, perhaps with additional text in that to
> > make it clear we want suspend/resume support or good excuses
> > 
> > "Please verify your driver correctly handles suspend and resume. If it
> > does not your patch submission is likely to be suspended and only resume
> > when the driver correctly handles this feature"
> 
> Maybe make it explicit that testing should be done for both suspend to
> ram and to disk, and with the following usage scenarios as
 > applicable?

Well, for many people s2ram does not work even today... so requiring
them to test it is slightly draconian.

> - built in;
> - modular, loaded while suspending but not loaded prior to resume from
> disk;

These two should be equivalent.

> - modular, loaded while suspending and loaded prior to resume from disk;

Ok.. but I'm not sure how many people will actually test it _that_
thoroughly. "Try to test it" is good enough for a first version. When
suspend is in better shape, we can ask for more.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
