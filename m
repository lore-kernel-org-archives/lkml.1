Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYBXWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYBXWQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYBXWQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:16:08 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbYBXWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:16:06 -0500
Date: Sun, 24 Feb 2008 14:16:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc3
Message-ID: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, it's out there, ready for your enjoyment.

As usual, most of the updates are in architecture and drivers, with the 
dirstat showing about 37% in arch (and that's with rename detection: 
there's some file movement in arch/xtensa that would bring it up to 43% if 
you looked at it as a traditional diff) and almost 50% in drivers.

Much of the include file stuff is also architecture-related updates. 

The driver updates are mostly fairly spread out, but some of it comes from 
a couple of new drivers: the mvsas SCSI driver, a new adt7473 driver, and 
a couple of new watchdog drivers.

Anyway, here's the managerial overview that you've all been waiting for 
(yeah, sure, I can see you all holding your breath):

   2.5% arch/h8300/
  13.9% arch/mips/configs/
  14.6% arch/mips/
   6.7% arch/powerpc/configs/
   7.5% arch/powerpc/
   2.5% arch/x86/
   6.1% arch/xtensa/kernel/
   6.2% arch/xtensa/
  37.0% arch/
   3.5% drivers/ata/
   6.0% drivers/hwmon/
   2.3% drivers/media/radio/
   6.1% drivers/media/video/
   9.0% drivers/media/
   3.1% drivers/net/
  13.0% drivers/scsi/
   5.1% drivers/watchdog/
  47.6% drivers/
   2.4% fs/
   2.9% include/asm-xtensa/
   5.1% include/
   2.0% net/

Now, if you ignore the architecture-specific stuff and drivers, the rest 
is mostly in networking, soem Documentation updates, and a few filesystem 
updates (mainly efs and xfs). 

Anyway, the upshot of it all? Quite frankly, it's all over the place. The 
changes in -rc3 are bigger than -rc2, probably mostly because we had some 
more time (-rc2 was a couple of days early because of the long weekend in 
the US), but hopefully also because people have started to find 
regressions.

Reading the shortlog (too big to be posted, although not by much), a lot 
of it really is fairly trivial. Things like sparse warning cleanups etc. 
But we had a nasty SLUB corruption issue in -rc2 that is fixed (not that 
very many people probably saw it), and we've hopfully fixed a number of 
regressions in networkign and suspend/resume.

So give it a good testing, please,

			Linus
