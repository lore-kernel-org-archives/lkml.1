Return-Path: <linux-kernel-owner+w=401wt.eu-S1946535AbXD3RQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946535AbXD3RQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946558AbXD3RQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:16:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41402 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946547AbXD3RQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:16:24 -0400
Message-ID: <46362463.5010309@garzik.org>
Date: Mon, 30 Apr 2007 13:16:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, Johann Lombardi <johann.lombardi@bull.net>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Dave Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.21-ext4-1
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> I've respun the ext4 development patchset, with Amit's updated fallocate
> patches.  I've added Dave's patch to add ia64 support to the fallocate
> system call, but *not* the XFS fallocate support patches.  (Probably
> better for them to live in an xfs tree, where they can more easily
> tested and updated.)  Yes, we haven't reached complete closure on the
> fallocate system call calling convention, but it's enough for us to get
> more testing in -mm.
> 
> Also added Johann's jbd2-stats-through-procfs patches; it provides
> useful help in turning the size of the journal, which will be useful in
> benchmarking efforts.  In addition, Alex Tomas's patch to free
> just-allocated patches when there is an error inserting the extent into
> the extent tree has also been included.
> 
> The patches have been compile-tested on x86, and compile/run-tested on
> x86/UML.  Would appreciate reports about testing on other platforms.

Why isn't this stuff going upstream rapidly?

AFAICT nothing much at all has happened upstream besides a mass renaming?

The whole point of having ext4 in the kernel is to do development 
upstream, in the public view, getting new stuff in ASAP (even if that 
means changing or pulling some stuff later).

As it stands now, ext4 in the upstream tree is completely useless -- 
it's the same as ext3, and has been for months (since Oct 11).

Hello?  Upstream development?  Ever heard of it?

	Jeff



