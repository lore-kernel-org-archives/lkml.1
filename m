Return-Path: <linux-kernel-owner+w=401wt.eu-S1763922AbXKNFlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763922AbXKNFlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbXKNFlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:41:14 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51843 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbXKNFlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:41:13 -0500
Message-ID: <473A83CF.90104@linux.vnet.ibm.com>
Date: Wed, 14 Nov 2007 10:42:47 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net, apw@shadowen.org
Subject: Re: [PATCH] 2.6.24-rc2-mm1 - Build fails - in nsfd/vfs.c
References: <20071114044904.GA12453@linux.vnet.ibm.com>
In-Reply-To: <20071114044904.GA12453@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The Kernel build fails, with error
> 
>   CC      fs/nfsd/vfs.o
> fs/nfsd/vfs.c: In function ‘nfsd_rename’:
> fs/nfsd/vfs.c:1695: error: request for member ‘mnt’ in something not a structure or union
> make[2]: *** [fs/nfsd/vfs.o] Error 1
> make[1]: *** [fs/nfsd] Error 2
> make: *** [fs] Error 2
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.24-rc2/fs/nfsd/vfs.c	2007-11-13 22:16:18.000000000 -0500
> +++ linux-2.6.24-rc2/fs/nfsd/~vfs.c	2007-11-13 23:10:18.000000000 -0500
> @@ -1692,7 +1692,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
>  		if (!host_err)
>  			host_err = nfsd_sync_dir(fdentry);
>  	}
> -	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
> +	mnt_drop_write(ffhp->fh_export->ex_mnt);
> 
>   out_dput_new:
>  	dput(ndentry);
> 
Sorry, for the report, its compiles fine, my box had the wrong
mm patches.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
