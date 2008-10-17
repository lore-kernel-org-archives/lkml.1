Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYJQNUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYJQNUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYJQNUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:20:43 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:62176 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYJQNUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:20:43 -0400
Date: Fri, 17 Oct 2008 21:20:44 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: akpm@linux-foundation.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/mca-legacy.h: Fix the warning
Message-ID: <20081017132044.GA22457@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warning of annotation.

  CC    drivers/mca/mca-legacy.o
  In file included from drivers/mca/mca-legacy.c:31:
  include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
  please move your driver to the new sysfs api"
  In file included from drivers/mca/mca-legacy.c:31:
  include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy -
  please move your driver to the new sysfs api"

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 include/linux/mca-legacy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mca-legacy.h b/include/linux/mca-legacy.h
index 7a3aea8..e349f2b 100644
--- a/include/linux/mca-legacy.h
+++ b/include/linux/mca-legacy.h
@@ -9,7 +9,7 @@
 
 #include <linux/mca.h>
 
-#warning "MCA legacy - please move your driver to the new sysfs api"
+/* warning "MCA legacy - please move your driver to the new sysfs api" */
 
 /* MCA_NOTFOUND is an error condition.  The other two indicate
  * motherboard POS registers contain the adapter.  They might be
-- 
1.5.2.5



-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
