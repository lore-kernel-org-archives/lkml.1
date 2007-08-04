Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXHDDvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXHDDvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762394AbXHDDux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:50:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759704AbXHDDuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:50:52 -0400
Date: Fri, 3 Aug 2007 20:50:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc2
Message-ID: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


So I tried to hold people to the merge window, and said no to a few pull 
requests, but this whole "-rc2 is the new -rc1" thing is a disease, and 
not only is -rc2 late, it's bigger than it should be. Oh, well.

A lot of the changes are small, and a lot of them really are fixes, but 
there's a MIPS merge in there too, and some absolutely _huge_ diffs due to 
some drivers undergoing Lindent cleanups (28 _thousand_ lines changes in 
advansys.c, and the PNP files got Lindented too, although those weren't 
nearly as big).

But if you ignore the Lindent changes, the MIPS merge, the lguest 
documentation updates, and the MPT fusion driver changes, and the 
removal of the broken arm26 support, the rest of the changes really aren't 
that big.

But there's still a lot of those mostly small things all over. And the 
ShortLog is too large to post. But the full log along with the customary 
tar-balls and patches are out there on kernel.org. And as usual, the git 
tree gives you the goods if you just do

	git shortlog v2.6.23-rc1..

(the most interesting statistic from there is that we apparently had more 
than 250 people involved in just the -rc1 to -rc2 timeframe. Impressively 
spread out, in other words)

			Linus
