Return-Path: <linux-kernel-owner+w=401wt.eu-S936192AbXGMSWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192AbXGMSWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154AbXGMSWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:22:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063AbXGMSWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:22:36 -0400
Message-ID: <4697C2DA.6060301@redhat.com>
Date: Fri, 13 Jul 2007 14:22:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH] sched: fix another prio_to_wmult[] entry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] sched: fix another prio_to_wmult[] entry

First digit of entry 16 was truncated.

Pointed out by Roman Zippel.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22.noarch.orig/kernel/sched.c
+++ linux-2.6.22.noarch/kernel/sched.c
@@ -749,7 +749,7 @@ static const u32 prio_to_wmult[40] = {
 	48356,   60446,   75558,   94446,  118058,  147573,
 	184467,  230589,  288233,  360285,  450347,
 	562979,  703746,  879575, 1099582, 1374389,
-	717986, 2147483, 2684354, 3355443, 4194304,
+	1717986, 2147483, 2684354, 3355443, 4194304,
 	5244160, 6557201, 8196502, 10250518, 12782640,
 	16025997, 19976592, 24970740, 31350126, 39045157,
 	49367440, 61356675, 76695844, 95443717, 119304647,
