Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbZF1QdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbZF1QdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZF1Q1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1110 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbZF1Q1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:34 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 21/62] drivers/macintosh/rack-meter.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:26 -0700
Message-Id: <8933f20d61d3e885e3d4dae130566fe5d482bad3.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/macintosh/rack-meter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index a98ab72..93fb320 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -274,7 +274,7 @@ static void __devinit rackmeter_init_cpu_sniffer(struct rackmeter *rm)
 
 		if (cpu > 1)
 			continue;
-		rcpu = &rm->cpu[cpu];;
+		rcpu = &rm->cpu[cpu];
 		rcpu->prev_idle = get_cpu_idle_time(cpu);
 		rcpu->prev_wall = jiffies64_to_cputime64(get_jiffies_64());
 		schedule_delayed_work_on(cpu, &rm->cpu[cpu].sniffer,
-- 
1.6.3.1.10.g659a0.dirty

