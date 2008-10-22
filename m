Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYJVRe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYJVRe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYJVRcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:52 -0400
Received: from kroah.org ([198.145.64.141]:53018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752497AbYJVRcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/42] staging: fix potential build error in slicoss driver
Date: Wed, 22 Oct 2008 10:28:47 -0700
Message-Id: <1224696563-5170-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This hides under DEBUG_REGISTER_TRACE so probably
not visible to many people.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/slicoss/slicoss.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b61ac4b..47b0ae1 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -275,7 +275,6 @@ static void slic_dbg_register_trace(struct adapter *adapter,
 			  card->reg_value[i], card->reg_valueh[i]);
 	}
 }
-}
 #endif
 
 static void slic_init_adapter(struct net_device *netdev,
-- 
1.6.0.2

