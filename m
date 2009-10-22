Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZJVDpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZJVDpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZJVDpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:18269 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZJVDpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:16 -0400
Subject: [PATCH 2/7] Documentation: ABI: document /sys/devices/system/cpu/
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:20 -0600
Message-ID: <20091022034520.13399.23985.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface has been around for a long time, but hasn't been
officially documented.

Document the top level sysfs directory for CPU attributes.

Signed-off-by: Alex Chiang <achiang@hp.com>
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

