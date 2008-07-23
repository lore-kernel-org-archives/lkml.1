Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYGWSge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYGWSge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYGWSgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:64532 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbYGWSgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/5] kgdb: remove unused HAVE_ARCH_KGDB_SHADOW_INFO config variable
Date: Wed, 23 Jul 2008 13:35:35 -0500
Message-Id: <1216838139-719-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216838139-719-1-git-send-email-jason.wessel@windriver.com>
References: <1216838139-719-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Jul 2008 18:35:44.0623 (UTC) FILETIME=[EAD68FF0:01C8ECF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_ARCH_KGDB_SHADOW_INFO because it does not
exist anywhere in the kernel mainline sources

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 lib/Kconfig.kgdb |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index a5d4b1d..2cfd272 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -1,7 +1,4 @@
 
-config HAVE_ARCH_KGDB_SHADOW_INFO
-	bool
-
 config HAVE_ARCH_KGDB
 	bool
 
-- 
1.5.5.1

