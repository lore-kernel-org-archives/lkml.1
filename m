Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZA1WMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZA1WMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZA1WMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:12:12 -0500
Received: from kroah.org ([198.145.64.141]:38880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787AbZA1WMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:12:10 -0500
Subject: patch staging-poch-fix-verification-of-memory-area.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 28 Jan 2009 14:10:34 -0800
In-Reply-To: <4980CAA9.1060301@gmail.com>
Message-ID: <12331806343697@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: poch: fix verification of memory area

to my gregkh-2.6 tree.  Its filename is

    staging-poch-fix-verification-of-memory-area.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Wed Jan 28 14:00:58 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 28 Jan 2009 22:14:17 +0100
Subject: Staging: poch: fix verification of memory area
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <4980CAA9.1060301@gmail.com>


fix verification of memory area

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/poch/poch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -1026,7 +1026,7 @@ static int poch_ioctl(struct inode *inod
 		}
 		break;
 	case POCH_IOC_GET_COUNTERS:
-		if (access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
+		if (!access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
 			return -EFAULT;
 
 		spin_lock_irq(&channel->counters_lock);


Patches currently in gregkh-2.6 which might be from roel.kluin@gmail.com are

usb.current/usb-gadget-fix-x-y.patch
staging/staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch
staging/staging-otus-logical-bit-and-confusion.patch
staging/staging-usbip-usbip_start_threads-handle-kernel_thread-failure.patch
staging/staging-poch-fix-verification-of-memory-area.patch
