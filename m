Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbXCZKL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbXCZKL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXCZKLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:11:55 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22326 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbXCZKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:11:54 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="32577294:sNHT23302146"
Subject: [PATCH -mm] Blackfin arch: power management replace firmware disk
	mode
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:12:16 +0800
Message-Id: <1174903937.32691.70.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This patches replace firmware disk mode according to include/linux/pm.h

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 arch/blackfin/mach-common/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.x/arch/blackfin/mach-common/pm.c
===================================================================
--- linux-2.6.x.orig/arch/blackfin/mach-common/pm.c
+++ linux-2.6.x/arch/blackfin/mach-common/pm.c
@@ -166,7 +166,7 @@
 }
 
 struct pm_ops bfin_pm_ops = {
-	.pm_disk_mode = PM_DISK_FIRMWARE,
+	.pm_disk_mode = PM_DISK_PLATFORM,
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
_

Thanks,
-Bryan Wu
