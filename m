Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZJVDpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZJVDpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZJVDpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:38 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:37729 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZJVDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:33 -0400
Subject: [PATCH 5/7] Documentation: ABI:
	/sys/devices/system/cpu/sched_[mc|smt]_power_savings
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:36 -0600
Message-ID: <20091022034536.13399.98197.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document sched_[mc|smt]_power_savings by reading existing code and
git logs.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alex Chiang <achiang@hp.com>
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

