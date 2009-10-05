Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZJEKXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZJEKXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZJEKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:23:05 -0400
Received: from bosmailout17.eigbox.net ([66.96.184.17]:35453 "EHLO
	bosmailout17.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbZJEKXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:23:05 -0400
X-EN-OrigOutIP: 10.20.18.2
X-EN-IMPSID: oyM41c00902gpmq0000000
Message-ID: <4AC9C8A6.6010209@jaysonking.com>
Date: Mon, 05 Oct 2009 05:21:26 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Remove obsolete comment in sched_init()
References: <4AC98F4A.7070303@jaysonking.com> <20091005100203.GA3211@elte.hu>
In-Reply-To: <20091005100203.GA3211@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.67.11.191
X-EN-OrigHost: adsl-67-67-11-191.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the comment about calling alloc_bootmem() as it is not called
here since commit 36b7b6d465489c4754c4fd66fcec6086eba87896.

Signed-off-by: Jayson R. King <dev@jaysonking.com>
---
 sched.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1535f38..d68ac0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9334,10 +9334,6 @@ void __init sched_init(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
-	/*
-	 * As sched_init() is called before page_alloc is setup,
-	 * we use alloc_bootmem().
-	 */
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);




