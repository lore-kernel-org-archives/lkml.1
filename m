Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXFOWHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXFOWHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbXFOWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:07:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXFOWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:07:07 -0400
Message-ID: <46730D82.7020508@redhat.com>
Date: Fri, 15 Jun 2007 18:06:58 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi irq flags
References: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net>
In-Reply-To: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2007 05:17 PM, Gregory Haskins wrote:
> The spinlock irq flags should be a unsigned long to properly support 64 bit

Ouch. Can't we automate checking for that?

> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> ---
> 
>  drivers/net/natsemi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
> index 4cf0d3f..460a087 100644
> --- a/drivers/net/natsemi.c
> +++ b/drivers/net/natsemi.c
> @@ -690,7 +690,7 @@ static ssize_t natsemi_set_dspcfg_workaround(struct device *dev,
>  {
>  	struct netdev_private *np = netdev_priv(to_net_dev(dev));
>  	int new_setting;
> -	u32 flags;
> +	unsigned long flags;
>  
>          /* Find out the new setting */
>          if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
> 
