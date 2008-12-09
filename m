Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYLIDyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYLIDyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYLIDyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:54:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYLIDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:54:12 -0500
Date: Mon, 8 Dec 2008 22:54:07 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] parisc: remove gratuitous cpu_online_map declaration.
Message-ID: <20081209035407.GF30783@bombadil.infradead.org>
References: <200812041012.41496.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812041012.41496.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 10:12:41AM +1030, Rusty Russell wrote:
> This is defined in linux/cpumask.h (included in this file already),
> and this will break when the definition changes (in a following patch).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Accepted, though it would have been nice if it had either hit all the
maintainers, or hit the list too...

cheers, Kyle

> ---
>  arch/parisc/include/asm/smp.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
> --- a/arch/parisc/include/asm/smp.h
> +++ b/arch/parisc/include/asm/smp.h
> @@ -15,8 +15,6 @@
>  #include <linux/threads.h>	/* for NR_CPUS */
>  #include <linux/cpumask.h>
>  typedef unsigned long address_t;
> -
> -extern cpumask_t cpu_online_map;
>  
>  
>  /*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
