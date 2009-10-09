Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbZJIJCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbZJIJCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760427AbZJIJCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:02:08 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:55108 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760423AbZJIJCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:02:07 -0400
Date: Fri, 09 Oct 2009 18:01:20 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/6] Haptic: Documentation for haptic class (v2)
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091009090120.GA24935@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 09 Oct 2009 09:01:28.0294 (UTC)
 FILETIME=[16434060:01CA48BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the haptic class and how to use

Changelog v1:
	Apply comments and feedbacks

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/haptic-class.txt |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/haptic-class.txt

diff --git a/Documentation/haptic-class.txt b/Documentation/haptic-class.txt
new file mode 100644
index 0000000..6bee82a
--- /dev/null
+++ b/Documentation/haptic-class.txt
@@ -0,0 +1,20 @@
+
+Haptic handling under Linux
+========================
+
+In its simplest form, the haptic class just allows control of Haptics from
+userspace. Haptic appears in /sys/class/haptic/. The maximum level of the
+haptic is defined in max_level file.
+
+The interface is pretty simple - it provides oneshot mode where user
+can specify duration of the effect (in milliseconds) and desired level
+Of course, you can adjust the level by setting level property
+
+# echo ${millisecond} > /sys/class/haptic/<device>/oneshot
+
+# echo ${level} > /sys/class/haptic/<device>/level
+
+You can also enable or disable haptics devices by manipulating 'enable' attribute:
+
+# echo 1 > /sys/class/haptic/<device>/enable	-> Enable
+# echo 0 > /sys/class/haptic/<device>/enable	-> Disable
-- 
1.5.3.3

