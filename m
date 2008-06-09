Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYFIWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYFIWYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbYFIWXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:17 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40931 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066AbYFIWXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:14 -0400
Date: Tue, 10 Jun 2008 01:22:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] export amiga_vblank
Message-ID: <20080609222219.GE1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  Building modules, stage 2.
  MODPOST 1203 modules
ERROR: "amiga_vblank" [drivers/video/amifb.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d087380beb0b6a63699bc167b4b012e9e02549e9 diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 50f5daa..dd0734e 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -51,6 +51,8 @@ unsigned long amiga_chipset;
 EXPORT_SYMBOL(amiga_chipset);
 
 unsigned char amiga_vblank;
+EXPORT_SYMBOL(amiga_vblank);
+
 unsigned char amiga_psfreq;
 
 struct amiga_hw_present amiga_hw_present;

