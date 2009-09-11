Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZIKOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZIKOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZIKOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:39:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:36819 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbZIKOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:39:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,370,1249282800"; 
   d="scan'208";a="186608456"
Date: Fri, 11 Sep 2009 22:39:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090911143929.GA25499@localhost>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911142926.GI14984@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:29:26PM +0800, Jens Axboe wrote:
> On Fri, Sep 11 2009, Christoph Hellwig wrote:
> > On Fri, Sep 11, 2009 at 09:42:41AM -0400, Theodore Tso wrote:
> > > > v19 include:
> > > > 
> > > > - Drop the max writeback pages patch from Ted. I think we should do
> > > >   something to that effect, but there's really no reason to entangle
> > > >   it with this patchset.
> > > 
> > > That's reasonable, but I'd really like to know whether some VM hacker
> > > going to try to deal with this during the 2.6.32 window?  Such as
> > > maybe Wu Fengguang's patches, perhaps?  
> > > 
> > > Or do I need to put in some kind of hack into ext4 ala what XFS did to
> > > work around this problem until we can come up with a longer-term fix?
> > 
> > I defintively want to see something in the VM, but I also agree with
> > Jens' decision not to include it in the patchkit.  It's not really
> > related to the patchkit except for depending on it, and we still
> > have a lot of discussion going on.  If we can't get an agreement with
> > the VM people by the end of the regular merge window I'm all for pushing
> > your simple patch.
> 
> I'd also appreciate if we can keep Wu (or Ted's) patch out of the merge
> until after -rc1 or at least with a few -git releases in between, so
> it'll be easier to check for regressions.

That would be good. Sorry for the late work. I'll allocate some time
in mid next week to help review and benchmark recent writeback works,
and hope to get things done in this merge window.

Thanks,
Fengguang
