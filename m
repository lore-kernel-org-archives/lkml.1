Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXJYJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXJYJnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXJYJnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:43:05 -0400
Received: from www.tglx.de ([62.245.132.106]:34838 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbXJYJnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:43:02 -0400
Date: Thu, 25 Oct 2007 11:42:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86/kernel/setup_32.c: unexport machine_id
In-Reply-To: <20071024162506.GU30533@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710251142270.3186@localhost.localdomain>
References: <20071024162506.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:

> This patch removes the unused EXPORT_SYMBOL(machine_id).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, applied

	tglx

> ---
> 2cb43d8ae339c609318adf16a835e990fd79ee21 
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index ba2e165..e8ddc4c 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -84,9 +84,6 @@ unsigned long mmu_cr4_features;
>  
>  /* for MCA, but anyone else can use it if they want */
>  unsigned int machine_id;
> -#ifdef CONFIG_MCA
> -EXPORT_SYMBOL(machine_id);
> -#endif
>  unsigned int machine_submodel_id;
>  unsigned int BIOS_revision;
>  unsigned int mca_pentium_flag;
> 
