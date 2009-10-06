Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZJFGt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZJFGt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZJFGt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:49:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:52847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbZJFGt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:49:57 -0400
Date: Tue, 6 Oct 2009 08:49:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Latest vfs scalability patch
Message-ID: <20091006064919.GB30316@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Several people have been interested to test my vfs patches, so rather
than resend patches I have uploaded a rollup against Linus's current
head.

ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/

I have used ext2,ext3,autofs4,nfs as well as in-memory filesystems
OK (although this doesn't mean there are no bugs!). Otherwise, if your
filesystem compiles, then there is a reasonable chance of it working,
or ask me and I can try updating it for the new locking.

I would be interested in seeing any numbers people might come up with,
including single-threaded performance.

Thanks, Nick

