Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbXIBUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbXIBUDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIBUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:03:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38319 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXIBUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:03:11 -0400
Date: Mon, 3 Sep 2007 01:46:20 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH -mm] drivers/mmc/core/bus.c: Fix unused var warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030145060.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1543750880-1188764183=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1543750880-1188764183=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/mmc/core/bus.c: In function ‘mmc_bus_uevent’:
drivers/mmc/core/bus.c:77: warning: unused variable ‘length’
drivers/mmc/core/bus.c:77: warning: unused variable ‘i’

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/mmc/core/bus.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/mmc/core/bus.c~fix	2007-09-02 19:18:05.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/mmc/core/bus.c	2007-09-02 19:18:08.000000000 +0530
@@ -74,7 +74,6 @@ mmc_bus_uevent(struct device *dev, struc
 {
 	struct mmc_card *card = dev_to_mmc_card(dev);
 	const char *type;
-	int i = 0, length = 0;
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
--464262402-1543750880-1188764183=:29617--
