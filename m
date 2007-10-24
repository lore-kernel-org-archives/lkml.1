Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXJXQax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXJXQax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXJXQXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33357 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758901AbXJXQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:22 -0400
Date: Wed, 24 Oct 2007 18:23:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/page-writeback.c: make a function static
Message-ID: <20071024162351.GY30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

task_dirty_limit() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ea2286c1631811eb7ea813c2b2785c3a1bfb0463 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 838a5e3..f13f7fc 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -219,7 +219,7 @@ static inline void task_dirties_fraction(struct task_struct *tsk,
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
 {
 	long numerator, denominator;
 	long dirty = *pdirty;

