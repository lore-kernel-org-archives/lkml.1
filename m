Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZDFV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZDFV0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZDFV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:26:27 -0400
Received: from THUNK.ORG ([69.25.196.29]:36902 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZDFV00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:26:26 -0400
Date: Mon, 6 Apr 2009 17:26:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406212615.GC8586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <alpine.LFD.2.00.0904061300310.6058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904061300310.6058@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 01:10:50PM -0700, Linus Torvalds wrote:
> where basically each 'sync' on the big file triggers that 15-20s total 
> failure. I do wonder if it's actually gotten _worse_ for the data=ordered 
> case, but at the same time it does make a pretty compelling argument for 
> switching the defaults around.

My first set of patches that I pushed to you were designed to fix
things for data=ordered, and did result in improvements for 2.6.29
versus 2.6.29+ext3-latency-fixes in the data=ordered case.  (It was
only in the last day or two that I switched to focusing on improving
things for data=writeback mode.)

I haven't benchmarked 2.6.29 versus 2.6.29 plus *all* of the recent
latency fixes with data=ordered, but I would expect that timings are
the same or better.

					- Ted
