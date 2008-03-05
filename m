Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbYCEHsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbYCEHsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764603AbYCEHsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:48:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761149AbYCEHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:48:01 -0500
Date: Wed, 5 Mar 2008 07:47:23 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/asm-arm - use angle brackets for includes
Message-ID: <20080305074723.GA19674@flint.arm.linux.org.uk>
References: <1204677978.5180.90.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204677978.5180.90.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: Russell King <rmk+kernel@arm.linux.org.uk>, Nicolas Pitre <nico@cam.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>

No idea why you're sending this to Nicolas, yet it touches s3cXXXX stuff
which is Ben Dooks, who has been omitted from the above.

On Tue, Mar 04, 2008 at 04:46:18PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com

This is not a proper signed off - please use both angle brackets. 8)

> 
> include/asm-arm/plat-s3c/uncompress.h |    4 ++--
>  include/asm-arm/proc-fns.h            |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-arm/plat-s3c/uncompress.h b/include/asm-arm/plat-s3c/uncompress.h
> index b5e6208..19b9eda 100644
> --- a/include/asm-arm/plat-s3c/uncompress.h
> +++ b/include/asm-arm/plat-s3c/uncompress.h
> @@ -27,8 +27,8 @@ static void arch_detect_cpu(void);
>  
>  /* defines for UART registers */
>  
> -#include "asm/plat-s3c/regs-serial.h"
> -#include "asm/plat-s3c/regs-watchdog.h"
> +#include <asm/plat-s3c/regs-serial.h>
> +#include <asm/plat-s3c/regs-watchdog.h>
>  
>  /* working in physical space... */
>  #undef S3C2410_WDOGREG
> diff --git a/include/asm-arm/proc-fns.h b/include/asm-arm/proc-fns.h
> index a4ce457..75ec760 100644
> --- a/include/asm-arm/proc-fns.h
> +++ b/include/asm-arm/proc-fns.h
> @@ -214,9 +214,9 @@
>  #ifndef __ASSEMBLY__
>  
>  #ifndef MULTI_CPU
> -#include "asm/cpu-single.h"
> +#include <asm/cpu-single.h>
>  #else
> -#include "asm/cpu-multi32.h"
> +#include <asm/cpu-multi32.h>
>  #endif
>  
>  #include <asm/memory.h>
> 
> 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
