Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbZINUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbZINUKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933710AbZINUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54190 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZINUJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Mingquan Pan <grace.pan@analog.com>
Subject: [PATCH 65/72] Blackfin: use KERN_ALERT in all kgdb_test output
Date: Mon, 14 Sep 2009 16:08:09 -0400
Message-Id: <1252958896-25150-66-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingquan Pan <grace.pan@analog.com>

Most messages are already using KERN_ALERT, so be consistent to make
things easier to check with test scripts.

Signed-off-by: Mingquan Pan <grace.pan@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb_test.c b/arch/blackfin/kernel/kgdb_test.c
index dbcf3e4..59fc42d 100644
--- a/arch/blackfin/kernel/kgdb_test.c
+++ b/arch/blackfin/kernel/kgdb_test.c
@@ -54,7 +54,7 @@ void kgdb_l2_test(void)
 
 int kgdb_test(char *name, int len, int count, int z)
 {
-	printk(KERN_DEBUG "kgdb name(%d): %s, %d, %d\n", len, name, count, z);
+	printk(KERN_ALERT "kgdb name(%d): %s, %d, %d\n", len, name, count, z);
 	count = z;
 	return count;
 }
-- 
1.6.4.2

