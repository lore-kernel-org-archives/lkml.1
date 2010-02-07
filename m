Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0BGQvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 11:51:45 -0500
Received: from kroah.org ([198.145.64.141]:44599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0BGQvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 11:51:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: ssc_dnp: fixed a brace coding style issue
Date: Sun,  7 Feb 2010 08:51:51 -0800
Message-Id: <1265561511-25543-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/comedi/drivers/ssv_dnp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 4918fbf..17c92a5 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -300,11 +300,11 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 
 	/* read 'old' direction of the port and set bits (out=1, in=0)             */
 	register_buffer = inb(CSCDR);
-	if (data[0] == COMEDI_OUTPUT) {
+	if (data[0] == COMEDI_OUTPUT)
 		register_buffer |= (1 << chan);
-	} else {
+	else
 		register_buffer &= ~(1 << chan);
-	}
+
 	outb(register_buffer, CSCDR);
 
 	return 1;
-- 
1.6.6.1

