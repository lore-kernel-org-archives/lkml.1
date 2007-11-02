Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbXKBPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbXKBPrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbXKBPpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:45:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53869 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760512AbXKBPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:59 -0400
Date: Fri, 2 Nov 2007 16:44:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/notifier.c should #include <linux/reboot.h>
Message-ID: <20071102154437.GQ30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case {,un}register_reboot_notifier()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f204a842031e86e45e97c26e955565b5994f7c7c 
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 4253f47..643360d 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -4,6 +4,7 @@
 #include <linux/notifier.h>
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
+#include <linux/reboot.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
