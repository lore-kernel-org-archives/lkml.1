Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYHFXO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYHFXO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 19:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYHFXOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:14:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:35343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYHFXOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:14:20 -0400
Subject: patch usb-cxacru-fix-printk-format-flag-in-error-message.patch added to gregkh-2.6 tree
To: simon@fire.lp0.eu, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 06 Aug 2008 16:10:29 -0700
In-Reply-To: <48791FF4.2080503@simon.arlott.org.uk>
Message-ID: <1218064229447@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: cxacru: Fix printk format flag in error message

to my gregkh-2.6 tree.  Its filename is

    usb-cxacru-fix-printk-format-flag-in-error-message.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From simon@fire.lp0.eu  Wed Aug  6 15:50:52 2008
From: Simon Arlott <simon@fire.lp0.eu>
Date: Sat, 12 Jul 2008 22:19:48 +0100
Subject: USB: cxacru: Fix printk format flag in error message
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <48791FF4.2080503@simon.arlott.org.uk>


"#%x" should have been "%#x"

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/atm/cxacru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -602,7 +602,7 @@ static int cxacru_cm_get_array(struct cx
 			offd = le32_to_cpu(buf[offb++]);
 			if (offd >= size) {
 				if (printk_ratelimit())
-					usb_err(instance->usbatm, "wrong index #%x in response to cm #%x\n",
+					usb_err(instance->usbatm, "wrong index %#x in response to cm %#x\n",
 						offd, cm);
 				ret = -EIO;
 				goto cleanup;


Patches currently in gregkh-2.6 which might be from simon@fire.lp0.eu are

usb.current/usb-move-usb-mon-up-to-misc-options-in-kconfig.patch
usb.current/usb-cxacru-fix-printk-format-flag-in-error-message.patch
