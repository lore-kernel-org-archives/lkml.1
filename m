Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbYDNPwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbYDNPwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYDNPwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:52:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46796 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYDNPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:52:30 -0400
Date: Mon, 14 Apr 2008 10:49:25 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mtd/chips/cfi_cmdset_0020.c: make a function static
Message-ID: <20080414104925.5416d07c@zod.rchland.ibm.com>
In-Reply-To: <20080414142030.GT6695@cs181133002.pp.htv.fi>
References: <20080414142030.GT6695@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 17:20:30 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global cfi_staa_erase_varsize() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

> 
> ---
> 071e1e3116928c1625f475a0fba2f96ee897a95c diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
> index 492e2ab..356939b 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0020.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0020.c
> @@ -893,7 +893,8 @@ retry:
>  	return ret;
>  }
> 
> -int cfi_staa_erase_varsize(struct mtd_info *mtd, struct erase_info *instr)
> +static int cfi_staa_erase_varsize(struct mtd_info *mtd,
> +				  struct erase_info *instr)
>  {	struct map_info *map = mtd->priv;
>  	struct cfi_private *cfi = map->fldrv_priv;
>  	unsigned long adr, len;
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
