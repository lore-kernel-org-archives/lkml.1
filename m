Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYA2JOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYA2JOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYA2JOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:14:21 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:58290 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752296AbYA2JOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:14:20 -0500
X-Greylist: delayed 1677 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 04:14:19 EST
Date: Tue, 29 Jan 2008 19:43:52 +1100
From: AP <ap@zip.com.au>
To: linux-kernel@vger.kernel.org
Cc: Laurent.Vivier@bull.net, avi@qumranet.com, mingo@elte.hu
Subject: [PATCH] documentation: Add desc of new cpu fields in /proc/stat
Message-ID: <20080129084352.GA4221@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I noticed that a new field cropped up in /proc/stat. The git patch
that made it is 5e84cfde51cf303d368fcb48f22059f37b3872de. I hope the
following description is adequately accurate. I tried to keep it short.

Signed-Off-By: Andrew P <ap@zip.com.au>

diff -aur linux/Documentation/filesystems/proc.txt work/Documentation/filesystems/proc.txt
--- linux/Documentation/filesystems/proc.txt	2008-01-29 11:27:18.000000000 +1100
+++ work/Documentation/filesystems/proc.txt	2008-01-29 11:37:41.000000000 +1100
@@ -813,9 +813,9 @@
 since the system first booted.  For a quick look, simply cat the file:
 
   > cat /proc/stat
-  cpu  2255 34 2290 22625563 6290 127 456 0
-  cpu0 1132 34 1441 11311718 3675 127 438 0
-  cpu1 1123 0 849 11313845 2614 0 18 0
+  cpu  2255 34 2290 22625563 6290 127 456 0 0
+  cpu0 1132 34 1441 11311718 3675 127 438 0 0
+  cpu1 1123 0 849 11313845 2614 0 18 0 0
   intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
   ctxt 1990473
   btime 1062191376
@@ -836,6 +836,7 @@
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
+- guest: time used to run a virtual CPU
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all

-- 
Andrew
