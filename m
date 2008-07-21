Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYGUTpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYGUTpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYGUToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:44:54 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:41365 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbYGUTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:44:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=GpnYuqIrGSoYz2c5hxZGIZPbBF236IZwyvKrH87pko+sBnLK2K82XL1woMV2kwRXSx4WwLTn4tPE7zZBJfqTGjuLWYpETAM0X3/t+mid1JaCZXDMr8CnFIH2SPlVz1Rj;
Message-ID: <4884E732.3000705@simon.arlott.org.uk>
Date: Mon, 21 Jul 2008 20:44:50 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: Move usb/mon/ up to misc options in Kconfig
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes "USB Monitor" appear under "Miscellaneous USB options"
section instead of in the middle of device specific drivers in the
"USB Imaging devices" section.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 755823c..4f9b5ec 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -95,6 +95,8 @@ config USB
 
 source "drivers/usb/core/Kconfig"
 
+source "drivers/usb/mon/Kconfig"
+
 source "drivers/usb/host/Kconfig"
 
 source "drivers/usb/class/Kconfig"
@@ -103,8 +105,6 @@ source "drivers/usb/storage/Kconfig"
 
 source "drivers/usb/image/Kconfig"
 
-source "drivers/usb/mon/Kconfig"
-
 comment "USB port drivers"
 	depends on USB
 
-- 
1.5.6.2

-- 
Simon Arlott
