Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbYIGXhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbYIGXhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYIGXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:36:52 -0400
Received: from mail.sprymix.net ([69.50.217.222]:33945 "EHLO mail.sprymix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYIGXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:36:52 -0400
X-Greylist: delayed 2032 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2008 19:36:52 EDT
From: Elvis Pranskevichus <el@prans.net>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Elvis Pranskevichus <el@prans.net>
Subject: [PATCH] Input: ALPS - add signature for DualPoint model found in Dell Latitude E6500
Date: Sun,  7 Sep 2008 19:02:56 -0400
Message-Id: <1220828576-10476-1-git-send-email-el@prans.net>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Elvis Pranskevichus <el@prans.net>
---
 drivers/input/mouse/alps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 385e32b..cbedf95 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -54,6 +54,7 @@ static const struct alps_model_info alps_model_data[] = {
 	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
 	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
 	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
+	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude E6500 */
 	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
 };
 
-- 
1.6.0.1

