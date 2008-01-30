Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYA3Twh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYA3Twh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYA3Tw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:52:28 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:18873 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbYA3Tw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:52:27 -0500
Date: Wed, 30 Jan 2008 11:51:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix drivers/base/class warning
Message-Id: <20080130115108.2df9ade6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc empty line warning:
Warning(linux-2.6.24-git8//drivers/base/class.c:866): bad line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-git8.orig/drivers/base/class.c
+++ linux-2.6.24-git8/drivers/base/class.c
@@ -863,7 +863,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device)
  * The callback should return 0 if the device doesn't match and non-zero
  * if it does.  If the callback returns non-zero, this function will
  * return to the caller and not iterate over any more devices.
-
+ *
  * Note, you will need to drop the reference with put_device() after use.
  *
  * We hold class->sem in this function, so it can not be
