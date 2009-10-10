Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZJJNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZJJNs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 09:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761230AbZJJNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 09:48:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:64766 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZJJNsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 09:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,537,1249282800"; 
   d="scan'208";a="197392721"
Date: Sat, 10 Oct 2009 21:47:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/45] writeback: remove unused nonblocking and
	congestion checks
Message-ID: <20091010134738.GA18238@localhost>
References: <20091007073818.318088777@intel.com> <20091007074901.625522882@intel.com> <20091009152629.GH7654@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009152629.GH7654@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:26:29PM +0800, Jan Kara wrote:
> On Wed 07-10-09 15:38:22, Wu Fengguang wrote:
> > - no one is calling wb_writeback and write_cache_pages with
> >   wbc.nonblocking=1 any more
> > - lumpy pageout will want to do nonblocking writeback without the
> >   congestion wait
> > 
> > So remove the congestion checks as suggested by Chris.
>   Looks good. Since encountered_congestion isn't used, you can delete it as
> well... BTW, you might need to split this patch to per-fs chunks for the
> sake of merging.

OK, good suggestions to follow :)

Thanks,
Fengguang
