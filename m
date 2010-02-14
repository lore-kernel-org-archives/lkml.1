Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0BNGMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:12:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:51717 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0BNGMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:12:37 -0500
Subject: Re: [PATCH 6/9] of: remove unused extern reference to devtree_lock
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100213160258.4767.22371.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	 <20100213160258.4767.22371.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 17:12:14 +1100
Message-ID: <1266127934.16346.63.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 09:02 -0700, Grant Likely wrote:
> Neither the powerpc nor the microblaze code use devtree_lock anymore.
> Remove the extern reference.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


>  arch/microblaze/include/asm/prom.h |    2 --
>  arch/powerpc/kernel/prom.c         |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index ddc5c57..8b1ebd3 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -30,8 +30,6 @@ extern struct device_node *of_chosen;
>  
>  #define HAVE_ARCH_DEVTREE_FIXUPS
>  
> -extern rwlock_t devtree_lock;	/* temporary while merging */
> -
>  /* Other Prototypes */
>  extern int early_uartlite_console(void);
>  
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 5bbbdb2..4869c93 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -67,8 +67,6 @@ int __initdata iommu_force_on;
>  unsigned long tce_alloc_start, tce_alloc_end;
>  #endif
>  
> -extern rwlock_t devtree_lock;	/* temporary while merging */
> -
>  /* export that to outside world */
>  struct device_node *of_chosen;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


