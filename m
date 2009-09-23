Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZIWHLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZIWHLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZIWHLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:11:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42574 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZIWHLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:11:49 -0400
Date: Wed, 23 Sep 2009 09:11:52 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@lists.linbit.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: block tree build failure
Message-ID: <20090923071152.GA8000@barkeeper1-xen.linbit>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	drbd-dev@lists.linbit.com, Christoph Hellwig <hch@lst.de>
References: <20090923145100.1917fdd8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090923145100.1917fdd8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 02:51:00PM +1000, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_tracing.c:29:26: error: linux/marker.h: No such file or directory
> 
> Caused by commit 95eaef1cbc63f73df4ff8559dd66b1d29b462535 ("Replaced our
> own tracing stuff with Linux's tracepoints") from the block/drbd trees
> interacting with commit fc5377668c3d808e1d53c4aee152c836f55c3490
> ("tracing: Remove markers") from Linus' tree.
> 
> I have no idea what the correct thing to do is here, so I have reverted
> the merge of the drbd tree into the block tree and will have to drop the
> drbd tree for today.

We'll have a look.
A quick fix should be to just disable CONFIG_DRBD_TRACE.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
