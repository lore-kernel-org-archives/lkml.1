Return-Path: <linux-kernel-owner+w=401wt.eu-S934824AbZKYRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbZKYRR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934781AbZKYRR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:17:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbZKYRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=s8HMOxEen586RwzGCHIECxqR3k4OOQyGgRiGeSXn4ZdWinf/NOhj6x0NluQcatIhDe
         1Wy9dAs+Tah5CrmI2QpG0a1FHLz64q5k3r76z1hv3MOPzJqW8KOW1htxwmJyaFBbsmRu
         RonqR4tAJkR7Ex4KWmIQPTLhqLKxKJvGy2u3w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:48 +0100
Message-Id: <20091125170948.5446.32754.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 62/86] pata_pdc202xx_old: document known issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: document known issues

Document known issues with the driver to aid distribution makers,
users and developers in making informed decisions instead of wasting
their time needlessly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -583,6 +583,10 @@ config PATA_PDC_OLD
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
 
+	  Known issues:
+	  - UDMA transfers fail mysteriously on some chipsets
+	  - ATAPI DMA is unsupported currently
+
 	  If unsure, say N.
 
 config PATA_QDI
