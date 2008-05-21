Return-Path: <linux-kernel-owner+w=401wt.eu-S937290AbYEUWEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937290AbYEUWEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYEUWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:03:55 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41264 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758435AbYEUWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:03:54 -0400
Date: Thu, 22 May 2008 01:01:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: export strnlen_user
Message-ID: <20080521220138.GA16376@cs181133002.pp.htv.fi>
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
  MODPOST 1327 modules
ERROR: "strnlen_user" [drivers/input/misc/uinput.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0318ae73cb3e61e5c192d62c22d988424e04f354 diff --git a/arch/avr32/kernel/avr32_ksyms.c b/arch/avr32/kernel/avr32_ksyms.c
index 3a090ba..84a7d44 100644
--- a/arch/avr32/kernel/avr32_ksyms.c
+++ b/arch/avr32/kernel/avr32_ksyms.c
@@ -43,6 +43,8 @@ EXPORT_SYMBOL(strncpy_from_user);
 EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(clear_user);
 EXPORT_SYMBOL(__clear_user);
+EXPORT_SYMBOL(strnlen_user);
+
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(csum_partial_copy_generic);
 

