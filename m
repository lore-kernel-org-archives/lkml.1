Return-Path: <linux-kernel-owner+w=401wt.eu-S934848AbYBMV73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848AbYBMV73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933432AbYBMViO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:38:14 -0500
Received: from mail.fieldses.org ([66.93.2.214]:45169 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765830AbYBMViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:38:12 -0500
Date: Wed, 13 Feb 2008 16:38:09 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make nfsd_create_setattr() static
Message-ID: <20080213213809.GC29590@fieldses.org>
References: <20080213213026.GD3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213213026.GD3383@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:30:26PM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global nfsd_create_setattr() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, applied.--b.

> 
> ---
> 7cfb17a22a0cf76477fbf1fbe6bf586108a13a44 diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index cc75e4f..035204f 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1151,7 +1151,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  }
>  #endif /* CONFIG_NFSD_V3 */
>  
> -__be32
> +static __be32
>  nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
>  			struct iattr *iap)
>  {
> 
