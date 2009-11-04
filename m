Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZKDRcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZKDRcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZKDRcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:32:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbZKDRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YXBVePq9f8nAu/5LJL6yWWm90VhNh2RaKDnhFNpF9vOT8Vo/ghgP9fIhzHKs0VD+bB
         oZa+dFbvef2Lhe3Jyg2o5xZq4OKHpnUdMWitUWqN8wYegnZtAIwKQJKINBfCMo8gEJsT
         vmQj0m1edWElbU+a/EnHGv8/fTDp5vo+FoSEY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:10 +0100
Message-Id: <20091104173210.28463.95558.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/41] rt2800pci: make Kconfig help entry more helpful
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: make Kconfig help entry more helpful

Document known issues with the driver to aid distribution makers,
users and developers in making informed decisions instead of wasting
their time needlessly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This reflects the actual state of affairs for driver in net-next tree.

 drivers/net/wireless/rt2x00/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -64,7 +64,7 @@ config RT2800PCI_SOC
 	default y
 
 config RT2800PCI
-	tristate "Ralink rt2800 (PCI/PCMCIA) support"
+	tristate "Ralink rt2800 (PCI/PCMCIA) support (VERY EXPERIMENTAL)"
 	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
 	select RT2X00_LIB_PCI if RT2800PCI_PCI
 	select RT2X00_LIB_SOC if RT2800PCI_SOC
@@ -77,6 +77,9 @@ config RT2800PCI
 	  This adds support for rt2800 wireless chipset family.
 	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
 
+	  This driver is non-functional at the moment and is intended for
+	  developers.
+
 	  When compiled as a module, this driver will be called "rt2800pci.ko".
 
 config RT2500USB
