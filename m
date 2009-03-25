Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZCYAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZCYAc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZCYA3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:42 -0400
Received: from kroah.org ([198.145.64.141]:54055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755823AbZCYA3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, schwidefsky@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH 09/61] s390: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:13 -0700
Message-Id: <1237940825-22904-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: schwidefsky@de.ibm.com
Cc: linux-s390@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/s390/net/qeth_l3_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 3d04920..0dcc036 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1038,7 +1038,7 @@ static int qeth_l3_setadapter_parms(struct qeth_card *card)
 	rc = qeth_query_setadapterparms(card);
 	if (rc) {
 		QETH_DBF_MESSAGE(2, "%s couldn't set adapter parameters: "
-			"0x%x\n", card->gdev->dev.bus_id, rc);
+			"0x%x\n", dev_name(&card->gdev->dev), rc);
 		return rc;
 	}
 	if (qeth_adp_supported(card, IPA_SETADP_ALTER_MAC_ADDRESS)) {
-- 
1.6.2

