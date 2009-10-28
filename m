Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZJ1W3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZJ1W3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZJ1W3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:29:16 -0400
Received: from mailgw.kvados.cz ([194.213.53.146]:41508 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJ1W3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:29:14 -0400
From: Milan Dadok <milan@dadok.name>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Date: Wed, 28 Oct 2009 23:23:50 +0100
Message-ID: <001601ca581d$5390e0e0$fab2a2a0$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpYHVMYxUwscQT9TLql5bn5YWcw1Q==
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing #include to make hv module compile successfull.

Signed-off-by: Milan Dadok <milan@dadok.name>

---
diff -uprN -X /usr/src/linux/Documentation/dontdiff
/usr/src/linux-2.6.32-rc5/drivers/staging/hv/ChannelMgmt.h
/usr/src/linux/drivers/staging/hv/ChannelMgmt.h
--- /usr/src/linux-2.6.32-rc5/drivers/staging/hv/ChannelMgmt.h  2009-10-28
18:13:04.000000000 +0100
+++ /usr/src/linux/drivers/staging/hv/ChannelMgmt.h     2009-10-28
17:47:28.000000000 +0100
@@ -26,6 +26,7 @@
 #define _CHANNEL_MGMT_H_

 #include <linux/list.h>
+#include <linux/timer.h>
 #include "RingBuffer.h"
 #include "VmbusChannelInterface.h"
 #include "VmbusPacketFormat.h"
diff -uprN -X /usr/src/linux/Documentation/dontdiff
/usr/src/linux-2.6.32-rc5/drivers/staging/hv/osd.h
/usr/src/linux/drivers/staging/hv/osd.h
--- /usr/src/linux-2.6.32-rc5/drivers/staging/hv/osd.h  2009-10-28
18:13:04.000000000 +0100
+++ /usr/src/linux/drivers/staging/hv/osd.h     2009-10-28
17:51:08.000000000 +0100
@@ -25,6 +25,7 @@
 #ifndef _OSD_H_
 #define _OSD_H_

+#include <linux/workqueue.h>

 /* Defines */
 #define ALIGN_UP(value, align) (((value) & (align-1)) ?                \
---

