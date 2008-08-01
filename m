Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYHAQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYHAQqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYHAQoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:44:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:50636 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYHAQod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:44:33 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] rtc: use CONFIG_PPC instead of CONFIG_PPC_MERGE
Date: Fri,  1 Aug 2008 11:44:15 -0500
Message-Id: <1217609060-6381-6-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217609060-6381-5-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-3-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-4-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-5-git-send-email-galak@kernel.crashing.org>
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
index 90ab738..564a3ed 100644
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

