Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZFFWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZFFWAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZFFWAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:00:11 -0400
Received: from wsip-70-184-212-11.om.om.cox.net ([70.184.212.11]:37788 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZFFWAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:00:10 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 18:00:10 EDT
From: "Luke-Jr" <luke@dashjr.org>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] arm: omap: n810: set lm8323 size_y to 12
Date: Sat, 6 Jun 2009 16:51:47 -0500
User-Agent: KMail/1.11.3 (Linux/2.6.27-gentoo-r7; KDE/4.2.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906061651.54915.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From de992fa168685ddd608fca0f54fcfbce2afc2963 Mon Sep 17 00:00:00 2001
From: Luke Dashjr <luke@dashjr.org>
Date: Sat, 6 Jun 2009 16:35:03 -0500
Subject: [PATCH] arm: omap: n810: set lm8323 size_y to 12

For some reason, this is needed for the shift keys and "fghjvbnm"

Signed-off-by: Luke Dashjr <luke@dashjr.org>
---
 arch/arm/mach-omap2/board-n800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n800.c b/arch/arm/mach-omap2/board-
n800.c
index cb32b61..0a50fd3 100644
--- a/arch/arm/mach-omap2/board-n800.c
+++ b/arch/arm/mach-omap2/board-n800.c
@@ -115,7 +115,7 @@ static struct lm8323_platform_data lm8323_pdata = {
 	.repeat		= 0, /* Repeat is handled in userspace for now. */
 	.keymap		= rx44_keymap,
 	.size_x		= 8,
-	.size_y		= 8,
+	.size_y		= 12,
 	.debounce_time	= 12,
 	.active_time	= 500,
 
-- 
1.6.0.6


