Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZFWLwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZFWLwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbZFWLwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:52:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55123 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbZFWLwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:52:22 -0400
Date: Tue, 23 Jun 2009 13:52:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623115224.GB31415@kernel.dk>
References: <20090623081156.GT31415@kernel.dk> <20090623110933.GA16565@infradead.org> <20090623111209.GZ31415@kernel.dk> <20090623111752.GA23813@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623111752.GA23813@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23 2009, Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 01:12:10PM +0200, Jens Axboe wrote:
> > > Last time we discussed this you said you're happy with 2.6.32.  I really
> > > want to take a more detailed look and put that on the not so urgent list
> > > because ou didn't seem to rush for .31.  So my vote goes for waiting a
> > > bit longer.
> > 
> > Yeah, 2.6.32 works for me too, .31 would have been nice though so I
> > don't have to carry it around anymore. But either is fine, if you and
> > Andrew want more time to review this stuff, then lets just settle for
> > .32.
> 
> Yes, I'd really prefer more time.  I also expect to come up with some
> more changes in that area.  Your patch makes the differences between
> kupdate and pdflush-stye writeback look even more ugly then it already
> is, so I want to see i there's some nicer way to handle it.  I also want

Good point, should be easy enough to fold the two together.

> to take a look if it makes sense to distangle data integrity and
> background writeback somehow.

That one is also on more list, would make the code flow a lot cleaner I
suspect.

-- 
Jens Axboe

