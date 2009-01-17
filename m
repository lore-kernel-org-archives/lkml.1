Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbZAQQVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbZAQQVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZAQQUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:20:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:39605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZAQQUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:20:53 -0500
Subject: Re: [PATCH] leds: Fix bounds checking of wm8350->pmic.led
From: Liam Girdwood <lrg@kernel.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: rpurdie@rpsys.net, broonie@opensource.wolfsonmicro.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4971F400.4070701@gmail.com>
References: <4971F400.4070701@gmail.com>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 16:20:34 +0000
Message-Id: <1232209234.16911.30.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 16:06 +0100, Roel Kluin wrote:
> Fix bounds checking of wm8350->pmic.led
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 7aa3524..5056e23 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1435,7 +1435,7 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
>  	struct platform_device *pdev;
>  	int ret;
>  
> -	if (lednum > ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
> +	if (lednum >= ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
>  		dev_err(wm8350->dev, "Invalid LED index %d\n", lednum);
>  		return -ENODEV;
>  	}
> --

Applied.

Thanks

Liam

