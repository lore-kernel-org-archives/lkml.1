Return-Path: <linux-kernel-owner+w=401wt.eu-S1750904Ab0A2QG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab0A2QG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A2QGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:20 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0A2QGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pOCCNbz5hxE0Fl8lFVZhzqFWUExeZvY0cLa+8Kr5xDbHLqAIIv2ppeZaqsUlXZjVDA
         4XS6+618ANsNwDiiwLWAhF7aGbdMV3FHg9CNskeEWQzAgIHUWKioWn7mJnl9sUDZPy8p
         b8lNGvpnFk4Aaw2pKkSr4jjKBaTMo0bGBp/Lc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:09 +0100
Message-Id: <20100129160609.21495.41616.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 28/68] add ide2libata header file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] add ide2libata header file

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide2libata.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: b/include/linux/ide2libata.h
===================================================================
--- /dev/null
+++ b/include/linux/ide2libata.h
@@ -0,0 +1,17 @@
+#ifndef __IDE2LIBATA_H
+#define __IDE2LIBATA_H
+
+#include <linux/ide.h>
+
+#define __IDE2LIBATA		1
+
+#define ATA_DEV_ATA		ide_disk
+
+#define ata_host		ide_host
+#define ata_port		hwif_s
+#define ata_device		ide_drive_s
+
+#define ata_pio_need_iordy(d)	ide_pio_need_iordy(d, d->pio_mode - XFER_PIO_0)
+#define ata_dev_pair		ide_get_pair_dev
+
+#endif /* __IDE2LIBATA_H */
