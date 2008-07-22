Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbYGVFle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbYGVFle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYGVFZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:43370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYGVFZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [PATCH 59/79] UIO: minor style and comment fixes
Date: Mon, 21 Jul 2008 22:19:23 -0700
Message-Id: <1216703983-21448-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 include/linux/uio_driver.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index cf65e96..cdf338d 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -36,7 +36,7 @@ struct uio_mem {
 	struct uio_map		*map;
 };
 
-#define MAX_UIO_MAPS 	5
+#define MAX_UIO_MAPS	5
 
 struct uio_device;
 
@@ -82,11 +82,11 @@ static inline int __must_check
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
 
-/* defines for uio_device->irq */
+/* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM	-1
 #define UIO_IRQ_NONE	-2
 
-/* defines for uio_device->memtype */
+/* defines for uio_mem->memtype */
 #define UIO_MEM_NONE	0
 #define UIO_MEM_PHYS	1
 #define UIO_MEM_LOGICAL	2
-- 
1.5.6.3

