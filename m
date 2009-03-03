Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZCCUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZCCUZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZCCUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:25:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43800 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750711AbZCCUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:25:09 -0500
Date: Tue, 3 Mar 2009 14:25:06 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v6] SGI RTC: add clocksource driver
Message-ID: <20090303202506.GA31426@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com> <20090303151657.GC20120@sgi.com> <20090303151827.GD20120@sgi.com> <20090303152016.GE20120@sgi.com> <20090303152206.GF20120@sgi.com> <1236110492.6068.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236110492.6068.22.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 12:01:32PM -0800, john stultz wrote:
> On Tue, 2009-03-03 at 09:22 -0600, Dimitri Sivanich wrote:
> > +
> > +static struct clocksource clocksource_uv = {
> > +	.name		= RTC_NAME,
> > +	.rating		= 400,
> > +	.read		= uv_read_rtc,
> > +	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> > +	.shift		= 10,
> 
> 
> What is the expected value for sn_rtc_cycles_per_second ? 
> 
> I ask because a shift value of 10 seems a bit low. It could very well be
> appropriate, but I just wanted to check.
> 

Likely in the range of 20,000,000 - 40,000,000.
