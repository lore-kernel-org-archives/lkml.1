Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZJVDp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZJVDp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZJVDpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33561 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJVDpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:21 -0400
Subject: [PATCH 3/7] Documentation: ABI: /sys/devices/system/cpu/ topology
	files
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:25 -0600
Message-ID: <20091022034525.13399.4286.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add brief descriptions for the following sysfs files:

	/sys/devices/system/cpu/kernel_max
	/sys/devices/system/cpu/offline
	/sys/devices/system/cpu/online
	/sys/devices/system/cpu/possible
	/sys/devices/system/cpu/present

Excerpted the relevant information from Documentation/cputopology.txt
and pointed back to cputopology.txt as the authoritative source of
information.

Cc: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   28 ++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 86126b1..871acdb 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -10,6 +10,34 @@ Description:
 		/sys/devices/system/cpu/cpu#/
 
 
+What:		/sys/devices/system/cpu/kernel_max
+		/sys/devices/system/cpu/offline
+		/sys/devices/system/cpu/online
+		/sys/devices/system/cpu/possible
+		/sys/devices/system/cpu/present
+Date:		December 2008
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CPU topology files that describe kernel limits related to
+		hotplug. Briefly:
+
+		kernel_max: the maximum cpu index allowed by the kernel
+		configuration.
+
+		offline: cpus that are not online because they have been
+		HOTPLUGGED off or exceed the limit of cpus allowed by the
+		kernel configuration (kernel_max above).
+
+		online: cpus that are online and being scheduled.
+
+		possible: cpus that have been allocated resources and can be
+		brought online if they are present.
+
+		present: cpus that have been identified as being present in
+		the system.
+
+		See Documentation/cputopology.txt for more information.
+
+
 What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
 Date:      August 2008
 KernelVersion:	2.6.27

