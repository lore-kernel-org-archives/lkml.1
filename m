Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbZDINcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbZDINcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZDINc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:32:26 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8762 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758748AbZDINcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:32:25 -0400
X-BigFish: VPS-32(z34a4jz13e6S936eQ936fKzz1202hzz5eeeTz32i6bh)
X-FB-SS: 5,13,
X-WSS-ID: 0KHU5LC-02-0RI-01
Date: Thu, 9 Apr 2009 15:31:53 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 8/8] x86/docs: add description for cache_disable sysfs
	interface
Message-ID: <20090409133153.GL31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:31:54.0296 (UTC) FILETIME=[8C1E6B80:01C9B917]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 .../ABI/testing/sysfs-devices-cache_disable        |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable

Oops, shouldn't Date and KernelVersion be adapted to reflect 2.6.30
and say June 2009.

I don't know.

Regards,
Andreas


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
-- 
1.6.2



