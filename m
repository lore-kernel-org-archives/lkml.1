Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbZENCp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbZENCp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZENCpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:45:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:40534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761282AbZENCpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:45:19 -0400
Cc: pierre@ossman.eu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <889F831A-D38C-43E8-BADB-BE772F7A3ADF@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
In-Reply-To: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] mmc: Add fsl,esdhc as a valid compatible to bind against
Date: Wed, 13 May 2009 21:45:08 -0500
References: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8, 2009, at 8:52 AM, Kumar Gala wrote:

> We plan to use fsl,esdhc going forward as the base compatible so  
> update
> the driver to bind against it.
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/mmc/host/sdhci-of.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)

Any feedback or possibility of picking this up.

- k

>
>
> diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
> index 3ff4ac3..09cc597 100644
> --- a/drivers/mmc/host/sdhci-of.c
> +++ b/drivers/mmc/host/sdhci-of.c
> @@ -277,6 +277,7 @@ static int __devexit sdhci_of_remove(struct  
> of_device *ofdev)
> static const struct of_device_id sdhci_of_match[] = {
> 	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc, },
> 	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
> +	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc, },
> 	{ .compatible = "generic-sdhci", },
> 	{},
> };
> -- 
> 1.6.0.6
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

