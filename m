Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYJ2O5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYJ2O5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYJ2O5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:57:25 -0400
Received: from relais.videotron.ca ([24.201.245.36]:18923 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYJ2O5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:57:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 29 Oct 2008 10:57:18 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mike Frysinger <vapier@gentoo.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMC91x: delete unused local variable "lp"
In-reply-to: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
Message-id: <alpine.LFD.2.00.0810291056590.13034@xanadu.home>
References: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Mike Frysinger wrote:

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Nicolas Pitre <nico@cam.org>


> ---
>  drivers/net/smc91x.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
> index c70870e..6f9895d 100644
> --- a/drivers/net/smc91x.c
> +++ b/drivers/net/smc91x.c
> @@ -2060,7 +2060,6 @@ static int smc_request_attrib(struct platform_device *pdev,
>  			      struct net_device *ndev)
>  {
>  	struct resource * res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "smc91x-attrib");
> -	struct smc_local *lp = netdev_priv(ndev);
>  
>  	if (!res)
>  		return 0;
> @@ -2075,7 +2074,6 @@ static void smc_release_attrib(struct platform_device *pdev,
>  			       struct net_device *ndev)
>  {
>  	struct resource * res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "smc91x-attrib");
> -	struct smc_local *lp = netdev_priv(ndev);
>  
>  	if (res)
>  		release_mem_region(res->start, ATTRIB_SIZE);
> -- 
> 1.6.0.2
> 


Nicolas
