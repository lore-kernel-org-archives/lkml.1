Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZDPQwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZDPQwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbZDPQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:52:06 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:56631 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbZDPQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:52:05 -0400
Message-ID: <49E761CB.300@emcraft.com>
Date: Thu, 16 Apr 2009 20:50:19 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Yuri Tikhonov <yur@emcraft.com>,
       prodyuth@gmail.com, jwboyer@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils> <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Hugh Dickins wrote:
> Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
> let powerpc 256kB pages coexist with CONFIG_SHMEM again.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>   

Acked-by: Ilya Yanok <yanok@emcraft.com>

> ---
> Added linuxppc-dev and some other Cc's for this 3/3: sorry
> if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.
>
>  arch/powerpc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 2.6.29-git13/arch/powerpc/Kconfig	2009-04-06 11:47:57.000000000 +0100
> +++ linux/arch/powerpc/Kconfig	2009-04-06 18:18:47.000000000 +0100
> @@ -462,7 +462,7 @@ config PPC_64K_PAGES
>  
>  config PPC_256K_PAGES
>  	bool "256k page size" if 44x
> -	depends on !STDBINUTILS && (!SHMEM || BROKEN)
> +	depends on !STDBINUTILS
>  	help
>  	  Make the page size 256k.
>  
>   

Regards, Ilya.

