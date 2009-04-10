Return-Path: <linux-kernel-owner+w=401wt.eu-S938399AbZDJMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938399AbZDJMlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936050AbZDJMj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:39:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:45888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938263AbZDJMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:39:27 -0400
Date: Fri, 10 Apr 2009 12:37:35 GMT
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409133153.GL31527@alberich.amd.com>
References: <20090409133153.GL31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86/docs: add description for cache_disable sysfs interface
Message-ID: <tip-2fad2d9bb8310889f3261035b594b4e068b6eb8b@git.kernel.org>
Git-Commit-ID: 2fad2d9bb8310889f3261035b594b4e068b6eb8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:37:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fad2d9bb8310889f3261035b594b4e068b6eb8b
Gitweb:     http://git.kernel.org/tip/2fad2d9bb8310889f3261035b594b4e068b6eb8b
Author:     Mark Langsdorf <mark.langsdorf@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:31:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:22:40 +0200

x86/docs: add description for cache_disable sysfs interface

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090409133153.GL31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../ABI/testing/sysfs-devices-cache_disable        |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-cache_disable b/Documentation/ABI/testing/sysfs-devices-cache_disable
new file mode 100644
index 0000000..175bb4f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-cache_disable
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
