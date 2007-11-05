Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXKEObE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXKEObE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXKEOaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:30:55 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35224 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbXKEOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:30:55 -0500
Date: Mon, 5 Nov 2007 09:29:21 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Nilsson <jesper.nilsson@axis.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS: Remove MTD_AMSTD and MTD_OBSOLETE_CHIPS
In-Reply-To: <20071105132102.GL7621@axis.com>
Message-ID: <Pine.LNX.4.64.0711050928330.10444@localhost.localdomain>
References: <20071105132102.GL7621@axis.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Jesper Nilsson wrote:

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
> @@ -99,7 +99,7 @@ CONFIG_MTD=y
>  CONFIG_MTD_CFI=y
>  # CONFIG_MTD_CFI_INTELEXT is not set
>  CONFIG_MTD_CFI_AMDSTD=y
> -CONFIG_MTD_AMDSTD=y
> +# CONFIG_MTD_AMDSTD is not set

why are you keeping this around?

> -CONFIG_MTD_OBSOLETE_CHIPS=y
> -CONFIG_MTD_AMDSTD=y
> +# CONFIG_MTD_OBSOLETE_CHIPS is not set
> +# CONFIG_MTD_AMDSTD is not set

same here.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
