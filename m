Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZKJJiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZKJJiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZKJJiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:38:07 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:44141 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbZKJJiG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:38:06 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 04:38:06 EST
Date: Tue, 10 Nov 2009 10:30:54 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com
Subject: Re: [PATCH RESENT] [RTC] Add Freescale MC13783 RTC driver
Message-ID: <20091110103054.516cc03b@linux.lan.towertech.it>
In-Reply-To: <1257841967-6084-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <4AF2E9E7.9050807@epfl.ch>
	<1257841967-6084-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 09:32:47 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> +	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
> +			mc13783_rtc_update_handler, DRIVER_NAME, priv);
> +	if (ret)
> +		goto err_update_irq_request;
> +
> +	mc13783_unlock(priv->mc13783);
> +
> +	priv->rtc = rtc_device_register(pdev->name,
> +			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
> +

 isn't better to enable irqs after registration?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

