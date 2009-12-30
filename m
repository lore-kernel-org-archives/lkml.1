Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZL3TKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZL3TKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZL3TKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:10:52 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37011 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZL3TKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:10:52 -0500
Date: Wed, 30 Dec 2009 20:10:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: discard use gfp_mask
Message-ID: <20091230191050.GH4489@kernel.dk>
References: <alpine.LSU.2.00.0912301900460.25340@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0912301900460.25340@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Hugh Dickins wrote:
> blkdev_issue_discard() takes a gfp_mask argument: usually GFP_KERNEL,
> but GFP_NOIO from swap and GFP_NOFS from gfs2.  blkdev_issue_discard()
> should use that for its alloc_page(), instead of assuming GFP_KERNEL.

An identical patch from OGAWA Hirofumi is already included in my current
tree. Linus hasn't pulled it yet, but I did send out a request
yesterday. So hopefully it'll show up in a -git near you soon :-)

-- 
Jens Axboe

