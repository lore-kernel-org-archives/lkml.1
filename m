Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYBPXiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYBPXiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 18:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBPXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 18:37:55 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:31627 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751363AbYBPXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 18:37:54 -0500
X-Trace: 673086712/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAHoCt0dRAVlC/2dsb2JhbACBWapEgXo
Subject: [PATCH] maple: remove unused variable
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh <linux-sh@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 23:37:33 +0000
Message-Id: <1203205053.6737.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unused variable from the definition of struct maple_device

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff -ruN a/include/linux/maple.h b/include/linux/maple.h
--- a/include/linux/maple.h	2008-02-16 20:52:09.000000000 +0000
+++ b/include/linux/maple.h	2008-02-16 21:42:06.000000000 +0000
@@ -64,7 +64,6 @@
 	int (*connect) (struct maple_device * dev);
 	void (*disconnect) (struct maple_device * dev);
 	struct device_driver drv;
-	int registered;
 };
 


