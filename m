Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXKERLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXKERLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbXKERHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:17 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59494 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756947AbXKERHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:16 -0500
Date: Mon, 5 Nov 2007 18:06:52 +0100
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport flexcop_reset_block_300
Message-ID: <20071105170652.GG12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(flexcop_reset_block_300).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6.17-rc1-mm3-full/drivers/media/dvb/b2c2/flexcop.c.old	2006-04-19 21:42:40.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/dvb/b2c2/flexcop.c	2006-04-19 21:43:02.000000000 +0200
@@ -215,7 +215,6 @@
 
 	fc->write_ibi_reg(fc,ctrl_208,v208_save);
 }
-EXPORT_SYMBOL(flexcop_reset_block_300);
 
 struct flexcop_device *flexcop_device_kmalloc(size_t bus_specific_len)
 {


