Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYE3RTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYE3RTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYE3RS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:18:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26879 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYE3RSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=epzQcvbwStPdhESJrgZ6poqGUQ5A+nmdZrHwodr+XsFYyAirSwhLHqCvQGYWhbU9EUDqaYLDZ3nsHkA5SOk5VQHCmsPM11MdFUEBenWGLE/N/k+Wzt4Nkbt+ek0GZn/GAGnJn5NeH+QekzI2gzhqsS43kz61BF8ORSac93/atNQ=
Subject: [PATCH] usb: digi_accelport.c trivial sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 30 May 2008 10:18:53 -0700
Message-Id: <1212167934.28403.196.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/serial/digi_acceleport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 04a56f3..d8209e9 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -573,6 +573,7 @@ static struct usb_serial_driver digi_acceleport_4_device = {
 static long cond_wait_interruptible_timeout_irqrestore(
 	wait_queue_head_t *q, long timeout,
 	spinlock_t *lock, unsigned long flags)
+__releases(lock)
 {
 	DEFINE_WAIT(wait);
 
-- 
1.5.6.rc0.277.g804cf



