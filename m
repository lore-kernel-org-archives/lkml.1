Return-Path: <linux-kernel-owner+w=401wt.eu-S966914AbZLHXGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966914AbZLHXGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936856AbZLHXGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:06:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1102 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936703AbZLHXGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:06:48 -0500
Subject: Re: x86: ucode-amd: Convert printk(KERN_*...) to pr_*(...)
From: Joe Perches <joe@perches.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200912082259.nB8Mx2ih008207@hera.kernel.org>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 15:06:53 -0800
Message-ID: <1260313613.27677.169.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:59 +0000, Linux Kernel Mailing List wrote:
> Commit:     1a74357066369be91e6f4f431621a00b052df964
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 9f13324..26e33bd 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
[]
> @@ -113,7 +113,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
>  
>  	/* ucode might be chipset specific -- currently we don't support this */
>  	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
> -		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
> +		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
>  		       "specific code not yet supported\n", cpu);
>  		return 0;
>  	}

Duplicates KERN_ERR

I think this one was better:
http://patchwork.kernel.org/patch/51654/


