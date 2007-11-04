Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbXKDCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbXKDCn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbXKDCnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 22:43:19 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:42241 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbXKDCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 22:43:18 -0400
From: "Denys" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Cc: dilinger@debian.org
Subject: patch, reboot fixup for WRAP 2C board (SC1100 based)
Date: Sun, 4 Nov 2007 04:42:54 +0200
Message-Id: <20071104023914.M66925@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Strange, that noone notice issue with popular for wireless board, WRAP2C. 
Probably most of developers was fixing silently in their codebase and was not 
supplying patch to mainline kernel.
The symptoms is easy, it just doesn't reboot in any case, till i apply patch.
Works for me.

Can anyone format it as it is required by kernel policy? It is trivial.

--- linux-2.6.23/arch/i386/kernel/reboot_fixups.c       2007-10-09 
23:31:38.000000000 +0300
+++ linux-2.6.23-new/arch/i386/kernel/reboot_fixups.c   2007-11-04 
04:34:44.000000000 +0200
@@ -42,6 +42,7 @@
 static struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
+{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE, cs5530a_warm_reset },
 };

 /*





--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

