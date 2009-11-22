Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZKVITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZKVITf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZKVITf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:19:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:49176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbZKVITe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:19:34 -0500
Subject: [PATCH] kernel.h: Fix kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:42:09 +0530
Message-Id: <1258877529.4495.43.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warnings:

  Warning(include/linux/kernel.h:708): No description found for parameter 'condition'
  Warning(include/linux/kernel.h:708): Excess function parameter 'cond' description in 'BUILD_BUG_ON'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 14bcd38..e1e81ed 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -691,7 +691,7 @@ struct sysinfo {
 
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
- * @cond: the condition which the compiler should know is false.
+ * @condition: the condition which the compiler should know is false.
  *
  * If you have some code which relies on certain constants being equal, or
  * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
-- 
1.6.5.3


