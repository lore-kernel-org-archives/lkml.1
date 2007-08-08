Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXHHQIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXHHQIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbXHHQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:08:17 -0400
Received: from www.osadl.org ([213.239.205.134]:40239 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755675AbXHHQIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:08:16 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make UIO available for arm architecture
Date: Wed, 8 Aug 2007 18:08:13 +0200
User-Agent: KMail/1.9.5
Organization: Linutronix
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081808.13889.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The config system doesn't show the UIO menu if arch=arm, this patch fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
Index: linux-2.6.23-rc/arch/arm/Kconfig
===================================================================
--- linux-2.6.23-rc.orig/arch/arm/Kconfig	2007-08-08 17:52:02.000000000 +0200
+++ linux-2.6.23-rc/arch/arm/Kconfig	2007-08-08 17:53:29.000000000 +0200
@@ -1052,6 +1052,8 @@
 
 source "drivers/dma/Kconfig"
 
+source "drivers/uio/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
