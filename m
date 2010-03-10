Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0CJVGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:06:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab0CJVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:06:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=KcqPGBqIESEEiTWzmJMqc78EE0f0CRd3KVTnEeiwe2ZlyY0SLw5R07gU57JGAWmfQ
	sGg+e0T1//SyK0CrhB1fQ==
From: Greg Thelen <gthelen@google.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org,
       Greg Thelen <gthelen@google.com>
Subject: [PATCH] mm: fix typo in refill_stock() comment
Date: Wed, 10 Mar 2010 13:05:17 -0800
Message-Id: <1268255117-3280-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change refill_stock() comment: s/consumt_stock()/consume_stock()/

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d813823..0576de1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1330,7 +1330,7 @@ static void drain_local_stock(struct work_struct *dummy)
 
 /*
  * Cache charges(val) which is from res_counter, to local per_cpu area.
- * This will be consumed by consumt_stock() function, later.
+ * This will be consumed by consume_stock() function, later.
  */
 static void refill_stock(struct mem_cgroup *mem, int val)
 {
-- 
1.7.0.1

