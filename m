Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbXEUXKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbXEUXKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXEUXJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:09:56 -0400
Received: from www.osadl.org ([213.239.205.134]:47407 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755431AbXEUXJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:09:55 -0400
Subject: Re: [PATCH] doc. clocksources
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20070521161122.eb419bcb.randy.dunlap@oracle.com>
References: <20070521161122.eb419bcb.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 01:09:43 +0200
Message-Id: <1179788983.12708.94.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 16:11 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Document the available clocksources per platform and move
> clocksource= into the correct (alpha) location in the file.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Makes sense.

Acked-by: Thomas Gleixner <tglx@linutronix.de>


> ---
>  Documentation/kernel-parameters.txt |   24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> --- linux-2622-rc2.orig/Documentation/kernel-parameters.txt
> +++ linux-2622-rc2/Documentation/kernel-parameters.txt
> @@ -396,6 +396,26 @@ and is between 256 and 4096 characters. 
>  			clocksource is not available, it defaults to PIT.
>  			Format: { pit | tsc | cyclone | pmtmr }
>  
> +	clocksource=	[GENERIC_TIME] Override the default clocksource
> +			Format: <string>
> +			Override the default clocksource and use the clocksource
> +			with the name specified.
> +			Some clocksource names to choose from, depending on
> +			the platform:
> +			[all] jiffies (this is the base, fallback clocksource)
> +			[ACPI] acpi_pm
> +			[ARM] imx_timer1,OSTS,netx_timer,mpu_timer2,
> +				pxa_timer,timer3,32k_counter,timer0_1
> +			[AVR32] avr32
> +			[IA-32] pit,hpet,tsc,vmi-timer;
> +				scx200_hrt on Geode; cyclone on IBM x440
> +			[MIPS] MIPS
> +			[PARISC] cr16
> +			[S390] tod
> +			[SH] SuperH
> +			[SPARC64] tick
> +			[X86-64] hpet,tsc
> +
>  	code_bytes	[IA32] How many bytes of object code to print in an
>  			oops report.
>  			Range: 0 - 8192
> @@ -1807,10 +1827,6 @@ and is between 256 and 4096 characters. 
>  
>  	time		Show timing data prefixed to each printk message line
>  
> -	clocksource=	[GENERIC_TIME] Override the default clocksource
> -			Override the default clocksource and use the clocksource
> -			with the name specified.
> -
>  	tipar.timeout=	[HW,PPT]
>  			Set communications timeout in tenths of a second
>  			(default 15).

