Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZBMOmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZBMOmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZBMOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:42:38 -0500
Received: from cs-studio.ru ([195.178.208.66]:36365 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760870AbZBMOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:42:37 -0500
Date: Fri, 13 Feb 2009 17:42:34 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] Stagging: pohmelfs/net.c: include vmalloc.h
Message-ID: <20090213144234.GC28569@ioremap.net>
References: <20090213143532.GA7266@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213143532.GA7266@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 05:35:32PM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> on Sparc64:
> drivers/staging/pohmelfs/net.c:33: error: implicit declaration of function 'vmalloc'
> drivers/staging/pohmelfs/net.c:42: error: implicit declaration of function 'vfree'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks a lot Alexander!

> ---
> 
>  drivers/staging/pohmelfs/net.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/pohmelfs/net.c b/drivers/staging/pohmelfs/net.c
> index d161237..c9b8540 100644
> --- a/drivers/staging/pohmelfs/net.c
> +++ b/drivers/staging/pohmelfs/net.c
> @@ -22,6 +22,7 @@
>  #include <linux/poll.h>
>  #include <linux/swap.h>
>  #include <linux/syscalls.h>
> +#include <linux/vmalloc.h>
> 
>  #include "netfs.h"

-- 
	Evgeniy Polyakov
