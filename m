Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZKDRcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZKDRcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZKDRcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:32:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbZKDRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=b0RJNRJox2xS3iRS/5fEFKycN8l6uWt9LG24kBccPMNGs7LKZvkQYltU69lSXU72O+
         TtQqXkxCh2muNLjTPNHJdn3jx7Z9/MWD+J6KyIc4nC6+lX07bqLutYPg/zfqsFZq15LD
         FJm6t5PfbOzu8Y9CP4DayhBrMpFpt1c5O1Yaw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:31:58 +0100
Message-Id: <20091104173158.28463.66661.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/41] rt2800usb: make Kconfig help entry more helpful
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: make Kconfig help entry more helpful

Document known issues with the driver to aid distribution makers,
users and developers in making informed decisions instead of wasting
their time needlessly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This reflects the actual state of affairs for driver in Linus' tree.

 drivers/net/wireless/rt2x00/Kconfig |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -104,7 +104,7 @@ config RT73USB
 	  When compiled as a module, this driver will be called rt73usb.
 
 config RT2800USB
-	tristate "Ralink rt2800 (USB) support"
+	tristate "Ralink rt2800 (USB) support (EXPERIMENTAL)"
 	depends on USB && EXPERIMENTAL
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_HT
@@ -115,6 +115,10 @@ config RT2800USB
 	  This adds experimental support for rt2800 wireless chipset family.
 	  Supported chips: RT2770, RT2870 & RT3070.
 
+	  Known issues:
+	  - support for RT2870 chips doesn't work with 802.11n APs yet
+	  - support for RT3070 chips is non-functional at the moment
+
 	  When compiled as a module, this driver will be called "rt2800usb.ko".
 
 config RT2X00_LIB_PCI
