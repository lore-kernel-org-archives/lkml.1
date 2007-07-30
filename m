Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXG3AHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXG3AHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763826AbXG3AHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:07:44 -0400
Received: from rex.snapgear.com ([203.143.235.140]:39170 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751915AbXG3AHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:07:43 -0400
Message-ID: <46AD2BC5.5050202@snapgear.com>
Date: Mon, 30 Jul 2007 10:07:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] m68knommu: Get rid of duplicate include
References: <200707292353.55129.jesper.juhl@gmail.com>
In-Reply-To: <200707292353.55129.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

Jesper Juhl wrote:
> This patch removes the duplicate inclusion of asm/irq.h 
> from arch/m68knommu/platform/5206e/config.c

You can add my acked by:

Acked-by: Greg Ungerer <gerg@uclinux.org>


> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  arch/m68knommu/platform/5206e/config.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68knommu/platform/5206e/config.c b/arch/m68knommu/platform/5206e/config.c
> index 4ab614f..425703f 100644
> --- a/arch/m68knommu/platform/5206e/config.c
> +++ b/arch/m68knommu/platform/5206e/config.c
> @@ -20,7 +20,6 @@
>  #include <asm/mcftimer.h>
>  #include <asm/mcfsim.h>
>  #include <asm/mcfdma.h>
> -#include <asm/irq.h>
>  
>  /***************************************************************************/
>  
> 
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
