Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXGWJsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXGWJsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXGWJsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:48:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbXGWJsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:48:04 -0400
Subject: Re: [PATCH][19/37] Clean up duplicate includes in fs/gfs2/
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com
In-Reply-To: <200707211703.23149.jesper.juhl@gmail.com>
References: <200707211703.23149.jesper.juhl@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 23 Jul 2007 10:46:56 +0100
Message-Id: <1185184016.8765.408.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now applied to the -nmw GFS2 git tree. Thanks,

Steve.

On Sat, 2007-07-21 at 17:03 +0200, Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	fs/gfs2/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 3f0974e..0c21be0 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -25,8 +25,6 @@
>  #include <asm/uaccess.h>
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
> -#include <linux/module.h>
> -#include <linux/kallsyms.h>
>  
>  #include "gfs2.h"
>  #include "incore.h"
> diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
> index 24d70f7..9e8265d 100644
> --- a/fs/gfs2/locking/dlm/lock_dlm.h
> +++ b/fs/gfs2/locking/dlm/lock_dlm.h
> @@ -13,7 +13,6 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> -#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
>  #include <linux/list.h>
> diff --git a/fs/gfs2/locking/nolock/main.c b/fs/gfs2/locking/nolock/main.c
> index 0d149c8..d3b8ce6 100644
> --- a/fs/gfs2/locking/nolock/main.c
> +++ b/fs/gfs2/locking/nolock/main.c
> @@ -9,7 +9,6 @@
>  
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/fs.h>

