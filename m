Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbXHNWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbXHNWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936271AbXHNWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:03:09 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35726 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936388AbXHNWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:03:06 -0400
Date: Tue, 14 Aug 2007 18:02:57 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make fs/nfsd/nfs4callback.c:do_probe_callback()
	static
Message-ID: <20070814220257.GH16376@fieldses.org>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070814212258.GH18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814212258.GH18945@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:22:58PM +0200, Adrian Bunk wrote:
> On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc2-mm1:
> >...
> >  git-nfsd.patch
> >...
> >  git trees
> >...
> 
> 
> do_probe_callback() can become static.

Oops, thanks; applied.--b.

> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 8177c6f652deb91fcb43c8ca86f7703a61468ba9 
> diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
> index afdf66b..c17a520 100644
> --- a/fs/nfsd/nfs4callback.c
> +++ b/fs/nfsd/nfs4callback.c
> @@ -369,7 +369,7 @@ nfsd4_lookupcred(struct nfs4_client *clp, int taskflags)
>  /* Reference counting, callback cleanup, etc., all look racy as heck.
>   * And why is cb_set an atomic? */
>  
> -int do_probe_callback(void *data)
> +static int do_probe_callback(void *data)
>  {
>  	struct nfs4_client *clp = data;
>  	struct nfs4_callback *cb = &clp->cl_callback;
> 
