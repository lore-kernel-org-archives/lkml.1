Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXKBTxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXKBTxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXKBTxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:53:44 -0400
Received: from waste.org ([66.93.16.53]:38911 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbXKBTxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:53:43 -0400
Date: Fri, 2 Nov 2007 14:48:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, Adrian Bunk <bunk@stusta.de>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused code from mm/tiny-shmem.c
Message-ID: <20071102194835.GQ19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102172056.14261.39829.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resent due to damaged header]

On Fri, Nov 02, 2007 at 10:50:56PM +0530, Balbir Singh wrote:
> This code in mm/tiny-shmem.c is under #if 0, do we really need it? This
> patch removes it.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Adrian added the #ifdefs in March, not sure why he didn't kill it outright.

Acked-by: Matt Mackall <mpm@selenic.com>

>  mm/tiny-shmem.c |   12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff -puN mm/tiny-shmem.c~remove-unused-code mm/tiny-shmem.c
> --- linux-2.6-latest/mm/tiny-shmem.c~remove-unused-code	2007-11-02 22:43:12.000000000 +0530
> +++ linux-2.6-latest-balbir/mm/tiny-shmem.c	2007-11-02 22:43:30.000000000 +0530
> @@ -121,18 +121,6 @@ int shmem_unuse(swp_entry_t entry, struc
>  	return 0;
>  }
>  
> -#if 0
> -int shmem_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	file_accessed(file);
> -#ifndef CONFIG_MMU
> -	return ramfs_nommu_mmap(file, vma);
> -#else
> -	return 0;
> -#endif
> -}
> -#endif  /*  0  */
> -
>  #ifndef CONFIG_MMU
>  unsigned long shmem_get_unmapped_area(struct file *file,
>  				      unsigned long addr,

-- 
Mathematics is the supreme nostalgia of our time.

