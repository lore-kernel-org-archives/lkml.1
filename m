Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYAANtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYAANtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYAANsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:48:50 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53812 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbYAANsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:48:37 -0500
Date: Tue, 1 Jan 2008 15:48:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Nick Sillik <n.sillik@temple.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: [2.6 patch] make USB_STORAGE_ONETOUCH available with PM
Message-ID: <20080101134823.GL2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Torsten Kaiser pointed out, it seems the dependency of 
USB_STORAGE_ONETOUCH on !PM should have been removed in
commit 7931e1c6f8007d5fef8a0bb2dc71bd97315eeae9.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9c1aa5fae6c8a4d1a6a8f90062d473d63250a403 
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 7e53333..05cfc84 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -123,7 +123,7 @@ config USB_STORAGE_ALAUDA
 
 config USB_STORAGE_ONETOUCH
 	bool "Support OneTouch Button on Maxtor Hard Drives (EXPERIMENTAL)"
-	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL && !PM
+	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL
 	help
 	  Say Y here to include additional code to support the Maxtor OneTouch
 	  USB hard drive's onetouch button.

