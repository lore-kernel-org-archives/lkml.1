Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYA0Jww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYA0Jww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbYA0JtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:22 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58950 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755955AbYA0JtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:14 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 17/32] ide-tape: remove EXPERIMENTAL driver status
Date: Sun, 27 Jan 2008 10:48:05 +0100
Message-Id: <1201427300-3954-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

ide-tape has depended on EXPERIMENTAL for ages. Change that since the driver is
being only maintained now.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 73ce5d1..330a80f 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -216,8 +216,7 @@ config BLK_DEV_IDECD_VERBOSE_ERRORS
 	  memory, though.
 
 config BLK_DEV_IDETAPE
-	tristate "Include IDE/ATAPI TAPE support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Include IDE/ATAPI TAPE support"
 	help
 	  If you have an IDE tape drive using the ATAPI protocol, say Y.
 	  ATAPI is a newer protocol used by IDE tape and CD-ROM drives,
-- 
1.5.3.7

