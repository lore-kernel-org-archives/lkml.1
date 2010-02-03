Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab0BCRVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:21:40 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:63943 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932622Ab0BCRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:21:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYBAA8/aUtLd/sX/2dsb2JhbAAIgyvFCZAlgS2CPloE
X-IronPort-AV: E=Sophos;i="4.49,399,1262581200"; 
   d="scan'208";a="55249704"
Message-ID: <4B69B0A0.2040701@teksavvy.com>
Date: Wed, 03 Feb 2010 12:21:36 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com> <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
In-Reply-To: <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/ata/pata_at91.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index 41c94b1..d222c0d 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -153,8 +153,8 @@ static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
>  	/* Compute ATA timing and set it to SMC */
>  	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
>  	if (ret) {
> -		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
> -				set PIO_0 timing\n", ret);
> +		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
> +			 ret);
..

NAK.  Just stick the ret); part onto the same line and be done with it.

-ml
