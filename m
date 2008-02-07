Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbYBGXMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbYBGXMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYBGXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:12:16 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55324 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbYBGXMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:12:14 -0500
Date: Fri, 8 Feb 2008 01:12:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [2.6 patch] fix ide/legacy/gayle.c compilation
Message-ID: <20080207231226.GD7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
deb88131c2fcc3076121597463153979aba9062d diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index 9d3851d..b7d8109 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -94,7 +94,7 @@ static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
 
 static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 				     unsigned long ctl, unsigned long irq_port,
-				     ide_ack_intr_t *ack_intr);
+				     ide_ack_intr_t *ack_intr)
 {
 	int i;
 

