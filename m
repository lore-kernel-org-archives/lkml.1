Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbXFQXms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbXFQXms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760710AbXFQXmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37888 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760611AbXFQXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:30 -0400
Date: Mon, 18 Jun 2007 01:42:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/namespace.c should #include "internal.h"
Message-ID: <20070617234246.GC3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/fs/namespace.c.old	2007-06-17 15:24:24.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/namespace.c	2007-06-17 15:24:50.000000000 +0200
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
+#include "internal.h"
 
 /* spinlock for vfsmount related operations, inplace of dcache_lock */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);

