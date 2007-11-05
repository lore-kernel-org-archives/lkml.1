Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXKERRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXKERRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbXKERIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:18 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59541 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757747AbXKERIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:17 -0500
Date: Mon, 5 Nov 2007 18:07:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] blackfin: unexport get_wchan
Message-ID: <20071105170753.GX12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(get_wchan).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6acc2faa1f25d2d5fbf6c5e435c222a79f753afa 
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 99ea57c..5dad9d3 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -65,7 +65,6 @@ EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcmp);
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memchr);
-EXPORT_SYMBOL(get_wchan);
 
 /*
  * libgcc functions - functions that are used internally by the

