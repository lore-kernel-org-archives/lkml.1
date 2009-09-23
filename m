Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZIWPFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZIWPFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZIWPFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:05:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42162 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZIWPFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:05:07 -0400
Date: Wed, 23 Sep 2009 17:05:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: stop background writeback when below
	background threshold
Message-ID: <20090923150510.GB23126@kernel.dk>
References: <20090923123337.990689487@intel.com> <20090923124027.589303074@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923124027.589303074@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23 2009, Wu Fengguang wrote:
> Treat bdi_start_writeback(0) as a special request to do background write,
> and stop such work when we are below the background dirty threshold.
> 
> Also simplify the (nr_pages <= 0) checks. Since we already pass in
> nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
> need to worry about it being decreased to zero.

Good cleanup! Do you want me to collect these fixes, or how shall we
handle this?

-- 
Jens Axboe

