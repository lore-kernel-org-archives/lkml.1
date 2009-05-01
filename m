Return-Path: <linux-kernel-owner+w=401wt.eu-S1764348AbZEATbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764348AbZEATbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZEATbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:31:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbZEATbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:31:07 -0400
Date: Fri, 1 May 2009 15:30:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, jistone@redhat.com
Subject: [PATCH] export softirq_to_name symbol
Message-ID: <20090501193022.GB3111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

In response to a user request:


Export 'softirq_to_name' so that modules using the softirq tracepoints
can resolve the # to a name.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b76064b..1841ab7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -60,6 +60,7 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
 	"TASKLET", "SCHED", "HRTIMER",	"RCU"
 };
+EXPORT_SYMBOL_GPL(softirq_to_name);
 
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
-- 
1.6.0.6

