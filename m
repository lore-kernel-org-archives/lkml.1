Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZJ0Hpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZJ0Hpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZJ0Hps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:45:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbZJ0Hpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:45:46 -0400
Message-ID: <4AE6A513.6010100@cn.fujitsu.com>
Date: Tue, 27 Oct 2009 15:45:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] no_hz: remove unused field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 15934a37324f32e0fda633dc7984a671ea81cd75,
field last_tick_seen is added to struct rq.
But it is unused now.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 91ffb01..5166de1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -534,7 +534,6 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
-	unsigned long last_tick_seen;
 	unsigned char in_nohz_recently;
 #endif
 	/* capture load from *all* tasks on this cpu: */

