Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGTTJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGTTJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZGTTJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:09:00 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:41332 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZGTTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:08:59 -0400
Date: Mon, 20 Jul 2009 22:08:53 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: balajitk@ti.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC][PATCH 2/4] OMAP4: PMIC: Add support for twl6030 RTC
Message-ID: <20090720190852.GF7984@gandalf>
Reply-To: me@felipebalbi.com
References: <1248097007-14699-1-git-send-email-balajitk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248097007-14699-1-git-send-email-balajitk@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Mon, Jul 20, 2009 at 07:06:47PM +0530, balajitk@ti.com wrote:
> @@ -257,15 +257,15 @@ config RTC_DRV_TWL92330
>  	  platforms. The support is integrated with the rest of
>  	  the Menelaus driver; it's not separate module.
>  
> -config RTC_DRV_TWL4030
> -	tristate "TI TWL4030/TWL5030/TPS659x0"
> -	depends on RTC_CLASS && TWL4030_CORE
> +config RTC_DRV_TWL
> +	tristate "TI TWL4030/TWL5030/TWL6030/TPS659x0"
> +	depends on RTC_CLASS && (TWL4030_CORE || TWL6030_CORE)
>  	help
>  	  If you say yes here you get support for the RTC on the
>  	  TWL4030 family chips, used mostly with OMAP3 platforms.
>  
>  	  This driver can also be built as a module. If so, the module
> -	  will be called rtc-twl4030.
> +	  will be called twl-rtc.

no renaming and still wrong, the driver will be called rtc-twl, not
twl-rtc.

anyways, keep the old name

-- 
balbi
