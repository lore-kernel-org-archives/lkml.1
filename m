Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZJ3WzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZJ3WzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbZJ3WzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:55:06 -0400
Received: from kroah.org ([198.145.64.141]:38989 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043AbZJ3Wyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/9] Documentation: ABI: /sys/devices/system/cpu/cpuidle/
Date: Fri, 30 Oct 2009 15:54:27 -0700
Message-Id: <1256943268-12164-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

Document cpuidle sysfs attributes by reading code, Documentation/cpuidle/,
and git logs.

Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
-- 
1.6.4.2

