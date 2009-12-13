Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZLNAVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZLNAVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZLNAU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:20:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34064 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZLMX5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:39 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, akpm@linux-foundation.org, mingo@elte.hu,
       matthew@wil.cx, torvalds@linux-foundation.org
Subject: [PATCH 1/1] Constify struct file_lock_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:34 +0100
Message-Id: <482ce9967027b3ce51ca7e1e38f024fd4eab9169.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
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
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a057f48..c88cb4b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1028,8 +1028,8 @@ static inline int file_check_writeable(struct file *filp)
 typedef struct files_struct *fl_owner_t;
 
 struct file_lock_operations {
-	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
-	void (*fl_release_private)(struct file_lock *);
+	void (* const fl_copy_lock)(struct file_lock *, struct file_lock *);
+	void (* const fl_release_private)(struct file_lock *);
 };
 
 struct lock_manager_operations {
-- 
1.6.5.3

