Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXJ0OSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXJ0OSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXJ0OSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:18:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56331 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbXJ0OSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:18:13 -0400
Date: Sat, 27 Oct 2007 16:18:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>, bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport ide_fix_driveid
Message-ID: <20071027141833.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ide_fix_driveid can now be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
627c730e21e5010a5bdb1f4f9968cfd5e0b4df2a 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 9516883..d3c5672 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -403,9 +403,6 @@ void ide_fix_driveid (struct hd_driveid *id)
 #endif
 }
 
-/* FIXME: exported for use by the USB storage (isd200.c) code only */
-EXPORT_SYMBOL(ide_fix_driveid);
-
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 {
 	u8 *p = s, *end = &s[bytecount & ~1]; /* bytecount must be even */

