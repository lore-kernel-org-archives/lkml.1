Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbXJ3XwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbXJ3XwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXJ3Xu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:50:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35810 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752914AbXJ3XuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:50:25 -0400
Date: Wed, 31 Oct 2007 00:50:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ata_scsi_lpm_get() static
Message-ID: <20071030235023.GT7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ata_scsi_lpm_get() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
380046f657271be470566bb5c762c1599569bac6 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 93bd36c..c4f0c6c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -120,7 +120,7 @@ static const struct {
 	{ MEDIUM_POWER, "medium_power" },
 };
 
-const char *ata_scsi_lpm_get(enum link_pm policy)
+static const char *ata_scsi_lpm_get(enum link_pm policy)
 {
 	int i;
 

