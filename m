Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbXJTJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbXJTJa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXJTJ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 05:29:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2144 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752707AbXJTJ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:29:48 -0400
Date: Thu, 18 Oct 2007 20:05:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
Message-ID: <20071018200531.GB6962@ucw.cz>
References: <4712786B.3040009@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712786B.3040009@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Since upgrading to 2.6.23.1 from 2.6.23-rc9, 
> resume-from-RAM has been misbehaving here.
> 
> It takes much (+5-7 seconds) longer to resume 
> *sometimes*, but not all/most of the time.
> And sometimes I get get flashing keyboard LEDs and have 
> to hold the power button
> in for a full hard reset.
> 
> With 2.6.23-rc8/rc9, no such troubles.
> 
> Difficult to reproduce, other than perhaps once a day.
> Anybody want to fess up with a likely candidate?

Are there any .config differences between rc8 and .1?

Can you try disabling nohz?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
