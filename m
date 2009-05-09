Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbZEIDbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbZEIDbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZEIDaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:30:07 -0400
Received: from kroah.org ([198.145.64.141]:41399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZEIDaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:30:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Hayes <dwhayes@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] Staging: rt2870: new device id
Date: Fri,  8 May 2009 20:26:51 -0700
Message-Id: <1241839613-9243-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032443.GC9000@kroah.com>
References: <20090509032443.GC9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hayes <dwhayes@gmail.com>

Hey, I have an Edimax wireless USB adapter that uses the rt2870 chipset.
lsusb shows it as follows:

Bus 001 Device 002: ID 7392:7717

When I added that ID to rt2870.h, the device came up and worked as
expected.

From: Dave Hayes <dwhayes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rt2870/rt2870.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2870/rt2870.h b/drivers/staging/rt2870/rt2870.h
index a42caa3..a69cf33 100644
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -145,6 +145,7 @@
 	{USB_DEVICE(0x0789,0x0162)}, /* Logitec */		\
 	{USB_DEVICE(0x0789,0x0163)}, /* Logitec */		\
 	{USB_DEVICE(0x0789,0x0164)}, /* Logitec */		\
+	{USB_DEVICE(0x7392,0x7717)}, /* Edimax */		\
 	{ }/* Terminating entry */                      \
 }
 
-- 
1.6.3

