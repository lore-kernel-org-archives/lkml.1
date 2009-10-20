Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZJTNX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZJTNX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZJTNX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:23:27 -0400
Received: from smtp.nokia.com ([192.100.105.134]:63421 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZJTNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:23:27 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [Resend PATCH 1/2] twl4030: Do not dereference null pointer in error path
Date: Tue, 20 Oct 2009 16:22:52 +0300
Message-Id: <1256044973-14548-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 20 Oct 2009 13:23:25.0919 (UTC) FILETIME=[813DBEF0:01CA5188]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/mfd/twl4030-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index e424cf6..8cf0a02 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -792,7 +792,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			twl->client = i2c_new_dummy(client->adapter,
 					twl->address);
 			if (!twl->client) {
-				dev_err(&twl->client->dev,
+				dev_err(&client->dev,
 					"can't attach client %d\n", i);
 				status = -ENOMEM;
 				goto fail;
-- 
1.6.0.4

