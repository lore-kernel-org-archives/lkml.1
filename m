Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXFRTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXFRTqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763197AbXFRTqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:46:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27030 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763046AbXFRTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:46:25 -0400
Date: Mon, 18 Jun 2007 21:46:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] Kill blk_congestion_wait() stub for !CONFIG_BLOCK
Message-ID: <20070618194601.GB6149@kernel.dk>
References: <20070618194249.7946.30327.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618194249.7946.30327.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18 2007, Benjamin Gilbert wrote:
> blk_congestion_wait() doesn't exist anymore, but there's still a stub
> in blkdev.h for the !CONFIG_BLOCK case.  Kill it.
> 
> Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>

Thanks, applied.

-- 
Jens Axboe

