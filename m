Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYJCLyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYJCLyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYJCLxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:53:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54072 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYJCLxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:53:18 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC][PATCH 4/5] OMAP SSI integration into misc drivers
Date: Fri,  3 Oct 2008 14:52:29 +0300
Message-Id: <1223034750-18690-4-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1223034750-18690-3-git-send-email-carlos.chinea@nokia.com>
References: <1223034606.32631.156.camel@groo.research.nokia.com>
 <1223034750-18690-1-git-send-email-carlos.chinea@nokia.com>
 <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com>
 <1223034750-18690-3-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 03 Oct 2008 11:52:57.0201 (UTC) FILETIME=[93AC9E10:01C9254E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 drivers/misc/Kconfig  |    2 ++
 drivers/misc/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index f0202ee..b09dc68 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -488,4 +488,6 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+source "drivers/misc/ssi/Kconfig"
+
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index b6167e7..39e153d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
+obj-$(CONFIG_OMAP_SSI)		+= ssi/
-- 
1.5.3.6

