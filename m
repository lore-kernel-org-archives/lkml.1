Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYBNXG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYBNXG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYBNXGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:06:18 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:59112 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755069AbYBNXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:06:17 -0500
Date: Thu, 14 Feb 2008 23:06:15 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: oakad@yahoo.com
Subject: MemoryStick: reference to MMC should be MemoryStick
Message-ID: <20080214230615.GA9696@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers/memstick/Kconfig references MMC where it should read MemoryStick

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff -urNp linux-2.6.25-rc1/drivers/memstick/Kconfig linux-2.6.25-rc1-bjd1/drivers/memstick/Kconfig
--- linux-2.6.25-rc1/drivers/memstick/Kconfig	2008-02-13 20:04:28.000000000 +0000
+++ linux-2.6.25-rc1-bjd1/drivers/memstick/Kconfig	2008-02-14 23:02:52.000000000 +0000
@@ -8,7 +8,7 @@ menuconfig MEMSTICK
 	  Sony MemoryStick is a proprietary storage/extension card protocol.
 
 	  If you want MemoryStick support, you should say Y here and also
-	  to the specific driver for your MMC interface.
+	  to the specific driver for your MemoryStick interface.
 
 if MEMSTICK
 
