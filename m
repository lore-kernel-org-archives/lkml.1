Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbXJXET0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbXJXET0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXJXETT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:19:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbXJXETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:19:18 -0400
Date: Tue, 23 Oct 2007 21:19:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.24-rc1
Message-ID: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This may count as one of the biggest -rc releases ever. It's humongous. 
Usually the compressed -rc1 diffs are in the 3-5MB range, with occasional 
smaller ones, and the occasional ones that top 6M, but this one is 
*eleven* megs.

I'd blame the x86 renames (and the watchdog ones), but the thing is, it's 
absolutely huge even when I generate the diff with git turning all those 
renames into relatively small rename diffs (which I don't do for the 
public diffs, since I expect that git people use git to get the changes, 
and non-git people won't have tools that understand a diff that involves 
renames).

In short, we just had an unusually large amount of not just x86 merges, 
but also tons of new drivers (wireless networking stands out, but is by no 
means the only thing - we've got dvb, regular wired network, mmc etc all 
joining in), and a fair amount or architecture stuff, filesystems, 
networking etc too.

So there's just lots of new stuff. The diffstat is ten thousand lines 
long, and weighing in at comfortably over half a megabyte it is way over 
the limits of this - or any sane - mailing list. The shortlog is barely 
shorter, weighing in at "just" 8461 lines and almost 400k. The full 
changelog (which I'm still producing for y'all, since people told me they 
actually care last time I asked) is 4 megs.

In other words, I don't even know where to start. The big noticeable thing 
is the x86 merge, and I think we all fervently hope that it won't cause 
any issues. So far it's been pretty smooth sailing. Knock wood.

Less smooth has the scatter-gather changes to the block layer been, but 
they are hopefully all in reasonable shape by now too. And the VM changes? 
I honestly hope nobody even notices. Same goes for some of the VFS layer 
changes that affected basically every filesystem (although in mostly very 
straightforward ways).

Just for fun, I'd really encourage git users to just try the

	git shortlog v2.6.23..

thing, it really is quite impressive. 

			Linus
