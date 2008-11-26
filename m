Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYKZQW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYKZQW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYKZQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:22:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYKZQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:22:17 -0500
Date: Wed, 26 Nov 2008 11:22:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [XFS] fix sparse warning
Message-ID: <20081126162214.GA10251@infradead.org>
References: <154e089b0811260754y191856bfl522f33febfc6e633@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811260754y191856bfl522f33febfc6e633@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 04:54:53PM +0100, Hannes Eder wrote:
> Impact: fix sparse warning
> 
> Fix the following sparse warning:
> 
>   fs/xfs/xfs_inode.h:326:2: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  fs/xfs/xfs_inode.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c6e295e..7a828cb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -323,7 +323,7 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
>  static inline void xfs_destroy_inode(struct xfs_inode *ip)
>  {
>  	make_bad_inode(VFS_I(ip));
> -	return destroy_inode(VFS_I(ip));
> +	destroy_inode(VFS_I(ip));
>  }

Yes, this makes sense.  Thanks for the patch.
