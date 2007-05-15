Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbXEOERq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbXEOERq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXEOERI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:17:08 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:4470 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbXEOERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:17:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvVoANzQSEZKhRO4W2dsb2JhbACBXIVUiEYdEhEB
Message-Id: <20070515041357.089204684.dtor@insightbb.com>
References: <20070515041249.301642231.dtor@insightbb.com>
Date: Tue, 15 May 2007 00:12:53 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: Vernon Mauery <vernux@us.ibm.com>, Max Asbock <masbock@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [patch 4/4] IBMASM: must depend on CONFIG_INPUT
Content-Disposition: inline; filename=ibmasm-depends-on-input.patch
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IBMASM: must depend on CONFIG_INPUT

The driver registers couple of input devices and therefore must depend
on CONFIG_INPUT.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: work/drivers/misc/Kconfig
===================================================================
--- work.orig/drivers/misc/Kconfig
+++ work/drivers/misc/Kconfig
@@ -6,7 +6,7 @@ menu "Misc devices"
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI && INPUT && EXPERIMENTAL
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
