Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYD0HJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYD0HJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYD0HJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:09:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7031 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYD0HJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:09:05 -0400
Message-ID: <a24804730804270009x3398a190wf68e52280015fc7f@mail.gmail.com>
Date: Sun, 27 Apr 2008 00:09:04 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix warning: remove unused static function in drivers/char/ip2/i2ellis.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against linux-2.6.25-git7.

chris


Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
diff -Naur linux-2.6.25-git7/drivers/char/ip2/i2ellis.c
linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c
--- linux-2.6.25-git7/drivers/char/ip2/i2ellis.c	2008-04-25
22:47:01.000000000 -0700
+++ linux-2.6.25-git7+patch/drivers/char/ip2/i2ellis.c	2008-04-25
23:19:57.000000000 -0700
@@ -86,22 +86,6 @@
 }

 //******************************************************************************
-// Function:   iiEllisCleanup()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required cleanup of the iiEllis subsystem.
-//
-//******************************************************************************
-static void
-iiEllisCleanup(void)
-{
-}
-
-//******************************************************************************
 // Function:   iiSetAddress(pB, address, delay)
 // Parameters: pB      - pointer to the board structure
 //             address - the purported I/O address of the board
