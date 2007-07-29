Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbXG2O66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbXG2O66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763938AbXG2O5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:15 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47764 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764130AbXG2O5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:13 -0400
Date: Sun, 29 Jul 2007 16:56:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/base/power/: make 2 functions static
Message-ID: <20070729145650.GH16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

suspend_device() and resume_device() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/base/power/power.h   |    6 ------
 drivers/base/power/resume.c  |    2 +-
 drivers/base/power/suspend.c |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc1-mm1/drivers/base/power/power.h.old	2007-07-26 05:14:12.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/base/power/power.h	2007-07-26 05:15:49.000000000 +0200
@@ -55,12 +55,6 @@
 
 extern void dpm_resume(void);
 extern void dpm_power_up(void);
-extern int resume_device(struct device *);
-
-/*
- * suspend.c
- */
-extern int suspend_device(struct device *, pm_message_t);
 
 #else /* CONFIG_PM */
 
--- linux-2.6.23-rc1-mm1/drivers/base/power/resume.c.old	2007-07-26 05:14:28.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/base/power/resume.c	2007-07-26 05:14:39.000000000 +0200
@@ -20,7 +20,7 @@
  *
  */
 
-int resume_device(struct device * dev)
+static int resume_device(struct device * dev)
 {
 	int error = 0;
 
--- linux-2.6.23-rc1-mm1/drivers/base/power/suspend.c.old	2007-07-26 05:16:00.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/base/power/suspend.c	2007-07-26 05:16:17.000000000 +0200
@@ -54,7 +54,7 @@
  *	@state:	Power state device is entering.
  */
 
-int suspend_device(struct device * dev, pm_message_t state)
+static int suspend_device(struct device * dev, pm_message_t state)
 {
 	int error = 0;
 

