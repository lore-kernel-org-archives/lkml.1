Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbZDJUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbZDJUQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbZDJUQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:16:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60100 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbZDJUQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:16:39 -0400
Date: Fri, 10 Apr 2009 21:16:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded (shmem)
In-Reply-To: <20090410130009.caf2285b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0904102111220.13548@blonde.anvils>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
 <49DFA3B3.3080003@oracle.com> <20090410130009.caf2285b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Andrew Morton wrote:
> On Fri, 10 Apr 2009 12:53:23 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > mm/shmem.c: In function 'shmem_file_setup':
> > mm/shmem.c:2622: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
> 
> Thanks.

Thanks Randy, thanks Andrew: sorry about that,
seems I only tested !CONFIG_SHMEM on 64-bit.

Hugh

> 
> --- a/mm/shmem.c~shmem-respect-max_lfs_filesize-fix
> +++ a/mm/shmem.c
> @@ -24,6 +24,7 @@
>  #include <linux/init.h>
>  #include <linux/vfs.h>
>  #include <linux/mount.h>
> +#include <linux/pagemap.h>
>  #include <linux/file.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> _
