Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYCEFD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYCEFD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYCEFDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:03:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYCEFDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:03:46 -0500
Date: Tue, 4 Mar 2008 21:03:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc4
Message-ID: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's a few days late, but I was waiting for some updates for some of the 
most annoying regressions until releasing it, so the end result is 
hopefully more useful as a result.

In particular, the block layer changes should hopefully have sorted 
themselves out, and CD burning etc hopefully works for people again. Same 
goes for the the scheduler regressions, and a number of annoying boot-time 
problems.

In short, if you had any issues, please do test, and make sure that the 
regression list gets updated (whether fixed or not).

The dirstat shows that (as usual) most of the changes are in drivers and 
arch (~51% and ~17% respectively), with about half the driver updates 
being in network drivers. Full details for those who care:

	   2.0% Documentation/
	   3.6% arch/blackfin/
	   3.6% arch/cris/
	   2.3% arch/sparc/kernel/
	   2.8% arch/x86/
	  17.3% arch/
	   2.1% drivers/char/
	   7.0% drivers/dma/
	   3.0% drivers/firewire/
	  24.0% drivers/net/
	  50.6% drivers/
	   5.6% fs/cifs/
	   9.4% fs/
	   3.6% include/
	   5.2% kernel/
	   3.9% mm/
	   2.5% net/

but in general, it's really a fair amount of small changes spread all 
over, with most of the changes being quite small (604 commits, most of 
them small, with the BNX2X network driver being and the new fsldma driver 
the only one that got some bigger changes).

So give it all a good testing,

		Linus
