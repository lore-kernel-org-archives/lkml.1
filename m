Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbYA2Aa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbYA2Aa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYA2AaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:30:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34625 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYA2AaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:30:09 -0500
Date: Tue, 29 Jan 2008 00:29:58 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport sys_{open,read}
Message-ID: <20080129002958.GA32567@infradead.org>
References: <20080128221040.GQ8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128221040.GQ8767@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:10:40AM +0200, Adrian Bunk wrote:
> Now that they are unused we can finally unexport sys_{open,read}.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Linus. any reason this is not in? 

> 
>  fs/open.c       |    1 -
>  fs/read_write.c |    1 -
>  2 files changed, 2 deletions(-)
> 
> eb86553917b5d7dc5c22e584145360ad0460372e 
> diff --git a/fs/open.c b/fs/open.c
> index 4932b4d..21acf85 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1061,7 +1061,6 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
>  	prevent_tail_call(ret);
>  	return ret;
>  }
> -EXPORT_UNUSED_SYMBOL_GPL(sys_open); /* To be deleted for 2.6.25 */
>  
>  asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
>  			   int mode)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index c4d3d17..af2c82f 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -366,7 +366,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
>  
>  	return ret;
>  }
> -EXPORT_UNUSED_SYMBOL_GPL(sys_read); /* to be deleted for 2.6.25 */
>  
>  asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
