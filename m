Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZLNAEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZLNAEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZLNAEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:04:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZLMX6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:33 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, pavel@ucw.cz, len.brown@intel.com,
       torvalds@linux-foundation.org
Subject: [PATCH 08/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:24 +0100
Message-Id: <69cf9cf2ea6f039b9ff3860ec81bdb0f1eb4b2d0.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 kernel/power/suspend.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6f10dfc..08e1e7b 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -23,13 +23,13 @@ const char *const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_MEM]	= "mem",
 };
 
-static struct platform_suspend_ops *suspend_ops;
+static const struct platform_suspend_ops *suspend_ops;
 
 /**
  *	suspend_set_ops - Set the global suspend method table.
  *	@ops:	Pointer to ops structure.
  */
-void suspend_set_ops(struct platform_suspend_ops *ops)
+void suspend_set_ops(const struct platform_suspend_ops *ops)
 {
 	mutex_lock(&pm_mutex);
 	suspend_ops = ops;
-- 
1.6.5.3

