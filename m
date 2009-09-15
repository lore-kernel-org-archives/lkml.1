Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZIOGXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZIOGXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZIOGXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:23:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47894 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbZIOGXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:23:03 -0400
Date: Tue, 15 Sep 2009 08:23:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: linux-next: drbd tree build failure
Message-ID: <20090915062306.GP14984@kernel.dk>
References: <20090915160739.86e85ab3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915160739.86e85ab3.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Stephen Rothwell wrote:
> Hi Philipp,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> drivers/block/drbd/drbd_req.c:45: error: lvalue required as increment operand
> drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> drivers/block/drbd/drbd_req.c:58: error: lvalue required as decrement operand
> 
> Caused by commit 954749162c98ca45c42cbc00c9ed6d5d6c0b8bb7 ("DRBD:
> request") from the drbd tree interacting with commit
> a9327cac440be4d8333bba975cbbf76045096275 ("Seperate read and write
> statistics of in_flight requests") from the block tree.
> 
> I have applied the following merge fix for today, but there may be a
> better fix.

Fix looks correct.

-- 
Jens Axboe

