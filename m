Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYGWLkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYGWLkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYGWLkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:40:11 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:49285 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWLkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:40:10 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 07:40:09 EDT
Date: Wed, 23 Jul 2008 07:30:07 -0400
From: ketuzsezr@darnok.org
To: Jan Beulich <jbeulich@novell.com>
Cc: ketuzsezr@darnok.org, pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi_ibft_find: fix modpost warning
Message-ID: <20080723113007.GA13214@andromeda.dapyr.net>
References: <4880A721.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4880A721.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 01:22:25PM +0100, Jan Beulich wrote:
> Exporting __init functions is wrong.

Looks good. Thanks for catching that.

> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  drivers/firmware/iscsi_ibft_find.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-2.6.26/drivers/firmware/iscsi_ibft_find.c	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-firmware-iscsi-modpost-warning/drivers/firmware/iscsi_ibft_find.c	2008-07-17 14:45:12.000000000 +0200
> @@ -81,4 +81,3 @@ void __init reserve_ibft_region(void)
>  	if (ibft_addr)
>  		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
>  }
> -EXPORT_SYMBOL_GPL(reserve_ibft_region);

