Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbXEMDVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbXEMDVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 23:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXEMDVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 23:21:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037AbXEMDVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 23:21:09 -0400
Date: Sat, 12 May 2007 20:20:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22-rc1
Message-ID: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, the merge window has closed, and 2.6.22-rc1 is out there.

The diffstat and shortlogs are way too big to fit under the kernel mailing 
list limits, and the changes are all over the place. Almost seven thousand 
files changed, and that's not double-counting the files that got moved 
around.

Architecture updates, drivers, filesystems, networking, security, build 
scripts, reorganizations, cleanups.. You name it, it's there.

You want a new firewire stack? We've got it. New wireless networking 
infrastructure? Check. New infiniband drivers? Digital video drivers? A 
totally new CPU architecture (blackfin)? Check, check, check.

That said, I think (and certainly hope) that this will not be nearly as 
painful as the big fundamental timer changes for 2.6.21, and while there 
are some pretty core changes there (like the new SLUB allocator, which 
hopefully will end up replacing both SLAB and SLOB), it feels pretty 
solid, and not as scary as ripping the carpet from under the timer 
infrastructure.

So give it a good testing. We'll see how the regression tracking ends up 
working, but in order to actually track that, we want people actively 
testing -rc1 and making good reports!

		Linus
