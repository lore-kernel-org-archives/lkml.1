Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYECTjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYECTjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYECTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:38:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYECTix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:38:53 -0400
Date: Sat, 3 May 2008 12:38:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc1
Message-ID: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So this merge window was somewhat rocky in the sense that there was a lot 
of arguments about it, but at the same time I at least personally think 
that from a technical angle, we had somewhat less scary stuff going on 
than has been almost the rule lately. 

Lots of changes, but nothing that really feels all that fragile to me. 
Famous last words. I expect that the x86 PAT support (which has been long 
in the making) has the potential to have some issues, but the obvious 
problems were hashed out long ago, and while the merge window already 
showed one bug, that one was fairly benign and quickly fixed.

As usual, the bulk of the changes are to drivers (roughly 40% of the 
diffs, and that's with rename detection - with renames shown as 
delete/create events it was pretty exactly half of the diff). The network 
driver updates were about half of that (again, that's not unusual, and is 
mostly indicative of the fact that there's a metric buttload of networking 
drivers out there).

Arch updates were another 20%, still leaving a fair amount of stuff spread 
out all over (that said, the "dirstat" with rename detection is a bit 
flaky - if files get renamed across directories, the accounting is 
obviously not very meaningful - so take the numbers as a guideline rather 
than anything else).

Among the randon stuff, filesystems (ext4, gfs2, ocfs2 and xfs stand out), 
and networking (with the generic 802.11 layer being a big part of it, so I 
guess that should counts as partly driver-related).

Of course, sometimes the small patches is what is more noticeable 
(especially if they introduce bugs ;). The VM doesn't really show up very 
big in diffstat, but there were a fair number of cleanups there.

Another feature that is notable not for its size, but because people have 
tried to get me to merge it for some long is kgdb support. Which really 
turned out pretty small and clean, once people started putting their 
effort into making it so.

So go out and test it. The diffstat and shortlogs are too big to post here 
(7500+ commits and the compressed full patch is 8.5MB in size), but one 
interesting tidbit I found was that during this *one* merge window, we had 
almost 800 different authors. Now, some of them will have gotten counted 
multiple times due to different versions of the same name, and I didn't 
filter that, but from a quick look, that is been pretty rare.

Obviously, most of those had just a couple of commits (more than half had 
three commits or less), but that's how everybody starts. 

			Linus
