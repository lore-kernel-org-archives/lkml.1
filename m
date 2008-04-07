Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYDGT7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYDGT7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYDGT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:59:12 -0400
Received: from mail.fieldses.org ([66.93.2.214]:53368 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYDGT7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:59:11 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Jon Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] Spell out behavior of atomic_dec_and_lock() in kerneldoc
Date: Mon,  7 Apr 2008 15:59:05 -0400
Message-Id: <1207598345-14295-4-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207598345-14295-3-git-send-email-bfields@citi.umich.edu>
References: <1207598345-14295-1-git-send-email-bfields@citi.umich.edu>
 <1207598345-14295-2-git-send-email-bfields@citi.umich.edu>
 <1207598345-14295-3-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little more detail here wouldn't hurt.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 include/linux/spinlock.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 576a5f7..1129ee0 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -341,6 +341,9 @@ static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
  * atomic_dec_and_lock - lock on reaching reference count zero
  * @atomic: the atomic counter
  * @lock: the spinlock in question
+ *
+ * Decrements @atomic by 1.  If the result is 0, returns true and locks
+ * @lock.  Returns false for all other cases.
  */
 extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
 #define atomic_dec_and_lock(atomic, lock) \
-- 
1.5.5.rc1

