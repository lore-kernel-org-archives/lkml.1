Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXE2NFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXE2NFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXE2NF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:05:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34594 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbXE2NF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:05:27 -0400
Date: Tue, 29 May 2007 15:04:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070529130459.GJ23046@elf.ucw.cz>
References: <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070527155738.GA20006@srcf.ucam.org> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> <20070528100448.GB18276@elf.ucw.cz> <alpine.LFD.0.98.0705280935560.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705280935560.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I guess we should warn the driver authors, then; and decide what driver 
> > authors should do.
> 
> Drivers really shouldn't do anythign at all.

*)

> > If I'm video4linux driver for grabbing screen, have been suspended, and 
> > someone asks me to read a frame, should I
> > 
> > a) return -ESORRYIMSUSPENDED
> > 
> > b) just block the caller
> 
> The "subsystem" thing should have stopped the queues, and the device 
> should never even _see_ this.

Okay, _if_ there's a subsystem, subsystem should have stopped the
queues. End result should be that userspace is blocked when trying to
access suspended device/suspended subsystem.

I guess we are in violent agreement.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
