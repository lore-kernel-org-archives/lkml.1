Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZKJWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZKJWhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZKJWhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:37:01 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35067 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbZKJWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:36:59 -0500
Subject: [PATCH v3 5/5] Documentation: ABI: /sys/devices/system/cpu/cpu#/node
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Date: Tue, 10 Nov 2009 15:37:04 -0700
Message-ID: <20091110223704.25636.78808.stgit@bob.kio>
In-Reply-To: <20091110223154.25636.48462.stgit@bob.kio>
References: <20091110223154.25636.48462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe NUMA node symlink created for CPUs when CONFIG_NUMA is set.

Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5aace16..1671634 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -94,6 +94,20 @@ Description:	Discover and change the online state of a CPU.
 		For more information, please read Documentation/cpu-hotplug.txt
 
 
+What:		/sys/devices/system/cpu/cpu#/node
+Date:		October 2009
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Discover NUMA node a CPU belongs to
+
+		When CONFIG_NUMA is enabled, a symbolic link that points
+		to the corresponding NUMA node directory.
+
+		For example, the following symlink is created for cpu42
+		in NUMA node 2:
+
+		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
+
+
 What:		/sys/devices/system/cpu/cpu#/topology/core_id
 		/sys/devices/system/cpu/cpu#/topology/core_siblings
 		/sys/devices/system/cpu/cpu#/topology/core_siblings_list

