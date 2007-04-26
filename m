Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXDZUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXDZUUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXDZUUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:20:33 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2965 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXDZUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:20:32 -0400
Date: Thu, 26 Apr 2007 21:20:19 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ian Molton <spyro@f2s.com>
Subject: Re: [PATCH] ARM: Remove useless config option GENERIC_BUST_SPINLOCK.
Message-ID: <20070426202019.GA11735@flint.arm.linux.org.uk>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, Ian Molton <spyro@f2s.com>
References: <Pine.LNX.4.64.0704260911110.2493@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260911110.2493@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 11:10:59AM -0400, Robert P. J. Day wrote:
> Remove the apparently useless config option GENERIC_BUST_SPINLOCK,
> since nothing in the source tree refers to it.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Please copy me on ARM (NOT ARM26) fixes.  For all intents and purposes
they're two entirely separate architectures.  One I'm responsible for.
The other Ian's responsible for.  Thanks.

>  arch/arm/Kconfig   |    3 ---
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e7baca2..5a4869f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -102,9 +102,6 @@ config GENERIC_CALIBRATE_DELAY
>  	bool
>  	default y
> 
> -config GENERIC_BUST_SPINLOCK
> -	bool
> -
>  config ARCH_MAY_HAVE_PC_FDC
>  	bool
> 

Just this part:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
