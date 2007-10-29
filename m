Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXJ2Mta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXJ2Mta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXJ2MtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33029 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752752AbXJ2MtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:49:04 -0400
Date: Mon, 29 Oct 2007 13:49:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] cpuidle: remove unused exports
Message-ID: <20071029124913.GJ7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused exports:
- cpuidle_devices
- cpuidle_register_governor
- cpuidle_unregister_governor

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/cpuidle/cpuidle.c  |    1 -
 drivers/cpuidle/governor.c |    3 ---
 2 files changed, 4 deletions(-)

d2197cfe905506ff95f6acd1ee6a6cd933419fdf 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index fdf4106..d2fabe7 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -19,7 +19,6 @@
 #include "cpuidle.h"
 
 DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
-EXPORT_PER_CPU_SYMBOL_GPL(cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index bb699cb..70b5964 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -94,8 +94,6 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
 	return ret;
 }
 
-EXPORT_SYMBOL_GPL(cpuidle_register_governor);
-
 /**
  * cpuidle_replace_governor - find a replacement governor
  * @exclude_rating: the rating that will be skipped while looking for
@@ -138,4 +136,3 @@ void cpuidle_unregister_governor(struct cpuidle_governor *gov)
 	mutex_unlock(&cpuidle_lock);
 }
 
-EXPORT_SYMBOL_GPL(cpuidle_unregister_governor);

