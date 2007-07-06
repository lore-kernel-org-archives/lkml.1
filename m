Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbXGFHlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbXGFHlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbXGFHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:41:09 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52857 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760765AbXGFHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:41:08 -0400
Date: Fri, 6 Jul 2007 09:40:42 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] lib/ioremap.c should #include <linux/io.h>
Message-ID: <20070706094042.770790fd@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070705232228.GU3492@stusta.de>
References: <20070705232228.GU3492@stusta.de>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 01:22:28 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> Every file should include the headers containing the prototypes for
> its global functions.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Can't argue with that.

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

> ---
> --- linux-2.6.22-rc6-mm1/lib/ioremap.c.old	2007-07-03 05:02:10.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/lib/ioremap.c	2007-07-03 05:02:22.000000000 +0200
> @@ -8,6 +8,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/mm.h>
>  #include <linux/sched.h>
> +#include <linux/io.h>
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
>  
> 
