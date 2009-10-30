Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbZJ3Wyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbZJ3Wyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbZJ3Wyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:54:35 -0400
Received: from kroah.org ([198.145.64.141]:38985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000AbZJ3Wyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/9] Documentation: ABI: /sys/devices/system/cpu/sched_[mc|smt]_power_savings
Date: Fri, 30 Oct 2009 15:54:26 -0700
Message-Id: <1256943268-12164-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

Document sched_[mc|smt]_power_savings by reading existing code and
git logs.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   24 ++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 2ade5c0..8cdda1c 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,6 +9,30 @@ Description:
 
 		/sys/devices/system/cpu/cpu#/
 
+What:		/sys/devices/system/cpu/sched_mc_power_savings
+		/sys/devices/system/cpu/sched_smt_power_savings
+Date:		June 2006
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Discover and adjust the kernel's multi-core scheduler support.
+
+		Possible values are:
+
+		0 - No power saving load balance (default value)
+		1 - Fill one thread/core/package first for long running threads
+		2 - Also bias task wakeups to semi-idle cpu package for power
+		    savings
+
+		sched_mc_power_savings is dependent upon SCHED_MC, which is
+		itself architecture dependent.
+
+		sched_smt_power_savings is dependent upon SCHED_SMT, which
+		is itself architecture dependent.
+
+		The two files are independent of each other. It is possible
+		that one file may be present without the other.
+
+		Introduced by git commit 5c45bf27.
+
 
 What:		/sys/devices/system/cpu/kernel_max
 		/sys/devices/system/cpu/offline
-- 
1.6.4.2

