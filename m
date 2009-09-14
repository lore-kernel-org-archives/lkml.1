Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZINK1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZINK1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZINK1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:27:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:34802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751569AbZINK1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:27:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+n+7lzAkKnuwmE+XxavuthMmWwJutaB7W4ZhrWjH
	gSD45HNUlWfvsD
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: choose acceleration engine for VX855
Date: Mon, 14 Sep 2009 10:30:04 +0000
Message-Id: <1252924206-3721-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1252924206-3721-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1252924206-3721-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: choose acceleration engine for VX855

This patch simply enables 2D hardware acceleration on VX855 for
copyarea, imageblit and fillrect by selecting the correct engine
which is the same as in VX800.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index 42ab4b4..9d4f3a4 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -337,6 +337,7 @@ int viafb_init_engine(struct fb_info *info)
 		viapar->shared->hw_bitblt = hw_bitblt_1;
 		break;
 	case UNICHROME_VX800:
+	case UNICHROME_VX855:
 		viapar->shared->hw_bitblt = hw_bitblt_2;
 		break;
 	default:
-- 
1.6.3.2

