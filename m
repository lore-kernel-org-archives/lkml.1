Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZIAMFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZIAMFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZIAMFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:05:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37371 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZIAMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:05:09 -0400
Date: Tue, 1 Sep 2009 14:05:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: move super_block argument to struct
	writeback_control
Message-ID: <20090901120511.GZ12579@kernel.dk>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-2-git-send-email-jens.axboe@oracle.com> <20090901115551.GA727@mit.edu> <20090901115702.GB727@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901115702.GB727@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01 2009, Theodore Tso wrote:
> On Tue, Sep 01, 2009 at 07:55:51AM -0400, Theodore Tso wrote:
> > 
> > I just tried compiling per-bdi v15 against the latest git HEAD, and
> > the compilation failed:
> 
> Oops, never mind.  I just realized you had already fixed this in v16.

Yeah, I didn't realize we had out-of-core callers of
generic_sync_sb_inodes(), should be alright now :-)

-- 
Jens Axboe

