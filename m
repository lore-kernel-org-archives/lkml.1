Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXEXWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXEXWSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXEXWSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:18:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38893 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbXEXWSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:18:03 -0400
Date: Fri, 25 May 2007 00:17:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Romano Giannetti <romanol@upcomillas.es>,
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
Message-ID: <20070524221743.GD9604@elf.ucw.cz>
References: <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-05-24 15:10:29, Linus Torvalds wrote:
> 
> 
> On Fri, 25 May 2007, Pavel Machek wrote:
> > > 
> > > Equally arguably, we should just have a "resume_late()" call that can be 
> > > used to do this after everything is up and running.
> > 
> > Yes, we can do that. But userland will see devices "not there" for a
> > few seconds after boot.
> 
> No they won't.
> 
> Why the HELL cannot you realize that kernel threads are different?

Ugh? We are talking about request_firmware() here, right? That's
calling userland helper to load the firmware...? Looks like USER
thread to me.
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
