Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZFWLR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZFWLR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZFWLRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:17:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZFWLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:17:51 -0400
Date: Tue, 23 Jun 2009 07:17:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623111752.GA23813@infradead.org>
References: <20090623081156.GT31415@kernel.dk> <20090623110933.GA16565@infradead.org> <20090623111209.GZ31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623111209.GZ31415@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:12:10PM +0200, Jens Axboe wrote:
> > Last time we discussed this you said you're happy with 2.6.32.  I really
> > want to take a more detailed look and put that on the not so urgent list
> > because ou didn't seem to rush for .31.  So my vote goes for waiting a
> > bit longer.
> 
> Yeah, 2.6.32 works for me too, .31 would have been nice though so I
> don't have to carry it around anymore. But either is fine, if you and
> Andrew want more time to review this stuff, then lets just settle for
> .32.

Yes, I'd really prefer more time.  I also expect to come up with some
more changes in that area.  Your patch makes the differences between
kupdate and pdflush-stye writeback look even more ugly then it already
is, so I want to see i there's some nicer way to handle it.  I also want
to take a look if it makes sense to distangle data integrity and
background writeback somehow.

