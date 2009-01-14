Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbZANOnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbZANOnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZANOnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:43:19 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:60282
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbZANOnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:43:18 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 1/2] sched: de CPP-ify the scheduler code
To: mingo@elte.hu
Cc: rostedt@home.goodmis.org, peterz@infradead.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2009 09:46:24 -0500
Message-ID: <20090114144624.11627.12938.stgit@dev.haskins.net>
In-Reply-To: <20090114144317.11627.69111.stgit@dev.haskins.net>
References: <20090114144317.11627.69111.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 18c7b5b..4eda5f7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -64,8 +64,10 @@ static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 
 #else
 
-#define enqueue_pushable_task(rq, p) do { } while (0)
-#define dequeue_pushable_task(rq, p) do { } while (0)
+static inline
+void enqueue_pushable_task(struct rq *rq, struct task_struct *p) {}
+static inline
+void dequeue_pushable_task(struct rq *rq, struct task_struct *p) {}
 
 #endif /* CONFIG_SMP */
 

