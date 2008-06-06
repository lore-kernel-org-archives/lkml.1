Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbYFFW5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbYFFW5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYFFW5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:57:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYFFW5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:57:01 -0400
Subject: patch usb-digi_accelport.c-trivial-sparse-lock-annotation.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
From: <gregkh@suse.de>
Date: Fri, 06 Jun 2008 15:51:37 -0700
In-Reply-To: <1212167934.28403.196.camel@brick>
Message-ID: <12127926972392@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: digi_accelport.c trivial sparse lock annotation

to my gregkh-2.6 tree.  Its filename is

     usb-digi_accelport.c-trivial-sparse-lock-annotation.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com  Fri Jun  6 15:16:54 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Fri, 30 May 2008 10:18:53 -0700
Subject: USB: digi_accelport.c trivial sparse lock annotation
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <1212167934.28403.196.camel@brick>


Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/digi_acceleport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -571,6 +571,7 @@ static struct usb_serial_driver digi_acc
 static long cond_wait_interruptible_timeout_irqrestore(
 	wait_queue_head_t *q, long timeout,
 	spinlock_t *lock, unsigned long flags)
+__releases(lock)
 {
 	DEFINE_WAIT(wait);
 


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

usb/usb-use-get_unaligned_-helpers-for-kl5kusb105-driver.patch
usb/usb-cp2101.c-fix-sparse-signedness-mismatch-warnings.patch
usb/usb-digi_accelport.c-trivial-sparse-lock-annotation.patch
usb/usb-speedtch.c-fix-sparse-shadowed-variable-warning.patch
