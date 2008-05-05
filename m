Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbYEEXA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbYEEXA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761201AbYEEW7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:59:08 -0400
Received: from xenotime.net ([66.160.160.81]:58030 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753367AbYEEW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:59:07 -0400
Date: Mon, 5 May 2008 15:58:59 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gcosta@redhat.com
Subject: Re: [PATCH] Use correct format when printing long unsigned int in
 arch/x86/kernel/setup.c
In-Reply-To: <alpine.LNX.1.00.0805060039100.27779@dragon.funnycrock.com>
Message-ID: <Pine.LNX.4.64.0805051558001.25277@shark.he.net>
References: <alpine.LNX.1.00.0805060039100.27779@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Jesper Juhl wrote:

> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> 
> Use correct format when printing long unsigned int in arch/x86/kernel/setup.c

Ugh, thanks.  Looks like I mucked that one up somehow.
I'll have to check my logs when I get back home.

> This patch gets rid of this compiler warning:
>   arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
>   arch/x86/kernel/setup.c:99: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'long unsigned int'
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  setup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index cc6f5eb..c0c68c1 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
>  
>  	/* Copy section for each CPU (we discard the original) */
>  	size = PERCPU_ENOUGH_ROOM;
> -	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
> +	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
>  			  size);
>  
>  	for_each_possible_cpu(i) {
> 
> 

-- 
~Randy
