Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZLDMuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZLDMuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbZLDMuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:50:06 -0500
Received: from mail.deathmatch.net ([72.66.92.28]:1660 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbZLDMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:50:05 -0500
Date: Fri, 4 Dec 2009 07:48:42 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Coly Li <coly.li@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] remove compiling warning by adding uninitialized_var()
Message-ID: <20091204124842.GA5982@hash.localnet>
References: <4B180462.4050904@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B180462.4050904@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 02:33:06AM +0800, Coly Li wrote:
> @@ -222,7 +222,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
>  	struct buffer_head *bh;
>  	sector_t next, offset;
>  	int ret;
> -	u64 new_block;
> +	u64 uninitialized_var(new_block);
>  	u32 max_extents;
>  	int extent_count;
>  	struct omfs_extent *oe;

OMFS part -

Reviewed-by: Bob Copeland <me@bobcopeland.com>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

