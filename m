Return-Path: <linux-kernel-owner+w=401wt.eu-S934529AbYDNSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbYDNSo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934179AbYDNSmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:20 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51094 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934175AbYDNSmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:19 -0400
Date: Mon, 14 Apr 2008 21:41:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper extern for mwave_s_mdd
Message-ID: <20080414184113.GP6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper extern for mwave_s_mdd in 
drivers/char/mwave/mwavedd.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/char/mwave/mwavedd.h |    2 ++
 drivers/char/mwave/tp3780i.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

5bb7b6d25cce1a8515e448c6dd64bd4da6525c64 diff --git a/drivers/char/mwave/mwavedd.h b/drivers/char/mwave/mwavedd.h
index 8eca61e..7e0d530 100644
--- a/drivers/char/mwave/mwavedd.h
+++ b/drivers/char/mwave/mwavedd.h
@@ -147,4 +147,6 @@ typedef struct _MWAVE_DEVICE_DATA {
 
 } MWAVE_DEVICE_DATA, *pMWAVE_DEVICE_DATA;
 
+extern MWAVE_DEVICE_DATA mwave_s_mdd;
+
 #endif
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index f282976..c689697 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -57,8 +57,6 @@
 #include "3780i.h"
 #include "mwavepub.h"
 
-extern MWAVE_DEVICE_DATA mwave_s_mdd;
-
 static unsigned short s_ausThinkpadIrqToField[16] =
 	{ 0xFFFF, 0xFFFF, 0xFFFF, 0x0001, 0x0002, 0x0003, 0xFFFF, 0x0004,
 	0xFFFF, 0xFFFF, 0x0005, 0x0006, 0xFFFF, 0xFFFF, 0xFFFF, 0x0007 };


