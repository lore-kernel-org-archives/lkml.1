Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYEEHGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYEEHGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYEEHGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:06:43 -0400
Received: from www.tglx.de ([62.245.132.106]:49267 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYEEHGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:06:42 -0400
Date: Mon, 5 May 2008 09:06:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: yhlu.kernel@gmail.com
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove spew print out about bus to node mapping
In-Reply-To: <200805041341.02375.yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0805050905050.3318@apollo.tec.linutronix.de>
References: <200805041341.02375.yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Yinghai Lu wrote:
> Jeff Garzik pointed out that is not needed. looks like spam.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
> index ab6d4b1..5c2799c 100644
> --- a/arch/x86/pci/k8-bus_64.c
> +++ b/arch/x86/pci/k8-bus_64.c
> @@ -504,14 +504,6 @@ static int __init early_fill_mp_bus_info(void)
>  		}
>  	}
>  
> -#ifdef CONFIG_NUMA
> -	for (i = 0; i < BUS_NR; i++) {
> -		node = mp_bus_to_node[i];
> -		if (node >= 0)
> -			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
> -	}
> -#endif
> -
>  	for (i = 0; i < pci_root_num; i++) {
>  		int res_num;
>  		int busnum;
> 

What about this loop, looks noisy as well ?

Thanks,

	tglx
