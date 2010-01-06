Return-Path: <linux-kernel-owner+w=401wt.eu-S933210Ab0AFX7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab0AFX7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199Ab0AFX7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:59:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab0AFX7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:59:44 -0500
Date: Thu, 7 Jan 2010 00:59:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Stefan Weil <weil@mail.berlios.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       "David S . Miller" <davem@davemloft.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix spelling in log messages
In-Reply-To: <1262819137-16775-1-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LRH.2.00.1001070059230.15694@twin.jikos.cz>
References: <1262819137-16775-1-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Stefan Weil wrote:

> Replace platfrom -> platform.
> 
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/input/serio/i8042.c |    2 +-
>  drivers/net/davinci_emac.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index d84a36e..33f3541 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -430,7 +430,7 @@ static bool i8042_filter(unsigned char data, unsigned char str,
>  	}
>  
>  	if (i8042_platform_filter && i8042_platform_filter(data, str, serio)) {
> -		dbg("Filtered out by platfrom filter\n");
> +		dbg("Filtered out by platform filter\n");
>  		return true;
>  	}
>  
> diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
> index 107bc5f..4741ade 100644
> --- a/drivers/net/davinci_emac.c
> +++ b/drivers/net/davinci_emac.c
> @@ -2652,7 +2652,7 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
>  
>  	pdata = pdev->dev.platform_data;
>  	if (!pdata) {
> -		printk(KERN_ERR "DaVinci EMAC: No platfrom data\n");
> +		printk(KERN_ERR "DaVinci EMAC: No platform data\n");
>  		return -ENODEV;
>  	}

This is now in trivial queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

