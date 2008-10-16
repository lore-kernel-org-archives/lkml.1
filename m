Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYJPRe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYJPRe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJPRet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:34:49 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61908 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYJPRes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:34:48 -0400
Date: Fri, 17 Oct 2008 02:34:54 +0900 (JST)
Message-Id: <20081017.023454.115932752.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH] serial_txx9: Use %lx for iobase
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a warning caused by commit 0c8946d97ae7d2d6691f8290a10faa63453b63f8
(serial: Make uart_port's ioport "unsigned long".)

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 8fcb4c5..7313c2e 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -1039,7 +1039,7 @@ static int __devinit serial_txx9_probe(struct platform_device *dev)
 		ret = serial_txx9_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%x MEM%llx IRQ%d): %d\n", i,
+				"(IO%lx MEM%llx IRQ%d): %d\n", i,
 				p->iobase, (unsigned long long)p->mapbase,
 				p->irq, ret);
 		}
