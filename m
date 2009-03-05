Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZCETTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZCETTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZCETS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:18:58 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33492 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbZCETS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:18:57 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 15/15] NULL noise: mm/memcontrol.c
Date: Thu, 05 Mar 2009 20:18:44 +0100
Message-ID: <20090305191839.30062.91081.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  mm/memcontrol.c:1637:32: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
v2: other subject, as suggested by Al Viro

 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8e4be9c..09d6650 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1634,7 +1634,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 		pc = list_entry(list->prev, struct page_cgroup, lru);
 		if (busy == pc) {
 			list_move(&pc->lru, list);
-			busy = 0;
+			busy = NULL;
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
 			continue;
 		}

