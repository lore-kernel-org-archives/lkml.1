Return-Path: <linux-kernel-owner+w=401wt.eu-S1761571AbYEESoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761571AbYEESoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761770AbYEESbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:31:06 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55341 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761751AbYEESbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:31:05 -0400
Date: Mon, 5 May 2008 21:29:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] avr32: export copy_page
Message-ID: <20080505182957.GC17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 61 modules
ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Also add an empty line since *_page aren't "String functions".

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ccf339103c0463b9528a42f133bbe4adeae6ad99 diff --git a/arch/avr32/kernel/avr32_ksyms.c b/arch/avr32/kernel/avr32_ksyms.c
index 80f55f8..3a090ba 100644
--- a/arch/avr32/kernel/avr32_ksyms.c
+++ b/arch/avr32/kernel/avr32_ksyms.c
@@ -29,7 +29,9 @@ EXPORT_SYMBOL(__avr32_asr64);
  */
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
+
 EXPORT_SYMBOL(clear_page);
+EXPORT_SYMBOL(copy_page);
 
 /*
  * Userspace access stuff.

