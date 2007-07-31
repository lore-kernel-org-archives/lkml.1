Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbXGaQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbXGaQ6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbXGaQ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:58:07 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2246 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761469AbXGaQ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:58:06 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04] drivers/sbus/char/bbc_i2c.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 18:58:05 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       davem@davemloft.net
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311858.05485.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/sbus/char/bbc_i2c.c | 10847 -> 10823 (-24 bytes)

 drivers/sbus/char/bbc_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/sbus/char/bbc_i2c.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/sbus/char/bbc_i2c.c	2007-07-31 18:12:13.000000000 +0200
@@ -357,13 +357,13 @@ static void __init reset_one_i2c(struct

 static int __init attach_one_i2c(struct linux_ebus_device *edev, int index)
 {
-	struct bbc_i2c_bus *bp = kmalloc(sizeof(*bp), GFP_KERNEL);
+	struct bbc_i2c_bus *bp;
 	struct linux_ebus_child *echild;
 	int entry;

+	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
 	if (!bp)
 		return -ENOMEM;
-	memset(bp, 0, sizeof(*bp));

 	bp->i2c_control_regs = ioremap(edev->resource[0].start, 0x2);
 	if (!bp->i2c_control_regs)
