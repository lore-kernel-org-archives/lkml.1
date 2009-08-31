Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZHaRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZHaRck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZHaRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:32:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60258 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbZHaRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:32:38 -0400
Date: Mon, 31 Aug 2009 19:32:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 06/10] writeback: allow sleepy exit of default
	writeback task
Message-ID: <20090831173240.GZ12579@kernel.dk>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-7-git-send-email-jens.axboe@oracle.com> <20090831130230.GD20465@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831130230.GD20465@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31 2009, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 02:14:47PM +0200, Jens Axboe wrote:
> > Since we do lazy create of default writeback tasks for a bdi, we can
> > allow sleepy exit if it has been completely idle for 5 minutes.
> 
> Any reason this is not merged into patch 2?

Separate functional change, but could easily be merged in #2.

-- 
Jens Axboe

