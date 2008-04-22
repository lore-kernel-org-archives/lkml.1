Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYDVRHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYDVRHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYDVRHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:07:33 -0400
Received: from xenotime.net ([66.160.160.81]:43722 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755736AbYDVRHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:07:32 -0400
Date: Tue, 22 Apr 2008 10:07:22 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org, mingo@redhat.com
Subject: [PATCH] kernel-doc: fix sched.c missing parameter
Message-ID: <Pine.LNX.4.64.0804221006160.4897@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc in kernel/sched.c:

Warning(linux-2.6.25-git3//kernel/sched.c:7044): No description found for parameter 'span'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.25-git3.orig/kernel/sched.c
+++ linux-2.6.25-git3/kernel/sched.c
@@ -7035,6 +7035,7 @@ static int find_next_best_node(int node,
 /**
  * sched_domain_node_span - get a cpumask for a node's sched_domain
  * @node: node whose cpumask we're constructing
+ * @span: resulting cpumask
  *
  * Given a node, construct a good cpumask for its sched_domain to span. It
  * should be one that prevents unnecessary balancing, but also spreads tasks
