Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZBEWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZBEWDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZBEWDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:03:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbZBEWDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:03:38 -0500
Date: Thu, 5 Feb 2009 14:02:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 2/3] mtd/maps: blackfin async flash maps: bfin-async mtd
 driver needs complex mappings
Message-Id: <20090205140255.b711b929.akpm@linux-foundation.org>
In-Reply-To: <1233822411-10210-3-git-send-email-cooloney@kernel.org>
References: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
	<1233822411-10210-3-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(all three patches were sent to "inux-mtd".  Fixed here).

On Thu,  5 Feb 2009 16:26:50 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

This is an underwhelming changelog.

>  drivers/mtd/maps/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index 0225cbb..043d50f 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -491,7 +491,7 @@ config MTD_PCMCIA_ANONYMOUS
>  
>  config MTD_BFIN_ASYNC
>  	tristate "Blackfin BF533-STAMP Flash Chip Support"
> -	depends on BFIN533_STAMP && MTD_CFI
> +	depends on BFIN533_STAMP && MTD_CFI && MTD_COMPLEX_MAPPINGS
>  	select MTD_PARTITIONS
>  	default y
>  	help

I assume this corrects a build error?
