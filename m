Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZJLVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZJLVLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZJLVLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:11:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:60169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZJLVLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:11:15 -0400
Message-ID: <4AD39B4A.6030305@suse.com>
Date: Mon, 12 Oct 2009 17:10:34 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: Complete sched.h removal from interrupt.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit d43c36dc removed sched.h from interrupt.h and distributed sched.h
 to users which needed it. This finishes it up for staging.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/staging/b3dfg/b3dfg.c              |    1 +
 drivers/staging/hv/osd.c                   |    1 +
 drivers/staging/iio/industrialio-core.c    |    2 ++
 drivers/staging/poch/poch.c                |    1 +
 drivers/staging/sep/sep_driver.c           |    1 +
 drivers/staging/vme/bridges/vme_ca91cx42.c |    1 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    1 +
 7 files changed, 8 insertions(+)

--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -33,6 +33,7 @@
 #include <linux/cdev.h>
 #include <linux/list.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
--- a/drivers/staging/hv/osd.c
+++ b/drivers/staging/hv/osd.c
@@ -30,6 +30,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -19,6 +19,8 @@
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
 #include "iio.h"
 #include "trigger_consumer.h"
 
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/ioctl.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 
 #include "poch.h"
 
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -38,6 +38,7 @@
 #include <linux/mm.h>
 #include <linux/poll.h>
 #include <linux/wait.h>
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <asm/ioctl.h>
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -25,6 +25,7 @@
 #include <linux/poll.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-- 
Jeff Mahoney
SUSE Labs
