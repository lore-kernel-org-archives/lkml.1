Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbXCTQDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbXCTQDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXCTQDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:03:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53199 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbXCTQDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:03:43 -0400
Date: Tue, 20 Mar 2007 17:03:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: vojtech@suse.cz, dmitry.torokhov@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange keyboard lag after suspend testing
Message-ID: <20070320160338.GC5533@elf.ucw.cz>
References: <20070320153332.GA5533@elf.ucw.cz> <20070320160006.GA14843@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320160006.GA14843@rhlx01.hs-esslingen.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
> > like someone added 50..100msec delay somewhere in keyboard
> > handling. Mouse does not seem affected. /proc/interrupts seem to
> > increase as they should, for both keyboard and mouse. Can someone
> > reproduce it? Any ideas how to debug it?
> 
> Probably just asking the obvious:
> it's not a trivial "failed to re-configure repeat rate upon resume"
> (which one could rule out by running "kbdrate" again)
> but a lag in some interrupt handler or somewhere else deeper, right?

No, it is not keyboard rate. Keyboard lags during normal typing,
sometimes letters come in groups of two or so...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
