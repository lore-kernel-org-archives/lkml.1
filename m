Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZINGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZINGZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZINGZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:25:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47168 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZINGZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:25:30 -0400
Date: Mon, 14 Sep 2009 08:25:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ed Cashin <ecashin@coraid.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20090914062532.GS14984@kernel.dk>
References: <20090914142729.beae34fd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914142729.beae34fd.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/aoe/aoeblk.c: In function 'aoeblk_make_request':
> drivers/block/aoe/aoeblk.c:175: error: implicit declaration of function 'bio_barrier'
> 
> Caused by commit c1db2f19f1302e894fe9db818e08fb03e4a84df9 ("aoe: end
> barrier bios with EOPNOTSUPP") interacting with commit
> 1f98a13f623e0ef666690a18c1250335fc6d7ef1 ("bio: first step in sanitizing
> the bio->bi_rw flag testing").
> 
> I have used the version of the block tree from next-20090910 for today.

Fixed.

-- 
Jens Axboe

