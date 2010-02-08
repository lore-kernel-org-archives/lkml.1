Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0BHIhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:37:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0BHIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:37:39 -0500
Date: Mon, 8 Feb 2010 00:37:06 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: dhowells@redhat.com, adkulkar@umail.iu.edu, arjan@infradead.org,
       adobriyan@gmail.com
Subject: Re: [PATCH] remove EXPERIMENTAL from NFS_FSCACHE
In-Reply-To: <alpine.DEB.2.01.1002031037280.3483@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.1002080036300.27799@bogon.housecafe.de>
References: <alpine.DEB.2.01.1002031037280.3483@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19eY+ab45kyiuc0nF0Tdo0JhNhOaDExNwUilNa
 g9ACQK9Jx5SISsQ4vObCpzIxPjA/NzASSyPM94Co1P/RbjU7Ub
 1KferqsI9mebGoNroj7CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 at 10:53, Christian Kujau wrote:
> there's currently an open Ubuntu bug[0], with the intent to compile 
> NFS_FSCACHE (and possibly AFS_FSCACHE, 9P_FSCACHE) into the standard 
> Ubuntu kernel. However, since *_FSCACHE still depends on EXPERIMENTAL, 
> this won't happen.
> 
> As Arjan van de Ven pointed out[1], the EXPERIMENTAL flag doesn't mean 
> that much any more, I propose the following patch to fs/nfs/Kconfig. I'd 
> do the same for fs/9p/Kconfig and fs/afs/Kconfig, but as I did not test 9p 
> or AFS, I feel it would not be appropriate for me to remove the flag.

....ping?

>
> Please consider applying.
> 
> Thanks,
> Christian.
> 
> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/440522/comments/5
> [1] http://lkml.org/lkml/2010/1/23/145
> 
> Signed-off-by: Christian Kujau <lists@nerdbynature.de>
> 
>  Kconfig |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
> index 59e5673..a43d07e 100644
> --- a/fs/nfs/Kconfig
> +++ b/fs/nfs/Kconfig
> @@ -95,8 +95,7 @@ config ROOT_NFS
>  	  Most people say N here.
>  
>  config NFS_FSCACHE
> -	bool "Provide NFS client caching support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	bool "Provide NFS client caching support"
>  	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
>  	help
>  	  Say Y here if you want NFS data to be cached locally on disc through
> 
> -- 
> BOFH excuse #259:
> 
> Someone's tie is caught in the printer, and if anything else gets printed, he'll be in it too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
BOFH excuse #258:

That's easy to fix, but I can't be bothered.
