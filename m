Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZKILlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZKILlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZKILlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:41:23 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41228 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZKILlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:41:22 -0500
Subject: Re: [PATCH resend] mtd/maps: Fix accidental removal in Makefile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20091108.024307.183026733.anemo@mba.ocn.ne.jp>
References: <20091108.024307.183026733.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 13:40:53 +0200
Message-Id: <1257766853.21596.292.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Nov 2009 11:40:58.0722 (UTC) FILETIME=[817CEC20:01CA6131]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 02:43 +0900, Atsushi Nemoto wrote:
> The commit d79c326 ("gpio-addr-flash: new driver for GPIO assisted
> flash addressing") removed two lines from the Makefile by accident.
> Though I'm not sure how this accident happened, this patch reverts the
> removal.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> This patch fixes a regression from 2.6.31
> 
>  drivers/mtd/maps/Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
> index 1d5cf86..ae2f6db 100644
> --- a/drivers/mtd/maps/Makefile
> +++ b/drivers/mtd/maps/Makefile
> @@ -58,4 +58,6 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
>  obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
>  obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
>  obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
> +obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
> +obj-$(CONFIG_MTD_VMU)		+= vmu-flash.o
>  obj-$(CONFIG_MTD_GPIO_ADDR)	+= gpio-addr-flash.o

This patch is in my l2-mtd-2.6 tree now, but I think it should be merged
to 2.6.32-rcX.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

