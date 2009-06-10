Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZFJBrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZFJBrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbZFJBra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:47:30 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:34107 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755441AbZFJBr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:47:29 -0400
Message-ID: <4A2F10B2.7000003@snapgear.com>
Date: Wed, 10 Jun 2009 11:47:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       uclinux-dev@uclinux.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/3] mtd/maps: uclinux: mark local stuff static
References: <20090526231902.GA6295@linux-sh.org> <1243380798-10089-2-git-send-email-vapier@gentoo.org>
In-Reply-To: <1243380798-10089-2-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mike Frysinger wrote:
> The uclinux_ram_mtdinfo, uclinux_romfs, and uclinux_point symbols do not
> need to be visible outside of this module, so mark them static.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Greg Ungerer <gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> CC: uclinux-dev@uclinux.org
> CC: linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/maps/uclinux.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
> index 61d4087..d4314fb 100644
> --- a/drivers/mtd/maps/uclinux.c
> +++ b/drivers/mtd/maps/uclinux.c
> @@ -30,11 +30,11 @@ struct map_info uclinux_ram_map = {
>  	.size = 0,
>  };
>  
> -struct mtd_info *uclinux_ram_mtdinfo;
> +static struct mtd_info *uclinux_ram_mtdinfo;
>  
>  /****************************************************************************/
>  
> -struct mtd_partition uclinux_romfs[] = {
> +static struct mtd_partition uclinux_romfs[] = {
>  	{ .name = "ROMfs" }
>  };
>  
> @@ -42,7 +42,7 @@ struct mtd_partition uclinux_romfs[] = {
>  
>  /****************************************************************************/
>  
> -int uclinux_point(struct mtd_info *mtd, loff_t from, size_t len,
> +static int uclinux_point(struct mtd_info *mtd, loff_t from, size_t len,
>  	size_t *retlen, void **virt, resource_size_t *phys)
>  {
>  	struct map_info *map = mtd->priv;

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
