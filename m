Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXKTB5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXKTB5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbXKTBtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:45 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2090 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbXKTBtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:12 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>
Subject: [PATCH 23/59] drivers/media/dvb: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:15 -0800
Message-Id: <1195523331-15303-24-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-23-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
Message-Id: <5ce69261b8ce239633c31431c61538234b0f8065.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/frontends/ves1820.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 60433b5..8791701 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -65,7 +65,7 @@ static int ves1820_writereg(struct ves1820_state *state, u8 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk("ves1820: %s(): writereg error (reg == 0x%02x,"
+		printk("ves1820: %s(): writereg error (reg == 0x%02x, "
 			"val == 0x%02x, ret == %i)\n", __FUNCTION__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
@@ -84,7 +84,7 @@ static u8 ves1820_readreg(struct ves1820_state *state, u8 reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("ves1820: %s(): readreg error (reg == 0x%02x,"
+		printk("ves1820: %s(): readreg error (reg == 0x%02x, "
 		"ret == %i)\n", __FUNCTION__, reg, ret);
 
 	return b1[0];
-- 
1.5.3.5.652.gf192c

