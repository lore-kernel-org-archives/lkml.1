Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbZAHUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbZAHUWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZAHUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:22:46 -0500
Received: from mail.fieldses.org ([141.211.133.115]:44199 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZAHUWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:22:45 -0500
Date: Thu, 8 Jan 2009 15:22:41 -0500
To: James Lentini <jlentini@netapp.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS/RDMA documentation update
Message-ID: <20090108202241.GC19312@fieldses.org>
References: <alpine.LFD.2.00.0901081309060.3209@jlentini-linux.nane.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901081309060.3209@jlentini-linux.nane.netapp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 01:13:26PM -0500, James Lentini wrote:
> 
> Bruce,
> 
> Please consider this patch for 2.6.29:
> 
> Update the NFS/RDMA documentation to use the new port number assigned 
> by IANA.

Applied, thanks!--b.

> 
> Signed-off-by: James Lentini <jlentini@netapp.com>
> ---
> 
>  nfs-rdma.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/Documentation/filesystems/nfs-rdma.txt	2008-12-24 18:26:37.000000000 -0500
> +++ b/Documentation/filesystems/nfs-rdma.txt	2009-01-08 09:52:32.193769000 -0500
> @@ -251,7 +251,7 @@
>  
>      Instruct the server to listen on the RDMA transport:
>  
> -    $ echo rdma 2050 > /proc/fs/nfsd/portlist
> +    $ echo rdma 20049 > /proc/fs/nfsd/portlist
>  
>    - On the client system
>  
> @@ -263,7 +263,7 @@
>      Regardless of how the client was built (module or built-in), use this
>      command to mount the NFS/RDMA server:
>  
> -    $ mount -o rdma,port=2050 <IPoIB-server-name-or-address>:/<export> /mnt
> +    $ mount -o rdma,port=20049 <IPoIB-server-name-or-address>:/<export> /mnt
>  
>      To verify that the mount is using RDMA, run "cat /proc/mounts" and check
>      the "proto" field for the given mount.
