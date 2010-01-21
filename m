Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719Ab0AUD5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0AUD5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863Ab0AUD5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:57:33 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50309 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0AUD5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:57:32 -0500
Message-ID: <4B57D07B.7080604@oracle.com>
Date: Wed, 20 Jan 2010 19:56:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
CC: Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] kfifo: fix kernel-doc notation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B57D097.0105:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kfifo kernel-doc warnings:

Warning(kernel/kfifo.c:361): No description found for parameter 'total'
Warning(kernel/kfifo.c:402): bad line:  @ @lenout: pointer to output variable with copied data
Warning(kernel/kfifo.c:412): No description found for parameter 'lenout'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
---
 kernel/kfifo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.33-rc4-git7.orig/kernel/kfifo.c
+++ linux-2.6.33-rc4-git7/kernel/kfifo.c
@@ -349,6 +349,7 @@ EXPORT_SYMBOL(__kfifo_from_user_n);
  * @fifo: the fifo to be used.
  * @from: pointer to the data to be added.
  * @len: the length of the data to be added.
+ * @total: the actual returned data length.
  *
  * This function copies at most @len bytes from the @from into the
  * FIFO depending and returns -EFAULT/0.
@@ -399,7 +400,7 @@ EXPORT_SYMBOL(__kfifo_to_user_n);
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
- @ @lenout: pointer to output variable with copied data
+ * @lenout: pointer to output variable with copied data
  *
  * This function copies at most @len bytes from the FIFO into the
  * @to buffer and 0 or -EFAULT.
