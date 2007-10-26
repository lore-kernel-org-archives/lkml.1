Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbXJZR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbXJZR75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXJZR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:59:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXJZR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:59:50 -0400
Message-ID: <47222AEE.3030200@zytor.com>
Date: Fri, 26 Oct 2007 10:59:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] voyager: fix breakage caused by boot_params problem
References: <1193419828.3293.35.camel@localhost.localdomain>
In-Reply-To: <1193419828.3293.35.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> There was a missed conversion in the voyager architecture setup file
> which this corrects.
> 
> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> ---
> 
> James
> 
> diff --git a/include/asm-x86/mach-voyager/setup_arch.h b/include/asm-x86/mach-voyager/setup_arch.h
> index 84d01ad..10debd2 100644
> --- a/include/asm-x86/mach-voyager/setup_arch.h
> +++ b/include/asm-x86/mach-voyager/setup_arch.h
> @@ -1,5 +1,5 @@
>  #include <asm/voyager.h>
> -#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
> +#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(&boot_params.apm_bios_info))
>  
>  /* Hook to call BIOS initialisation function */
>  

Acked-by: H. Peter Anvin <hpa@zytor.com>
