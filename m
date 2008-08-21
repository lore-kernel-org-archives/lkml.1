Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYHUEsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYHUEsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYHUErL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:60662 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbYHUErH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:07 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 4/9] rtc: use CONFIG_PPC instead of CONFIG_PPC_MERGE
Date: Wed, 20 Aug 2008 23:46:53 -0500
Message-Id: <1219294018-12557-5-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
CC: rtc-linux@googlegroups.com
CC: a.zummo@towertech.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms and we want to get rid of it use CONFIG_PPC instead.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rtc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9a9755c..fd32828 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -577,7 +577,7 @@ config RTC_DRV_RS5C313
 
 config RTC_DRV_PPC
        tristate "PowerPC machine dependent RTC support"
-       depends on PPC_MERGE
+       depends on PPC
        help
 	 The PowerPC kernel has machine-specific functions for accessing
 	 the RTC. This exposes that functionality through the generic RTC
-- 
1.5.5.1

