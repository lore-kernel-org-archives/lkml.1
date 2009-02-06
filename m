Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZBFJkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZBFJkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBFJkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:40:43 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:42655 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZBFJkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:40:42 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82428291"
From: Bryan Wu <cooloney@kernel.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ivan Kuten <ivan.kuten@promwad.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] usb: Correct Makefile to make isp1760 buildable
Date: Fri,  6 Feb 2009 17:42:34 +0800
Message-Id: <1233913354-13755-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Kuten <ivan.kuten@promwad.com>

Signed-off-by: Ivan Kuten <ivan.kuten@promwad.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 8bcde8c..b2ceb4a 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_USB_MON)		+= mon/
 obj-$(CONFIG_PCI)		+= host/
 obj-$(CONFIG_USB_EHCI_HCD)	+= host/
 obj-$(CONFIG_USB_ISP116X_HCD)	+= host/
+obj-$(CONFIG_USB_ISP1760_HCD)	+= host/
 obj-$(CONFIG_USB_OHCI_HCD)	+= host/
 obj-$(CONFIG_USB_UHCI_HCD)	+= host/
 obj-$(CONFIG_USB_FHCI_HCD)	+= host/
-- 
1.5.6.3
