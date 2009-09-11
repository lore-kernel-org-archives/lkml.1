Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZIKO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZIKO3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZIKO3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:29:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZIKO3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:29:24 -0400
Date: Fri, 11 Sep 2009 16:29:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, jack@suse.cz,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090911142926.GI14984@kernel.dk>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911141659.GA3508@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Christoph Hellwig wrote:
> On Fri, Sep 11, 2009 at 09:42:41AM -0400, Theodore Tso wrote:
> > > v19 include:
> > > 
> > > - Drop the max writeback pages patch from Ted. I think we should do
> > >   something to that effect, but there's really no reason to entangle
> > >   it with this patchset.
> > 
> > That's reasonable, but I'd really like to know whether some VM hacker
> > going to try to deal with this during the 2.6.32 window?  Such as
> > maybe Wu Fengguang's patches, perhaps?  
> > 
> > Or do I need to put in some kind of hack into ext4 ala what XFS did to
> > work around this problem until we can come up with a longer-term fix?
> 
> I defintively want to see something in the VM, but I also agree with
> Jens' decision not to include it in the patchkit.  It's not really
> related to the patchkit except for depending on it, and we still
> have a lot of discussion going on.  If we can't get an agreement with
> the VM people by the end of the regular merge window I'm all for pushing
> your simple patch.

I'd also appreciate if we can keep Wu (or Ted's) patch out of the merge
until after -rc1 or at least with a few -git releases in between, so
it'll be easier to check for regressions.

-- 
Jens Axboe

