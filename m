Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbXEOTga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbXEOTga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbXEOTgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45057 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbXEOTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing mm.h in fw-ohci
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ho2oc-0003TB-AX@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


need it for page_private(), not all targets have it pulled indirectly

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/firewire/fw-ohci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 1f5c704..c17342d 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/poll.h>
 #include <linux/dma-mapping.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
-- 
1.5.0-rc2.GIT


