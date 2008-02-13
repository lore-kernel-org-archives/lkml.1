Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbYBMVfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbYBMVfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYBMVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:15 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47474 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763377AbYBMVaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:11 -0500
Date: Wed, 13 Feb 2008 23:29:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ian Campbell <ijc@hellion.org.uk>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: don't make swapper_pg_fixmap global
Message-ID: <20080213212955.GP3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not required for swapper_pg_fixmap to be global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cdaa89e8d9f49eecc6ec9052db1d65a62f1be04b diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 74ef4a4..25eb985 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -612,7 +612,7 @@ ENTRY(swapper_pg_pmd)
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
 #endif
-ENTRY(swapper_pg_fixmap)
+swapper_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
