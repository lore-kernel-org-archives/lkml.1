Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbYJSGil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbYJSGil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 02:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYJSGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 02:38:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYJSGid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 02:38:33 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: jkosina@suse.cz, akpm@osdl.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove rogue default ms for THRUSTMASTER/ZEROPLUS in drivers/hid/Kconfig
Date: Sun, 19 Oct 2008 08:38:30 +0200
Message-Id: <1224398310-10676-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

No reason at all to make these obscure drivers default m

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/hid/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index f5999a9..b4fd8ca 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -247,7 +247,6 @@ config HID_SUNPLUS
 
 config THRUSTMASTER_FF
 	tristate "ThrustMaster devices support"
-	default m
 	depends on USB_HID
 	select INPUT_FF_MEMLESS
 	help
@@ -256,7 +255,6 @@ config THRUSTMASTER_FF
 
 config ZEROPLUS_FF
 	tristate "Zeroplus based game controller support"
-	default m
 	depends on USB_HID
 	select INPUT_FF_MEMLESS
 	help
-- 
1.5.6.5

