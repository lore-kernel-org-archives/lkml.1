Return-Path: <linux-kernel-owner+w=401wt.eu-S1030752AbXCNJQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752AbXCNJQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030755AbXCNJQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:16:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60766 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030752AbXCNJQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:35 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's bool and it depends on IDE => should depend on IDE=y

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ide/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5d134bb..3f76987 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -802,7 +802,7 @@ config BLK_DEV_IDEDMA_PMAC
 
 config BLK_DEV_IDE_CELLEB
 	bool "Toshiba's Cell Reference Set IDE support"
-	depends on PPC_CELLEB
+	depends on PPC_CELLEB && IDE=y
 	help
 	  This driver provides support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
-- 
1.5.0-rc2.GIT


