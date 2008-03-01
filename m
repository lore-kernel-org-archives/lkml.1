Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYCAQ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYCAQ22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbYCAQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:34 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55874 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763231AbYCAQYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:31 -0500
Date: Sat, 1 Mar 2008 18:23:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chas@cmf.nrl.navy.mil, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make atm/he.c:read_prom_byte() static
Message-ID: <20080301162306.GY25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global read_prom_byte() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
64b0e035ca2ddec5daca8c9b56a5586c7bdd7f82 foobar
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 2e3395b..ffc4a5a 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -3000,8 +3000,7 @@ he_proc_read(struct atm_dev *dev, loff_t *pos, char *page)
 
 /* eeprom routines  -- see 4.7 */
 
-u8
-read_prom_byte(struct he_dev *he_dev, int addr)
+static u8 read_prom_byte(struct he_dev *he_dev, int addr)
 {
 	u32 val = 0, tmp_read = 0;
 	int i, j = 0;

