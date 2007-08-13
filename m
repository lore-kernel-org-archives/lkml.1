Return-Path: <linux-kernel-owner+w=401wt.eu-S967542AbXHMPwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967542AbXHMPwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030643AbXHMOOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:14:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51855 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946505AbXHMOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:14:01 -0400
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 10:14:00 EDT
Date: Mon, 13 Aug 2007 15:46:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Cc: andrea@suse.de, npiggin@suse.de, peterz@infradead.org
Subject: min_free_kbytes documentation, /proc/sys/vm docs
Message-ID: <20070813134626.GA7305@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

min_free_kbytes documentation says:

min_free_kbytes:

This is used to force the Linux VM to keep a minimum number 
of kilobytes free.  The VM uses this number to compute a pages_min
value for each lowmem zone in the system.  Each lowmem zone gets 
a number of reserved free pages based proportionally on its size.

...which is not too helpful :-(. In particular, should kernel survive
setting this to 0 and still work reliably? IOW is this
performance-only tweak, or does it correctness implications?

I guess it should also say something like "do not set this to more
than half of your physical RAM (or half of lowmem?) or you get an
instant OOM".

Plus, lowmem_reserve_ratio seems to be undocumented.
									Pavel
			(trying to come up with agressive settings, so
			that swap over ata over ethernet finally breaks).
			
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
