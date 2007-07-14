Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXGNXVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXGNXVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbXGNXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:20:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:48273 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753838AbXGNXU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:20:57 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19DoMhxYutDzNI279/ic8MTJBox+GOPq73DwBNYP5
	+gaE7JRIUhNzn0
Date: Sun, 15 Jul 2007 01:21:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trilok Soni <soni.trilok@gmail.com>
cc: i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       amit.kucheria@gmail.com, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [i2c] OMAP: Add TI TWL92330/Menelaus Power Management chip driver
In-Reply-To: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
Message-ID: <Pine.LNX.4.60.0707150104050.12464@poirot.grange>
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Trilok Soni wrote:

> Hi Jean/Andrew,
> 
> Attached patch adds Texas Instruments TWL92330/Menelaus Power
> Management chip driver. Also includes RTC code in the same driver
> instead of the separate module. Here is the description of
> driver/commit message :)

I think, the plan is to eventually merge the power_supply class currently 
in -mm, so, it would be nice to interface menelaus to it?

Thanks
Guennadi

> 
> =============
>   OMAP: Add TI TWL92330/Menelaus Power Management chip driver
> 
>   Add Texas Instruments TWL92330/Menelaus Power Management chip driver.
>   This includes voltage regulators, Dual slot memory card tranceivers and
>   real-time clock(RTC).
> 
>   The support for RTC is integrated with this driver only; it is not separate
>   module. Passes 'rtctest' on OMAP H4 EVM, other than lack of
>   "periodic" (1/N second) IRQs. System wakeup alarms (from suspend-to-RAM)
>   work too.
> 
>   The battery keeps the RTC active over power off, so once you set clock
>   (rdate/ntpdate/etc, then "hwclock -w") then RTC_HCTOSYS at boot time
>   will behave as expected.
> 
> =============
> 
> RTC part was reviewed and acked-by RTC maintainer. CCing to lkml and
> MMC maintainer this time.
> 
> -- 
> --Trilok Soni
> 

---
Guennadi Liakhovetski
