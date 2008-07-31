Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYGaUV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYGaUV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGaUVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:21:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:37221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYGaUVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:21:20 -0400
Subject: patch usb-usb-storage-quirk-around-v1.11-firmware-on-nikon-d4.patch added to gregkh-2.6 tree
To: davej@redhat.com, gregkh@suse.de, johannes@sipsolutions.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Thu, 31 Jul 2008 12:58:29 -0700
In-Reply-To: <20080714172834.GA23016@redhat.com>
Message-ID: <12175343092020@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: usb-storage: quirk around v1.11 firmware on Nikon D4

to my gregkh-2.6 tree.  Its filename is

     usb-usb-storage-quirk-around-v1.11-firmware-on-nikon-d4.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From davej@redhat.com  Thu Jul 31 10:32:27 2008
From: Dave Jones <davej@redhat.com>
Date: Mon, 14 Jul 2008 13:28:34 -0400
Subject: USB: usb-storage: quirk around v1.11 firmware on Nikon D4
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, gregkh@suse.de
Message-ID: <20080714172834.GA23016@redhat.com>
Content-Disposition: inline


usb-storage: quirk around v1.11 firmware on Nikon D40

https://bugzilla.redhat.com/show_bug.cgi?id=454028
Just as in earlier firmware versions, we need to perform this
quirk for the latest version too.

Speculatively do the entry for the D80 too, as they seem to
have the same firmware problems historically.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -356,14 +356,14 @@ UNUSUAL_DEV(  0x04b0, 0x040f, 0x0100, 0x
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 		"NIKON",
 		"NIKON DSC D80",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Ortwin Glueck <odi@odi.ch> */
-UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0111,
 		"NIKON",
 		"NIKON DSC D40",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,


Patches currently in gregkh-2.6 which might be from davej@redhat.com are

bad/pci-dynamic-id-cleanup.patch
bad/pci-two-drivers-on-one-pci-device.patch
usb.current/usb-usb-storage-quirk-around-v1.11-firmware-on-nikon-d4.patch
