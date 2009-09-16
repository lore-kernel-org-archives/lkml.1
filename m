Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbZIPXi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbZIPXi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760580AbZIPXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45303 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628AbZIPXiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 07/11] USB: musb: fix musb_platform_set_mode() definition
Date: Wed, 16 Sep 2009 19:38:41 -0400
Message-Id: <1253144325-1203-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>

Update function definition to match latest MUSB framework.

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/blackfin.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index bbee5f6..db099e2 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -227,8 +227,9 @@ int musb_platform_get_vbus_status(struct musb *musb)
 	return 0;
 }
 
-void musb_platform_set_mode(struct musb *musb, u8 musb_mode)
+int musb_platform_set_mode(struct musb *musb, u8 musb_mode)
 {
+	return -EIO;
 }
 
 int __init musb_platform_init(struct musb *musb)
-- 
1.6.5.rc1

