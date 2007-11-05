Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXKERNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXKERNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXKERHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:43 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59509 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757516AbXKERHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:41 -0500
Date: Mon, 5 Nov 2007 18:07:18 +0100
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/common/ir-functions.c: make a function static
Message-ID: <20071105170718.GK12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ir_rc5_decode() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/common/ir-functions.c |    3 +--
 include/media/ir-common.h           |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

b0c2b9ed5b57f3a18160f03305a569eaee5e2bc2 
diff --git a/drivers/media/common/ir-functions.c b/drivers/media/common/ir-functions.c
index e7c3ab9..bb2a027 100644
--- a/drivers/media/common/ir-functions.c
+++ b/drivers/media/common/ir-functions.c
@@ -258,7 +258,7 @@ int ir_decode_biphase(u32 *samples, int count, int low, int high)
  * saa7134 */
 
 /* decode raw bit pattern to RC5 code */
-u32 ir_rc5_decode(unsigned int code)
+static u32 ir_rc5_decode(unsigned int code)
 {
 	unsigned int org_code = code;
 	unsigned int pair;
@@ -371,7 +371,6 @@ EXPORT_SYMBOL_GPL(ir_dump_samples);
 EXPORT_SYMBOL_GPL(ir_decode_biphase);
 EXPORT_SYMBOL_GPL(ir_decode_pulsedistance);
 
-EXPORT_SYMBOL_GPL(ir_rc5_decode);
 EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
 EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
 
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 7a785fa..b904d32 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -97,7 +97,6 @@ int  ir_dump_samples(u32 *samples, int count);
 int  ir_decode_biphase(u32 *samples, int count, int low, int high);
 int  ir_decode_pulsedistance(u32 *samples, int count, int low, int high);
 
-u32 ir_rc5_decode(unsigned int code);
 void ir_rc5_timer_end(unsigned long data);
 void ir_rc5_timer_keyup(unsigned long data);
 

