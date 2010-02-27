Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746Ab0B0VaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:30:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56284 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933277Ab0B0VaD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:30:03 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:29:57 +0000
Message-ID: <1267306197.16186.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 1/6] Correct various filenames
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filenames should be the names of the installed binary files, without
the base directory 'firmware'.

Remove mention of absent file 'whiteheat_loader_debug.fw'.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE |   61 ++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/WHENCE b/WHENCE
index 0b99cb1..728b71d 100644
--- a/WHENCE
+++ b/WHENCE
@@ -10,7 +10,7 @@ kernel.
 
 Driver: ambassador -- Madge Ambassador (Collage PCI 155 Server) ATM NIC.
 
-File: firmware/atmsar11.fw
+File: atmsar11.fw
 
 Licence: Allegedly GPLv2+, but no source visible. Marked:
 
@@ -271,7 +271,6 @@ File: whiteheat.fw
 Version: 4.06
 
 File: whiteheat_loader.fw
-File: whiteheat_loader_debug.fw
 
 Licence: Allegedly GPLv2, but no source visible. Marked:
 	 Copyright (C) 2000-2002  ConnectTech Inc
@@ -507,9 +506,9 @@ Licence: GPLv2 or OpenIB.org BSD license, no source visible
 
 Driver: cxgb3 - Chelsio Terminator 3 1G/10G Ethernet adapter
 
-File: cxgb3/ael2005_opt_edc.bin.ihex
-File: cxgb3/ael2005_twx_edc.bin.ihex
-File: cxgb3/ael2020_twx_edc.bin.ihex
+File: cxgb3/ael2005_opt_edc.bin
+File: cxgb3/ael2005_twx_edc.bin
+File: cxgb3/ael2020_twx_edc.bin
 
 Licence:
  *	Copyright (c) 2007-2009 NetLogic Microsystems, Inc.
@@ -597,27 +596,27 @@ Also available from http://linuxwimax.org/Download
 
 Driver: libertas - Marvell Libertas fullmac-type 802.11b/g cards
 
-File: cf8385.bin
-File: cf8385_helper.bin
-File: gspi8682.bin
-File: gspi8682_helper.bin
-File: gspi8686_v9.bin
-File: gspi8686_v9_helper.bin
-File: gspi8688.bin
-File: gspi8688_helper.bin
-File: sd8385.bin
-File: sd8385_helper.bin
-File: sd8682.bin
-File: sd8682_helper.bin
-File: sd8686_v8.bin
-File: sd8686_v8_helper.bin
-File: sd8686_v9.bin
-File: sd8686_v9_helper.bin
-File: sd8688.bin
-File: sd8688_helper.bin
-File: usb8388_v5.bin
-File: usb8388_v9.bin
-File: usb8682.bin
+File: libertas/cf8385.bin
+File: libertas/cf8385_helper.bin
+File: libertas/gspi8682.bin
+File: libertas/gspi8682_helper.bin
+File: libertas/gspi8686_v9.bin
+File: libertas/gspi8686_v9_helper.bin
+File: libertas/gspi8688.bin
+File: libertas/gspi8688_helper.bin
+File: libertas/sd8385.bin
+File: libertas/sd8385_helper.bin
+File: libertas/sd8682.bin
+File: libertas/sd8682_helper.bin
+File: libertas/sd8686_v8.bin
+File: libertas/sd8686_v8_helper.bin
+File: libertas/sd8686_v9.bin
+File: libertas/sd8686_v9_helper.bin
+File: libertas/sd8688.bin
+File: libertas/sd8688_helper.bin
+File: libertas/usb8388_v5.bin
+File: libertas/usb8388_v9.bin
+File: libertas/usb8682.bin
 
 Licence: Redistributable. See LICENCE.libertas for details.  Extracted from
 Linux driver tarballs downloaded from Marvell's "Extranet" with permission.
@@ -626,8 +625,8 @@ Linux driver tarballs downloaded from Marvell's "Extranet" with permission.
 
 Driver: mwl8k - Marvell Libertas softmac-type 802.11b/g cards
 
-File: fmimage_8687.fw
-File: helper_8687.fw
+File: mwl8k/fmimage_8687.fw
+File: mwl8k/helper_8687.fw
 
 Licence: Redistributable. See LICENCE.mwl8k for details.  Downloaded from
 Marvell's "Extranet" with permission.
@@ -907,8 +906,8 @@ Driver: bnx2x: Broadcom Everest
 
 File: bnx2x-e1-4.8.53.0.fw
 File: bnx2x-e1h-4.8.53.0.fw
-File: bnx2x-e1-5.2.7.0.fw.ihex
-File: bnx2x-e1h-5.2.7.0.fw.ihex
+File: bnx2x-e1-5.2.7.0.fw
+File: bnx2x-e1h-5.2.7.0.fw
 
 Licence:
   Copyright (c) 2007-2009 Broadcom Corporation
@@ -1014,7 +1013,7 @@ Downloaded from http://www.ralinktech.com/ralink/Home/Support/Linux.html
 Driver: usbdux/usbduxfast - usbdux data acquisition cards
 
 File: usbdux_firmware.bin
-File: usbdixfast_firmware.bin
+File: usbduxfast_firmware.bin
 Source: usbdux/fx2-include.asm
 Source: usbdux/usbduxfast_firmware.asm
 Source: usbdux/usbdux_firmware.asm
-- 
1.6.6.2



