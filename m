Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbXHODIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbXHODIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 23:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXHODIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 23:08:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:6968 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbXHODIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 23:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nQ4/ZLRWPzOWXWbu9Zu3UgBg4AILJdf2owdYoBx5bCGzbLuoDD08TDzu8TXhkiKpc39fypjTU1khAF/jHV4/nvUnu1i5tYOeOv7VfthU70SzJKf+zIF1fDqcDKW5/9foGEJy0Orh8pzNb0A2sMoJp47Qu6oxQLf2siuchIvbtq8=
Message-ID: <a4e6962a0708142008h395505f6k9967d72bc49cc1ce@mail.gmail.com>
Date: Tue, 14 Aug 2007 22:08:40 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] #if 0 v9fs_fid_lookup_remove()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Latchesar Ionkov" <lucho@ionkov.net>, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070814212624.GA18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070814212624.GA18945@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry- its in my merge queue, but I've been fighting other fires.
Will try and get this regression tested and merged into v9fs-devel
tomorrow afternoon along with a few other patches.

                -eric


On 8/14/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch #if 0's the unused v9fs_fid_lookup_remove().
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
> This patch has been sent on:
> - 29 Jul 2007
>
>  fs/9p/fid.c |    2 ++
>  fs/9p/fid.h |    1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> --- linux-2.6.23-rc1-mm1/fs/9p/fid.h.old        2007-07-26 13:22:00.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/fs/9p/fid.h    2007-07-26 13:22:07.000000000 +0200
> @@ -28,6 +28,5 @@
>  };
>
>  struct p9_fid *v9fs_fid_lookup(struct dentry *dentry);
> -struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry);
>  struct p9_fid *v9fs_fid_clone(struct dentry *dentry);
>  int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid);
> --- linux-2.6.23-rc1-mm1/fs/9p/fid.c.old        2007-07-26 13:22:22.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/fs/9p/fid.c    2007-07-26 13:22:40.000000000 +0200
> @@ -92,6 +92,7 @@
>         return fid;
>  }
>
> +#if 0
>  struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry)
>  {
>         struct p9_fid *fid;
> @@ -107,6 +108,7 @@
>
>         return fid;
>  }
> +#endif  /*  0  */
>
>
>  /**
>
>
