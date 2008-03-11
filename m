Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYCKEyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYCKEyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYCKEyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:54:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54785 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYCKEyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:54:01 -0400
Date: Tue, 11 Mar 2008 13:53:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] ia64: Remove redundant display of free swap space in  show_mem()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <12051798742672-git-send-email-hannes@saeurebad.de>
References: <12051798631122-git-send-email-hannes@saeurebad.de> <12051798742672-git-send-email-hannes@saeurebad.de>
Message-Id: <20080311135245.8931.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


nice.
Thanks.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>  arch/ia64/mm/contig.c    |    2 --
>  arch/ia64/mm/discontig.c |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
> index 344f64e..0479661 100644
> --- a/arch/ia64/mm/contig.c
> +++ b/arch/ia64/mm/contig.c
> @@ -45,8 +45,6 @@ void show_mem(void)
>  
>  	printk(KERN_INFO "Mem-info:\n");
>  	show_free_areas();
> -	printk(KERN_INFO "Free swap:       %6ldkB\n",
> -	       nr_swap_pages<<(PAGE_SHIFT-10));
>  	printk(KERN_INFO "Node memory in pages:\n");
>  	for_each_online_pgdat(pgdat) {
>  		unsigned long present;
> diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
> index ee5e68b..ffee1ea 100644
> --- a/arch/ia64/mm/discontig.c
> +++ b/arch/ia64/mm/discontig.c
> @@ -522,8 +522,6 @@ void show_mem(void)
>  
>  	printk(KERN_INFO "Mem-info:\n");
>  	show_free_areas();
> -	printk(KERN_INFO "Free swap:       %6ldkB\n",
> -	       nr_swap_pages<<(PAGE_SHIFT-10));
>  	printk(KERN_INFO "Node memory in pages:\n");
>  	for_each_online_pgdat(pgdat) {
>  		unsigned long present;
> -- 
> 1.5.2.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



