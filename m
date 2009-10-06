Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZJFF4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZJFF4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZJFF4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:56:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42941 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbZJFF4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:56:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firmware: only allow EDD on x86/x86_64
Date: Tue,  6 Oct 2009 01:55:34 -0400
Message-Id: <1254808534-3793-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git-svn-id: svn://localhost/svn/linux-kernel/trunk@7548 526b6c2d-f592-4532-a319-5dd88ccb003d
---
 drivers/firmware/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index ebb9e51..7fff33f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -7,7 +7,7 @@ menu "Firmware Drivers"
 
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
-	depends on !IA64
+	depends on (X86_64 || X86_32)
 	help
 	  Say Y or M here if you want to enable BIOS Enhanced Disk Drive
 	  Services real mode BIOS calls to determine which disk
-- 
1.6.5.rc2

