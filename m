Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYKTUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYKTUwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYKTUvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:39 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22326 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756125AbYKTUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PVkJ6vr9A1Yetvt4o5x4f3naw9DQfyouUPAmAjE5MwofrPnDH9mtO2P+49xhzRpdiGIWsa3SwUFcjVI5zQLlgDIGRcCYRwY8qhX2WFCrwfhhQQlSO4+wtuQhN6GY5ZU7vgELVk9AJPaV4ubVzlIFqirMON9QP6NqyUa06uOGmuE=  ;
X-YMail-OSG: aKvDM1YVM1mdHlc6xkU4RMaFbrZnXc0_KLRcWkP7V0MJ.u96lE.KOSDIA1sdurOwKuT5fsCiLemw.7pxrfdSy0ytuIAvg5ymD5_s2ovAOk3MLy9t7fmYrh0xBYI3r4WTauByaNQYQYxaldKHrPN1XtZuL4.5OW.4GKwgU8DmEkXKmCflibLVAZ.pJo9u
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 03/16] Blackfin SPI Driver: move bfin_addr_dcachable() and friends into the cacheflush header where it belongs
Date: Thu, 20 Nov 2008 12:26:55 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-4-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-4-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201226.55975.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... except that you really need to have patch comments,
not just overlong $SUBJECT lines, so please fix that.


> ---
>  drivers/spi/spi_bfin5xx.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index a38106a..6c5671e 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -25,9 +25,6 @@
>  #include <asm/dma.h>
>  #include <asm/portmux.h>
>  #include <asm/bfin5xx_spi.h>
> -
> -/* reserved_mem_dcache_on and cache friends */
> -#include <asm/cplbinit.h>
>  #include <asm/cacheflush.h>
>  
>  #define DRV_NAME	"bfin-spi"
> -- 
> 1.5.6.3
> 
> 


