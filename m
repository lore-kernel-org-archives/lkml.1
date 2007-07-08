Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbXGHNAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbXGHNAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXGHNA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:00:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4559 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751163AbXGHNA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:00:26 -0400
Date: Sun, 8 Jul 2007 12:53:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matt Mackall <mpm@selenic.com>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Message-ID: <20070708125332.GA4229@ucw.cz>
References: <200706262021.51410.mb@bu3sch.de> <20070626224517.GG11115@waste.org> <20070627024856.GB5491@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627024856.GB5491@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Instead of papering over the problem with borked solutions, maybe we should
> just export ALL HRNGs to userspace.  While at it, please add whatever is
> needed so that userspace can talk to the kernel driver to get vital
> information about the HRNG device the driver might have (the current
> interface is a bad simplistic hack).
> 
> Let userspace get the data from whichever HRNG it wants, process it in any
> way it wants and pipe it back through /dev/random IOCTLs.  And let it do it
> for as many HRNGs it wants at the same time.

Hmm.... xor all available HRNGs together? That way you have random
data if you have at least one goot HRNG in your system :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
