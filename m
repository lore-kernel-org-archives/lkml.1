Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbZKYUJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbZKYUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934745AbZKYUJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:09:25 -0500
Received: from fieldses.org ([174.143.236.118]:39055 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbZKYUJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:09:23 -0500
Date: Wed, 25 Nov 2009 15:10:11 -0500
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] lockd: Remove unused nfsd headers #includes
Message-ID: <20091125201011.GG32502@fieldses.org>
References: <4B0C1EB7.50508@panasas.com> <4B0C1FE0.8040105@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C1FE0.8040105@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 08:03:12PM +0200, Boaz Harrosh wrote:
> 
> In what history where these ever needed? Well not
> any more.

Applied, thanks.--b.

> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  fs/lockd/svc4proc.c |    4 ----
>  fs/lockd/svcproc.c  |    4 ----
>  2 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
> index bd173a6..a7966ee 100644
> --- a/fs/lockd/svc4proc.c
> +++ b/fs/lockd/svc4proc.c
> @@ -11,10 +11,6 @@
>  #include <linux/time.h>
>  #include <linux/slab.h>
>  #include <linux/smp_lock.h>
> -#include <linux/in.h>
> -#include <linux/sunrpc/svc.h>
> -#include <linux/sunrpc/clnt.h>
> -#include <linux/nfsd/nfsd.h>
>  #include <linux/lockd/lockd.h>
>  #include <linux/lockd/share.h>
>  
> diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
> index e1d28dd..56c9519 100644
> --- a/fs/lockd/svcproc.c
> +++ b/fs/lockd/svcproc.c
> @@ -11,10 +11,6 @@
>  #include <linux/time.h>
>  #include <linux/slab.h>
>  #include <linux/smp_lock.h>
> -#include <linux/in.h>
> -#include <linux/sunrpc/svc.h>
> -#include <linux/sunrpc/clnt.h>
> -#include <linux/nfsd/nfsd.h>
>  #include <linux/lockd/lockd.h>
>  #include <linux/lockd/share.h>
>  
> -- 
> 1.6.5.2
> 
> 
