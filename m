Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXH1IRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXH1IRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXH1IR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:17:27 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:45430 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXH1IRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:17:15 -0400
Message-id: <12315207221202319057@pripojeni.net>
Subject: [PATCH 1/3] V4L: stk11xx, use ARRAY_SIZE in another 2 cases
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 28 Aug 2007 04:17:15 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stk11xx, use ARRAY_SIZE in another 2 cases

There were 2 places with constant in for loop. Use ARRARY_SIZE instead to
allow easy update of the tables.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit addcd116df57eaca525a1c827efdd5bf3e61b7b5
tree a4ee11673dfdbaabe1500cd9e4301bd535177bfa
parent 926af968884e1e153ad2f91892ff71ec33005d22
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 09:53:55 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 09:53:55 +0200

 drivers/media/video/stk1125.c |    2 +-
 drivers/media/video/stk1135.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/stk1125.c b/drivers/media/video/stk1125.c
index ed3cc58..2429225 100644
--- a/drivers/media/video/stk1125.c
+++ b/drivers/media/video/stk1125.c
@@ -80,7 +80,7 @@ static int stk1125_load_microcode(struct stk11xx *dev)
 		break;
 	}
 
-	for (i = 0; i < 59; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_1_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
diff --git a/drivers/media/video/stk1135.c b/drivers/media/video/stk1135.c
index c6e0361..9acd951 100644
--- a/drivers/media/video/stk1135.c
+++ b/drivers/media/video/stk1135.c
@@ -53,7 +53,7 @@ static int stk1135_load_microcode(struct stk11xx *dev)
 		0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
 	};
 
-	for (i = 0; i < 117; i++) {
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
 		stk11xx_read_dummy(dev, 0x02ff);
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
 
