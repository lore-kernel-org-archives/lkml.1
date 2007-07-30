Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXG3HlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXG3HlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXG3HlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:41:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753546AbXG3HlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:41:11 -0400
Message-ID: <46AD95E1.6020100@sgi.com>
Date: Mon, 30 Jul 2007 09:40:17 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: Remove a few duplicate includes
References: <200707300028.42496.jesper.juhl@gmail.com>
In-Reply-To: <200707300028.42496.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> (sorry about the duplicate mail, forgot a recipient first time)
> 
> Hi,
> This patch removes a few duplicate includes from arch/ia64/
> Please consider merging :-)
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

sn2/Altix portion is fine with me, so.

Acked-by: Jes Sorensen <jes@sgi.com>

> ---
> 
>  arch/ia64/ia32/sys_ia32.c   |    1 -
>  arch/ia64/kernel/setup.c    |    1 -
>  arch/ia64/sn/kernel/setup.c |    1 -
>  3 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
> index af10462..a3405b3 100644
> --- a/arch/ia64/ia32/sys_ia32.c
> +++ b/arch/ia64/ia32/sys_ia32.c
> @@ -34,7 +34,6 @@
>  #include <linux/uio.h>
>  #include <linux/nfs_fs.h>
>  #include <linux/quota.h>
> -#include <linux/syscalls.h>
>  #include <linux/sunrpc/svc.h>
>  #include <linux/nfsd/nfsd.h>
>  #include <linux/nfsd/cache.h>
> diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
> index 7cecd29..cd9a37a 100644
> --- a/arch/ia64/kernel/setup.c
> +++ b/arch/ia64/kernel/setup.c
> @@ -60,7 +60,6 @@
>  #include <asm/smp.h>
>  #include <asm/system.h>
>  #include <asm/unistd.h>
> -#include <asm/system.h>
>  
>  #if defined(CONFIG_SMP) && (IA64_CPU_SIZE > PAGE_SIZE)
>  # error "struct cpuinfo_ia64 too big!"
> diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
> index 684b1c9..1f38a3a 100644
> --- a/arch/ia64/sn/kernel/setup.c
> +++ b/arch/ia64/sn/kernel/setup.c
> @@ -25,7 +25,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/acpi.h>
>  #include <linux/compiler.h>
> -#include <linux/sched.h>
>  #include <linux/root_dev.h>
>  #include <linux/nodemask.h>
>  #include <linux/pm.h>
> 

