Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0BCDph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:45:37 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45753 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0BCDpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:34 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>, Jack Wang <jack_wang@usish.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 02/11] SCSI: pm8001: Fix spelling of 'unknown'
Date: Wed,  3 Feb 2010 00:48:18 +0800
Message-Id: <1265129307-18201-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9b44c6f..7985ae4 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2924,7 +2924,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	default:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unkown device type(%x)\n", deviceType));
+			pm8001_printk("unknown device type(%x)\n", deviceType));
 		break;
 	}
 	phy->phy_type |= PORT_TYPE_SAS;
-- 
1.6.3.3

