Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbYIMKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbYIMKq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYIMKqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:46:43 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:54797 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbYIMKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:46:42 -0400
Date: Sat, 13 Sep 2008 12:46:41 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [MTD] physmap.c: Add #endif comments
Message-ID: <20080913104641.GE21603@xi.wantstofly.org>
References: <48CB5E9F.9060109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CB5E9F.9060109@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:33:03PM -0700, Zev Weiss wrote:

> Adding comments to a few of the less painfully-obvious #endifs.
> 
> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
> ---
>   drivers/mtd/maps/physmap.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index 6fba0d4..49e2039 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -244,7 +244,7 @@ static void physmap_flash_shutdown(struct platform_device *dev)
>   #define physmap_flash_suspend NULL
>   #define physmap_flash_resume NULL
>   #define physmap_flash_shutdown NULL
> -#endif
> +#endif /* CONFIG_PM */
> 
>   static struct platform_driver physmap_flash_driver = {
>   	.probe		= physmap_flash_probe,
> @@ -302,8 +302,8 @@ void physmap_set_partitions(struct mtd_partition *parts, int
> num_parts)
>   	physmap_flash_data.nr_parts = num_parts;
>   	physmap_flash_data.parts = parts;
>   }
> -#endif
> -#endif
> +#endif /* CONFIG_MTD_PARTITIONS */
> +#endif /* PHYSMAP_COMPAT */

I thought that this was frowned upon.  (I don't like it myself, and
my editor is perfectly well capable of pointing out to me which ifdef
matches up with which endif.)
