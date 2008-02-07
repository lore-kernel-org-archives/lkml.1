Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYBGNCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYBGNCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYBGNCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:02:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36750 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYBGNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:02:43 -0500
Date: Thu, 7 Feb 2008 13:02:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207130222.GA8587@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080207133805.13f092ff@dilbert.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:38:05PM +0100, Hans-Jürgen Koch wrote:
> From: Hans J Koch <hjk@linutronix.de>
> To: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: Greg KH <greg@kroah.com>
> Subject: arch/arm/Kconfig: Make UIO available on ARM architecture
> 
> Source drivers/uio/Kconfig to make UIO available in menuconfig if ARCH=arm.
> I already posted this a few months ago, but it got lost somehow.
> 
> Signed-off-by: Hans J Koch <hjk@linutronix.de>
> ---
>  arch/arm/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/arm/Kconfig	2008-02-07 13:01:45.000000000 +0100
> +++ linux-2.6/arch/arm/Kconfig	2008-02-07 13:18:22.000000000 +0100
> @@ -1066,6 +1066,8 @@
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
>  
> +source "drivers/uio/Kconfig"
> +

Please place it in the same relative position in arch/arm/Kconfig as it
is found in drivers/Kconfig.
