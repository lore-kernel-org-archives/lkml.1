Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbZJ3Wyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbZJ3Wyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933038AbZJ3Wyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:54:31 -0400
Received: from kroah.org ([198.145.64.141]:38974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035AbZJ3Wy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/9] Documentation: ABI: document /sys/devices/system/cpu/
Date: Fri, 30 Oct 2009 15:54:23 -0700
Message-Id: <1256943268-12164-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

This interface has been around for a long time, but hasn't been
officially documented.

Document the top level sysfs directory for CPU attributes.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 175bb4f..86126b1 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -1,3 +1,15 @@
+What:		/sys/devices/system/cpu/
+Date:		pre-git history
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		A collection of both global and individual CPU attributes
+
+		Individual CPU attributes are contained in subdirectories
+		named by the kernel's logical CPU number, e.g.:
+
+		/sys/devices/system/cpu/cpu#/
+
+
 What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
 Date:      August 2008
 KernelVersion:	2.6.27
-- 
1.6.4.2

