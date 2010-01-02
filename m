Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430Ab0ABE0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0ABE0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 23:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375Ab0ABE0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 23:26:40 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43805 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0ABE0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 23:26:39 -0500
Date: Fri, 1 Jan 2010 20:26:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] power: fix kernel-doc notation
Message-Id: <20100101202630.f00a6ce2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B3ECAF6.0081:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Warning(drivers/base/power/main.c:453): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:453): No description found for parameter 'cb'
Warning(drivers/base/power/main.c:719): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:719): No description found for parameter 'state'
Warning(drivers/base/power/main.c:719): No description found for parameter 'cb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.33-rc2-git4.orig/drivers/base/power/main.c
+++ linux-2.6.33-rc2-git4/drivers/base/power/main.c
@@ -446,8 +446,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
  * legacy_resume - Execute a legacy (bus or class) resume callback for device.
- * dev: Device to resume.
- * cb: Resume callback to execute.
+ * @dev: Device to resume.
+ * @cb: Resume callback to execute.
  */
 static int legacy_resume(struct device *dev, int (*cb)(struct device *dev))
 {
@@ -711,8 +711,9 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
 /**
  * legacy_suspend - Execute a legacy (bus or class) suspend callback for device.
- * dev: Device to suspend.
- * cb: Suspend callback to execute.
+ * @dev: Device to suspend.
+ * @state: PM transition of the system being carried out.
+ * @cb: Suspend callback to execute.
  */
 static int legacy_suspend(struct device *dev, pm_message_t state,
 			  int (*cb)(struct device *dev, pm_message_t state))
