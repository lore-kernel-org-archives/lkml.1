Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbYFESXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbYFESXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYFESX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:23:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38951 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYFESXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:23:25 -0400
Date: Thu, 5 Jun 2008 21:22:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k: make multi_defconfig the default defconfig
Message-ID: <20080605182235.GB1469@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to match the intention behind multi_defconfig to make it the 
default defconfig.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
55c8d7ed853df41c5fe97a1e529a2ddeeded98ef diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index b15173f..8133dbc 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -13,7 +13,7 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-KBUILD_DEFCONFIG := amiga_defconfig
+KBUILD_DEFCONFIG := multi_defconfig
 
 # override top level makefile
 AS += -m68020

