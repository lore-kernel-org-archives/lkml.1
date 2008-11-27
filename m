Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYK1JiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYK1JiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYK1JiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:38:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:25332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYK1JiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:38:08 -0500
To: "David S. Miller" <davem@davemloft.net>
To: netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Date: Thu, 27 Nov 2008 20:33:17 +0100
Subject: [PATCH] pkt_sched: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <492fbbfd.190c660a.1db3.fffffcc3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make global function static

Fix the following sparse warning:

  net/sched/sch_api.c:192:14: warning: symbol 'qdisc_match_from_root' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/sched/sch_api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f859dd5..6bc29e8 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(unregister_qdisc);
    (root qdisc, all its children, children of children etc.)
  */
 
-struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
+static struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
 {
 	struct Qdisc *q;
 
-- 
1.5.6.3

