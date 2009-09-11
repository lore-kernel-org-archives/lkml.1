Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZIKSBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZIKSBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZIKSBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:01:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbZIKSBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:01:03 -0400
Date: Fri, 11 Sep 2009 14:01:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 2/4] Assign bdi in super_block
Message-ID: <20090911180106.GB19598@infradead.org>
References: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com> <1252669832-13553-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252669832-13553-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 01:50:30PM +0200, Jens Axboe wrote:
> We do this automatically in get_sb_bdev() from the set_bdev_super()
> callback. Filesystems that have their own private backing_dev_info
> must assign that in ->fill_super().
> 
> Note that ->s_bdi assignment is required for proper writeback!

Looks good to me.   Can we get rid of BDI_CAP_NO_WRITEBACK with this by
simply not assigning a bdi?

