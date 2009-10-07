Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZJGO1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZJGO1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbZJGO1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:27:38 -0400
Received: from thunk.org ([69.25.196.29]:49445 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287AbZJGO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:27:37 -0400
Date: Wed, 7 Oct 2009 10:26:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20091007142632.GM17883@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Li Shaohua <shaohua.li@intel.com>,
	Myklebust Trond <Trond.Myklebust@netapp.com>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>,
	Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20091007073818.318088777@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007073818.318088777@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 03:38:18PM +0800, Wu Fengguang wrote:
> 
> The estimated writeback bandwidth is about 1/2 the real throughput
> for ext2/3/4 and btrfs; noticeable bigger than real throughput for NFS; and
> cannot be estimated at all for XFS.  Very interesting..

Can you expand on what you mean here?  Estimated write bandwidth of
what?  And what are you comparing it against?

I'm having trouble understanding your note (which I'm guessing you
write fairly late at night?  :-)

Thanks,

						- Ted
