Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbZBHO3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbZBHO3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBHO31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:29:27 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:24721 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBHO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:29:26 -0500
Date: Sun, 8 Feb 2009 15:33:26 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 2/15] tdfxfb: fix memory leaks in
 removal path
Message-Id: <20090208153326.4ae93d66.krzysztof.h1@poczta.fm>
In-Reply-To: <20090207121224.1e162373@ephemeral>
References: <20090207121224.1e162373@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 50e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:12:24 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> We were leaking the cmap memory.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/tdfxfb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
> index 14bd3f3..ee64771 100644
> --- a/drivers/video/tdfxfb.c
> +++ b/drivers/video/tdfxfb.c
> @@ -1393,6 +1393,7 @@ static void __devexit tdfxfb_remove(struct pci_dev *pdev)
>  	release_mem_region(pci_resource_start(pdev, 0),
>  			   pci_resource_len(pdev, 0));
>  	pci_set_drvdata(pdev, NULL);
> +	fb_dealloc_cmap(&info->cmap);
>  	framebuffer_release(info);
>  }
>  


----------------------------------------------------------------------
Zostan mistrzem parkowania w Bombaju!
Zagraj >> http://link.interia.pl/f204e 

