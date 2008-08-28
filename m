Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYH1H0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYH1H0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYH1H0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:26:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50041 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYH1H0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:26:23 -0400
Date: Thu, 28 Aug 2008 09:26:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: kmalloc args reversed, small function definition  fixes
Message-ID: <20080828072621.GQ20055@kernel.dk>
References: <1219868669.6069.53.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219868669.6069.53.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27 2008, Harvey Harrison wrote:
> Noticed by sparse:
> block/blk-softirq.c:156:12: warning: symbol 'blk_softirq_init' was not declared. Should it be static?
> block/genhd.c:583:28: warning: function 'bdget_disk' with external linkage has definition
> block/genhd.c:659:17: warning: incorrect type in argument 1 (different base types)
> block/genhd.c:659:17:    expected unsigned int [unsigned] [usertype] size
> block/genhd.c:659:17:    got restricted gfp_t
> block/genhd.c:659:29: warning: incorrect type in argument 2 (different base types)
> block/genhd.c:659:29:    expected restricted gfp_t [usertype] flags
> block/genhd.c:659:29:    got unsigned int
> block: kmalloc args reversed

Woops, that kmalloc() is nasty. Thanks a lot, applied to for-2.6.28.

-- 
Jens Axboe

