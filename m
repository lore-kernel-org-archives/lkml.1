Return-Path: <linux-kernel-owner+w=401wt.eu-S936659AbXHHX0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936659AbXHHX0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762179AbXHHX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:26:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33085 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761094AbXHHX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:26:45 -0400
Date: Thu, 9 Aug 2007 01:26:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>, starvik@axis.com
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, dev-etrax@axis.com
Subject: [2.6.23 regression fix] cris: drivers/cdrom/Kconfig no longer
	exists
Message-ID: <20070808232629.GL6997@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following 2.6.23 regression:

<--  snip  -->

...
scripts/kconfig/conf -d arch/cris/Kconfig
arch/cris/Kconfig:183: can't open file "drivers/cdrom/Kconfig"
make[2]: *** [defconfig] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
25f8889abda9596429f0840dc1d9330cfad8ac48 
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 4b41248..6b4d026 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -180,8 +180,6 @@ source "drivers/isdn/Kconfig"
 
 source "drivers/telephony/Kconfig"
 
-source "drivers/cdrom/Kconfig"
-
 #
 # input before char - char/joystick depends on it. As does USB.
 #

