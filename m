Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYARCQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYARCQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbYARCQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:16:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbYARCQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:16:43 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] fix drivers/lguest Makefile entry
Date: Fri, 18 Jan 2008 00:16:43 -0200
Message-Id: <12006226032537-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should depend on CONFIG_LGUEST, not CONFIG_LGUEST_GUEST

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index ee1b6a5..58a17e9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -73,7 +73,7 @@ obj-$(CONFIG_ISDN)		+= isdn/
 obj-$(CONFIG_EDAC)		+= edac/
 obj-$(CONFIG_MCA)		+= mca/
 obj-$(CONFIG_EISA)		+= eisa/
-obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
+obj-$(CONFIG_LGUEST)		+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_MMC)		+= mmc/
-- 
1.5.0.6

