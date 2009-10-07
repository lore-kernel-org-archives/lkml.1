Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZJGGSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZJGGSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbZJGGSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:18:40 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:64463 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbZJGGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:18:38 -0400
Date: Wed, 07 Oct 2009 15:17:54 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/6] Haptic: Documentation for haptic class
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091007061754.GA7588@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 07 Oct 2009 06:18:00.0223 (UTC)
 FILETIME=[EB5EE2F0:01CA4715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the haptic class and how to use

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
+To use simple. it provides the oneshot mode. Give millisecond time to this
+property. It working at given time with pre-defined level.
+Of course, you can adjust the level by setting level property
+
+# echo ${millisecond} > /sys/class/haptic/<device>/oneshot
+
+# echo ${level} > /sys/class/haptic/<device>/level
+
+Also you can enable/disable by setting enable property
+
+# echo 1 > /sys/class/haptic/<device>/level	-> Enable
+# echo 0 > /sys/class/haptic/<device>/level	-> Disable
-- 
1.5.3.3

