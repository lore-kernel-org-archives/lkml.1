Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbXGAUZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbXGAUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbXGAUWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:22:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46867 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759040AbXGAUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:21:52 -0400
Date: Sun, 1 Jul 2007 22:22:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [-mm patch] fix include/asm-m68k/fb.h
Message-ID: <20070701202219.GP10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/include/asm-m68k/fb.h.old	2007-06-30 02:40:16.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-m68k/fb.h	2007-06-30 02:40:25.000000000 +0200
@@ -15,6 +15,7 @@
 #else
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
+{
 	if (CPU_IS_020_OR_030)
 		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
 	if (CPU_IS_040_OR_060) {

