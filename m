Return-Path: <linux-kernel-owner+w=401wt.eu-S935559AbXGUWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935559AbXGUWMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935382AbXGUWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:11:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:44246 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935315AbXGUWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:11:38 -0400
Subject: Re: [PATCH][09/37] Clean up duplicate includes in
	drivers/macintosh/
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <200707211702.30610.jesper.juhl@gmail.com>
References: <200707211702.30610.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 08:11:14 +1000
Message-Id: <1185055874.5439.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 17:02 +0200, Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	drivers/macintosh/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
> diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
> index 4177ff0..2c21d4f 100644
> --- a/drivers/macintosh/rack-meter.c
> +++ b/drivers/macintosh/rack-meter.c
> @@ -30,7 +30,6 @@
>  #include <asm/machdep.h>
>  #include <asm/pmac_feature.h>
>  #include <asm/dbdma.h>
> -#include <asm/dbdma.h>
>  #include <asm/macio.h>
>  #include <asm/keylargo.h>
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

