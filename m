Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYLEWKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYLEWKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYLEWJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:09:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43207 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbYLEWJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:09:57 -0500
Subject: Re: [PATCH 2/2 v4] SGI RTC: add clocksource driver
From: john stultz <johnstul@us.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081124195810.GB8387@sgi.com>
References: <20081124195405.GA8339@sgi.com> <20081124195617.GA8387@sgi.com>
	 <20081124195810.GB8387@sgi.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 14:09:53 -0800
Message-Id: <1228514994.21144.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 13:58 -0600, Dimitri Sivanich wrote:
> This patch provides a driver for SGI RTC clocks and timers.
> 
> This provides a high resolution clock and timer source using the SGI
> system-wide synchronized RTC clock/timer hardware.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Changed the shift values for clocksource and clockevent.
> Made other stylistic changes.
> 
[snip]
> +static struct clocksource clocksource_uv = {
> +	.name		= RTC_NAME,
> +	.rating		= 400,
> +	.read		= uv_read_rtc,
> +	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> +	.shift		= 10,
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +};

Hey Dimitri, 
	Sorry for being slow to catch this. This address my earlier concerns.
Thanks!

Acked-by: John Stultz <johnstul@us.ibm.com>

-john

