Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZDGG4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZDGG4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZDGGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:55:56 -0400
Received: from mail.kolorific.com ([61.63.28.39]:38256 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZDGGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:55:55 -0400
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 02:55:55 EDT
Date: Tue, 7 Apr 2009 14:33:06 +0800
From: "figo.zhang" <figo.zhang@kolorific.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: [PATCH]kernel/sched_fair.c: the comment of the calc_delta_fair()
 maybe not correctly
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090407063306.64659F50054@mail.kolorific.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the comment of the calc_delta_fair() maybe not correctly, should be
delta *= NICE_O_LOAD/se->load

Signed-off-by: figo.zhang <figo.zhang@kolorific.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..5134b45 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -386,7 +386,7 @@ int sched_nr_latency_handler(struct ctl_table
*table, int write, #endif
 
 /*
- * delta /= w
+ * delta *= NICE_O_LOAD/se->load
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
