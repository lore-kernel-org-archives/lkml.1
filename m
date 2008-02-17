Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYBQNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYBQNla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYBQNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:41:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:57826 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYBQNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=lQsYM48qz/UJviPiFFkc/otYlei7YnKxPxJNVC0jsgZ9Ml1bDmtmVBtKHIJax1aoU7WHQDh0hbz05knSBhLymJe0F9KAp3SbHU+34XaE2ssyDWdj2inrzFl16LF0BZxR4qvrzHiEdFHAVfWqTwclfuj3fcZh+Eu2L0PRwNps13k=
Date: Sun, 17 Feb 2008 14:41:16 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes in arch/x86/lib/io_64.c
Message-ID: <20080217144116.5f146cfd@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: coding style fixes in arch/x86/lib/io_64.c

This simple patch makes the file error free (according to
checkpatch.pl)


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/io_64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/io_64.c b/arch/x86/lib/io_64.c
index 87b4a4e..71fdf4b 100644
--- a/arch/x86/lib/io_64.c
+++ b/arch/x86/lib/io_64.c
@@ -2,15 +2,15 @@
 #include <asm/io.h>
 #include <linux/module.h>
 
-void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
+void __memcpy_toio(unsigned long dst, const void*src, unsigned len)
 {
-	__inline_memcpy((void *) dst,src,len);
+	__inline_memcpy((void *) dst, src, len);
 }
 EXPORT_SYMBOL(__memcpy_toio);
 
-void __memcpy_fromio(void *dst,unsigned long src,unsigned len)
+void __memcpy_fromio(void *dst, unsigned long src, unsigned len)
 {
-	__inline_memcpy(dst,(const void *) src,len);
+	__inline_memcpy(dst, (const void *) src, len);
 }
 EXPORT_SYMBOL(__memcpy_fromio);
 
@@ -18,6 +18,6 @@ void memset_io(volatile void __iomem *a, int b, size_t c)
 {
 	/* XXX: memset can mangle the IO patterns quite a bit.
 	   perhaps it would be better to use a dumb one */
-	memset((void *)a,b,c);
+	memset((void *)a, b, c);
 }
 EXPORT_SYMBOL(memset_io);
-- 
1.5.4.1.183.gf873

