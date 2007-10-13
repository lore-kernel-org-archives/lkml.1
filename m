Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbXJMSkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbXJMSkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761667AbXJMSkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:40:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48619 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761615AbXJMSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:40:12 -0400
Date: Sat, 13 Oct 2007 19:40:08 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] missing includes in arch/powerpc/platforms/52xx/lite5200.c
Message-ID: <20071013184008.GL8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 0caa3d9..774f249 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -18,6 +18,8 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/root_dev.h>
+#include <linux/initrd.h>
 #include <asm/time.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
