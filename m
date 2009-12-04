Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZLDWW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZLDWW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZLDWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:22:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZLDWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:22:25 -0500
Message-ID: <4B198BA7.5000200@gmail.com>
Date: Fri, 04 Dec 2009 23:22:31 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/31] Constify struct file_lock_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct file_lock_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..5c621a0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1027,8 +1027,8 @@ static inline int file_check_writeable(struct file *filp)
 typedef struct files_struct *fl_owner_t;
 
 struct file_lock_operations {
-	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
-	void (*fl_release_private)(struct file_lock *);
+	void (* const fl_copy_lock)(struct file_lock *, struct file_lock *);
+	void (* const fl_release_private)(struct file_lock *);
 };
 
 struct lock_manager_operations {

