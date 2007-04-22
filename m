Return-Path: <linux-kernel-owner+w=401wt.eu-S1030936AbXDVPEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030936AbXDVPEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030937AbXDVPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:04:09 -0400
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:54061 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030936AbXDVPEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:04:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.46
Date: Mon, 23 Apr 2007 01:03:14 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704230103.15265.kernel@kolivas.org>
X-Length: 1518
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another significant bugfix for SMP balancing was just posted for the 
staircase deadline cpu scheduler which improves behaviour dramatically on any 
SMP machine.

Thanks to Willy Tarreau for noticing more bugs.

As requested was a version in the Makefile so this version of the patch 
adds -sd046 to the kernel version.

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.46.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.46.patch

Renicing X to -10, while not essential, may be desirable on the desktop. 
Unlike the CFS scheduler which renices X without your intervention to 
nice -19, the SD patches do not alter nice level on their own.

See the patch just posted called 'sched: implement staircase deadline 
scheduler load  weight fix' for details of the fixes.

Thanks to all testing and giving feedback.

Well I'm exhausted...

-- 
-ck
