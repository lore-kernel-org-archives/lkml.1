Return-Path: <linux-kernel-owner+w=401wt.eu-S936834AbXGMToO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936834AbXGMToO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760427AbXGMToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:44:00 -0400
Received: from www.osadl.org ([213.239.205.134]:41379 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760235AbXGMTn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:43:59 -0400
Subject: [PATCH] CFS: Fix missing digit off in wmult table
From: Thomas Gleixner <tglx@linutronix.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <Pine.LNX.4.64.0707131728070.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 21:43:55 +0200
Message-Id: <1184355835.12353.321.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel noticed inconsistency of the wmult table.

wmult[16] has a missing digit.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/sched.c b/kernel/sched.c
index 0559665..3332bbb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -750,7 +750,7 @@ static const u32 prio_to_wmult[40] = {
 	48356,   60446,   75558,   94446,  118058,  147573,
 	184467,  230589,  288233,  360285,  450347,
 	562979,  703746,  879575, 1099582, 1374389,
-	717986, 2147483, 2684354, 3355443, 4194304,
+	1717986, 2147483, 2684354, 3355443, 4194304,
 	5244160, 6557201, 8196502, 10250518, 12782640,
 	16025997, 19976592, 24970740, 31350126, 39045157,
 	49367440, 61356675, 76695844, 95443717, 119304647,


