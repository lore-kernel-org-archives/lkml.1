Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYEEPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYEEPNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYEEPNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:13:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48510 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbYEEPNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:13:09 -0400
Date: Mon, 5 May 2008 18:12:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080505151202.GA17139@cs181133002.pp.htv.fi>
References: <20080504193113.GA24358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080504193113.GA24358@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 09:35:42PM +0200, Ingo Molnar wrote:
>...
> Thomas Gleixner (2):
>...
>       x86: olpc build fix
>...
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> +	depends on MGEODE_LX
>  	default n
>  	help
>...

This patch not only excludes OLPC and code depending on it (currently 
BATTERY_OLPC) from all{mod,yes}config builds (where it built fine) 
but also makes it very hard for generic distribution kernels to
support the OLPC.

The commit comment does not indicate what the actual problem was, and if 
this patch was sent to linux-kernel I must have missed it.

What exactly was the build problem?
Can we fix it in a less invasive way?

Thanks in advance
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

