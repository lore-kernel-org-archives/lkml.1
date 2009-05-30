Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbZE3LWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbZE3LWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbZE3LWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:22:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51570 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbZE3LWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:22:23 -0400
Date: Sat, 30 May 2009 13:22:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090530112221.GA1395@ucw.cz>
References: <1243408083.13460.14.camel@debian-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243408083.13460.14.camel@debian-nb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index f430e15..b0ee851 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -158,6 +158,17 @@ config ARCH_MTD_XIP
>  config GENERIC_HARDIRQS_NO__DO_IRQ
>  	def_bool y
>  
> +config OF
> +        def_bool y
> +
> +config PROC_DEVICETREE
> +        bool "Support for device tree in /proc"

It certainly should not be in /proc.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
