Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZIJHYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZIJHYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZIJHYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:24:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47569 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZIJHYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:24:04 -0400
Date: Thu, 10 Sep 2009 09:24:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ed Cashin <ecashin@coraid.com>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20090910072407.GO18599@kernel.dk>
References: <20090910144801.2b604ee7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910144801.2b604ee7.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/block/aoe/aoeblk.c between commit
> 7135a71b19be1faf48b7148d77844d03bc0717d6 ("aoe: allocate unused
> request_queue for sysfs") from Linus' tree and commit
> 5063fe01e7dc205ebca89877f8eb01d6a5b0ebd6 ("writeback: add name to
> backing_dev_info") from the block tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

Thanks, I'll update my for-2.6.32 branch today and let that propagate
into for-next to resolve this.

-- 
Jens Axboe

