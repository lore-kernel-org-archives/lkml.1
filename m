Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbYBWRjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbYBWRjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbYBWRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:38:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:23914 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760224AbYBWRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=F2W+CdiZz1vkrk6PSpgRQpPyeHGSD/p6q+FLYEyzTSPZqXP9ruVGcrQNvNGFE2pOfePqO/bLUFx1otCkj449OKSo8+2ty35IR1jqNfzScuj2BwFN7dHXPUy4776A7hhu5yZYBTH/zsI7+dlATb8nr0QFW3sgbPW2M9P5L/8DiQg=
Date: Sat, 23 Feb 2008 18:38:30 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 3/6] IDE: Coding Style fixes to drivers/ide/legacy/ali14xx.c
Message-ID: <20080223183830.1ecd44e5@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free, 2 warnings left.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/legacy/ali14xx.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index c9536dd..33bb7b8 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -86,7 +86,7 @@ static u8 regOff;	/* output to base port to close registers */
 /*
  * Read a controller register.
  */
-static inline u8 inReg (u8 reg)
+static inline u8 inReg(u8 reg)
 {
 	outb_p(reg, regPort);
 	return inb(dataPort);
@@ -95,7 +95,7 @@ static inline u8 inReg (u8 reg)
 /*
  * Write a controller register.
  */
-static void outReg (u8 data, u8 reg)
+static void outReg(u8 data, u8 reg)
 {
 	outb_p(reg, regPort);
 	outb_p(data, dataPort);
@@ -143,7 +143,7 @@ static void ali14xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 /*
  * Auto-detect the IDE controller port.
  */
-static int __init findPort (void)
+static int __init findPort(void)
 {
 	int i;
 	u8 t;
@@ -175,7 +175,8 @@ static int __init findPort (void)
 /*
  * Initialize controller registers with default values.
  */
-static int __init initRegisters (void) {
+static int __init initRegisters(void)
+{
 	const RegInitializer *p;
 	u8 t;
 	unsigned long flags;
@@ -239,7 +240,7 @@ static int __init ali14xx_probe(void)
 	return 0;
 }
 
-int probe_ali14xx = 0;
+int probe_ali14xx;
 
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
-- 
1.5.4.2.316.gf7a7

