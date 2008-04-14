Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbYDNNGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbYDNNGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYDNNFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:05:53 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44010 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYDNNFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:05:52 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Takashi Yamamoto <TakashiA.Yamamoto@jp.sony.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] PS3: fix compile error
Date: Mon, 14 Apr 2008 22:00:45 +0900
Message-Id: <1208178045-22921-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ps3/ps3-lpm.c: In function 'ps3_set_pm_bookmark':
drivers/ps3/ps3-lpm.c:192: error: implicit declaration of function 'get_tb'
make[3]: *** [drivers/ps3/ps3-lpm.o] Error 1

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Takashi Yamamoto <TakashiA.Yamamoto@jp.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 drivers/ps3/ps3-lpm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
index 6c9592c..85edf94 100644
--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
+#include <asm/time.h>
 #include <asm/ps3.h>
 #include <asm/lv1call.h>
 #include <asm/cell-pmu.h>
-- 
1.5.4.2

