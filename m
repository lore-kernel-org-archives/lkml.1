Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbXCEVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbXCEVib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXCEViE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:38:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4530 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933636AbXCEViC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:38:02 -0500
Date: Tue, 1 Jan 2002 03:05:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH (updated)] timer: Run calc_load halfway through each round_jiffies second
Message-ID: <20020101030506.GB4106@ucw.cz>
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk> <45E75911.3070907@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E75911.3070907@simon.arlott.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Whenever jiffies is started at a multiple of 5*HZ or 
> wraps, calc_load is run exactly on the second which is 
> when tasks using round_jiffies will be scheduled to run. 
> This has a bad effect on the load average, making it 
> tend towards 1.00 if a task happens to run every time 
> the load is being calculated.
> 
> This changes calc_load so that it updates load half a 
> second after any tasks scheduled using round_jiffies.

Hmm, otoh this makes calc_load more expensive, power-wise, because it
needs to wake the cpu once more?

Timetraveling, sorry.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
