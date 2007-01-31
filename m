Return-Path: <linux-kernel-owner+w=401wt.eu-S1161040AbXAaVgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040AbXAaVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbXAaVgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:36:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbXAaVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:36:07 -0500
Message-ID: <45C10B68.4050002@redhat.com>
Date: Wed, 31 Jan 2007 16:34:32 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Fix apparent typo of "CONFIG_MT_SMP".
References: <Pine.LNX.4.64.0701251839140.15699@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701251839140.15699@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   Replace apparent typo of CONFIG_MT_SMP with CONFIG_MIPS_MT_SMP.
>
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> ---
>
> diff --git a/arch/mips/mips-boards/sim/sim_setup.c b/arch/mips/mips-boards/sim/sim_setup.c
> index 2659c1c..ea2066c 100644
> --- a/arch/mips/mips-boards/sim/sim_setup.c
> +++ b/arch/mips/mips-boards/sim/sim_setup.c
> @@ -57,7 +57,7 @@ void __init plat_mem_setup(void)
>  	board_time_init = sim_time_init;
>  	prom_printf("Linux started...\n");
>
> -#ifdef CONFIG_MT_SMP
> +#ifdef CONFIG_MIPS_MT_SMP
>  	sanitize_tlb_entries();
>  #endif
>  }
>
>   
Have you posted the latest version of your scripts for finding these?

