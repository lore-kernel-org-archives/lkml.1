Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYJaEte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYJaEte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYJaEtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:49:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54185 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYJaEs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:48:59 -0400
Message-ID: <490A8E35.8080204@garzik.org>
Date: Fri, 31 Oct 2008 00:48:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: nico@cam.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMC91x: delete unused local variable "lp"
References: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1225288566-18457-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
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

applied


