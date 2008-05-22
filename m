Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbYEVVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbYEVVpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760873AbYEVVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:45:25 -0400
Received: from www.tglx.de ([62.245.132.106]:36917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbYEVVpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:45:23 -0400
Date: Thu, 22 May 2008 23:45:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: move pic_mode to apic_32.c
In-Reply-To: <20080519154656.15071.96979.stgit@thinkpad>
Message-ID: <alpine.LFD.1.10.0805222343430.3295@apollo.tec.linutronix.de>
References: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Alexey Starikovskiy wrote:
>  
>  	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
>  	       mpf->mpf_specification);
> -#ifdef CONFIG_X86_32
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
>  	if (mpf->mpf_feature2 & (1 << 7)) {
>  		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
>  		pic_mode = 1;

This part is not about moving pic_mode. Please separate it out.

Thanks,
	tglx
