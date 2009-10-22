Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZJVDp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZJVDp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbZJVDpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:40 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:17075 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZJVDph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:37 -0400
Subject: [PATCH 6/7] Documentation: ABI: /sys/devices/system/cpu/cpuidle/
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:41 -0600
Message-ID: <20091022034541.13399.59424.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document cpuidle sysfs attributes by reading code, Documentation/cpuidle/,
and git logs.

Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 8cdda1c..968d8ba 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -101,6 +101,26 @@ Description:	CPU topology files that describe a logical CPU's relationship
 		See Documentation/cputopology.txt for more information.
 
 
+What:		/sys/devices/system/cpu/cpuidle/current_driver
+		/sys/devices/system/cpu/cpuidle/current_governer_ro
+Date:		September 2007
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Discover cpuidle policy and mechanism
+
+		Various CPUs today support multiple idle levels that are
+		differentiated by varying exit latencies and power
+		consumption during idle.
+
+		Idle policy (governor) is differentiated from idle mechanism
+		(driver)
+
+		current_driver: displays current idle mechanism
+
+		current_governor_ro: displays current idle policy
+
+		See files in Documentation/cpuidle/ for more information.
+
+
 What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
 Date:      August 2008
 KernelVersion:	2.6.27

