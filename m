Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYBAPr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYBAPr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYBAPrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:47:49 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:50906 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYBAPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:47:48 -0500
Date: Fri, 01 Feb 2008 10:44:42 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: log spamming
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <200802011044.42919.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just rebooted to a new config of 2.6.24, basically trying to strip out the 
building of modules I don't use.  And I enabled a couple of checks that 
weren't checked in the kernel-hacking menu.  .config posted on request.

Now the messages log is being spammed at 2-5 second intervals by these:
Feb  1 10:41:08 coyote kernel: [ 3085.501037] MCE: The hardware reports a non 
fatal, correctable incident occurred on CPU 0.
Feb  1 10:41:08 coyote kernel: [ 3085.501042] Bank 1: d400400000000152
Feb  1 10:41:08 coyote kernel: [ 3085.501045] MCE: The hardware reports a non 
fatal, correctable incident occurred on CPU 0.
Feb  1 10:41:08 coyote kernel: [ 3085.501048] Bank 2: d40040000000017a

Always the same 2 addresses.  Is this telling me I should be running memtest86 
for a couple of cycles?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"It is the creationists who blasphemously are claiming that God is cheating
 us in a stupid way."
-- J. W. Nienhuys
