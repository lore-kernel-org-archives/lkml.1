Return-Path: <linux-kernel-owner+w=401wt.eu-S1750946AbZIYEGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946AbZIYEGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZIYEGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:06:22 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:59631 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740AbZIYEGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:06:21 -0400
Message-ID: <4ABC41A2.6000109@snapgear.com>
Date: Fri, 25 Sep 2009 14:05:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Greg Ungerer <gerg@uclinux.org>, Steven King <sfking@fdwdc.com>,
       uclinux-dev@uclinux.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68knommu: includecheck fix: 5206e, config.c
References: <1253789400.5860.4.camel@ht.satnam>
In-Reply-To: <1253789400.5860.4.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

Jaswinder Singh Rajput wrote:
> fix the following 'make includecheck' warning:
> 
>   arch/m68knommu/platform/5206e/config.c: asm/mcfuart.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Steven King <sfking@fdwdc.com>

Thanks. Essentially the same patch was sent here a few days ago
by Huang Weiyi. And that is currently sitting in the for-linus
branch of:

  http://git.kernel.org/?p=linux/kernel/git/gerg/m68knommu.git;a=summary

I will be sending that to Linus soon (with a couple of other
fixes too).

Regards
Greg



> ---
>  arch/m68knommu/platform/5206e/config.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
> index 0f41ba8..9423979 100644
> --- a/arch/m68knommu/platform/5206e/config.c
> +++ b/arch/m68knommu/platform/5206e/config.c
> @@ -17,7 +17,6 @@
>  #include <asm/mcfsim.h>
>  #include <asm/mcfuart.h>
>  #include <asm/mcfdma.h>
> -#include <asm/mcfuart.h>
>  
>  /***************************************************************************/
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
