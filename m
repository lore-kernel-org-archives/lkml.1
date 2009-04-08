Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbZDHJC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbZDHJC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZDHJCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:02:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZDHJCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:02:17 -0400
Message-ID: <49DC6751.30308@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 16:58:57 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Make __stringify support variable argument macro
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example:
__stringify(__entry->irq, __entry->ret) will convert it to:
"REC->irq, REC->ret"

It also support single argument as old macro.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/stringify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/stringify.h b/include/linux/stringify.h
index 0b43883..841cec8 100644
--- a/include/linux/stringify.h
+++ b/include/linux/stringify.h
@@ -6,7 +6,7 @@
  * converts to "bar".
  */
 
-#define __stringify_1(x)	#x
-#define __stringify(x)		__stringify_1(x)
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
 
 #endif	/* !__LINUX_STRINGIFY_H */
-- 
1.5.5.3


