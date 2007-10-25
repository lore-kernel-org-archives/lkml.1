Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXJYJlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXJYJlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXJYJlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:41:23 -0400
Received: from www.tglx.de ([62.245.132.106]:34811 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXJYJlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:41:23 -0400
Date: Thu, 25 Oct 2007 11:40:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86/mm/discontig_32.c: make code static
In-Reply-To: <20071024162447.GP30533@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710251139490.3186@localhost.localdomain>
References: <20071024162447.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:

> node0_bdata and paddr_to_nid() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, applied.

	tglx

> ---
> 
>  arch/x86/mm/discontig_32.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 3380c9e430ab49db51bea06835e4b058f573d7b5 
> diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
> index fe608a4..13a474d 100644
> --- a/arch/x86/mm/discontig_32.c
> +++ b/arch/x86/mm/discontig_32.c
> @@ -40,7 +40,7 @@
>  
>  struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
>  EXPORT_SYMBOL(node_data);
> -bootmem_data_t node0_bdata;
> +static bootmem_data_t node0_bdata;
>  
>  /*
>   * numa interface - we expect the numa architecture specific code to have
> @@ -404,7 +404,7 @@ void __init set_highmem_pages_init(int bad_ppro)
>  }
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> -int paddr_to_nid(u64 addr)
> +static int paddr_to_nid(u64 addr)
>  {
>  	int nid;
>  	unsigned long pfn = PFN_DOWN(addr);
> 
