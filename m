Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIEUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIEUpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 16:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZIEUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 16:45:43 -0400
Received: from ru.mvista.com ([213.79.90.228]:13298 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbZIEUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 16:45:43 -0400
Date: Sun, 6 Sep 2009 00:45:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power_supply: Add driver for the PMU on WM831x PMICs
Message-ID: <20090905204543.GA27681@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1252155965-9755-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1252155965-9755-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 02:06:05PM +0100, Mark Brown wrote:
[...]
> I'm fairly sure Anton said that he'd applied it previously but it
> doesn't appear to have shown up in -next yet so I'm resending it.

It's in battery-2.6.git since Friday, -next tree lags a
little bit.

http://git.infradead.org/battery-2.6.git

> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index bdbc4f7..343194c 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -29,6 +29,13 @@ config APM_POWER
>  	  Say Y here to enable support APM status emulation using
>  	  battery class devices.
>  
> +config WM831X_POWER
> +        tristate "WM831X PMU support"
> +        depends on MFD_WM831X
> +        help
> +          Say Y here to enable support for the power management unit
> +	  provided by Wolfson Microelectronics WM831x PMICs.

FYI, I fixed whitespaces vs. tabs issue here. ;-)

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
