Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbYFQWb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbYFQWb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbYFQWbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:31:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46779 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716AbYFQWbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:31:35 -0400
Date: Wed, 18 Jun 2008 01:30:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] input/serio/hp_sdc_mlc.c: make a struct static
Message-ID: <20080617223008.GD25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct hp_sdc_mlc_priv_s static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a393b82d875616b9a78382d260b89f50b37fde71 diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 587398f..b587e2d 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -50,7 +50,7 @@ MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("Glue for onboard HIL MLC in HP-PARISC machines");
 MODULE_LICENSE("Dual BSD/GPL");
 
-struct hp_sdc_mlc_priv_s {
+static struct hp_sdc_mlc_priv_s {
 	int emtestmode;
 	hp_sdc_transaction trans;
 	u8 tseq[16];

