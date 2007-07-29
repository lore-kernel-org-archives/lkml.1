Return-Path: <linux-kernel-owner+w=401wt.eu-S1764445AbXG2QVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764445AbXG2QVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762701AbXG2QVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:21:10 -0400
Received: from smtp2.versatel.nl ([62.58.50.89]:41103 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762813AbXG2QVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:21:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 12:21:09 EDT
Message-ID: <46ACBB8E.9080302@hhs.nl>
Date: Sun, 29 Jul 2007 18:08:46 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [2.6 patch] make abituguru3_read_increment_offset()
 static
References: <20070729145701.GJ16817@stusta.de>
In-Reply-To: <20070729145701.GJ16817@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> abituguru3_read_increment_offset() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Looks good, good catch.

Acked-by: Hans de Goede <j.w.r.degoede@hhs.nl>

> 
> ---
> --- linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c.old	2007-07-26 08:56:33.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c	2007-07-26 08:57:00.000000000 +0200
> @@ -691,8 +691,9 @@
>  
>  /* Sensor settings are stored 1 byte per offset with the bytes
>     placed add consecutive offsets. */
> -int abituguru3_read_increment_offset(struct abituguru3_data *data, u8 bank,
> -	u8 offset, u8 count, u8 *buf, int offset_count)
> +static int abituguru3_read_increment_offset(struct abituguru3_data *data,
> +					    u8 bank, u8 offset, u8 count,
> +					    u8 *buf, int offset_count)
>  {
>  	int i, x;
>  
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 

