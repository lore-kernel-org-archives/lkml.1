Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbZIPXk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbZIPXk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbZIPXko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:40:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45267 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760625AbZIPXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 03/11] USB: musb: kill some useless comments in Blackfin driver
Date: Wed, 16 Sep 2009 19:38:37 -0400
Message-Id: <1253144325-1203-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/blackfin.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 80c765e..bbee5f6 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -263,10 +263,6 @@ int __init musb_platform_init(struct musb *musb)
 		SSYNC();
 	}
 
-	/* TODO
-	 * Set SIC-IVG register
-	 */
-
 	/* Configure PLL oscillator register */
 	bfin_write_USB_PLLOSC_CTRL(0x30a8);
 	SSYNC();
-- 
1.6.5.rc1

