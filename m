Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYGaUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYGaUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYGaUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:19:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:37112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYGaUTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:19:02 -0400
Subject: patch usb-move-usb-mon-up-to-misc-options-in-kconfig.patch added to gregkh-2.6 tree
To: simon@fire.lp0.eu, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 31 Jul 2008 12:58:05 -0700
In-Reply-To: <4884E732.3000705@simon.arlott.org.uk>
Message-ID: <12175342852216@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: Move usb/mon/ up to misc options in Kconfig

to my gregkh-2.6 tree.  Its filename is

     usb-move-usb-mon-up-to-misc-options-in-kconfig.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From simon@fire.lp0.eu  Thu Jul 31 10:50:44 2008
From: Simon Arlott <simon@fire.lp0.eu>
Date: Mon, 21 Jul 2008 20:44:50 +0100
Subject: USB: Move usb/mon/ up to misc options in Kconfig
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Message-ID: <4884E732.3000705@simon.arlott.org.uk>


This makes "USB Monitor" appear under "Miscellaneous USB options"
section instead of in the middle of device specific drivers in the
"USB Imaging devices" section.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 


Patches currently in gregkh-2.6 which might be from simon@fire.lp0.eu are

usb.current/usb-move-usb-mon-up-to-misc-options-in-kconfig.patch
