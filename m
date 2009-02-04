Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZBDWOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZBDWOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZBDWOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:14:31 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:41227 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbZBDWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:14:30 -0500
Message-ID: <498A1315.5060200@freescale.com>
Date: Wed, 04 Feb 2009 16:13:41 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc: Eliminate double sizeof
References: <Pine.LNX.4.64.0902042236200.3091@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0902042236200.3091@ask.diku.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> --- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> +++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> @@ -186,7 +186,7 @@ out_unmap_regs:
>  	iounmap(priv->regs);
>  out_free_bootmem:
>  	free_bootmem((unsigned long)priv,
> -	             sizeof(sizeof(struct pq2ads_pci_pic)));
> +	             sizeof(struct pq2ads_pci_pic));
>  	of_node_put(np);
>  out_unmap_irq:
>  	irq_dispose_mapping(irq);

ACK

-Scott
