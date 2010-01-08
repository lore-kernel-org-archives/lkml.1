Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811Ab0AHSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0AHSar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316Ab0AHSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:30:45 -0500
Received: from [206.15.93.42] ([206.15.93.42]:28752 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752637Ab0AHSah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:30:37 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] cm4000_cs.c: Remove unnecessary cast
Date: Fri, 8 Jan 2010 11:30:13 -0700
Cc: laforge@gnumonks.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081130.13177.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cm4000_cs.c: Remove unnecessary cast

The struct file 'private_data' member is a void *, the cast is not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Harald Welte <laforge@gnumonks.org>

---

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 2db4c0a..c9bc896 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1047,7 +1047,7 @@ release_io:
 static ssize_t cmm_write(struct file *filp, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	struct cm4000_dev *dev = (struct cm4000_dev *) filp->private_data;
+	struct cm4000_dev *dev = filp->private_data;
 	unsigned int iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	unsigned char tmp;
