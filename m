Return-Path: <linux-kernel-owner+w=401wt.eu-S932546Ab0AGITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0AGITf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422Ab0AGITe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:19:34 -0500
Received: from compulab.co.il ([67.18.134.219]:58643 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab0AGITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:19:33 -0500
Message-ID: <4B459910.7040106@compulab.co.il>
Date: Thu, 07 Jan 2010 10:19:28 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Stefan Weil <weil@mail.berlios.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] da9030_battery: Fix spelling in comment
References: <1262818823-16532-1-git-send-email-weil@mail.berlios.de>
In-Reply-To: <1262818823-16532-1-git-send-email-weil@mail.berlios.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Weil wrote:
> platfrom -> platform
> monotor -> monitor
> 
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/power/da9030_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Mike Rapoport <mike@compulab.co.il>

> diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
> index 3364198..a2e71f7 100644
> --- a/drivers/power/da9030_battery.c
> +++ b/drivers/power/da9030_battery.c
> @@ -509,7 +509,7 @@ static int da9030_battery_probe(struct platform_device *pdev)
>  
>  	charger->master = pdev->dev.parent;
>  
> -	/* 10 seconds between monotor runs unless platfrom defines other
> +	/* 10 seconds between monitor runs unless platform defines other
>  	   interval */
>  	charger->interval = msecs_to_jiffies(
>  		(pdata->batmon_interval ? : 10) * 1000);

