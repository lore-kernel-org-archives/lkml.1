Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZJVDpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZJVDpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZJVDpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:16 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:46910 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZJVDpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:11 -0400
Subject: [PATCH 1/7] Documentation: ABI: rename sysfs-devices-cache_disable
	properly
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Date: Wed, 21 Oct 2009 21:45:15 -0600
Message-ID: <20091022034515.13399.39630.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename sysfs-devices-cache_disable to sysfs-devices-system-cpu, in
order to keep a stricter correlation between a sysfs directory and
its documentation.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 .../ABI/testing/sysfs-devices-cache_disable        |   18 ------------------
 Documentation/ABI/testing/sysfs-devices-system-cpu |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-cpu

diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
deleted file mode 100644
index 175bb4f..0000000
--- a/Documentation/ABI/testing/sysfs-devices-cache_disable
+++ /dev/null
@@ -1,18 +0,0 @@
-What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
-Date:      August 2008
-KernelVersion:	2.6.27
-Contact:	mark.langsdorf@amd.com
-Description:	These files exist in every cpu's cache index directories.
-		There are currently 2 cache_disable_# files in each
-		directory.  Reading from these files on a supported
-		processor will return that cache disable index value
-		for that processor and node.  Writing to one of these
-		files will cause the specificed cache index to be disabled.
-
-		Currently, only AMD Family 10h Processors support cache index
-		disable, and only for their L3 caches.  See the BIOS and
-		Kernel Developer's Guide at
-		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
-		for formatting information and other details on the
-		cache index disable.
-Users:    joachim.deguara@amd.com
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
new file mode 100644
index 0000000..175bb4f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -0,0 +1,18 @@
+What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
+Date:      August 2008
+KernelVersion:	2.6.27
+Contact:	mark.langsdorf@amd.com
+Description:	These files exist in every cpu's cache index directories.
+		There are currently 2 cache_disable_# files in each
+		directory.  Reading from these files on a supported
+		processor will return that cache disable index value
+		for that processor and node.  Writing to one of these
+		files will cause the specificed cache index to be disabled.
+
+		Currently, only AMD Family 10h Processors support cache index
+		disable, and only for their L3 caches.  See the BIOS and
+		Kernel Developer's Guide at
+		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
+		for formatting information and other details on the
+		cache index disable.
+Users:    joachim.deguara@amd.com

