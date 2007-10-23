Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbXJWGZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbXJWGZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJWGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:25:25 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42029 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXJWGZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:25:25 -0400
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       torvalds@linux-foundation.org
Subject: [PATCH] ide: build fix
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071023152506I.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 23 Oct 2007 15:25:06 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

git-drivers/ide/ide-probe.c: In function 'hwif_init':
drivers/ide/ide-probe.c:1327: error: implicit declaration of function 'sg_init_table'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ide/ide-probe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ec55a17..6a6f2e0 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -47,6 +47,7 @@
 #include <linux/spinlock.h>
 #include <linux/kmod.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
-- 
1.5.2.4

