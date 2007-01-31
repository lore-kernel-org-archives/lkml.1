Return-Path: <linux-kernel-owner+w=401wt.eu-S1161059AbXAaWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161059AbXAaWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161063AbXAaWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:07:29 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161059AbXAaWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:07:28 -0500
Date: Wed, 31 Jan 2007 22:07:14 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: ak@suse.de, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: define dma noncoherent API functions
Message-ID: <20070131220714.GB8999@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>, ak@suse.de,
	Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
References: <20070131124107.GA4884@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131124107.GA4884@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 07:41:07AM -0500, Jeff Garzik wrote:
> x86-64 is missing these:
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> diff --git a/include/asm-x86_64/dma-mapping.h b/include/asm-x86_64/dma-mapping.h
> index be9ec68..49dbab0 100644
> --- a/include/asm-x86_64/dma-mapping.h
> +++ b/include/asm-x86_64/dma-mapping.h
> @@ -63,6 +63,9 @@ static inline int dma_mapping_error(dma_addr_t dma_addr)
>  	return (dma_addr == bad_dma_address);
>  }
>  
> +#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
> +#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
> +

What are these, and why haven't they been discussed in such places as
linux-arch so that architecture maintainers can comment on them ?

Ditto for the recently added dma_sync_range_whatever functions ?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
