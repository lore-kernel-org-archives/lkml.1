Return-Path: <linux-kernel-owner+w=401wt.eu-S933927AbZGQBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbZGQBSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbZGQBSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:18:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933478AbZGQBSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:18:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] power: trivial comment fixes
Date: Fri, 17 Jul 2009 03:19:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090716134257.GA22163@localhost>
In-Reply-To: <20090716134257.GA22163@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907170319.02997.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009, Wu Fengguang wrote:
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks for the patch, I'll add it to the suspend tree when I'm back home
(probably on Monday).

Best,
Rafael


> ---
>  kernel/power/snapshot.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux.orig/kernel/power/snapshot.c
> +++ linux/kernel/power/snapshot.c
> @@ -233,7 +233,7 @@ static void *chain_alloc(struct chain_al
>  
>  #define BM_END_OF_MAP	(~0UL)
>  
> -#define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
> +#define BM_BITS_PER_BLOCK	(PAGE_SIZE * BITS_PER_BYTE)
>  
>  struct bm_block {
>  	struct list_head hook;	/* hook into a list of bitmap blocks */
> @@ -275,7 +275,7 @@ static void memory_bm_free(struct memory
>  
>  /**
>   *	create_bm_block_list - create a list of block bitmap objects
> - *	@nr_blocks - number of blocks to allocate
> + *	@pages - number of pages to track
>   *	@list - list to put the allocated blocks into
>   *	@ca - chain allocator to be used for allocating memory
>   */
