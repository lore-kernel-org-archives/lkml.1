Return-Path: <linux-kernel-owner+w=401wt.eu-S2993039AbXCIHZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993039AbXCIHZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993047AbXCIHZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:25:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:7671 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993039AbXCIHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=VGW4d166tO1oJjSy+O5k9HVqvCFatbanNjVvfb/VunmyGSsL0bHxjWQ4ehzQZ/3BXMX7PV9fqNIhVsBis7t79FgZvk2k2gG7BDcrCzkEOuic2d+nR/XMpvSGR0RyKQeYeTLV6EkUOfe+PgY9OCZhcd/wrlQss/lyA2/uVnS+o7g=
Date: Thu, 8 Mar 2007 23:25:03 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/atm/fore200e.c: change in error message.
Message-Id: <20070308232503.7148e219.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Change in error message in function fore200e_kmalloc(), in file drivers/atm/fore200e.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 3a7b21f..1c7ea02 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -178,7 +178,7 @@ fore200e_kmalloc(int size, gfp_t flags)
     void *chunk = kzalloc(size, flags);
 
     if (!chunk)
-	printk(FORE200E "kmalloc() failed, requested size = %d, flags = 0x%x\n",			size, flags);
+	printk(FORE200E "kzalloc() failed, requested size = %d, flags = 0x%x\n",			size, flags);
     
     return chunk;
 }
