Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZIZOEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZIZOEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZIZOEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:04:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56274 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZIZOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:04:07 -0400
Date: Sat, 26 Sep 2009 10:03:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Byungho Min <bhmin@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Remove unused CONFIG reference DEBUG_S3C_PORT
In-Reply-To: <1253973658.4568.10.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0909261002400.19973@localhost>
References: <1253973658.4568.10.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Jaswinder Singh Rajput wrote:

>
> Remove unused CONFIG reference DEBUG_S3C_PORT from defconfig
>
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Byungho Min <bhmin@samsung.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Russell King <rmk+lkml@arm.linux.org.uk>
> ---
>  arch/arm/configs/s5pc100_defconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/configs/s5pc100_defconfig b/arch/arm/configs/s5pc100_defconfig
> index b0d7d3d..94edde5 100644
> --- a/arch/arm/configs/s5pc100_defconfig
> +++ b/arch/arm/configs/s5pc100_defconfig
> @@ -859,7 +859,6 @@ CONFIG_DEBUG_ERRORS=y
>  # CONFIG_DEBUG_STACK_USAGE is not set
>  CONFIG_DEBUG_LL=y
>  # CONFIG_DEBUG_ICEDCC is not set
> -CONFIG_DEBUG_S3C_PORT=y
>  CONFIG_DEBUG_S3C_UART=0

  no, there is no point removing redundant entries from any of the
defconfig files -- those files will eventually be rebuilt
automatically at some point.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
