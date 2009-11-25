Return-Path: <linux-kernel-owner+w=401wt.eu-S934773AbZKYTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbZKYTAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbZKYTAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:00:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:6806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524AbZKYTAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:00:00 -0500
Message-ID: <4B0D7EB0.8090604@monstr.eu>
Date: Wed, 25 Nov 2009 20:00:00 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: graeme.smecher@mail.mcgill.ca
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Add dev_archdata node accessors
References: <1259175422-4628-1-git-send-email-graeme.smecher@mail.mcgill.ca>
In-Reply-To: <1259175422-4628-1-git-send-email-graeme.smecher@mail.mcgill.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

graeme.smecher@mail.mcgill.ca wrote:
> From: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
> 
> This syncs microblaze with powerpc and sparc architectures, which gained the
> same accessors in Commit 3f3b1632022fcc8317fa3b3c1236471415b3a6b8.

I have the same patch in my next branch. Will be add to mainline soon.

Thanks,
Michal

> 
> Signed-off-by: Graeme Smecher <graeme.smecher@mail.mcgill.ca>
> ---
>  arch/microblaze/include/asm/device.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/device.h b/arch/microblaze/include/asm/device.h
> index 30286db..b8f654d 100644
> --- a/arch/microblaze/include/asm/device.h
> +++ b/arch/microblaze/include/asm/device.h
> @@ -16,6 +16,18 @@ struct dev_archdata {
>  	struct device_node	*of_node;
>  };
>  
> +static inline void dev_archdata_set_node(struct dev_archdata *ad,
> +					 struct device_node *np)
> +{
> +	ad->of_node = np;
> +}
> +
> +static inline struct device_node *
> +dev_archdata_get_node(const struct dev_archdata *ad)
> +{
> +	return ad->of_node;
> +}
> +
>  struct pdev_archdata {
>  };
>  


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
