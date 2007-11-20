Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbXKTCMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbXKTCMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbXKTByY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:54:24 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2227 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbXKTByC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:54:02 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 58/59] sound/isa: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:45 -0800
Message-Id: <1195523627-15389-16-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-15-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
 <1195523627-15389-4-git-send-email-joe@perches.com>
 <1195523627-15389-5-git-send-email-joe@perches.com>
 <1195523627-15389-6-git-send-email-joe@perches.com>
 <1195523627-15389-7-git-send-email-joe@perches.com>
 <1195523627-15389-8-git-send-email-joe@perches.com>
 <1195523627-15389-9-git-send-email-joe@perches.com>
 <1195523627-15389-10-git-send-email-joe@perches.com>
 <1195523627-15389-11-git-send-email-joe@perches.com>
 <1195523627-15389-12-git-send-email-joe@perches.com>
 <1195523627-15389-13-git-send-email-joe@perches.com>
 <1195523627-15389-14-git-send-email-joe@perches.com>
 <1195523627-15389-15-git-send-email-joe@perches.com>
Message-Id: <5dcd734c020cccb2215a61da5eb4728e2d7ef8db.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/isa/sc6000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 94daf83..bc0c379 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -390,7 +390,7 @@ static int __devinit sc6000_init_board(char __iomem *vport, int irq, int dma,
 
 	err = sc6000_init_mss(vport, config, vmss_port, mss_config);
 	if (err < 0) {
-		snd_printk(KERN_ERR "Can not initialize"
+		snd_printk(KERN_ERR "Can not initialize "
 			   "Microsoft Sound System mode.\n");
 		return -ENODEV;
 	}
-- 
1.5.3.5.652.gf192c

