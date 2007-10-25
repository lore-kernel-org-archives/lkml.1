Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXJYNRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXJYNRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXJYNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:17:24 -0400
Received: from wombat.diezmil.com ([209.190.27.106]:53206 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXJYNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:17:23 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 09:17:23 EDT
Date: Thu, 25 Oct 2007 08:45:03 -0400
Message-ID: <27752604.1193316303106.JavaMail.root@wombat.diezmil.com>
From: edz_mania@yahoo.com
Reply-To: edz_mania@yahoo.com
To: linux-kernel@vger.kernel.org
Subject: Re: Linux v2.6.24-rc1
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- Linus Torvalds wrote : 

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
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger...
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--
This message was sent on behalf of edz_mania@yahoo.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/7843899.html
