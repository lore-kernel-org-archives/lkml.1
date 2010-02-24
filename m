Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0BXA60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:58:26 -0500
Received: from trinity.fluff.org ([89.16.178.74]:44444 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0BXA6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:58:24 -0500
Date: Wed, 24 Feb 2010 00:58:22 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the samsung tree with the arm tree
Message-ID: <20100224005822.GP10014@trinity.fluff.org>
References: <20100224113306.465efa4d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224113306.465efa4d.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 11:33:06AM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/Makefile between various commits from the arm tree and various
> commits from the samsung tree.

yeah, I intend on getting this merged to RMK asap, i've unfortunately
been unwell and this is becoming overdue :(
 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/Makefile
> index 00ea105,13c5c2b..0000000
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@@ -186,11 -182,11 +186,11 @@@ plat-$(CONFIG_PLAT_IOP)		:= io
>   plat-$(CONFIG_PLAT_NOMADIK)	:= nomadik
>   plat-$(CONFIG_PLAT_ORION)	:= orion
>   plat-$(CONFIG_PLAT_PXA)		:= pxa
> - plat-$(CONFIG_PLAT_S3C24XX)	:= s3c24xx s3c samsung
> - plat-$(CONFIG_PLAT_S3C64XX)	:= s3c64xx s3c samsung
> - plat-$(CONFIG_PLAT_S5PC1XX)	:= s5pc1xx s3c samsung
> - plat-$(CONFIG_PLAT_S5P)		:= s5p samsung s3c
> + plat-$(CONFIG_PLAT_S3C24XX)	:= s3c24xx samsung
> + plat-$(CONFIG_ARCH_S3C64XX)	:= samsung
> + plat-$(CONFIG_PLAT_S5PC1XX)	:= s5pc1xx samsung
> + plat-$(CONFIG_PLAT_S5P)		:= s5p samsung
>  -plat-$(CONFIG_ARCH_STMP3XXX)	:= stmp3xxx
>  +plat-$(CONFIG_PLAT_VERSATILE)	:= versatile
>   
>   ifeq ($(CONFIG_ARCH_EBSA110),y)
>   # This is what happens if you forget the IOCS16 line.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

