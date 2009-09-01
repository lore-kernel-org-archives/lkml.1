Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZIAOGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZIAOGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZIAOGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:06:24 -0400
Received: from thunk.org ([69.25.196.29]:40137 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbZIAOGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:06:24 -0400
Date: Tue, 1 Sep 2009 10:06:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: move super_block argument to struct
	writeback_control
Message-ID: <20090901140621.GB13229@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-2-git-send-email-jens.axboe@oracle.com> <20090901115551.GA727@mit.edu> <20090901115702.GB727@mit.edu> <20090901120511.GZ12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901120511.GZ12579@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 02:05:11PM +0200, Jens Axboe wrote:
> On Tue, Sep 01 2009, Theodore Tso wrote:
> > On Tue, Sep 01, 2009 at 07:55:51AM -0400, Theodore Tso wrote:
> > > 
> > > I just tried compiling per-bdi v15 against the latest git HEAD, and
> > > the compilation failed:
> > 
> > Oops, never mind.  I just realized you had already fixed this in v16.
> 
> Yeah, I didn't realize we had out-of-core callers of
> generic_sync_sb_inodes(), should be alright now :-)

I just sent out a call for benchmarking/testing to the ext4 list, and
cc'ed LKML.

    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git test-bdi
    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

This contains the v16 per-bdi patches plus the ext4 patches I plan to
push for 2.6.32.

I'm also running it through XFSQA using ext4; it's been a clean run so
far.

							- Ted


