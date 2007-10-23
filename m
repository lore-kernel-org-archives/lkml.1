Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXJWRG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXJWRG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbXJWRF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:27 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35057
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754648AbXJWRFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 05/13] RT: Initialize the priority value
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:50:49 -0400
Message-ID: <20071023165049.5536.4280.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
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
index dfd0b92..7c4fba8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7386,6 +7386,8 @@ void __init sched_init(void)
 		highest_cpu = i;
 		/* delimiter for bitsearch: */
 		__set_bit(MAX_RT_PRIO, array->bitmap);
+
+		set_rq_prio(rq, MAX_PRIO);
 	}
 
 	set_load_weight(&init_task);

