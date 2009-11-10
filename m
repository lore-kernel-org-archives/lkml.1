Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZKJCH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZKJCH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZKJCH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:07:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1287 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZKJCH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:07:56 -0500
Subject: [PATCH] nvidia.c: Use correct length in strncmp
From: Joe Perches <joe@perches.com>
To: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 18:08:01 -0800
Message-ID: <1257818881.12852.77.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/video/nvidia/nvidia.c
b/drivers/video/nvidia/nvidia.c
index efe10ff..81e78c9 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -1495,7 +1495,7 @@ static int __devinit nvidiafb_setup(char *options)
 			flatpanel = 1;
 		} else if (!strncmp(this_opt, "hwcur", 5)) {
 			hwcur = 1;
-		} else if (!strncmp(this_opt, "noaccel", 6)) {
+		} else if (!strncmp(this_opt, "noaccel", 7)) {
 			noaccel = 1;
 		} else if (!strncmp(this_opt, "noscale", 7)) {
 			noscale = 1;


