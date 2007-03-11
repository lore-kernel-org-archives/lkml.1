Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXCKD5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXCKD5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932904AbXCKD5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:57:30 -0500
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:52705 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932903AbXCKD53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:57:29 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Sun, 11 Mar 2007 14:57:17 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703111457.17624.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What follows this email is a patch series for the latest version of the RSDL 
cpu scheduler (ie v0.29). I have addressed all bugs that I am able to 
reproduce in this version so if some people would be kind enough to test if 
there are any hidden bugs or oops lurking, it would be nice to know in 
anticipation of putting this back in -mm. Thanks.

Full patch for 2.6.21-rc3-mm2:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.29.patch

Patch series (which will follow this email):
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/

Changelog:
- Fixed the longstanding buggy bitmap problem which occurred due to swapping 
arrays when there were still tasks on the active array.
- Fixed preemption of realtime tasks when rt prio inheritance elevated their 
priority.
- Made kernel threads not be reniced to -5 by default
- Changed sched_yield behaviour of SCHED_NORMAL (SCHED_OTHER) to resemble 
realtime task yielding.

-- 
-ck
