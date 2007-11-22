Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbXKVEJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbXKVEJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 23:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXKVEIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 23:08:55 -0500
Received: from fallback.mail.ru ([194.67.57.14]:32337 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbXKVEIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 23:08:54 -0500
Date: Thu, 22 Nov 2007 07:02:17 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/59] fs/ufs: Add missing "space"
Message-ID: <20071122040213.GA9896@rain>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <1195523627-15389-7-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195523627-15389-7-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:53:36PM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ufs/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
> index 30f8c2b..d19dfe8 100644
> --- a/fs/ufs/dir.c
> +++ b/fs/ufs/dir.c
> @@ -180,7 +180,7 @@ bad_entry:
>  Eend:
>  	p = (struct ufs_dir_entry *)(kaddr + offs);
>  	ufs_error (sb, "ext2_check_page",

If you touch this code, it will be good,
if you also replace "ext2_check_page" with something like __FUNCTION__.

> -		   "entry in directory #%lu spans the page boundary"
> +		   "entry in directory #%lu spans the page boundary "
>  		   "offset=%lu",
>  		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
>  fail:
> -- 
> 1.5.3.5.652.gf192c

-- 
/Evgeniy

