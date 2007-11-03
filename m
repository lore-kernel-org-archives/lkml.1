Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbXKCJL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbXKCJL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXKCJLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:11:20 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34648 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbXKCJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:11:19 -0400
Date: Sat, 3 Nov 2007 05:10:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: bryan.wu@analog.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] BLACKFIN:  Typo: "CONFIG_RTC_BFIN_MODULE" ->
 "CONFIG_RTC_DRV_BFIN_MODULE"
Message-ID: <Pine.LNX.4.64.0711030506370.8543@localhost.localdomain>
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


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i'm *reasonably* confident that this is a typo that should be fixed.


diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index b941550..7d33096 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -49,7 +49,7 @@
  */
 const char bfin_board_name[] = "HV Sistemas H8606";

-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_BFIN_MODULE)
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
 	.id   = -1,
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
