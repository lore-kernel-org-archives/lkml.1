Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYBZKPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYBZKPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbYBZKOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:14:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:28621 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYBZKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:14:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o+Q2Ws2FErTrLcF2hg6Fvqq+48xipY0homOTwv3bz5nmowS5wnvWoRoH0KqLDILeKyYSTcUtBUsaGLL3TbfN5ZoSOiCIDgDGCqJ2MXJRLUUFhXODOB6pXdnsR17J5lAd9YdkuTOtaF5nsDg0fxQBeigz6NvD5vBxozBfE4wi1gI=
From: Denis Cheng <crquan@gmail.com>
To: Corey Minyard <cminyard@mvista.com>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [IPMI] remove unused target and action in Makefile
Date: Tue, 26 Feb 2008 18:14:34 +0800
Message-Id: <1204020874-18683-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild system handle this automatically.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/char/ipmi/Makefile |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/Makefile b/drivers/char/ipmi/Makefile
index 553f0a4..eb8a1a8 100644
--- a/drivers/char/ipmi/Makefile
+++ b/drivers/char/ipmi/Makefile
@@ -9,7 +9,3 @@ obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
 obj-$(CONFIG_IPMI_SI) += ipmi_si.o
 obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
 obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
-
-ipmi_si.o:	$(ipmi_si-objs)
-	$(LD) -r -o $@ $(ipmi_si-objs)
-
-- 
1.5.4.2

