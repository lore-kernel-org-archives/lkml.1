Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYKHIYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYKHIYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYKHIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:24:27 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:56229 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYKHIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=dc9d8I4w0ZSmxvJPxnlqUgPOUWRRQ/5cXglg/mR/k7H5jFDv22Hy2U0x69aUbeNLAR
         whw1X8XxN742S+ue9k0PVvYyXsGe/ChcBK22LOC6NP5EHup1ztko+CT8hZ6T4aUp8eup
         +/lpcbTwso6gP0vVUd8blLpE51w/OZ6FnPnMc=
Date: Sat, 8 Nov 2008 16:23:53 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: jeremy@xensource.com, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] drivers/xen/xenbus/xenbus_client.c: cleanup kerneldoc
Message-ID: <20081108162353.0532c2c0@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no argument named @xbt in xenbus_switch_state(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 9678b3e..92a1ef8 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -136,7 +136,6 @@ EXPORT_SYMBOL_GPL(xenbus_watch_pathfmt);
 /**
  * xenbus_switch_state
  * @dev: xenbus device
- * @xbt: transaction handle
  * @state: new state
  *
  * Advertise in the store a change of the given driver to the given new_state.
@@ -267,7 +266,7 @@ EXPORT_SYMBOL_GPL(xenbus_dev_error);
  * @fmt: error message format
  *
  * Equivalent to xenbus_dev_error(dev, err, fmt, args), followed by
- * xenbus_switch_state(dev, NULL, XenbusStateClosing) to schedule an orderly
+ * xenbus_switch_state(dev, XenbusStateClosing) to schedule an orderly
  * closedown of this driver and its peer.
  */
 
