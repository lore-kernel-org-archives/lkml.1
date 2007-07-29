Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXG2PPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXG2PPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbXG2PCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:02:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47898 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932134AbXG2PCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:02:07 -0400
Date: Sun, 29 Jul 2007 17:01:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/Kbuild: remove duplicate entries
Message-ID: <20070729150144.GP16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes three headers from header-y that were also listed 
as unifdef-y.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/Kbuild |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.23-rc1-mm1/include/linux/Kbuild.old	2007-07-28 17:15:01.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/linux/Kbuild	2007-07-28 17:15:25.000000000 +0200
@@ -78,7 +78,6 @@ header-y += if_arcnet.h
 header-y += if_bonding.h
 header-y += if_cablemodem.h
 header-y += if_fc.h
-header-y += if_fddi.h
 header-y += if.h
 header-y += if_hippi.h
 header-y += if_infiniband.h
@@ -121,7 +120,6 @@ header-y += nl80211.h
 header-y += oom.h
 header-y += param.h
 header-y += pci_regs.h
-header-y += personality.h
 header-y += pfkeyv2.h
 header-y += pg.h
 header-y += phantom.h
@@ -159,7 +157,6 @@ header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
 header-y += vt.h
-header-y += wireless.h
 header-y += x25.h
 
 unifdef-y += acct.h

