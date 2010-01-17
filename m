Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007Ab0AQV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0AQV3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952Ab0AQV3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:29:21 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39754 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:29:20 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] trivial: capitalization and other minor fixes in pnp documentation
Date: Sun, 17 Jan 2010 19:26:47 -0200
Message-Id: <1263763608-9733-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/pnp.txt |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/pnp.txt b/Documentation/pnp.txt
index a327db6..763e465 100644
--- a/Documentation/pnp.txt
+++ b/Documentation/pnp.txt
@@ -57,7 +57,7 @@ PC standard floppy disk controller
 # cat resources
 DISABLED
 
-- Notice the string "DISABLED".  THis means the device is not active.
+- Notice the string "DISABLED".  This means the device is not active.
 
 3.) check the device's possible configurations (optional)
 # cat options
@@ -139,7 +139,7 @@ Plug and Play but it is planned to be in the near future.
 
 Requirements for a Linux PnP protocol:
 1.) the protocol must use EISA IDs
-2.) the protocol must inform the PnP Layer of a devices current configuration
+2.) the protocol must inform the PnP Layer of a device's current configuration
 - the ability to set resources is optional but preferred.
 
 The following are PnP protocol related functions:
@@ -158,7 +158,7 @@ pnp_remove_device
 - automatically will free mem used by the device and related structures
 
 pnp_add_id
-- adds a EISA ID to the list of supported IDs for the specified device
+- adds an EISA ID to the list of supported IDs for the specified device
 
 For more information consult the source of a protocol such as
 /drivers/pnp/pnpbios/core.c.
@@ -167,7 +167,7 @@ For more information consult the source of a protocol such as
 
 Linux Plug and Play Drivers
 ---------------------------
-	This section contains information for linux PnP driver developers.
+	This section contains information for Linux PnP driver developers.
 
 The New Way
 ...........
@@ -235,11 +235,10 @@ static int __init serial8250_pnp_init(void)
 The Old Way
 ...........
 
-a series of compatibility functions have been created to make it easy to convert 
-
+A series of compatibility functions have been created to make it easy to convert
 ISAPNP drivers.  They should serve as a temporary solution only.
 
-they are as follows:
+They are as follows:
 
 struct pnp_card *pnp_find_card(unsigned short vendor,
 				 unsigned short device,
-- 
1.6.6

