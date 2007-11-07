Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXKGA0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXKGA0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXKGA0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:26:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbXKGA0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:26:16 -0500
Date: Tue, 6 Nov 2007 16:26:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc2
Message-ID: <alpine.LFD.0.999.0711061601180.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Yeah, don't remind me - it's late. 

There was nothng in particular holding this thing up, I just basically 
just forgot to cut a -rc2 release last week.

There's not a lot of hugely exciting stuff here. Some arch updates: MIPS, 
arm, blackfin, x86, sparc[64], sh, s390..

Also various driver updates: libata, IDE, networking, DVB.. And some more 
fallout from the scatter-gather changes.

Some scheduler cleanups, and also fixing the CPU usage statistics that 
got scrogged at some point.

Nothing really earthshattering that I can recall or see. A lot of it is 
small buglets and compiler warnings (and occasionally broken builds). The 
shortlog is still slightly too large for the mailing list limit, so you 
need to generate it either from the full log (posted on the normal sites) 
or with

	git shortlog v2.6.24-rc1..

but quite frankly, it's no Leo Tolstoy. If you have trouble falling 
asleep, you might try to print it out and take it to bed with you: it's 
not going to be more than just a couple of pages ("use 2nup and save a 
tree"), but I dare you to actually get to the end. Snooze city.

It's full of such *riveting* entries like:

	James Bottomley:
	      x86: voyager: fix bogus conversion to per_cpu for boot_cpu_info
	...
	Jens Axboe:
	      mmc: sg fallout
	...
	Joerg Roedel:
	      x86 gart: rename iommu.h to gart.h
	...
	Mauro Carvalho Chehab:
	      V4L/DVB (6390): Updates missing entries at CARDLIST.em28xx
	...
	Ralf Baechle:
	      [MIPS] Alchemy: Nuke homebrew setup_irq(), it's broken and unnecessary.
	...
	Yu Luming:
	      [IA64] fix typo in per_cpu_offset
	..

and yes, I just picked those out randomly. 

			Linus
