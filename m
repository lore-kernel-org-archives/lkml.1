Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZJaKQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZJaKQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 06:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZJaKQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 06:16:42 -0400
Received: from mail.crca.org.au ([67.207.131.56]:53112 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZJaKQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 06:16:42 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AEC0EBE.2040308@crca.org.au>
Date: Sat, 31 Oct 2009 21:17:34 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
CC: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
In-Reply-To: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've only looked at this one, but something caught my eye...

André Goddard Rosa wrote:
> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> index f7b9cdc..b52c1f8 100644
> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
> 
>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>  	d_cache = CPLB_L1_CHBL;
> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
>  	d_cache |= CPLB_L1_AOW | CPLB_WT;
>  #endif
>  #endif

"Surely that can't be the only time?", I thought. But it is - all of the
other #ifdefs are spelled correctly, so you're probably fixing a
hard-to-find bug here! Good catch!

Makes me wonder if anyone's written a tool to find things like this -
#ifdefs that will never be defined...

Regards,

Nigel
