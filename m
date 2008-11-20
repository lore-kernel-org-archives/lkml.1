Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYKTKAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYKTKAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 05:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYKTKAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 05:00:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYKTKAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 05:00:00 -0500
Date: Thu, 20 Nov 2008 10:59:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2 v3] SGI RTC: add clocksource/clockevent driver and
	generic timer vector
Message-ID: <20081120095943.GF6885@elte.hu>
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119212202.GA3377@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> The following patches provide a driver for synchronized RTC 
> clocksource and clockevents for SGI systems, as well as a generic 
> timer system interrupt.
> 
> With these patches, a module can be installed that registers the 
> system-wide synchronized RTC clocksource and timers as both a 
> clocksource and clockevents device running in high resolution mode.
> 
> [PATCH 1/2 v3] SGI RTC: add clocksource driver
> [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt

Looks very clean and well-done to me.

I had to take a good look at the rtc_timer_head->expires[] construct - 
but i guess that's the best approach, as the max number of entries is 
hard to judge at build time. (and we wont get any real limit 
protection from gcc anyway)

Thomas, any objections?

	Ingo
