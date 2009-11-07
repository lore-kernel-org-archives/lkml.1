Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZKGVqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZKGVqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZKGVqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:46:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbZKGVqt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:46:49 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: isdn4linux@listserv.isdn4linux.de, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:46:51 +0000
Message-ID: <1257630411.15927.396.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 09/75] speedfax: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/hardware/mISDN/speedfax.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/speedfax.c b/drivers/isdn/hardware/mISDN/speedfax.c
index ff3a4e2..7726afd 100644
--- a/drivers/isdn/hardware/mISDN/speedfax.c
+++ b/drivers/isdn/hardware/mISDN/speedfax.c
@@ -110,6 +110,7 @@ set_debug(const char *val, struct kernel_param *kp)
 MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(SPEEDFAX_REV);
+MODULE_FIRMWARE("isdn/ISAR.BIN");
 module_param_call(debug, set_debug, param_get_uint, &debug, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Speedfax debug mask");
 module_param(irqloops, uint, S_IRUGO | S_IWUSR);
-- 
1.6.5.2



