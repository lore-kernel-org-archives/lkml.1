Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbZHENp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbZHENp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933555AbZHENp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:45:56 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50763 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbZHENp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:45:56 -0400
Date: Wed, 5 Aug 2009 15:45:52 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Ville Syrjala <syrjala@sci.fi>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] w1_gpio: switch to new dev_pm_ops
Message-ID: <20090805134552.GH13236@buzzloop.caiaq.de>
References: <1249476412-27362-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249476412-27362-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 02:46:52PM +0200, Daniel Mack wrote:
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ville Syrjala <syrjala@sci.fi>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  drivers/w1/masters/w1-gpio.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index 6f8866d..4a940fb 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -106,9 +106,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
>  
>  #ifdef CONFIG_PM
>  
> -static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
> +static int w1_gpio_suspend(struct device *dev)
>  {
> -	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
> +	struct w1_gpio_platform_data *pdata = dev_get_drvdata(dev);

That was wrong, I apologize. Will send a new version soon.

Daniel
