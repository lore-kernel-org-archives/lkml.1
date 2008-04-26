Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbYDZA3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbYDZA3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbYDZA3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:29:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26568 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834AbYDZA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:29:08 -0400
Date: Fri, 25 Apr 2008 17:20:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com, Alexander van Heukelum <heukelum@fastmail.fm>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
Message-Id: <20080425172023.cbf34a68.randy.dunlap@oracle.com>
In-Reply-To: <20080425191830.GA4898@martell.zuzino.mipt.ru>
References: <20080425090901.ca642c4d.randy.dunlap@oracle.com>
	<48121331.1030204@cosmosbay.com>
	<1209145675.2005.1249890339@webmail.messagingengine.com>
	<48121A37.5020504@cosmosbay.com>
	<20080425191830.GA4898@martell.zuzino.mipt.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 23:18:30 +0400 Alexey Dobriyan wrote:

> [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
> 
> Bug introduces in commit eb01c9cd87c7a9998c2edf209721ea069e3e3652
> aka "[XFS] Remove the xlog_ticket allocator"
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com> // and tested-by

> ---
> 
>  fs/xfs/xfs_vfsops.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/xfs/xfs_vfsops.c
> +++ b/fs/xfs/xfs_vfsops.c
> @@ -186,6 +186,7 @@ xfs_cleanup(void)
>  	kmem_zone_destroy(xfs_efi_zone);
>  	kmem_zone_destroy(xfs_ifork_zone);
>  	kmem_zone_destroy(xfs_ili_zone);
> +	kmem_zone_destroy(xfs_log_ticket_zone);
>  }
>  
>  /*

---
~Randy
