Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZJFMwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZJFMwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZJFMwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:52:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34487 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbZJFMwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:52:03 -0400
Date: Tue, 6 Oct 2009 14:51:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091006125125.GU5216@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006102604.GN5216@kernel.dk> <1254827438.21044.251.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254827438.21044.251.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Peter Zijlstra wrote:
> On Tue, 2009-10-06 at 12:26 +0200, Jens Axboe wrote:
> 
> > I did a quick perf analysis on that, but only on 8 clients (64 clients
> > basically causes perf to shit itself, it's just not functional).
> 
> Even when used with -a so that you profile each cpu? I can imagine the
> cacheline contention from the inherited counters to render a 64 thread
> machine less than usable?

No, that's without -a. I used -a for perf top, and that has some impact
on performance while it's running, but millions of miles apart from what
it does without it :-)

-- 
Jens Axboe

