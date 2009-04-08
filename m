Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbZDHLjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbZDHLjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbZDHL1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:27:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49243 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932128AbZDHL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:47 -0400
X-Sasl-enc: 4bQ9C9tDQJLuBLBzIXv+Au7jIJR/lNEmFZfFW99BYDlf 1239190064
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 42/56] drivers/s390: Remove void casts
Date: Wed,  8 Apr 2009 12:22:14 +0100
Message-Id: <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
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
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/s390/net/qeth_core_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index c827d69..454e181 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1037,7 +1037,7 @@ static int qeth_is_1920_device(struct qeth_card *card)
 	QETH_DBF_TEXT(SETUP, 2, "chk_1920");
 
 	ccwdev = card->data.ccwdev;
-	chp_dsc = (struct channelPath_dsc *)ccw_device_get_chp_desc(ccwdev, 0);
+	chp_dsc = ccw_device_get_chp_desc(ccwdev, 0);
 	if (chp_dsc != NULL) {
 		/* CHPP field bit 6 == 1 -> single queue */
 		single_queue = ((chp_dsc->chpp & 0x02) == 0x02);
-- 
1.5.4.3

