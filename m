Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZF1Pfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZF1Pfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZF1PfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:35:06 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49609 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZF1PfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=t2Imsi+xKg/5t7QpSYhBeZTkgnucAvQYMISnBWSASgja5j3asRFs4rxC45bVAH+/rs
         p5PppHJWWaPygwZyaqPyoUk0UVyD4IJiTk50eJLSVrxSgqrm8Fveygm8UtCvsBL23KcV
         GFJVIDzZBOb4MnX6Be2+fudrGPESVFGDrr6Xs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] Staging: rtl8187se: add TODO
Date: Sun, 28 Jun 2009 17:40:24 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281740.24971.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/TODO |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: b/drivers/staging/rtl8187se/TODO
===================================================================
--- /dev/null
+++ b/drivers/staging/rtl8187se/TODO
@@ -0,0 +1,21 @@
+TODO:
+- prepare private ieee80211 stack for merge with rtl8192su's version:
+  - remove [IN]_OPENSUSE_SLED definitions
+  - remove ENABLE_IPS ifdefs
+  - rename struct ieee80211_hdr to struct ieee80211_hdr_4addr
+  - rename struct ieee80211_hdr_3addr_QOS to struct ieee80211_hdr_3addrqos
+  - rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
+  - add hwsec_active flag to struct ieee80211_device
+  - add bHwSec flag to cb_desc structure
+  - switch ieee80211.h to use <linux/ieee80211.h>
+- switch to use shared "librtl" instead of private ieee80211 stack
+- switch to use LIB80211
+- switch to use MAC80211
+- switch to use EEPROM_93CX6
+- use kernel coding style
+- checkpatch.pl fixes
+- sparse fixes
+- integrate with drivers/net/wireless/rtl818x
+
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
+Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>.
