Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXFUXw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXFUXw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbXFUXvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:51:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35914 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755133AbXFUXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:51:52 -0400
Date: Fri, 22 Jun 2007 01:52:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
Message-ID: <20070621235211.GH23017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Users should use the libata based drivers for SATA drives.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/Documentation/feature-removal-schedule.txt.old	2007-06-21 23:41:03.000000000 +0200
+++ linux-2.6.22-rc4-mm2/Documentation/feature-removal-schedule.txt	2007-06-21 23:42:03.000000000 +0200
@@ -347,3 +347,10 @@
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
+
+What:  CONFIG_BLK_DEV_IDE_SATA
+When:  December 2007
+Why:   users should use the libata based drivers for SATA
+Who:   Adrian Bunk <bunk@stusta.de>
+
+---------------------------

