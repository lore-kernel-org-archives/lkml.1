Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYJTVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYJTVig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYJTVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:37:25 -0400
Received: from kroah.org ([198.145.64.141]:37521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755784AbYJTVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:37:23 -0400
Date: Mon, 20 Oct 2008 14:18:22 -0700
From: Greg KH <greg@kroah.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: staging: me4000: remove duplicated #include's
Message-ID: <20081020211822.GA30320@kroah.com>
References: <20081018113833.61B4.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018113833.61B4.WEIYI.HUANG@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 11:52:15AM +0800, Huang Weiyi wrote:
> Removed duplicated #include's in drivers/staging/me4000/me4000.c
>    asm/uaccess.h
>    linux/fs.h
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> 
> diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
> index 862dd7f..90de6f0 100644
> --- a/drivers/staging/me4000/me4000.c
> +++ b/drivers/staging/me4000/me4000.c
> @@ -30,7 +30,6 @@
>  #include <asm/uaccess.h>
>  #include <linux/errno.h>
>  #include <linux/delay.h>
> -#include <linux/fs.h>
>  #include <linux/mm.h>
>  #include <linux/unistd.h>
>  #include <linux/list.h>
> @@ -39,7 +38,6 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <asm/pgtable.h>
> -#include <asm/uaccess.h>
>  #include <linux/types.h>
> 
>  #include <linux/slab.h>

Hm, this doesn't apply anymore as some cleanups went in that should have
just made this not needed.

But if you have a script I can run somewhere to verify it, I'd
appreciate it.

thanks,

greg k-h
