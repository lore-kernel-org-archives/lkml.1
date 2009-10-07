Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZJGOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZJGOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZJGOp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:45:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:17370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbZJGOp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,519,1249282800"; 
   d="scan'208";a="196092253"
Date: Wed, 7 Oct 2009 22:45:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] some writeback experiments
Message-ID: <20091007144502.GB8622@localhost>
References: <20091007073818.318088777@intel.com> <20091007142632.GM17883@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007142632.GM17883@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 10:26:32PM +0800, Theodore Ts'o wrote:
> On Wed, Oct 07, 2009 at 03:38:18PM +0800, Wu Fengguang wrote:
> > 
> > The estimated writeback bandwidth is about 1/2 the real throughput
> > for ext2/3/4 and btrfs; noticeable bigger than real throughput for NFS; and
> > cannot be estimated at all for XFS.  Very interesting..
> 
> Can you expand on what you mean here?  Estimated write bandwidth of
> what?  And what are you comparing it against?
 
Please refer to [PATCH 21/45] writeback: estimate bdi write bandwidth
and patch 22, I have some numbers there :)

> I'm having trouble understanding your note (which I'm guessing you
> write fairly late at night?  :-)

Sorry - I wrote that when I got tired on debugging ;)

Thanks,
Fengguang

