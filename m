Return-Path: <linux-kernel-owner+w=401wt.eu-S966971AbXHGVqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966971AbXHGVqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965837AbXHGVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:21:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34025 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965825AbXHGVVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:21:30 -0400
Subject: Re: [Jfs-discussion] [PATCH 15/25] JFS: call attr_kill_to_mode
	from jfs_setattr
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <200708061354.l76DsoWh002331@dantu.rdu.redhat.com>
References: <200708061354.l76DsoWh002331@dantu.rdu.redhat.com>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 16:21:27 -0500
Message-Id: <1186521687.30743.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 09:54 -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/jfs/acl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
> index 4d84bdc..34ca314 100644
> --- a/fs/jfs/acl.c
> +++ b/fs/jfs/acl.c
> @@ -227,6 +227,8 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
>  	struct inode *inode = dentry->d_inode;
>  	int rc;
> 
> +	attr_kill_to_mode(inode, iattr);
> +
>  	rc = inode_change_ok(inode, iattr);
>  	if (rc)
>  		return rc;
-- 
David Kleikamp
IBM Linux Technology Center

