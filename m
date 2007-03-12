Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXCLAB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXCLAB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964825AbXCLAB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:01:58 -0400
Received: from mout1.freenet.de ([194.97.50.132]:34913 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbXCLAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:01:58 -0400
Message-ID: <45F4A681.8080500@freenet.de>
Date: Mon, 12 Mar 2007 02:01:53 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cosmetic adaption of drivers/ide/Kconfig concerning SATA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
since Serial ATA has it's own menu point now, I guess we can change the 
description of the deprecated SATA driver as well, since the new S-ATA 
subsystem is not configured through a SCSI low-level driver anymore.

The following patch is against 2.6.21-rc3:

--- linux-2.6.20.orig/drivers/ide/Kconfig    2007-03-12 
01:34:38.000000000 +0100
+++ linux-2.6.20/drivers/ide/Kconfig    2007-03-12 01:47:10.000000000 +0100
@@ -103,7 +103,7 @@
     ---help---
       There are two drivers for Serial ATA controllers.
 
-      The main driver, "libata", exists inside the SCSI subsystem
+      The main driver, "libata", exists in the "Serial ATA subsystem"
       and supports most modern SATA controllers.
 
       The IDE driver (which you are currently configuring) supports


Since I am not subscribed to the list, I'd find it great if I were 
personally CC'ed. :-)


Best regards
Patrick


