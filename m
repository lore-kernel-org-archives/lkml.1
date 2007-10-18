Return-Path: <linux-kernel-owner+w=401wt.eu-S1764507AbXJRKwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764507AbXJRKwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764302AbXJRKwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:52:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44762 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764601AbXJRKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:52:09 -0400
Date: Thu, 18 Oct 2007 12:52:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       James Bottomley <James.Bottomley@SteelEye.com>, james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/lpfc/lpfc_debugfs.c: fix typo
Message-ID: <20071018105237.GL3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo introduced by
commit bbfbbbc1182f8b44c8cc4c99f4a3f3a512149022.

It wasn't a compile error since CONFIG_LPFC_DEBUG_FS is not (yet?) 
available as an option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
74e14a2a4ed066aa8fedd557a6768fdfec5eb883 
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 149fdd2..d6a98bc 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -901,7 +901,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		}
 	}
 
-	vport->disc_trc = kmzlloc(
+	vport->disc_trc = kzalloc(
 		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc),
 		GFP_KERNEL);
 

