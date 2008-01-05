Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYAEPtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYAEPtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYAEPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:48:52 -0500
Received: from [212.12.190.185] ([212.12.190.185]:52982 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753549AbYAEPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:48:51 -0500
Message-Id: <200801051546.SAA08950@raad.intranet>
From: Al Boldi <a1426z@gawab.com>
To: linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/5] USB Kconfig: Select ATM for USB DSL modem support
Date: Sat, 5 Jan 2008 18:42:05 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Select ATM for USB DSL modem support.


Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---

--- 23.a/drivers/usb/atm/Kconfig
+++ 23.b/drivers/usb/atm/Kconfig
@@ -4,7 +4,8 @@
 
 menuconfig USB_ATM
 	tristate "USB DSL modem support"
-	depends on USB && ATM
+	depends on USB && NET
+	select ATM
 	select CRC32
 	default n
 	help

