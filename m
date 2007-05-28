Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbXE1NGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbXE1NGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXE1NG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:06:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43337 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754104AbXE1NG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:06:28 -0400
Date: Mon, 28 May 2007 15:06:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Message-ID: <20070528130613.GN18807@elf.ucw.cz>
References: <1180008394.15600.26.camel@localhost> <20070527184402.GA21161@srcf.ucam.org> <20070528010506.GA24186@srcf.ucam.org> <200705281011.17338.rjw@sisk.pl> <20070528121056.GA29143@srcf.ucam.org> <20070528125507.GI18807@elf.ucw.cz> <20070528130343.GB29738@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528130343.GB29738@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, PPC people are aware of this, and they think they can fix the
> > drivers. We probably want to drop the freezer for suspend long-term,
> > so. PPC machines use small subset of all the drivers, so it apparently
> > is not big problem for them.
> 
> I'm fairly certain that PPC uses USB. In any case, it's not limited to 
> PPC - APM has the same issue. Any driver that assumes processes will be 
> frozen during suspend to RAM is broken now, not the future.

Yup, that's a possible view. Fixes welcome.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
