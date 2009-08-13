Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZHMPGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZHMPGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZHMPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:06:12 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58720 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZHMPGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:06:11 -0400
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h in davinci_wdt.c
References: <20090807203939.GA19374@pengutronix.de>
	<1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de>
	<20090809094306.GA26591@n2100.arm.linux.org.uk>
	<87iqgvk43c.fsf@deeprootsystems.com>
	<20090810172637.GC27147@n2100.arm.linux.org.uk>
	<87zla7fkio.fsf@deeprootsystems.com>
	<20090810220234.GD27147@n2100.arm.linux.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 13 Aug 2009 08:06:09 -0700
In-Reply-To: <20090810220234.GD27147@n2100.arm.linux.org.uk> (Russell King's message of "Mon\, 10 Aug 2009 23\:02\:34 +0100")
Message-ID: <87zla3hhy6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Mon, Aug 10, 2009 at 02:04:31PM -0700, Kevin Hilman wrote:
>> @@ -86,6 +88,9 @@ static void wdt_enable(void)
>>  {
>>  	u32 tgcr;
>>  	u32 timer_margin;
>> +	u32 wdt_freq;
>> +
>> +	wdt_freq = clk_get_rate(wdt_clk);
>
> Much better - and only a minor nit which doesn't deserve a repost -
> wdt_freq should probably match the return type of clk_get_rate.  IOW
> unsigned long.

Wim,

If you're OK with this, can you queue this one for 2.6.32?

Thanks,

Kevin
