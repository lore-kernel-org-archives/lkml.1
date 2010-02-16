Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab0BPSTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:19:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:38072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab0BPSTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:19:23 -0500
Date: Tue, 16 Feb 2010 18:19:21 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@osdl.org>
cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: radeonfb backlight fix
Message-ID: <alpine.LFD.2.00.1002161817570.23940@casper.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A simple patch to allow radeonfb to compile if the backlight option is 
set.

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 6c37e8e..2c01726 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -276,7 +276,7 @@ static int nomtrr = 0;
 #endif
 static int force_sleep;
 static int ignore_devlist;
-#ifdef CONFIG_PMAC_BACKLIGHT
+#ifdef CONFIG_FB_RADEON_BACKLIGHT
 static int backlight = 1;
 #else
 static int backlight = 0;
