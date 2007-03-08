Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXCHBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXCHBlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXCHBlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:41:35 -0500
Received: from ns.suse.de ([195.135.220.2]:49121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbXCHBle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:41:34 -0500
From: Neil Brown <neilb@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Thu, 8 Mar 2007 12:41:24 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17903.27076.860958.900374@notabene.brown>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Replace misspelled "PRINTK" with "CONFIG_PRINTK".
In-Reply-To: message from Robert P. J. Day on Wednesday March 7
References: <Pine.LNX.4.64.0703071836420.3888@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday March 7, rpjday@mindspring.com wrote:
> 
>   Replace the apparently misspelled preprocessor variable "PRINTK"
> with "CONFIG_PRINTK".

No, it is meant to be "PRINTK".
It dates way way back before my time, but presumably the idea was you
could -DPRINTK=something and if you didn't do that, it would figure
out what it thought you wanted.

Definitely not meant to be CONFIG_PRINTK.

NeilBrown


> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   not sure who the official maintainer here is, sorry.
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 5554ada..0c09772 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -53,7 +53,7 @@
>  //#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
>  #define DPRINTK(x...) do { } while(0)
> 
> -#ifndef PRINTK
> +#ifndef CONFIG_PRINTK
>  #  if DEBUG > 0
>  #    define PRINTK(x...) printk(KERN_DEBUG x)
>  #  else
> 
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
