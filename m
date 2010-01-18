Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527Ab0ARBdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0ARBdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653Ab0ARBdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:33:20 -0500
Received: from trinity.fluff.org ([89.16.178.74]:39161 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab0ARBdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:33:16 -0500
Date: Mon, 18 Jan 2010 01:33:07 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20100118013307.GD10014@trinity.fluff.org>
References: <20100118103534.a5dc3c66.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118103534.a5dc3c66.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 10:35:34AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/Makefile between commit 95b8f20fd6a2694a16b8addb190b942bfb670c88
> (ARM: fix badly placed mach/plat entries in Kconfig & Makefile"") from
> the arm-current tree and commit c4ffccddd54b669cc9683f2c69e31035e916a1a0
> ("ARM: S5P6440: Add new Kconfig and Makefiles") from the arm tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

Is that from the merge of next-samsung or from two parts of the ARM
trees?

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> (Sorry, cut and paste diff)
> diff --cc arch/arm/Makefile
> index 9e75825,bbcd512..0000000
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@@ -184,7 -184,9 +185,8 @@@ plat-$(CONFIG_PLAT_ORION)  := orio
>   plat-$(CONFIG_PLAT_PXA)               := pxa
>   plat-$(CONFIG_PLAT_S3C24XX)   := s3c24xx s3c samsung
>   plat-$(CONFIG_PLAT_S3C64XX)   := s3c64xx s3c samsung
>  -plat-$(CONFIG_PLAT_S5PC1XX)   := s5pc1xx s3c samsung
> + plat-$(CONFIG_PLAT_S5P)               := s5p samsung s3c
>  -plat-$(CONFIG_ARCH_STMP3XXX)  := stmp3xxx
>  +plat-$(CONFIG_PLAT_S5PC1XX)   := s5pc1xx s3c samsung
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

