Return-Path: <linux-kernel-owner+w=401wt.eu-S935205AbXGMHMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205AbXGMHMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbXGMHMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:12:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758850AbXGMHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:12:33 -0400
Date: Fri, 13 Jul 2007 00:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 015 of 20] knfsd: nfsd4: make readonly access depend on
 pseudoflavor
Message-Id: <20070713001215.b4b57a5b.akpm@linux-foundation.org>
In-Reply-To: <1070710022749.13539@suse.de>
References: <20070710121949.12548.patches@notabene>
	<1070710022749.13539@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:27:49 +1000 NeilBrown <neilb@suse.de> wrote:

> 
> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Allow readonly access to vary depending on the pseudoflavor, using the
> flag passed with each pseudoflavor in the export downcall.
> 
> Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./include/linux/nfsd/export.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff .prev/include/linux/nfsd/export.h ./include/linux/nfsd/export.h
> --- .prev/include/linux/nfsd/export.h	2007-07-10 11:40:31.000000000 +1000
> +++ ./include/linux/nfsd/export.h	2007-07-10 11:50:43.000000000 +1000
> @@ -43,7 +43,7 @@
>  #define NFSEXP_ALLFLAGS		0xFE3F
>  
>  /* The flags that may vary depending on security flavor: */
> -#define NFSEXP_SECINFO_FLAGS	0
> +#define NFSEXP_SECINFO_FLAGS	NFSEXP_READONLY
>  
>  #ifdef __KERNEL__
>  

You have two patches called "knfsd: nfsd4: make readonly access depend on
pseudoflavor".  This one appears to have the wrong title and changelog.
