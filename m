Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZCERng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZCERng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZCERnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:43:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34576 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754133AbZCERnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:43:23 -0500
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Message-Id: <4BC7466E-89A4-44E3-8189-C5531F994D73@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Hannes Eder <hannes@hanneseder.net>
In-Reply-To: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 0/3] xfs: fix sparse warnings
Date: Thu, 5 Mar 2009 11:43:20 -0600
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4, 2009, at 12:33 PM, Hannes Eder wrote:

> The following series fixes a fair amount of the remaining sparse
> warnings in fs/xfs with !CONFIG_XFS_DEBUG.
>
> With CONFIG_XFS_DEBUG we still got alot of "Should it be static?"
> warnings, but that's a different issue.

Looks good to me with the changes Christoph pointed out.
I'll push it in. Thanks.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> ---
> Hannes Eder (3):
>      xfs: include header files for prototypes
>      xfs: make symbols static
>      xfs: move declaration to header file
>
> fs/xfs/linux-2.6/xfs_ioctl.c |    1 +
> fs/xfs/linux-2.6/xfs_super.c |    6 +++---
> fs/xfs/support/debug.c       |    1 +
> fs/xfs/xfs_bmap.c            |    2 +-
> fs/xfs/xfs_da_btree.h        |    1 +
> fs/xfs/xfs_dir2.c            |    2 --
> fs/xfs/xfs_dir2_leaf.c       |    2 +-
> 7 files changed, 8 insertions(+), 7 deletions(-)

