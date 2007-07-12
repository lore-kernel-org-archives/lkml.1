Return-Path: <linux-kernel-owner+w=401wt.eu-S1765308AbXGLQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765308AbXGLQMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbXGLQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:12:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53572 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbXGLQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:12:03 -0400
Subject: Re: [Patch] drivers/mtd/maps/tqm8xxl.c: Style cleanups
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: kirk@hpc.ee.ntu.edu.tw, dwmw2@infradead.org, akpm@osdl.org,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070712150135.GA4102@localhost.localdomain>
References: <20070712150135.GA4102@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 11:11:58 -0500
Message-Id: <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 23:01 +0800, WANG Cong wrote:
> Change C++ style comments into K&R's.
> Cut long lines into pieces.
> 
> This patch is against 2.6.22.1, and can be also applied to
> the last -mm tree.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
>  tqm8xxl.c |   41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6.22.1/drivers/mtd/maps/tqm8xxl.c
> ===================================================================
> --- a/drivers/mtd/maps/tqm8xxl.c	2007-04-26 11:08:32.000000000 +0800
> +++ b/drivers/mtd/maps/tqm8xxl.c	2007-07-05 00:16:16.000000000 +0800
> @@ -38,7 +38,7 @@
>  #define FLASH_SIZE 0x00800000
>  #define FLASH_BANK_MAX 4
> 
> -// trivial struct to describe partition information
> +/* trivial struct to describe partition information*/

Needs a space at the end.

>  struct mtd_part_def
>  {
>  	int nums;
> @@ -46,7 +46,7 @@
>  	struct mtd_partition* mtd_part;
>  };
> 
> -//static struct mtd_info *mymtd;
> +/*static struct mtd_info *mymtd;*/

Just delete this...

>  static struct mtd_info* mtd_banks[FLASH_BANK_MAX];
>  static struct map_info* map_banks[FLASH_BANK_MAX];
>  static struct mtd_part_def part_banks[FLASH_BANK_MAX];
> @@ -106,7 +106,7 @@
>  	  .name = "jffs",
>  	  .offset = 0x00200000,
>  	  .size = 0x00200000,
> -	  //.size = MTDPART_SIZ_FULL,
> +	  /*.size = MTDPART_SIZ_FULL,*/

Delete it...

>  	}
>  };
>  #endif
> @@ -121,10 +121,11 @@
>  	flash_addr = bd->bi_flashstart;
>  	flash_size = bd->bi_flashsize;
> 
> -	//request maximum flash size address space
> +	/*request maximum flash size address space*/

Spaces needed (repeat for the rest of the ones that don't have spaces
either).

josh

