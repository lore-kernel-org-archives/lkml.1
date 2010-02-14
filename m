Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0BNGPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:15:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:39521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0BNGPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:15:19 -0500
Subject: Re: [PATCH 9/9] of: remove undefined request_OF_resource &
 release_OF_resource
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100213160314.4767.93924.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	 <20100213160314.4767.93924.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 17:14:57 +1100
Message-ID: <1266128097.16346.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 09:03 -0700, Grant Likely wrote:
> Neither request_OF_resource or release_OF_resource are defined
> anywhere.  Remove the declarations.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

>  arch/microblaze/include/asm/prom.h |    4 ----
>  arch/powerpc/include/asm/prom.h    |    5 -----
>  2 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index aa1a437..03f45a9 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -31,10 +31,6 @@
>  /* Other Prototypes */
>  extern int early_uartlite_console(void);
>  
> -extern struct resource *request_OF_resource(struct device_node *node,
> -				int index, const char *name_postfix);
> -extern int release_OF_resource(struct device_node *node, int index);
> -
>  /*
>   * OF address retreival & translation
>   */
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index 7f9a50a..ddd408a 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -39,11 +39,6 @@ extern struct device_node* pci_device_to_OF_node(struct pci_dev *);
>  extern void pci_create_OF_bus_map(void);
>  #endif
>  
> -extern struct resource *request_OF_resource(struct device_node* node,
> -				int index, const char* name_postfix);
> -extern int release_OF_resource(struct device_node* node, int index);
> -
> -
>  /*
>   * OF address retreival & translation
>   */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


