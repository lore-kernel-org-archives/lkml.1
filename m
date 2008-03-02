Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYCBWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYCBWw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYCBWwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:52:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:40221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYCBWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G6pwfttU2rRzuAbl7f0C44dhUOM/4v8KX4w3Na1ilIjCsA6YVrNmVDZNQoEIX6wzjL2H/e/XOZ8n+uCr9pPjJWuyH6u9AmSQU0pqSJ3PLBPlLfrqH1ovclKCdUVQ572MhxLfk6xiTzYSt5m1wGh5caeBZGd9uF7l/77gsx/TRfc=
Subject: [PATCH 1/3] saa7146: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 14:52:48 -0800
Message-Id: <1204498368.23005.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Follow-on to my sparse warning patch.

 drivers/media/common/saa7146_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 8c755a1..92d51d3 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -74,7 +74,7 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 		if (err) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -89,7 +89,7 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 		saa7146_read(dev, MC2);
 		if (err) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n",	dev->name, __FUNCTION__));
+				"completion\n",	dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -111,7 +111,7 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 		if (!loops--) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		udelay(1);
@@ -125,7 +125,7 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 		saa7146_read(dev, MC2);
 		if (!loops--) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n", dev->name, __FUNCTION__));
+				"completion\n", dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		udelay(5);
-- 
1.5.4.3.409.g8811


