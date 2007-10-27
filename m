Return-Path: <linux-kernel-owner+w=401wt.eu-S1765459AbXJ0B2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765459AbXJ0B2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXJ0B2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:28:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36151 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXJ0B2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:28:23 -0400
Date: Fri, 26 Oct 2007 18:26:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] voyager: fix breakage caused by boot_params problem
Message-Id: <20071026182609.ea703328.randy.dunlap@oracle.com>
In-Reply-To: <1193419828.3293.35.camel@localhost.localdomain>
References: <1193419828.3293.35.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 12:30:28 -0500 James Bottomley wrote:

> There was a missed conversion in the voyager architecture setup file
> which this corrects.
> 
> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Oh.
http://lkml.org/lkml/2007/10/22/180
even cc-ed to you.

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


---
~Randy
