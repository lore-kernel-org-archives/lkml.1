Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYJVGgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYJVGgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVGgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:36:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJVGgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:36:35 -0400
Date: Wed, 22 Oct 2008 08:36:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] SGI RTC: add clocksource/clockevent driver and
	timer bios calls
Message-ID: <20081022063613.GH651@elte.hu>
References: <20081021211740.GA3936@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021211740.GA3936@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> The following patchset provides a driver and bios call framework for
> synchronized RTC clocksource and clockevents for SGI systems.
> 
> With these patches, a module can be installed that registers the system-wide
> synchronized RTC clocksource and timers as both a clocksource and clockevents
> device running in high resolution mode.
> 
> 
> [PATCH 1/3] SGI RTC: add clocksource driver
> [PATCH 2/3] SGI RTC: add bios framework for RTC timer operations
> [PATCH 3/3] SGI RTC: add RTC system interrupt

hm, i dont really like the direction of this.

Why isnt there a native Linux driver offered for this? This isnt about 
memory discovery or device discovery, where BIOS interaction might be 
acceptable (and might be unavoidable). This is about hardware interfaces 
and drivers, and the last thing we want there is BIOSes.

	Ingo
