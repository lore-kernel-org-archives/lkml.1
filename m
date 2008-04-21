Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbYDUIzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbYDUIzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbYDUIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:52:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58540 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbYDUIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:52:13 -0400
Date: Mon, 21 Apr 2008 11:51:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: unexport kmap_atomic_to_page
Message-ID: <20080421085144.GH26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used export of kmap_atomic_to_page.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f31eb5842f0a727041ff53355819cac964288428 diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 9cf33d3..165c871 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -155,4 +155,3 @@ EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
-EXPORT_SYMBOL(kmap_atomic_to_page);

