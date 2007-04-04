Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXDDS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXDDS3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXDDS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:28:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40670 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbXDDS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:28:42 -0400
Date: Wed, 4 Apr 2007 11:29:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       Marek =?UTF-8?Q?Va=C5=A1ut?= <marek.vasut@gmail.com>
Subject: Re: [PATCH 18/90] ARM: OMAP: PalmZ71 support
Message-Id: <20070404112924.8946346e.randy.dunlap@oracle.com>
In-Reply-To: <11757100112473-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757099743984-git-send-email-tony@atomide.com>
	<1175709977545-git-send-email-tony@atomide.com>
	<1175709988265-git-send-email-tony@atomide.com>
	<11757099942493-git-send-email-tony@atomide.com>
	<11757100011056-git-send-email-tony@atomide.com>
	<1175710003925-git-send-email-tony@atomide.com>
	<11757100063945-git-send-email-tony@atomide.com>
	<11757100092910-git-send-email-tony@atomide.com>
	<11757100112473-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:04:57 -0400 Tony Lindgren wrote:

> From: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>
> 
> Palmz71 specific things - board file.
> 
> Signed-off-by: Marek Vašut <marek.vasut@gmail.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap1/Kconfig               |    9 +
>  arch/arm/mach-omap1/Makefile              |    1 +
>  arch/arm/mach-omap1/board-palmz71.c       |  384 +++++++++++++++++++++++++++++
>  include/asm-arm/arch-omap/board-palmz71.h |   26 ++
>  include/asm-arm/arch-omap/hardware.h      |    4 +
>  5 files changed, 424 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
> index cc266bf..1cdb0ea 100644
> --- a/arch/arm/mach-omap1/Kconfig
> +++ b/arch/arm/mach-omap1/Kconfig
> @@ -86,6 +86,15 @@ config MACH_OMAP_PALMTE
>  	  http://palmtelinux.sourceforge.net/ for more information.
>  	  Say Y here if you have this PDA model, say N otherwise.
>  
> +config MACH_OMAP_PALMZ71
> +		bool "Palm Zire71"
> +		depends on ARCH_OMAP1 && ARCH_OMAP15XX
> +		help

Indentation as documented and expected and like the rest of the
kernel tree, please:
one tab on lines above, one tab + 2 spaces on help text below.

> +	 Support for the Palm Zire71 PDA. To boot the kernel,
> +	 you'll need a PalmOS compatible bootloader; check out
> +	 http://hackndev.com/palm/z71 for more informations.
> +	 Say Y here if you have such a PDA, say N otherwise.
> +
>  config MACH_NOKIA770
>  	bool "Nokia 770"
>  	depends on ARCH_OMAP1 && ARCH_OMAP16XX

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
