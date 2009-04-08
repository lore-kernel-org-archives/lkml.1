Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZDHL2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZDHL2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762947AbZDHLWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50209 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762701AbZDHLWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:49 -0400
X-Sasl-enc: fcGBibSolmpbijVIA/HnltUhkArn0tbYQ1OvkKzbU986 1239189767
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 13/56] i2c: Remove void casts
Date: Wed,  8 Apr 2009 12:21:45 +0100
Message-Id: <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/i2c/i2c-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index b6f3a0d..1578645 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1510,7 +1510,7 @@ struct i2c_adapter* i2c_get_adapter(int id)
 	struct i2c_adapter *adapter;
 
 	mutex_lock(&core_lock);
-	adapter = (struct i2c_adapter *)idr_find(&i2c_adapter_idr, id);
+	adapter = idr_find(&i2c_adapter_idr, id);
 	if (adapter && !try_module_get(adapter->owner))
 		adapter = NULL;
 
-- 
1.5.4.3

