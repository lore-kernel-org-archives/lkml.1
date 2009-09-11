Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZIKOEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZIKOEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIKOE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:04:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55077 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZIKOE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:04:28 -0400
Date: Fri, 11 Sep 2009 16:04:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090911140431.GF14984@kernel.dk>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911134501.GA24668@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911134501.GA24668@think>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Chris Mason wrote:
> On Fri, Sep 11, 2009 at 09:42:41AM -0400, Theodore Tso wrote:
> > On Fri, Sep 11, 2009 at 09:34:03AM +0200, Jens Axboe wrote:
> > > Hi,
> > > 
> > > (sorry if you receive this twice, the original posting had a mangled
> > >  From address).
> > > 
> > > This is the 20th release of the writeback patchset. Changes since
> > > v19 include:
> > > 
> > > - Drop the max writeback pages patch from Ted. I think we should do
> > >   something to that effect, but there's really no reason to entangle
> > >   it with this patchset.
> > 
> > That's reasonable, but I'd really like to know whether some VM hacker
> > going to try to deal with this during the 2.6.32 window?  Such as
> > maybe Wu Fengguang's patches, perhaps?  
> 
> Wu Fengguang's patches seem very reasonable to me.  My only concern is
> that with tossing it in all at once.  I'd rather seen Jens' work go in
> and then incremental benchmarking done afterward.

OK, if that's the general consensus, then I'll add it back and we can
build from there.

-- 
Jens Axboe

