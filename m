Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbXCJCOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbXCJCOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXCJCOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:14:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:35983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbXCJCOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:14:54 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/misc/asus-laptop.c: make code static
Date: Fri, 9 Mar 2007 21:07:07 -0500
User-Agent: KMail/1.9.5
Cc: Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
References: <20070220000725.GT13958@stusta.de>
In-Reply-To: <20070220000725.GT13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092107.07380.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Monday 19 February 2007 19:07, Adrian Bunk wrote:
> This patch makes some needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.20-mm1/drivers/misc/asus-laptop.c.old	2007-02-18 01:06:30.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/misc/asus-laptop.c	2007-02-18 01:06:43.000000000 +0100
> @@ -211,7 +211,7 @@
>  				     enum led_brightness value);	\
>  	static void object##_led_update(struct work_struct *ignored);	\
>  	static int object##_led_wk;					\
> -	DECLARE_WORK(object##_led_work, object##_led_update);		\
> +	static DECLARE_WORK(object##_led_work, object##_led_update);	\
>  	static struct led_classdev object##_led = {			\
>  		.name           = "asus:" ledname,			\
>  		.brightness_set = object##_led_set,			\
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
