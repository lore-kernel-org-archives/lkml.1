Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZIGMjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZIGMjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZIGMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:39:12 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:54217 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZIGMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v+sgS6fK9K/tuwT9dCLwUm2lR8da1HqTdMS6cuzuRjUOS8WmPeJbeJ5kymdDXIJy8A
         0tuLCBOy+1N9rqboamj9gCFkaPAmUjQK1ixLgpGHAq2XB86Oy80WpHRUt/KKyajiEKhW
         6U1lvfEcIa1oxGpBtHjakzYxq8mZiMI0Z6BdA=
Subject: [PATCH 4/5] debugfs - Modified default dir of debugfs for
	debugging UHCI.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: stern@rowland.harvard.edu, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:39:05 +0900
Message-Id: <1252327145.2153.100.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 0fc6858c047a00a6433c74e7a24110dfbb8d1875 Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 20:51:39 +0900
Subject: [PATCH 4/5] Modified default mounting dir of debugfs for debugging UHCI.

Change default debugfs directory as mounting point for debugging
UHCI(Universal Host Controller Interface driver) for USB.

As we all know, We need change default directory for consistency of
debugfs by Greg.K.H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 drivers/usb/host/uhci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 274751b..5cd0e48 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(ignore_oc, "ignore hardware overcurrent indications");
  * debug = 0, no debugging messages
  * debug = 1, dump failed URBs except for stalls
  * debug = 2, dump all failed URBs (including stalls)
- *            show all queues in /debug/uhci/[pci_addr]
+ *            show all queues in /sys/kernel/debug/uhci/[pci_addr]
  * debug = 3, show all TDs in URBs when dumping
  */
 #ifdef DEBUG
-- 
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

