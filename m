Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYGHSb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYGHSb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbYGHSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:31:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47913 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbYGHSbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:31:31 -0400
Date: Tue, 8 Jul 2008 21:30:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org
Subject: Re: [RFC 08/11] remove CONFIG_KMOD from net
Message-ID: <20080708183035.GC11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net> <20080708170047.433712000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080708170047.433712000@sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 07:00:23PM +0200, Johannes Berg wrote:
>...
> --- everything.orig/net/core/dev.c	2008-07-08 18:35:53.000000000 +0200
> +++ everything/net/core/dev.c	2008-07-08 18:36:06.000000000 +0200
> @@ -4639,7 +4639,7 @@ EXPORT_SYMBOL(br_fdb_get_hook);
>  EXPORT_SYMBOL(br_fdb_put_hook);
>  #endif
>  
> -#ifdef CONFIG_KMOD
> +#ifdef CONFIG_MODULES
>  EXPORT_SYMBOL(dev_load);
>  #endif
>...

You can remove the #ifdef  

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

