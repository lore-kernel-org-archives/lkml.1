Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYHBNYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYHBNYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYHBNYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:24:41 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:44561 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYHBNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:24:40 -0400
Date: Sat, 2 Aug 2008 09:24:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] omfs: fix warning
Message-ID: <20080802132410.GA18961@hash.localnet>
References: <20080802080725.GA4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802080725.GA4856@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 12:07:25PM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> omfs: fix warnings
> 
> fs/omfs/inode.c:495: warning: format '%llx' expects type 'long long
> 	unsigned int', but argument 2 has type 'u64'
> fs/omfs/inode.c:495: warning: format '%llx' expects type 'long
> 	long unsigned int', but argument 3 has type '__be64'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Bob Copeland <me@bobcopeland.com>

Thanks!

Acked-by: Bob Copeland <me@bobcopeland.com>

(And I'm downloading cross compilers as I type this.)

Andrew, should I continue to send omfs patches through you, or do I need
to publish a git repo?

>  			"super and root blocks (%llx, %llx)\n",
> -			sbi->s_num_blocks, be64_to_cpu(omfs_rb->r_num_blocks));
> +			(unsigned long long)sbi->s_num_blocks,
> +			(unsigned long long)be64_to_cpu(omfs_rb->r_num_blocks));
>  		goto out_brelse_bh2;

-- 
Bob Copeland %% www.bobcopeland.com

