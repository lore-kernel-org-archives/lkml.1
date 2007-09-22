Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbXIVRuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbXIVRuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXIVRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:50:27 -0400
Received: from www.osadl.org ([213.239.205.134]:46721 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981AbXIVRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:50:27 -0400
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223202.2504813DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de>
	 <20070921223202.2504813DCD@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 19:50:24 +0200
Message-Id: <1190483424.4035.64.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> From: "Oliver Pinter" <oliver.pntr@gmail.com>
> 
> add cpu core name for arch/i386/Kconfig.cpu:Pentium 4 sections help
> add Pentium D for arch/i386/Kconfig.cpu
> add Pentium D for arch/x86_64/Kconfig
> 
> Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/Kconfig.cpu |   34 +++++++++++++++++++++++++++++++---
>  arch/x86_64/Kconfig   |    6 +++---
>  2 files changed, 34 insertions(+), 6 deletions(-)
> 
> Index: linux/arch/i386/Kconfig.cpu
> ===================================================================
> --- linux.orig/arch/i386/Kconfig.cpu
> +++ linux/arch/i386/Kconfig.cpu
> @@ -115,11 +115,39 @@ config MPENTIUM4
>  	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
>  	help
>  	  Select this for Intel Pentium 4 chips.  This includes the
> -	  Pentium 4, P4-based Celeron and Xeon, and Pentium-4 M
> -	  (not Pentium M) chips.  This option enables compile flags
> -	  optimized for the chip, uses the correct cache shift, and
> +	  Pentium 4, Pentium D, P4-based Celeron and Xeon, and
> +	  Pentium-4 M (not Pentium M) chips.  This option enables compile
> +	  flags optimized for the chip, uses the correct cache shift, and
>  	  applies any applicable Pentium III optimizations.
>  
> +	  CPUIDs: F[0-6][1-A] (in /proc/cpuinfo show = cpu family : 15 )
> +
> +	  Select this for:
> +	    Pentiums (Pentium 4, Pentium D, Celeron, Celeron D) corename:
> +		-Willamette
> +		-Northwood
> +		-Mobile Pentium 4
> +		-Mobile Pentium 4 M
> +		-Extreme Edition (Gallatin)
> +		-Prescott
> +		-Prescott 2M
> +		-Cedar Mill
> +		-Presler
> +		-Smithfiled
> +	    Xeons (Intel Xeon, Xeon MP, Xeon LV, Xeon MV) corename:
> +	    	-Foster
> +		-Prestonia
> +		-Gallatin
> +		-Nocona
> +		-Irwindale
> +		-Cranford
> +		-Potomac
> +		-Paxville
> +		-Dempsey
> +
> +	  more info: http://balusc.xs4all.nl/srv/har-cpu.html

This will never be up to date. Also the URL above is redirected to an
empty bye/bye page. Put this up to one of the kernel related wikis, if
you think it might be useful at all. 99% of the users do not even know
which CPU they have in their system.

	tglx




