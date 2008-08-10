Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYHJPyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYHJPyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYHJPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:54:39 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:40179 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYHJPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:54:38 -0400
Date: Sun, 10 Aug 2008 11:54:37 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] ide: remove unused macros from <asm-parisc/ide.h>
Message-ID: <20080810155437.GA6576@phobos.i.cabal.ca>
References: <200808101747.08025.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808101747.08025.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 05:47:07PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  include/asm-parisc/ide.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> Index: b/include/asm-parisc/ide.h
> ===================================================================
> --- a/include/asm-parisc/ide.h
> +++ b/include/asm-parisc/ide.h
> @@ -13,10 +13,6 @@
>  
>  #ifdef __KERNEL__
>  
> -#define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
> -#define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
> -#define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
> -#define ide_release_region(from,extent)		release_region((from), (extent))
>  /* Generic I/O and MEMIO string operations.  */
>  

Thanks Bart!

Groovy... Want me to merge this, or will you shepherd it in?

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

regards, Kyle
