Return-Path: <linux-kernel-owner+w=401wt.eu-S1763520AbYA3O2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763520AbYA3O2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYA3O2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:28:21 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43271 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYA3O2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:28:20 -0500
Message-ID: <47A08980.1020905@tiscali.nl>
Date: Wed, 30 Jan 2008 15:28:16 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/pcmcia/ti113x.h] ENE_TEST_C9_PFENABLE duplicate *_F0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch below, please confirm it's the right fix.
--
duplicate ENE_TEST_C9_PFENABLE_F0, 2nd should be *_F1

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/pcmcia/ti113x.h b/drivers/pcmcia/ti113x.h
index d29657b..87a5fd5 100644
--- a/drivers/pcmcia/ti113x.h
+++ b/drivers/pcmcia/ti113x.h
@@ -155,7 +155,7 @@
 #define ENE_TEST_C9_TLTENABLE		0x02
 #define ENE_TEST_C9_PFENABLE_F0		0x04
 #define ENE_TEST_C9_PFENABLE_F1		0x08
-#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F0)
+#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F1)
 #define ENE_TEST_C9_WPDISALBLE_F0	0x40
 #define ENE_TEST_C9_WPDISALBLE_F1	0x80
 #define ENE_TEST_C9_WPDISALBLE		(ENE_TEST_C9_WPDISALBLE_F0 | ENE_TEST_C9_WPDISALBLE_F1)
