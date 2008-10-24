Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbYJXEKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbYJXEKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYJXEKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:10:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbYJXEKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:10:31 -0400
Date: Thu, 23 Oct 2008 21:10:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc1
Message-ID: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
is out there, and it's hopefully all good.

The changes in -rc1 are (as usual) too many to really enumerate, with the 
bulk of them being - again as usual - drivers. In fact, that's doubly true 
now that we merged the drivers from the staging tree. The dirstat output 
makes that very obvious:

   3.3% arch/arm/
  14.2% arch/
   3.1% crypto/
   4.0% drivers/media/
   3.7% drivers/net/wireless/
  10.3% drivers/net/
   6.5% drivers/staging/me4000/
   8.5% drivers/staging/slicoss/
   4.8% drivers/staging/wlan-ng/
  29.7% drivers/staging/
  63.6% drivers/
   3.3% include/
   4.6% net/
   4.6% sound/

but some other statistics may be fun: 

 - 7141 non-merge commits (and 419 merges)

 - average non-merge commit:
	39 lines removed, 104 lines added
   (not counting renames)

 - About 880 individual authors
	- 340 of which had just one commit
	- while 183 authors had ten or more commits

 - Most screwed-up clock award goes to:

	Greg Kroah-Hartman

   for his commit 51b90540, which claims to be from April 9 - six years 
   ago! And it's a fix to a driver that was merged this July!

Way to go, Greg!

Anyway, have fun, please test it, and report any intersting anomalies you 
find.

			Linus
