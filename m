Return-Path: <linux-kernel-owner+w=401wt.eu-S2992959AbXDDPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992959AbXDDPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXDDPZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:25:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42720 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992944AbXDDPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:25:27 -0400
Date: Wed, 4 Apr 2007 17:25:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/namespace.c should #include "internal.h"
Message-ID: <20070404152527.GH27660@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm3/fs/namespace.c.old	2007-04-03 01:41:16.000000000 +0200
+++ linux-2.6.21-rc5-mm3/fs/namespace.c	2007-04-03 01:41:28.000000000 +0200
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
+#include "internal.h"
 
 /* spinlock for vfsmount related operations, inplace of dcache_lock */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);

