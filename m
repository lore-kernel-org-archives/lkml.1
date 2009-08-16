Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZHPOIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZHPOIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZHPOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:08:51 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:48336 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbZHPOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:08:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOquh0pR9cbZ/2dsb2JhbADRPwmEEAWCKQ
Date: Sun, 16 Aug 2009 16:08:50 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h
	in davinci_wdt.c
Message-ID: <20090816140850.GP4302@infomag.iguana.be>
References: <20090807203939.GA19374@pengutronix.de> <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de> <1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de> <20090809094306.GA26591@n2100.arm.linux.org.uk> <87iqgvk43c.fsf@deeprootsystems.com> <20090810172637.GC27147@n2100.arm.linux.org.uk> <87zla7fkio.fsf@deeprootsystems.com> <20090810220234.GD27147@n2100.arm.linux.org.uk> <87zla3hhy6.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zla3hhy6.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> > On Mon, Aug 10, 2009 at 02:04:31PM -0700, Kevin Hilman wrote:
> >> @@ -86,6 +88,9 @@ static void wdt_enable(void)
> >>  {
> >>  	u32 tgcr;
> >>  	u32 timer_margin;
> >> +	u32 wdt_freq;
> >> +
> >> +	wdt_freq = clk_get_rate(wdt_clk);
> >
> > Much better - and only a minor nit which doesn't deserve a repost -
> > wdt_freq should probably match the return type of clk_get_rate.  IOW
> > unsigned long.
> 
> Wim,
> 
> If you're OK with this, can you queue this one for 2.6.32?

I'm also OK with this. I'll queue it up in my -next tree today or tomorrow.

Kind regards,
Wim.

