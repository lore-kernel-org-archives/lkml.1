Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXGOUBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXGOUBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXGOUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39917 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbXGOUAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:02 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] PDA_POWER depends on having request_irq()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IAAG9-00054P-U5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... so all proud owners of s390-based PDAs will have to live without that one

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/power/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index ab9c3e5..3f6e176 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -16,6 +16,7 @@ config POWER_SUPPLY_DEBUG
 
 config PDA_POWER
 	tristate "Generic PDA/phone power driver"
+	depends on !S390
 	help
 	  Say Y here to enable generic power driver for PDAs and phones with
 	  one or two external power supplies (AC/USB) connected to main and
-- 
1.5.3.GIT


