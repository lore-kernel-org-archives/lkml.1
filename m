Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbZJ3WzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbZJ3WzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbZJ3Wyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:54:33 -0400
Received: from kroah.org ([198.145.64.141]:38978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbZJ3Wya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/9] Documentation: ABI: /sys/devices/system/cpu/ topology files
Date: Fri, 30 Oct 2009 15:54:24 -0700
Message-Id: <1256943268-12164-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
-- 
1.6.4.2

