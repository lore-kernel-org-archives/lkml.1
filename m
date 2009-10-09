Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZJILBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZJILBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZJILBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:01:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37131 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbZJILBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:01:37 -0400
Date: Fri, 9 Oct 2009 13:01:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>, Jan Kara <jack@suse.cz>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: account IO throttling wait as iowait
Message-ID: <20091009110059.GA9228@kernel.dk>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com> <20091008015822.GB14224@localhost> <1254989316.26976.260.camel@twins> <20091008083609.GA9228@kernel.dk> <20091009025235.GA28640@localhost> <20091009104105.GY9228@kernel.dk> <20091009105847.GA16235@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009105847.GA16235@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Wu Fengguang wrote:
> On Fri, Oct 09, 2009 at 06:41:05PM +0800, Jens Axboe wrote:
> > > ---
> > > writeback: account IO throttling wait as iowait
> > > 
> > > It makes sense to do IOWAIT when someone is blocked
> > > due to IO throttle, as suggested by Kame and Peter.
> > > 
> > > There is an old comment for not doing IOWAIT on throttle,
> > > however it has been mismatching the code for a long time.
> > > 
> > > If we stop accounting IOWAIT for 2.6.32, it could be an
> > > undesirable behavior change. So restore the io_schedule.
> > 
> > Thanks, queued up.
> 
> Thank you. Would you also pick up this one if it's OK to you?

Sure, looks appropriate.

-- 
Jens Axboe

