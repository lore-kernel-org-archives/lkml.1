Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYGVT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYGVT3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYGVTYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:16 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14323 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYGVTYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:05 -0400
X-BigFish: VPS24(z37d4jzzz10d3izzz32i87il66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VF-01-8PS-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 23/24] oprofile: Fix printk in cpu_buffer.c
Date: Tue, 22 Jul 2008 21:09:07 +0200
Message-ID: <1216753748-11261-24-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:41.0214 (UTC) FILETIME=[7301C3E0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index aba905b..4decab6 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -364,7 +364,7 @@ static void wq_sync_buffer(struct work_struct *work)
 	struct oprofile_cpu_buffer * b =
 		container_of(work, struct oprofile_cpu_buffer, work.work);
 	if (b->cpu != smp_processor_id()) {
-		printk("WQ on CPU%d, prefer CPU%d\n",
+		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
 		       smp_processor_id(), b->cpu);
 	}
 	sync_buffer(b->cpu);
-- 
1.5.5.4


