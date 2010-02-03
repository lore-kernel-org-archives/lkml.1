Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0BCEnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:43:12 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:45133 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0BCEnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:43:07 -0500
X-Greylist: delayed 871 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 23:43:07 EST
From: "jack wang" <jack_wang@usish.com>
To: "'Daniel Mack'" <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>
Cc: "'Jiri Kosina'" <trivial@kernel.org>,
       "'Junio C Hamano'" <gitster@pobox.com>,
       "'James Bottomley'" <James.Bottomley@suse.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de> <1265129307-18201-2-git-send-email-daniel@caiaq.de>
Subject: RE: [PATCH 02/11] SCSI: pm8001: Fix spelling of 'unknown'
Date: Wed, 3 Feb 2010 12:28:31 +0800
Message-ID: <5914D9196FC04C52B6D073F9D4A09CD1@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1265129307-18201-2-git-send-email-daniel@caiaq.de>
Thread-Index: Acqkg1lWnEuIc8i8RKi0vEjen3QBsgABUWqw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
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

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 9b44c6f..7985ae4 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2924,7 +2924,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 		break;
 	default:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unkown device type(%x)\n",
deviceType));
+			pm8001_printk("unknown device type(%x)\n",
deviceType));
 		break;
 	}
 	phy->phy_type |= PORT_TYPE_SAS;
-- 
1.6.3.3

[Jack] Sorry for the typo. Thanks Daniel.
Acked-by: Jack Wang <jack_wang@usish.com>

