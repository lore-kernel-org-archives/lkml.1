Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXJMPY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXJMPY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXJMPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:24:16 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40680
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbXJMPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:24:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 8/8] ssb bus needs <linux/io.h>
Date: Sat, 13 Oct 2007 17:23:26 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       John Linville <linville@tuxdriver.com>
References: <20071013123123.085686856@mail.of.borg> <20071013123414.647276232@mail.of.borg>
In-Reply-To: <20071013123414.647276232@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710131723.26807.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007 14:31:31 Geert Uytterhoeven wrote:
> ssb bus needs <linux/io.h>
> 
> linux/drivers/ssb/main.c: In function 'ssb_ssb_read16':
> linux/drivers/ssb/main.c:518: error: implicit declaration of function 'readw'
> linux/drivers/ssb/main.c: In function 'ssb_ssb_read32':
> linux/drivers/ssb/main.c:526: error: implicit declaration of function 'readl'
> linux/drivers/ssb/main.c: In function 'ssb_ssb_write16':
> linux/drivers/ssb/main.c:534: error: implicit declaration of function 'writew'
> linux/drivers/ssb/main.c: In function 'ssb_ssb_write32':
> linux/drivers/ssb/main.c:542: error: implicit declaration of function 'writel'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

> ---
>  drivers/ssb/main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -11,6 +11,7 @@
>  #include "ssb_private.h"
>  
>  #include <linux/delay.h>
> +#include <linux/io.h>
>  #include <linux/ssb/ssb.h>
>  #include <linux/ssb/ssb_regs.h>
>  #include <linux/dma-mapping.h>
> 



-- 
Greetings Michael.
