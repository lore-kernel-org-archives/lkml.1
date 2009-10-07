Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZJGGed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZJGGed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZJGGec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:34:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZJGGeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:34:31 -0400
Date: Wed, 7 Oct 2009 08:33:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20091007063354.GG5216@kernel.dk>
References: <20091007135505.df1f058c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007135505.df1f058c.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> drivers/block/drbd/drbd_req.c:43: error: lvalue required as increment operand
> drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> drivers/block/drbd/drbd_req.c:56: error: lvalue required as decrement operand
> 
> This is back again :-(
> 
> I have used the block tree from next-20091006 for today.  I also had to
> use the device-mapper tree from next-20091006 since that is based on the
> block tree.

Irk darn, I fixed this up. Sorry about that, Stephen. It was due to the
in_flight counter being reverted for -rc3 and now back functional in my
upstream branch.

-- 
Jens Axboe

