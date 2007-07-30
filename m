Return-Path: <linux-kernel-owner+w=401wt.eu-S965849AbXG3Akf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965849AbXG3Akf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965556AbXG3Ak2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:40:28 -0400
Received: from rex.snapgear.com ([203.143.235.140]:41315 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965267AbXG3Ak1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:40:27 -0400
Message-ID: <46AD3377.6020909@snapgear.com>
Date: Mon, 30 Jul 2007 10:40:23 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Yoann Padioleau <padator@wanadoo.fr>
CC: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/68] 0 -> NULL, for arch/m68knommu
References: <200707270944.LAA17230@ifs.emn.fr>
In-Reply-To: <200707270944.LAA17230@ifs.emn.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoann,

Yoann Padioleau wrote:
> When comparing a pointer, it's clearer to compare it to NULL than to 0.
>
> Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
> Cc: gerg@uclinux.org

Acked-by: Greg Ungerer <gerg@uclinux.org>


> Cc: akpm@linux-foundation.org
> ---
> 
>  comempci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/m68knommu/kernel/comempci.c b/arch/m68knommu/kernel/comempci.c
> index 6ee00ef..528517e 100644
> --- a/arch/m68knommu/kernel/comempci.c
> +++ b/arch/m68knommu/kernel/comempci.c
> @@ -736,7 +736,7 @@ #endif
>  
>  	/* Find a free spot to put this handler */
>  	for (i = 0; (i < COMEM_MAXPCI); i++) {
> -		if (pci_irqlist[i].handler == 0) {
> +		if (pci_irqlist[i].handler == NULL) {
>  			pci_irqlist[i].handler = handler;
>  			pci_irqlist[i].device = device;
>  			pci_irqlist[i].dev_id = dev_id;
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
