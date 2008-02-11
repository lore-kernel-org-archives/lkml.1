Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYBKI0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYBKI0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYBKI03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:26:29 -0500
Received: from www.tglx.de ([62.245.132.106]:44291 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbYBKI02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:26:28 -0500
Date: Mon, 11 Feb 2008 09:25:47 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
 architecture
Message-ID: <20080211092547.09bca061@dilbert.local>
In-Reply-To: <20080207141236.00940d09@dilbert.local>
References: <20080207133805.13f092ff@dilbert.local>
	<20080207130222.GA8587@flint.arm.linux.org.uk>
	<20080207141236.00940d09@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 7 Feb 2008 14:12:36 +0100
schrieb Hans-Jürgen Koch <hjk@linutronix.de>:

AFAICT, this patch was neither rejected nor applied. It generated a
long thread about changing the whole ARM Kconfig system. I feel not
qualified to do that, but I still want UIO available on ARM ;-)
What can I do to help?

Thanks,
Hans

> From: Hans J Koch <hjk@linutronix.de>
> To: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: Greg KH <greg@kroah.com>
> Subject: arch/arm/Kconfig: Make UIO available on ARM architecture
> 
> Source drivers/uio/Kconfig to make UIO available in menuconfig if
> ARCH=arm.
> 
> Signed-off-by: Hans J Koch <hjk@linutronix.de>
> ---
>  arch/arm/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/arm/Kconfig	2008-02-07
> 13:57:58.000000000 +0100 +++ linux-2.6/arch/arm/Kconfig
> 2008-02-07 14:08:46.000000000 +0100 @@ -1159,6 +1159,8 @@
>  
>  source "drivers/dca/Kconfig"
>  
> +source "drivers/uio/Kconfig"
> +
>  endmenu
>  
>  source "fs/Kconfig"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
