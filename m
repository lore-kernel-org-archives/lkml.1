Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXJXQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXJXQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXJXQXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33384 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755371AbXJXQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:53 -0400
Date: Wed, 24 Oct 2007 18:24:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport tick_nohz_get_sleep_length
Message-ID: <20071024162422.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused 
EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f7c83dfe117f4fd072b2506ae090e4145abda362 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 10a1347..5997456 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -320,8 +320,6 @@ ktime_t tick_nohz_get_sleep_length(void)
 	return ts->sleep_length;
 }
 
-EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
-
 /**
  * nohz_restart_sched_tick - restart the idle tick from the idle task
  *

