Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZIKFaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZIKFaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZIKFaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:30:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39189 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZIKFaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:30:10 -0400
Date: Fri, 11 Sep 2009 07:30:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
Message-ID: <20090911053013.GA18599@kernel.dk>
References: <20090911143203.e52e294d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911143203.e52e294d.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/aoe/aoeblk.c: In function 'aoeblk_gdalloc':
> drivers/block/aoe/aoeblk.c:271: error: request for member 'backing_dev_info' in something not a structure or union
> 
> Caused by commit 7cd6134162529e6b7f9eaa5d72b1ef8fe3b355c9 ("writeback:
> add name to backing_dev_info"). 'q->blkq' changed to be a pointer in
> commit 7135a71b19be1faf48b7148d77844d03bc0717d6 ("aoe: allocate unused
> request_queue for sysfs").
> 
> Please be a bit more careful with rebases.

Sorry, I thought I had double checked it... Will fix it now.

> I have used the version of the block tree from next-20090910 for today.

No problem.

-- 
Jens Axboe

