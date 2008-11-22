Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYKVLjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYKVLjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbYKVLjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:39:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56834 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYKVLjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:39:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 22 Nov 2008 12:38:58 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: another iPod mini quirk entry
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.a60e28fc2b8821c3@s5r6.in-berlin.de>
Message-ID: <tkrat.5f37d82b925cd628@s5r6.in-berlin.de>
References: <tkrat.a60e28fc2b8821c3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another model ID of a broken firmware to prevent early I/O errors
by acesses at the end of the disk.  Reported at linux1394-user,
http://marc.info/?t=122670842900002

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -368,14 +368,19 @@ static const struct {
 	/* iPod 4th generation. */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
+		.model			= 0x000022,
+		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod mini */ {
+		.firmware_revision	= 0x0a2700,
 		.model			= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod Photo */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x00007e,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,

-- 
Stefan Richter
-=====-==--- =-== =-==-
http://arcgraph.de/sr/

