Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZIXBYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZIXBYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZIXBYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:24:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:39600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZIXBYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,441,1249282800"; 
   d="scan'208";a="191018335"
Date: Thu, 24 Sep 2009 09:24:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: stop background writeback when below
	background threshold
Message-ID: <20090924012405.GA6456@localhost>
References: <20090923123337.990689487@intel.com> <20090923124027.589303074@intel.com> <20090923150510.GB23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923150510.GB23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 11:05:10PM +0800, Jens Axboe wrote:
> On Wed, Sep 23 2009, Wu Fengguang wrote:
> > Treat bdi_start_writeback(0) as a special request to do background write,
> > and stop such work when we are below the background dirty threshold.
> > 
> > Also simplify the (nr_pages <= 0) checks. Since we already pass in
> > nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
> > need to worry about it being decreased to zero.
> 
> Good cleanup! Do you want me to collect these fixes, or how shall we
> handle this?

Thanks. I'm feeling OK with these patches(except the last one) as well
as Jan's busy loop fixing patch. Can you pull them to your tree?

Thanks,
Fengguang
