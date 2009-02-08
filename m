Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZBHOah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZBHOah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBHOa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:30:28 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:12884 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBHOa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:30:28 -0500
Date: Sun, 8 Feb 2009 15:34:34 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 3/15] tridentfb: fix memory leaks in
 removal path
Message-Id: <20090208153434.4b28a2f1.krzysztof.h1@poczta.fm>
In-Reply-To: <20090207121233.0a93b4db@ephemeral>
References: <20090207121233.0a93b4db@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: eee2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:12:33 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> We were leaking the cmap memory.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---


Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


>  drivers/video/tridentfb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/tridentfb.c b/drivers/video/tridentfb.c
> index 479b2e7..c5369ba 100644
> --- a/drivers/video/tridentfb.c
> +++ b/drivers/video/tridentfb.c
> @@ -1563,6 +1563,7 @@ static void __devexit trident_pci_remove(struct pci_dev *dev)
>  	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
>  	pci_set_drvdata(dev, NULL);
>  	kfree(info->pixmap.addr);
> +	fb_dealloc_cmap(&info->cmap);
>  	framebuffer_release(info);
>  }
>  


----------------------------------------------------------------------
Zostan mistrzem parkowania w Bombaju!
Zagraj >> http://link.interia.pl/f204e 

