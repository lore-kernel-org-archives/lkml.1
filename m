Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900Ab0ARPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0ARPQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475Ab0ARPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:16:45 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:60385 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0ARPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:16:44 -0500
Date: Mon, 18 Jan 2010 10:16:30 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org, marcelo@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix grammo in tsc comment about Geode TSC
 reliability
Message-ID: <20100118101630.7ba94ab8@mycelium.queued.net>
In-Reply-To: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
References: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andres Salomon <dilinger@collabora.co.uk>

That code should probably exist for generic kernels (distro kernels
that aren't compiled specifically for GEODE_LX).  Currently it's
#ifdef'd..


On Sun, 17 Jan 2010
19:44:44 -0200 Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  arch/x86/kernel/tsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 597683a..23066ec 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -806,7 +806,7 @@ static void __init check_system_tsc_reliable(void)
>  	unsigned long res_low, res_high;
>  
>  	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
> -	/* Geode_LX - the OLPC CPU has a possibly a very reliable
> TSC */
> +	/* Geode_LX - the OLPC CPU has a very reliable TSC */
>  	if (res_low & RTSC_SUSP)
>  		tsc_clocksource_reliable = 1;
>  #endif
