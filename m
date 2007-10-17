Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbXJQTGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbXJQTGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760995AbXJQTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:04:43 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53156
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760880AbXJQTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:04:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/9] RT: Initialize the priority value
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 17 Oct 2007 14:50:47 -0400
Message-ID: <20071017185047.11272.13579.stgit@novell1.haskins.net>
In-Reply-To: <20071017184745.11272.10024.stgit@novell1.haskins.net>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We should init the base value of the current RQ priority to "IDLE"

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 131f618..d68f600 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7385,6 +7385,8 @@ void __init sched_init(void)
 		highest_cpu = i;
 		/* delimiter for bitsearch: */
 		__set_bit(MAX_RT_PRIO, array->bitmap);
+
+		set_rq_prio(rq, MAX_PRIO);
 	}
 
 	set_load_weight(&init_task);

