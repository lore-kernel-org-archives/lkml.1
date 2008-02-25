Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYBYKLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYBYKLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYBYKLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:11:03 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:44423 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYBYKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AXwdEBHVZsoDaDIT+/KOJmxt3sJ/RUcyrLlBXUtYXa5cwb3siAOQalXsKi71y3sSbkwg3vh3g9U1a1m/bFmrdtmFvAUQKzPg9tpZtFVJEKoP9PK4Vy47TxWXsaFRzk2ZeJPTg5GxGvdk1hNeW2sU5ZYPIYkK0R2fiKUiJ+v0Z28=
From: tom.leiming@gmail.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Lei Ming <tom.leiming@gmail.com>
Subject: [PATCH] usb: fix comment of struct usb_interface
Date: Mon, 25 Feb 2008 18:07:28 +0800
Message-Id: <1203934048-9718-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.5.4.rc4.338.g923d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lei Ming <tom.leiming@gmail.com>

update the comment for the removed "driver" field  and  being
out-of-order of  @cur_altsetting and @num_altsetting.

Signed-off-by: Lei Ming <tom.leiming@gmail.com>
---
 include/linux/usb.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 include/linux/usb.h

diff --git a/include/linux/usb.h b/include/linux/usb.h
old mode 100644
new mode 100755
index 2372e2e..8a864f8
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -94,10 +94,9 @@ enum usb_interface_condition {
  * @altsetting: array of interface structures, one for each alternate
  * 	setting that may be selected.  Each one includes a set of
  * 	endpoint configurations.  They will be in no particular order.
- * @num_altsetting: number of altsettings defined.
  * @cur_altsetting: the current altsetting.
+ * @num_altsetting: number of altsettings defined.
  * @intf_assoc: interface association descriptor
- * @driver: the USB driver that is bound to this interface.
  * @minor: the minor number assigned to this interface, if this
  *	interface is bound to a driver that uses the USB major number.
  *	If this interface does not use the USB major, this field should
-- 
1.5.4.rc4.338.g923d4

