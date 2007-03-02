Return-Path: <linux-kernel-owner+w=401wt.eu-S1422917AbXCBFm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422917AbXCBFm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422920AbXCBFm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:42:58 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:65107 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422917AbXCBFm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:42:57 -0500
Date: Fri, 02 Mar 2007 00:42:12 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: belkin bulldog ups monitor vs 2.6.21-rc2
To: linux-kernel@vger.kernel.org
Message-id: <200703020042.17902.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just rebooted to 2.6.21-rc2 and noted that getting x up and running was 
about 15 seconds longer than usual.  When it got a bash shell going I 
went to it and ran htop which showed that the bulldog monitor was taking 
90% of the cpu.  Killed it, then restarted it, but when I ran the gui 
which ran fine and then stopped the gui, the daemon once again went hog 
wild and had to be killed,  and I'm losing my kmail composer focus for 30 
seconds at a time now that amanda is making her nightly run.

There is nothing in the log about it other than from xinetd as it ran the 
amanda server stuff.

Not quite ready for prime time methinks.  Using the ck scheduler, this is 
terrible performance, virtually no multitasking.  Back to 2.6.20-ck1 in 
the morning if it lives the rest of the night.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
