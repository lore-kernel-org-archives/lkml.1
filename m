Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbYEHWmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbYEHWmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYEHWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:42:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:41834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYEHWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:42:20 -0400
Subject: patch usb-use-get_unaligned_-helpers-for-kl5kusb105-driver.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 08 May 2008 15:39:18 -0700
In-Reply-To: <1209700377.22362.20.camel@brick>
Message-ID: <12102863583733@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: use get_unaligned_* helpers for kl5kusb105 driver

to my gregkh-2.6 tree.  Its filename is

     usb-use-get_unaligned_-helpers-for-kl5kusb105-driver.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com Thu May  1 20:52:48 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Thu, 01 May 2008 20:52:57 -0700
Subject: USB: use get_unaligned_* helpers for kl5kusb105 driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <1209700377.22362.20.camel@brick>


Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kl5kusb105.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -236,7 +236,7 @@ static int klsi_105_get_line_state(struc
 	if (rc < 0)
 		err("Reading line status failed (error = %d)", rc);
 	else {
-		status = le16_to_cpu(get_unaligned((__le16 *)status_buf));
+		status = get_unaligned_le16(status_buf);
 
 		info("%s - read status %x %x", __func__,
 		     status_buf[0], status_buf[1]);


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

usb.next/usb-fix-integer-as-null-pointer-warnings-found-by-sparse.patch
usb.next/usb-use-get_unaligned_-helpers-for-kl5kusb105-driver.patch
