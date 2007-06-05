Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXFEGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXFEGrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXFEGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:47:11 -0400
Received: from mx34.mail.ru ([194.67.23.200]:13037 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755205AbXFEGrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:47:10 -0400
Date: Tue, 5 Jun 2007 10:46:59 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Remove apparently useless, commented
	apm_get_battery_status().
Message-ID: <20070605064659.GA678@zarina>
Reply-To: cbou@mail.ru
References: <Pine.LNX.4.64.0706040715520.32191@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706040715520.32191@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 07:15:58AM -0400, Robert P. J. Day wrote:
> 
> Remove the "#if 0"ed definition of apm_get_battery_status().
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Anton Vorontsov <cbou@mail.ru>

> ---
> 
> diff --git a/arch/i386/kernel/apm.c b/arch/i386/kernel/apm.c
> index 4112afe..5c6da2b 100644
> --- a/arch/i386/kernel/apm.c
> +++ b/arch/i386/kernel/apm.c
> @@ -1006,35 +1006,6 @@ static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
>  	return APM_SUCCESS;
>  }
> 
> -#if 0
> -static int apm_get_battery_status(u_short which, u_short *status,
> -				  u_short *bat, u_short *life, u_short *nbat)
> -{
> -	u32	eax;
> -	u32	ebx;
> -	u32	ecx;
> -	u32	edx;
> -	u32	esi;
> -
> -	if (apm_info.connection_version < 0x0102) {
> -		/* pretend we only have one battery. */
> -		if (which != 1)
> -			return APM_BAD_DEVICE;
> -		*nbat = 1;
> -		return apm_get_power_status(status, bat, life);
> -	}
> -
> -	if (apm_bios_call(APM_FUNC_GET_STATUS, (0x8000 | (which)), 0, &eax,
> -			&ebx, &ecx, &edx, &esi))
> -		return (eax >> 8) & 0xff;
> -	*status = ebx;
> -	*bat = ecx;
> -	*life = edx;
> -	*nbat = esi;
> -	return APM_SUCCESS;
> -}
> -#endif
> -
>  /**
>   *	apm_engage_power_management	-	enable PM on a device
>   *	@device: identity of device
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
