Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZFFQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZFFQgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZFFQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:36:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34804 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZFFQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:36:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Jun 2009 18:36:24 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: include linux/uaccess.h instead of
 asm/uaccess.h
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.4dc7768cda122ae3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/core-cdev.c
===================================================================
--- linux.orig/drivers/firewire/core-cdev.c
+++ linux/drivers/firewire/core-cdev.c
@@ -35,12 +35,12 @@
 #include <linux/preempt.h>
 #include <linux/spinlock.h>
 #include <linux/time.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #include "core.h"
 

-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/

