Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab0CLW4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:56:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55355 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab0CLW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:56:15 -0500
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Add xtime, wall_to_monotonic to feature-removal-schedule
Date: Fri, 12 Mar 2010 14:56:00 -0800
Message-Id: <1268434560-2677-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They aren't really features, but fair warning to out of tree
driver folks who might be accessing these variables.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Documentation/feature-removal-schedule.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a5cc0db..b545080 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -582,3 +582,16 @@ Why:	The paravirt mmu host support is slower than non-paravirt mmu, both
 Who:	Avi Kivity <avi@redhat.com>
 
 ----------------------------
+
+What:  xtime, wall_to_monotonic
+When:  2.6.36+
+Files: kernel/time/timekeeping.c include/linux/time.h
+Why:   Cleaning up timekeeping internal values. Please use
+       existing timekeeping accessor functions to access
+       the equivalent functionality.
+Who:   John Stultz <johnstul@us.ibm.com>
+
+----------------------------
+
+
+
-- 
1.6.0.4

