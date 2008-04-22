Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbYDVBzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbYDVBzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYDVBzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:55:00 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:49951 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYDVBy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:54:59 -0400
Date: Mon, 21 Apr 2008 21:53:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/8] omfs: add file routines
Message-ID: <20080422015342.GA9591@hash.localnet>
References: <1208637457-24969-6-git-send-email-me@bobcopeland.com> <E1JnxxA-0002z2-NY@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JnxxA-0002z2-NY@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:29:12PM +0200, Miklos Szeredi wrote:
> This instead?
> 
> 		if (offset > 0) {
> 			ret = 0;
> 			map_bh(bh_result, inode->i_sb, offset);
> 			if (remain > max_blocks)
> 				remain = max_blocks;
> 			bh_result->b_size = (remain << inode->i_blkbits);
> 			goto out_brelse;
> 		}

Much cleaner, thanks!

-- 
Bob Copeland %% www.bobcopeland.com 

