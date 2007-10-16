Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXJPQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXJPQXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXJPQWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:22:53 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43767
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757740AbXJPQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:22:51 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/4] RT: Initialize the priority value
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 16 Oct 2007 12:09:03 -0400
Message-ID: <20071016160903.5202.41015.stgit@novell1.haskins.net>
In-Reply-To: <20071016160226.5202.53965.stgit@novell1.haskins.net>
References: <20071016160226.5202.53965.stgit@novell1.haskins.net>
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
index 1866a6e..b69e49b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7388,6 +7388,8 @@ void __init sched_init(void)
 		highest_cpu = i;
 		/* delimiter for bitsearch: */
 		__set_bit(MAX_RT_PRIO, array->bitmap);
+
+		set_rq_prio(rq, MAX_PRIO);
 	}
 
 	set_load_weight(&init_task);

