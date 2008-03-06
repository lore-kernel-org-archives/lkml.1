Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbYCFC1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbYCFC1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761247AbYCFCZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbYCFCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wvHHL05C2Sdfr/XWD1Z2B3MvpbZnDRWz+/2E18ehVk26S17zGsXixQoVFnS8T7I/L720GpbSOQ5bEZAHsd9bRNfO1+kHGRp57j1meniwJzpIqkQJcx91PrcJ5qNpvwF7xZMd2qrd7cwqR25WooeLfR00ToalJ8QbYOY7X6Uqud8=
Subject: [PATCH 04/16] block: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:53 -0800
Message-Id: <1204770293.14154.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/sx8.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index cd5674b..7ad8167 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -79,9 +79,9 @@ MODULE_PARM_DESC(max_queue, "Maximum number of queued commands. (min==1, max==30
 
 /* note: prints function name for you */
 #ifdef CARM_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #ifdef CARM_VERBOSE_DEBUG
-#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define VPRINTK(fmt, args...)
 #endif	/* CARM_VERBOSE_DEBUG */
@@ -96,7 +96,7 @@ MODULE_PARM_DESC(max_queue, "Maximum number of queued commands. (min==1, max==30
 #define assert(expr) \
         if(unlikely(!(expr))) {                                   \
         printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n", \
-        #expr,__FILE__,__FUNCTION__,__LINE__);          \
+	#expr, __FILE__, __func__, __LINE__);          \
         }
 #endif
 
-- 
1.5.4.GIT


