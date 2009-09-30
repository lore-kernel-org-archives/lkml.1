Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZI3PLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZI3PLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZI3PLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:11:30 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52037 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbZI3PL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:11:29 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org, ilkka.koskinen@nokia.com
Subject: [PATCH 1/2] twl4030: Do not dereference null pointer in error path
Date: Wed, 30 Sep 2009 18:11:54 +0300
Message-Id: <1254323515-30866-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 30 Sep 2009 15:11:24.0839 (UTC) FILETIME=[46B77B70:01CA41E0]
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

