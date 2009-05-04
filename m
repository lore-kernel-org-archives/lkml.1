Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZEDJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZEDJa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZEDJaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:30:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43367 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZEDJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:30:09 -0400
Date: Mon, 4 May 2009 11:33:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] PM: Drop shrink_all_memory (rev. 2) (was: Re:
	[PATCH 3/3] PM/Hibernate: Use memory allocations to free memory)
Message-ID: <20090504093310.GC30306@elf.ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905030220.57933.rjw@sisk.pl> <20090503130818.GC9661@localhost> <200905031830.49690.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905031830.49690.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I know that swsusp_shrink_memory() has problems, that's why I'd like to get rid
> of it.
> 
> > I wonder if it's possible to free up the memory within 1s at all.
> 
> I'm not sure.
> 
> Apparently, the counting of saveable pages takes substantial time (0.5 s each
> iteration on my 64-bit test box), so we can improve that by limiting the number
> of iterations.

We could increase step size after each step. Free in 40MB step, then
80MB step, then 160MB step, ...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
