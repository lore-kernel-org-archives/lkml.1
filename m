Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0BEB1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:27:20 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:57501 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0BEB1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fUO55VApnACU39E99h4jLuVBfdLhK+woS0IRyIKFaKhUdyGLBGygiOPRTah+2EkseS
         Zyb90gyicpRicN9T1cFstfw9zLXNsLXNKN3Lq2fngdXZ0W49g0fUDfVcIFsEUln3xftG
         O3m1FlElwIhM11EEuACx8dZdqtubZsrmTEiSM=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, sgayda2@uiuc.edu,
       mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: poc: fix coding style issues
Date: Thu,  4 Feb 2010 22:27:05 -0300
Message-Id: <1265333225-6726-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes a line over 80 characters and a brace warnings.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/comedi/drivers/poc.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index d23e588..207d5ee 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -136,8 +136,8 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* check if io addresses are available */
 	if (!request_region(iobase, iosize, "dac02")) {
 		printk
-		    ("I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-		     iobase, iobase + iosize - 1);
+		    ("I/O port conflict: failed to allocate ports 0x%lx to "
+					"0x%lx\n", iobase, iobase + iosize - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -156,10 +156,9 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = this_board->winsn;
 	s->insn_read = this_board->rinsn;
 	s->insn_bits = this_board->insnbits;
-	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO) {
+	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO)
 		s->subdev_flags = SDF_WRITABLE;
-	}
-
+
 	return 0;
 }
 
-- 
1.5.6.3

