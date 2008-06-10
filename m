Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYFJHPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYFJHPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYFJHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:14:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:33603 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYFJHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:14:53 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-164.messagelabs.com!1213082092!8146598!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] UIO: minor style and comment fixes
Date: Tue, 10 Jun 2008 09:14:48 +0200
Message-ID: <1213082088-24294-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <20080610071032.GB22814@digi.com>
References: <20080610071032.GB22814@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jun 2008 07:14:49.0238 (UTC) FILETIME=[AB5E4B60:01C8CAC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
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
1.5.5.3

