Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZIWDLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZIWDLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 23:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZIWDLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 23:11:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:40541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbZIWDLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 23:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,435,1249282800"; 
   d="scan'208";a="190599641"
Date: Wed, 23 Sep 2009 11:11:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923031115.GB26530@localhost>
References: <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923024958.GA13205@localhost> <20090922195605.a9a7aca8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922195605.a9a7aca8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:56:05AM +0800, Andrew Morton wrote:
> On Wed, 23 Sep 2009 10:49:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > After the sleep we repoll all queues.
> > 
> > I mean, it is not always necessary. Only when _all_ superblocks cannot
> > writeback their inodes (eg. all in congestion), we should wait.
> 
> Well.  The code will still submit MAX_WRITEBACK_PAGES pages to _some_
> queue in that situation.
> 
> But yup, maybe that's a bug!  Sounds easy to fix.  It doesn't justify
> rewriting the whole world and then saying "look, the new code is faster
> than the old code which had a bug which I knew about but didn't fix".

I didn't submit the patches to avoid conflicts with Jens' work.
Sorry for doing that - that's not good attitude towards bug fixes..

Thanks,
Fengguang

