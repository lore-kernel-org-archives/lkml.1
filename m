Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZDHAVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZDHAVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZDHAVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:21:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbZDHAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:21:33 -0400
Date: Tue, 7 Apr 2009 17:20:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.30-rc1
Message-ID: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So the two week merge window has closed, and just as well - because we had 
a lot of changes. As usual. Certainly I had no urges to keep the window 
open to get those last remaining few megabytes of patches..

The changes follow roughly the same pattern they have before: one third 
crap (that is, "staging" - the new random drivers that aren't really ready 
to be merged properly but get into the tree in the hope that they'll get 
better some day), one third real drivers, and one third "rest".

And just to not break a new tradition, there's a few new filesystems in 
this release too:

 - "nilfs2" has been brewing for a long while, and is another 
   log-structured filesystem that does snapshotting. Just google for 
   'nilfs2' for more details.

 - "exofs" implements a filesystem on top of an external object store 
   (ie not a traditional storage of a linear array of anonymous blocks, 
   but a "smart" disk that does objects). See 

		Documentation/filesystems/exofs.txt

   for some details.

 - fscache/cachefiles is not really a filesystem, but infrastructure to do 
   caching of remote filesystems in the local filesystem, and NFS and AFS 
   have been updated to be able to use it.

I'm personally hoping that we'll run out of filesystems rather than 
continue this new tradition indefinitely, but we'll see.

But we've got older filesystems updated too: btrfs hopefully uses less 
stack space and is usable with a 4k stack, reiserfs got some updates, and 
a lot of other filesystems got minor refreshes. The ext3 changes are small 
enough to not show up in any dirstat, but hey, I think the fsync latency 
changes are interesting and probably more relevant to lots of people than 
most of the other changes.

Other? Arch updates - amainly rm, powerpc, sh and x86. Firmware updates. 
And lots and lots of driver updates, including some more core 
suspend/resume changes (hopefully the last really fundamental ones). 

Go out and try it,

		Linus
