Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbYDVCLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbYDVCLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYDVCLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:11:31 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:59999 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbYDVCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:11:30 -0400
Date: Mon, 21 Apr 2008 22:11:03 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] omfs: add inode routines
Message-ID: <20080422021103.GA9730@hash.localnet>
References: <1208637457-24969-4-git-send-email-me@bobcopeland.com> <E1Jnxhm-0002we-Tx@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jnxhm-0002we-Tx@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:13:18PM +0200, Miklos Szeredi wrote:
> > +	if (sbi->s_num_blocks != be64_to_cpu(omfs_rb->r_num_blocks)) {
> > +		printk(KERN_ERR "omfs: block count discrepancy between "
> > +			"super and root blocks (%llx, %llx)\n",
> > +			sbi->s_num_blocks, be64_to_cpu(omfs_rb->r_num_blocks));
> > +		goto out_bh;
> 
> Jump to wrong label.
> 
> Also label names are a bit chaotic.  But that's a matter of taste...

Thanks, fixed and I changed the label names to e.g. out_brelse_bh2.

-- 
Bob Copeland %% www.bobcopeland.com 

