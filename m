Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZI0Wev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZI0Wev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZI0Wev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 18:34:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbZI0Weu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 18:34:50 -0400
Date: Sun, 27 Sep 2009 15:34:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc1
Message-ID: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been two weeks (and then some - but with last week being LinuxCon and 
Plumbers conf I extended it by a few days), and as usual that means that 
the merge window is all over and done with. 2.6.32-rc1 is out, so give it 
a whirl.

What can I say? 67% drivers (the bulk of which is from 'staging', but 
there's driver changes all over), 10% firmware, 10% arch updates 
(dominated by arm, but MIPS, POWER, SH and x86 updates are there too, 
along with the new 'SCore' architecture), 5% Documentation, and a random 
smattering of other things (ie the normal filesystem, kernel, networking 
etc updates).

For a change, I don't think we have a single new filesystem this time 
around, but we do have updates to existing ones (ocfs2, btrfs, nfs, nilfs, 
xfs, gfs2, ext4 - you name it).

Some of the more interesting changes (but perhaps that's just me) are some 
of the VM updates (ZERO_PAGE is back!) and the writeback work by Jens and 
others to spread out writeback by backing store. 

Go wild, test it out, and let us know about any regressions you find,

		Linus
