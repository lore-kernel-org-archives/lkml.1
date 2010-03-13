Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab0CMOz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:55:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56329 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265Ab0CMOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mD+PrvYwA7vyBt1Hyzq/itDMoZEAn/amK0Rw9d7F6is0O5ryKE1Rl4VNVQ7a2kBbFd
         ccgEdJO74hkm9ApCB3zyQPCHBlyv1HZIp3cgs1Xf8apnuvZh9T9Rdt19UE9NW94dJ093
         u5rkx++eiRyf8Z24rqZ1r5GZEM9OZQT9BahM4=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch
Date: Sat, 13 Mar 2010 22:53:34 +0800
Message-Id: <1268492014-6355-10-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1d43d0d..f17cb09 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1921,7 +1921,7 @@ static int detach(struct comedi_device *dev)
 						    ao_dma_desc_bus_addr);
 			if (priv(dev)->main_phys_iobase)
 				comedi_pci_disable(priv(dev)->hw_dev);
-	
+
 			pci_dev_put(priv(dev)->hw_dev);
 		}
 	}
-- 
1.7.0

