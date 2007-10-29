Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXJ2Nww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXJ2Nww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXJ2Nwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:52:45 -0400
Received: from www.tglx.de ([62.245.132.106]:57890 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXJ2Nwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:52:44 -0400
Date: Mon, 29 Oct 2007 14:52:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the dead X86_REMOTE_DEBUG option
In-Reply-To: <20071029124916.GK7227@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710291451560.3186@localhost.localdomain>
References: <20071029124916.GK7227@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Adrian Bunk wrote:

> This patch removes the dead X86_REMOTE_DEBUG option.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks

	tglx

> ---
> 6ea2f2bbd1646369a3affbed8ad1af5acc1530cd 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 970b2de..a2fa37d 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -113,7 +113,4 @@ config IOMMU_LEAK
>  	  Add a simple leak tracer to the IOMMU code. This is useful when you
>  	  are debugging a buggy device driver that leaks IOMMU mappings.
>  
> -#config X86_REMOTE_DEBUG
> -#	bool "kgdb debugging stub"
> -
>  endmenu
> 
