Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbYA1Wic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbYA1Wic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA1WiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:38:25 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33642 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYA1WiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:38:24 -0500
Date: Mon, 28 Jan 2008 14:37:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let LOG_BUF_SHIFT default to 17
Message-Id: <20080128143748.530a33d1.randy.dunlap@oracle.com>
In-Reply-To: <20080128221223.GE8767@does.not.exist>
References: <20080128221223.GE8767@does.not.exist>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 00:12:23 +0200 Adrian Bunk wrote:

> 16 kB is often no longer enough for a normal boot of an UP system.

s/16/64/ then agreed.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> And even less when people e.g. use suspend.
> 
> 17 seems to be a more reasonable default for current kernels on current 
> hardware (it's just the default, anyone who is memory limited can 
> still lower it).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> f02213e3c1cb90ec1c66227f037110d489f30bfd 
> diff --git a/init/Kconfig b/init/Kconfig
> index 0eda68f..81a1255 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -272,17 +272,14 @@ config IKCONFIG_PROC
>  config LOG_BUF_SHIFT
>  	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
>  	range 12 21
> -	default 17 if S390 || LOCKDEP
> -	default 16 if X86_NUMAQ || IA64
> -	default 15 if SMP
> -	default 14
> +	default 17
>  	help
>  	  Select kernel log buffer size as a power of 2.
> -	  Defaults and Examples:
> -	  	     17 => 128 KB for S/390
> -		     16 => 64 KB for x86 NUMAQ or IA-64
> -	             15 => 32 KB for SMP
> -	             14 => 16 KB for uniprocessor
> +	  Examples:
> +	  	     17 => 128 KB
> +		     16 => 64 KB
> +	             15 => 32 KB
> +	             14 => 16 KB
>  		     13 =>  8 KB
>  		     12 =>  4 KB
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
