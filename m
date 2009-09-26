Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZIZO4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZIZO4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZIZO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:56:07 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:56166 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZIZO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XGUg8efVtgM787A76F6zCvH7d93vQTRqBRcas66jp5eTYPrUbSmxdfsjH6KvyTDyNr
         9xhryaUAC06KLEembakZxJBFNkfjAL92NTV013SW3mYO/FRucB9ffosUD0La2KQENAtv
         AoGI6wfJdyEZqDI86hDf2WdntWTT80pxoWo5Q=
Date: Sat, 26 Sep 2009 18:55:36 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
       cbou@mail.ru
Subject: Re: something wrong in drivers/power
Message-ID: <20090926145536.GA8445@doriath.ww600.siemens.net>
References: <20090926095555.GG1331@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926095555.GG1331@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:55:55AM +0200, Pavel Machek wrote:
> 
> Tosa battery driver seems to be confused about its own identity.

NAK. Please see the drivers/input/touchscree/wm97xx-core.c

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff -ur power.ofic/tosa_battery.c power/tosa_battery.c
> --- linux/drivers/power.ofic/tosa_battery.c	2009-09-06 08:56:36.000000000 +0200
> +++ linux/drivers/power/tosa_battery.c	2009-09-15 15:14:08.000000000 +0200
> @@ -459,7 +459,7 @@
>  }
>  
>  static struct platform_driver tosa_bat_driver = {
> -	.driver.name	= "wm97xx-battery",
> +	.driver.name	= "tosa-battery",
>  	.driver.owner	= THIS_MODULE,
>  	.probe		= tosa_bat_probe,
>  	.remove		= __devexit_p(tosa_bat_remove),
> @@ -483,4 +483,4 @@
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Dmitry Baryshkov");
>  MODULE_DESCRIPTION("Tosa battery driver");
> -MODULE_ALIAS("platform:wm97xx-battery");
> +MODULE_ALIAS("platform:tosa-battery");
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
With best wishes
Dmitry

