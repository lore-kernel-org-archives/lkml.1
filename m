Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0BHThd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:37:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab0BHTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:37:29 -0500
Date: Mon, 8 Feb 2010 14:37:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Julia Lawall <julia@diku.dk>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/11] fs/xfs: Correct NULL test
Message-ID: <20100208193726.GB9527@infradead.org>
References: <Pine.LNX.4.64.1002060944580.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002060944580.8092@ask.diku.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 09:45:15AM +0100, Julia Lawall wrote:
> diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
> index 11cfd82..4318cd5 100644
> --- a/fs/xfs/quota/xfs_qm.c
> +++ b/fs/xfs/quota/xfs_qm.c
> @@ -123,7 +123,7 @@ xfs_Gqm_init(void)
>  		goto out;
>  
>  	gdqhash = kmem_zalloc_large(hsize);
> -	if (!udqhash)
> +	if (!gdqhash)
>  		goto out_free_udqhash;

Thanks, this looks correct,


Reviewed-by: Christoph Hellwig <hch@lst.de>
