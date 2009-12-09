Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZLIFPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZLIFPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZLIFPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:15:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51588 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbZLIFPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:15:38 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Dec 2009 05:15:42 +0000
Message-ID: <1260335742.4532.246.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/5] firmware/WHENCE: Correct filenames for ambassador,
 bnx2x, cxgb3
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filenames should be the names of the installed binary files, without
the base directory.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/WHENCE |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index 5fe6045..e144711 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -10,7 +10,7 @@ kernel.
 
 Driver: ambassador -- Madge Ambassador (Collage PCI 155 Server) ATM NIC.
 
-File: firmware/atmsar11.fw
+File: atmsar11.fw
 
 Licence: Allegedly GPLv2+, but no source visible. Marked:
 
@@ -410,9 +410,9 @@ Found in hex form in kernel source.
 
 Driver: cxgb3 - Chelsio Terminator 3 1G/10G Ethernet adapter
 
-File: cxgb3/t3b_psram-1.1.0.bin.ihex
-File: cxgb3/t3c_psram-1.1.0.bin.ihex
-file: cxgb3/t3fw-7.4.0.bin.ihex
+File: cxgb3/t3b_psram-1.1.0.bin
+File: cxgb3/t3c_psram-1.1.0.bin
+file: cxgb3/t3fw-7.4.0.bin
 
 License: GPLv2 or OpenIB.org BSD license, no source visible
 
@@ -420,9 +420,9 @@ License: GPLv2 or OpenIB.org BSD license, no source visible
 
 Driver: cxgb3 - Chelsio Terminator 3 1G/10G Ethernet adapter
 
-File: cxgb3/ael2005_opt_edc.bin.ihex
-File: cxgb3/ael2005_twx_edc.bin.ihex
-File: cxgb3/ael2020_twx_edc.bin.ihex
+File: cxgb3/ael2005_opt_edc.bin
+File: cxgb3/ael2005_twx_edc.bin
+File: cxgb3/ael2020_twx_edc.bin
 
 Licence:
  *	Copyright (c) 2007-2009 NetLogic Microsystems, Inc.
@@ -678,8 +678,8 @@ Found in hex form in kernel source.
 
 Driver: bnx2x: Broadcom Everest
 
-File: bnx2x-e1-5.2.7.0.fw.ihex
-File: bnx2x-e1h-5.2.7.0.fw.ihex
+File: bnx2x-e1-5.2.7.0.fw
+File: bnx2x-e1h-5.2.7.0.fw
 
 License:
   Copyright (c) 2007-2009 Broadcom Corporation
-- 
1.6.5.3



