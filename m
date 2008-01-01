Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYAANrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYAANrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYAANrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:47:12 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53729 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYAANrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:47:11 -0500
Date: Tue, 1 Jan 2008 15:46:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled 'time' option removal
Message-ID: <20080101134656.GG2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the 'time' option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    8 --------
 kernel/printk.c                            |   13 -------------
 2 files changed, 21 deletions(-)

c0ea16c447460698c0e85963310c38fa051f0e23 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..93aac19 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -233,10 +233,2 @@ Who:	Jean Delvare <khali@linux-fr.org>
 ---------------------------
-
-What:	'time' kernel boot parameter
-When:	January 2008
-Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
-	enabled or disabled as needed
-Who:	Randy Dunlap <randy.dunlap@oracle.com>
-
----------------------------
 
diff --git a/kernel/printk.c b/kernel/printk.c
index a30fe33..296c4ea 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -560,15 +560,2 @@ static int printk_time = 0;
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
-
-static int __init printk_time_setup(char *str)
-{
-	if (*str)
-		return 0;
-	printk_time = 1;
-	printk(KERN_NOTICE "The 'time' option is deprecated and "
-		"is scheduled for removal in early 2008\n");
-	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
-	return 1;
-}
-
-__setup("time", printk_time_setup);
 

