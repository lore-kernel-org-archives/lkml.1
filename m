Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbXKTCMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbXKTCMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXKTBy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:54:26 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2229 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbXKTByD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:54:03 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Riccardo Facchetti <fizban@tin.it>
Subject: [PATCH 59/59] sound/oss: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:46 -0800
Message-Id: <1195523627-15389-17-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-16-git-send-email-joe@perches.com>
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
 <1195523627-15389-16-git-send-email-joe@perches.com>
Message-Id: <e138039432625a469859ede2281982263db71cac.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/oss/aedsp16.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/aedsp16.c b/sound/oss/aedsp16.c
index 51e1fde..f0d2bd9 100644
--- a/sound/oss/aedsp16.c
+++ b/sound/oss/aedsp16.c
@@ -1092,7 +1092,7 @@ static int __init aedsp16_init_board(void)
 	if (ae_config.mss_base != -1) {
 		if (ae_config.init & INIT_MSS) {
 			if (aedsp16_init_mss(ae_config.base_io) == FALSE) {
-				printk("[AEDSP16] Can not initialize"
+				printk("[AEDSP16] Can not initialize "
 				       "Microsoft Sound System mode.\n");
 				return FALSE;
 			}
-- 
1.5.3.5.652.gf192c

