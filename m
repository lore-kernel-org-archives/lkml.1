Return-Path: <linux-kernel-owner+w=401wt.eu-S966610AbYD1V2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966610AbYD1V2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965814AbYD1V1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:27:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25204 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778AbYD1V1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=g1Q/0uhRtwNTg1ZrBSk+bvDZTAwYWV+w04ceJzGAAWZXrFZLd/Lf+3wC23zZYYE7h254aYIEoGDlKRI5SSp9bzkbWaJv51mKZN6MprML3tcNx0J/0SsuLCsWI2muEL5/5vV+8l0WA88RYXY+AWxpTGrfJXEHisHewzx3IkVIcKc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] piix: add Asus Eee 701 controller to short cable list
Date: Mon, 28 Apr 2008 23:42:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804282342.39402.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on ata_piix patch by Dan McGee.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/piix.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -250,6 +250,7 @@ static const struct ich_laptop ich_lapto
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
+	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
 };
