Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXCQXOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXCQXOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXCQXOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:14:09 -0400
Received: from mout0.freenet.de ([194.97.50.131]:53362 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXCQXOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:14:07 -0400
Message-ID: <45FC763B.1010708@freenet.de>
Date: Sun, 18 Mar 2007 00:14:03 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, bzolnier@gmail.com
Subject: [PATCH UPDATED] cosmetic adaption of drivers/ide/Kconfig concerning
 SATA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
since especially Serial ATA has it's own menu point now, I guess we can 
change the description of the deprecated SATA driver as well, since the 
new libATA subsystem is not configured through a SCSI low-level driver 
anymore, but has it's own menu point.

The following patch is against 2.6.21-rc4:

--- linux-2.6.20.old/drivers/ide/Kconfig	2007-03-18 00:05:11.000000000 +0100
+++ linux-2.6.20/drivers/ide/Kconfig	2007-03-18 00:09:47.000000000 +0100
@@ -103,7 +103,7 @@
  	---help---
  	  There are two drivers for Serial ATA controllers.

-	  The main driver, "libata", exists inside the SCSI subsystem
+	  The main driver, "libata", exists inside the ATA subsystem
  	  and supports most modern SATA controllers.

  	  The IDE driver (which you are currently configuring) supports

---

Since I am not subscribed to the list, I'd find it great if I were
personally CC'ed. :-)


Best regards
Patrick





