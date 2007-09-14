Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbXINMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbXINMT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXINMTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:19:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38576 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXINMTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:19:51 -0400
Date: Fri, 14 Sep 2007 14:20:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix failure to resume from initrds
Message-ID: <20070914122018.GA1671@elf.ucw.cz>
References: <200709141422.18788.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141422.18788.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Nigel Cunningham <nigel@nigel.suspend2.net>
> 
> Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel threads
> nonfreezable by default) breaks freezing when attempting to resume from an
> initrd, because the init (which is freezeable) spins while waiting for another
> thread to run /linuxrc, but doesn't check whether it has been told to enter
> the refrigerator. The original patch replaced a call to try_to_freeze() with a
> call to yield(). I believe a simple reversion is wrong because
> if !CONFIG_PM_SLEEP, try_to_freeze() is a noop. It should still yield.
> 
> Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
