Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXKEP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXKEP5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXKEP5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:57:38 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43764 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbXKEP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:57:38 -0500
Date: Mon, 5 Nov 2007 16:57:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS: Remove MTD_AMSTD and MTD_OBSOLETE_CHIPS
Message-ID: <20071105155713.GO12045@stusta.de>
References: <20071105132102.GL7621@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071105132102.GL7621@axis.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:21:02PM +0100, Jesper Nilsson wrote:
> Remove no longer configured MTD_AMDSTD and MTD_OBSOLETE_CHIPS from
> defconfig, Kconfig and code, instead we'll use MTD_CFI and/or MTD_JEDECPROBE.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  arch-v10/defconfig              |    3 +--
>  arch-v10/drivers/Kconfig        |    2 --
>  arch-v10/drivers/axisflashmap.c |    8 ++++----
>  arch-v32/drivers/Kconfig        |    2 --
>  defconfig                       |    4 ++--
>  5 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/cris/arch-v10/defconfig b/arch/cris/arch-v10/defconfig
> index 710c20b..d03bfc0 100644
> --- a/arch/cris/arch-v10/defconfig
> +++ b/arch/cris/arch-v10/defconfig
>...

Patching defconfig's is not that effective, and defconfig's containing 
no longer present options are not a problem.

Simply ignore them for now (but it might make sense to update them 
once all your patches got merged).

> /^JN - Jesper Nilsson

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

