Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbXE0VAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbXE0VAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbXE0VA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:00:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2053 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754824AbXE0VA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:00:26 -0400
Date: Sun, 27 May 2007 20:35:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Message-ID: <20070527203549.GD3989@ucw.cz>
References: <200705261128.57332.maxi@daemonizer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705261128.57332.maxi@daemonizer.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When I try software suspend on my laptop it always returns to my running 
> system after some time.
> This is what's logged by the kernel:
> 
> swsusp: Basic memory bitmaps created
> Stopping tasks ... 
> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to 
> freeze):
>  cryptd
> Restarting tasks ... done.

Is cryptd a kernel thread? It is probably missing try_to_freeze(). If
it is userland app, try stopping it before suspend.

							Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
