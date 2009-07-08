Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbZGHUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbZGHUEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZGHUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:04:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53035 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZGHUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ocRQ5Yp5B2l0I2w20Gq1XOrcXZZIzuXCsTmxSogtBmvP6P9Xoy1hFcZtCB2/GDDT83
         tGlBYmI8/adsRfjjPoDSPW6qvaXNMGl2deW/+C8XW36UVX92tI41nVwVttteshge2Zzs
         f9NSe3Tdt3tb2o5MMV+twNymm6juXXDy/svdA=
Message-ID: <4A54FB81.30302@gmail.com>
Date: Wed, 08 Jul 2009 22:03:13 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: fix supported cards for rtl8187
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different revisions of WUSB54GC-EU use different chipsets -
v2 uses rtl8187, but v3 uses Ralink RT3070.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Przemyslaw Kulczycki <azrael@autocom.pl>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Linux wireless <linux-wireless@vger.kernel.org>
---
 drivers/net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 5bc00db..7d5902d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -431,7 +431,7 @@ config RTL8187
 	  ASUS P5B Deluxe
 	  Toshiba Satellite Pro series of laptops
 	  Asus Wireless Link
-	  Linksys WUSB54GC-EU
+	  Linksys WUSB54GC-EU v2
 
 	  Thanks to Realtek for their support!
 
-- 
1.6.3.3


