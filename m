Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbYBRLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbYBRLQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYBRLQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:16:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbYBRLQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:16:09 -0500
Subject: Re: [2.6 patch] proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080217082034.GT3848@cs181133002.pp.htv.fi>
References: <20080217082034.GT3848@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Mon, 18 Feb 2008 11:15:40 +0000
Message-Id: <1203333340.9635.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Sun, 2008-02-17 at 10:20 +0200, Adrian Bunk wrote:
> This patch adds a proper extern declaration for gdlm_ops in 
> fs/gfs2/locking/dlm/lock_dlm.h
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  fs/gfs2/locking/dlm/lock_dlm.h |    5 +++++
>  fs/gfs2/locking/dlm/main.c     |    2 --
>  fs/gfs2/locking/dlm/sysfs.c    |    2 --
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> b4ac811ad577cd6039fdd1395cfa910294b8efdc diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
> index 9e8265d..58fcf8c 100644
> --- a/fs/gfs2/locking/dlm/lock_dlm.h
> +++ b/fs/gfs2/locking/dlm/lock_dlm.h
> @@ -183,5 +183,10 @@ int gdlm_plock_get(void *, struct lm_lockname *, struct file *,
>  		struct file_lock *);
>  int gdlm_punlock(void *, struct lm_lockname *, struct file *,
>  		struct file_lock *);
> +
> +/* mount.c */
> +
> +extern const struct lm_lockops gdlm_ops;
> +
>  #endif
>  
> diff --git a/fs/gfs2/locking/dlm/main.c b/fs/gfs2/locking/dlm/main.c
> index a0e7eda..36a2258 100644
> --- a/fs/gfs2/locking/dlm/main.c
> +++ b/fs/gfs2/locking/dlm/main.c
> @@ -11,8 +11,6 @@
>  
>  #include "lock_dlm.h"
>  
> -extern struct lm_lockops gdlm_ops;
> -
>  static int __init init_lock_dlm(void)
>  {
>  	int error;
> diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
> index a87b098..8479da4 100644
> --- a/fs/gfs2/locking/dlm/sysfs.c
> +++ b/fs/gfs2/locking/dlm/sysfs.c
> @@ -12,8 +12,6 @@
>  
>  #include "lock_dlm.h"
>  
> -extern struct lm_lockops gdlm_ops;
> -
>  static ssize_t proto_name_show(struct gdlm_ls *ls, char *buf)
>  {
>  	return sprintf(buf, "%s\n", gdlm_ops.lm_proto_name);
> 

