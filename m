Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZKPVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZKPVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZKPVRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:17:14 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10353 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZKPVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:17:14 -0500
Date: Mon, 16 Nov 2009 14:17:19 -0700
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: ABI: /sys/devices/system/cpu/cpu#/online
Message-ID: <20091116211719.GE21242@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for CPU hotplug interface.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
I forgot to send this patch in the last round of documentation
updates, and wanted to send it before it gets misplaced. ;)

---
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index a703b9e..5aace16 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -62,7 +62,6 @@ Description:	CPU topology files that describe kernel limits related to
 		See Documentation/cputopology.txt for more information.
 
 
-
 What:		/sys/devices/system/cpu/cpu#/node
 Date:		October 2009
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
@@ -77,6 +76,24 @@ Description:	Discover NUMA node a CPU belongs to
 		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
 
 
+What:		/sys/devices/system/cpu/cpu#/online
+Date:		January 2006
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Discover and change the online state of a CPU.
+
+		To discover the state:
+
+		cat /sys/devices/system/cpu/cpu#/online
+
+		A value of 0 indicates the CPU is offline. A value of 1
+		indicates it is online. To change the state, echo the
+		desired new state into the file:
+
+		echo [0|1] > /sys/devices/system/cpu/$cpu/online
+
+		For more information, please read Documentation/cpu-hotplug.txt
+
+
 What:		/sys/devices/system/cpu/cpu#/topology/core_id
 		/sys/devices/system/cpu/cpu#/topology/core_siblings
 		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
