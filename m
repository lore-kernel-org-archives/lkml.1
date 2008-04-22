Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbYDVUed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbYDVUed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYDVUeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:34:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34648 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYDVUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:34:22 -0400
Date: Tue, 22 Apr 2008 21:33:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Message-ID: <20080422203334.GA9809@flint.arm.linux.org.uk>
References: <1208895950.24124.9.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208895950.24124.9.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was my initial approach as well, which got shot down by Andrew
Morton and others as being unacceptable.

On Tue, Apr 22, 2008 at 01:25:50PM -0700, Harvey Harrison wrote:
> Limit this driver to ARCH_PXA, noticed by breakage on allyesconfig
> builds on 32-bit x86.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Linus, please apply and Russell can fix it up however he likes later
> in the week.  Many people are hitting this.
> 
>  drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2566479..bd29c61 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -32,6 +32,7 @@ config HTC_EGPIO
>  
>  config HTC_PASIC3
>  	tristate "HTC PASIC3 LED/DS1WM chip support"
> +	depends on ARCH_PXA
>  	help
>  	  This core driver provides register access for the LED/DS1WM
>  	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
> -- 
> 1.5.5.144.g3e42
> 
> 
> 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
