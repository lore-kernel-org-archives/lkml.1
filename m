Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZA0PCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZA0PCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZA0PCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:02:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZA0PCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:02:37 -0500
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: Andre Haupt <andre@bitwigglers.org>, marcel@holtmann.org
Subject: [PATCH] bluetooth/bt3c: eliminate a sparse warning.
Date: Tue, 27 Jan 2009 16:02:31 +0100
Message-Id: <1233068551-13210-1-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.6.1.213.g28da8
X-Provags-ID: V01U2FsdGVkX1+ZimHfzHiYJ+LgX8E1VRs7V4bt51oPJIZ8V5j
 nIyK5K/nOvbf6ujL1ZxegqZfwRAFIqb01Af0Puuh/2mbk9huWs
 tuhKzLi8X3/ZAxhyzDiD3g8UP95g8WkC5ZP4iuBnig=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates a sparse warning that symbol 'stat' shadows an earlier one.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/bluetooth/bt3c_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index ff195c2..d58e22b 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -359,9 +359,9 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 			BT_ERR("Very strange (stat=0x%04x)", stat);
 		} else if ((stat & 0xff) != 0xff) {
 			if (stat & 0x0020) {
-				int stat = bt3c_read(iobase, 0x7002) & 0x10;
+				int status = bt3c_read(iobase, 0x7002) & 0x10;
 				BT_INFO("%s: Antenna %s", info->hdev->name,
-							stat ? "out" : "in");
+							status ? "out" : "in");
 			}
 			if (stat & 0x0001)
 				bt3c_receive(info);
-- 
1.6.1.213.g28da8

