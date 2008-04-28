Return-Path: <linux-kernel-owner+w=401wt.eu-S935749AbYD1Pph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749AbYD1Pph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934654AbYD1Pjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49130 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbYD1Pjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:47 -0400
Date: Mon, 28 Apr 2008 18:39:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Aidan Thornton <makosoft@googlemail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make em28xx-dvb.c:register_dvb() static
Message-ID: <20080428153914.GN2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global register_dvb() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
72255e23e002cff5a8c8b2b6bf6c166340fc1a09 diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 7df8157..8af318e 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -263,10 +263,10 @@ static int attach_xc3028(u8 addr, struct em28xx *dev)
 
 /* ------------------------------------------------------------------ */
 
-int register_dvb(struct em28xx_dvb *dvb,
-		 struct module *module,
-		 struct em28xx *dev,
-		 struct device *device)
+static int register_dvb(struct em28xx_dvb *dvb,
+			struct module *module,
+			struct em28xx *dev,
+			struct device *device)
 {
 	int result;
 

