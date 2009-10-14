Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbZJNCue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbZJNCue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbZJNCud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:50:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761422AbZJNCud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:50:33 -0400
Date: Tue, 13 Oct 2009 19:49:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix sparsemem configuration
Message-Id: <20091013194950.2f8f0fe1.akpm@linux-foundation.org>
In-Reply-To: <20091005150530.GA12271@rmk-PC.arm.linux.org.uk>
References: <20091005150530.GA12271@rmk-PC.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009 16:05:30 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Currently, sparsemem is only available if EXPERIMENTAL is enabled.
> However, it hasn't ever been marked experimental.
> 
> It's been about four years since sparsemem was merged, and we have
> platforms which depend on it; allow architectures to decide whether
> sparsemem should be the default memory model.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> --
>  mm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 2477607..95b2965 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -67,7 +67,7 @@ config DISCONTIGMEM
>  
>  config SPARSEMEM
>  	def_bool y
> -	depends on SPARSEMEM_MANUAL
> +	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
>  
>  config FLATMEM
>  	def_bool y

Can you suggest which kernel version(s) we should merge this into?  I'm
struggling.

Ta.
