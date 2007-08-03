Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbXHCBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbXHCBss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbXHCBsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:48:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35974 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031AbXHCBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:48:39 -0400
Subject: patch usb-u132-hcd.c-fix-a-warning-when-config_pm-n.patch added to gregkh-2.6 tree
To: nix.or.die@googlemail.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 02 Aug 2007 18:51:20 -0700
In-Reply-To: <46ADC3FF.8040506@googlemail.com>
Message-ID: <1186105880@kroah.com>
X-Bad-Reply: In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: u132-hcd.c - Fix a warning when CONFIG_PM=n

to my gregkh-2.6 tree.  Its filename is

     usb-u132-hcd.c-fix-a-warning-when-config_pm-n.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From nix.or.die@googlemail.com  Thu Aug  2 18:39:02 2007
From: Gabriel C <nix.or.die@googlemail.com>
Date: Mon, 30 Jul 2007 12:57:03 +0200
Subject: USB: u132-hcd.c - Fix a warning when CONFIG_PM=n
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tony.olech@elandigitalsystems.com, gregkh@suse.de
Message-ID: <46ADC3FF.8040506@googlemail.com>


I noticed this warning with CONFING_PM=n 

...

drivers/usb/host/u132-hcd.c:1525: warning: 'port_power' defined but not used

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/u132-hcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -1519,12 +1519,15 @@ static void u132_hcd_endp_work_scheduler
                 }
         }
 }
+#ifdef CONFIG_PM
 
 static void port_power(struct u132 *u132, int pn, int is_on)
 {
         u132->port[pn].power = is_on;
 }
 
+#endif
+
 static void u132_power(struct u132 *u132, int is_on)
 {
         struct usb_hcd *hcd = u132_to_hcd(u132)


Patches currently in gregkh-2.6 which might be from nix.or.die@googlemail.com are

usb/usb-u132-hcd.c-fix-a-warning-when-config_pm-n.patch
