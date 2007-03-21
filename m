Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXCUGse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXCUGse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXCUGse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:48:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:15665 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXCUGsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:48:33 -0400
Message-ID: <d4cf37a60703202348y4824c61cra2a2d8bcb344a204@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:48:32 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Modifications to drivers/Kconfig and Makefile to configure
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 drivers/Kconfig  |    2 ++
 drivers/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 050323f..f05a2bf 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -84,4 +84,6 @@ source "drivers/auxdisplay/Kconfig"

 source "drivers/kvm/Kconfig"

+source "drivers/trec/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 3a718f5..01724c0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
+obj-$(CONFIG_TREC)		+= trec/
-- 
1.5.0.rc2
