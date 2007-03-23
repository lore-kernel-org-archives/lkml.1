Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXCWM2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXCWM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422847AbXCWM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:28:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422844AbXCWM2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:28:54 -0400
Date: Fri, 23 Mar 2007 13:27:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070323122739.GA5178@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Ok, I think it's those timers again...

agreed - this seems to be a genuine CONFIG_HIGH_RES_TIMERS=y bug. (which 
has probably not been fixed since -rc4 either, we have no bugfix in this 
area that could explain the expires_next==KTIME_MAX timer state visible 
in SysRq-Q.)

there seems to be a trend in the reports: HT P4 CPUs.

>   Ingo: let me just state how *happy* I am that I told you off when 
>   you wanted to merge the hires timers and NO_HZ before 2.6.20 because 
>   they were "stable". You were wrong, and 2.6.20 is at least in 
>   reasonable shape. [...]

yes - i was quite wrong pushing it so hard. (and doubly so given your 
stated focus of making v2.6.20 a quiet release) Sorry :-/

> [...] Now we just need to make sure that 2.6.21 will be too.. ]

yeah - we are working hard on it.

	Ingo
