Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXKCFcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXKCFcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 01:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXKCFc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 01:32:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35113 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbXKCFc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 01:32:27 -0400
Date: Sat, 3 Nov 2007 01:31:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] ARM: Remove reference to non-existent MTD_OBSOLETE_CHIPS.
Message-ID: <Pine.LNX.4.64.0711030129060.24537@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The CONFIG variable MTD_OBSOLETE_CHIPS was deleted in commit
ba7cc09c9c9e29a57045dc5bbf843ac1cfad3283.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 970c8c7..4264e27 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -367,7 +367,6 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_RAM is not set
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-CONFIG_MTD_OBSOLETE_CHIPS=y
 CONFIG_MTD_SHARP=y
 # CONFIG_MTD_XIP is not set

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
