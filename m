Return-Path: <linux-kernel-owner+w=401wt.eu-S1765641AbXHPQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765641AbXHPQQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762994AbXHPQP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:15:58 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60890 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883AbXHPQP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:15:57 -0400
Date: Fri, 17 Aug 2007 01:14:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Make rtc-ds1553 driver hotplug-aware
Message-ID: <20070816161450.GE13927@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>, a.zummo@towertech.it,
	linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
	dbrownell@users.sourceforge.net
References: <20070817.010627.110331225.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817.010627.110331225.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 01:06:27AM +0900, Atsushi Nemoto wrote:
> Add an MODULE_ALIAS() to make this platform driver hotplug-aware.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
> index 46da571..e932024 100644
> --- a/drivers/rtc/rtc-ds1553.c
> +++ b/drivers/rtc/rtc-ds1553.c
> @@ -417,3 +417,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
>  MODULE_DESCRIPTION("Dallas DS1553 RTC driver");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(DRV_VERSION);
> +MODULE_ALIAS("ds1742");

Presumably this should be ds1553.
