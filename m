Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZE3Xyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZE3Xyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZE3XyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:54:25 -0400
Received: from [213.58.128.207] ([213.58.128.207]:36034 "EHLO
	ftp.linux-mips.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZE3XyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:54:24 -0400
Date: Sun, 31 May 2009 00:54:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Marc Zyngier <maz@wild-wind.fr.eu.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] eisa.ids: Add Network Peripherals FDDI boards
Message-ID: <alpine.LFD.1.10.0905310041200.15490@ftp.linux-mips.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add EISA IDs for Network Peripherals FDDI boards.  Descriptions taken 
from the respective EISA configuration files.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It's unlikely we'll ever support these cards, the problem being the lack 
of documentation.  Assuming the policy for the EISA ID database is the 
same as for PCI I'm sending these entries for the sake of completeness.

 Please apply.

  Maciej

patch-mips-2.6.27-rc8-20081004-npi-eisa-0
Index: linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids
===================================================================
--- linux-mips-2.6.27-rc8-20081004-dolch.orig/drivers/eisa/eisa.ids
+++ linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids
@@ -1140,6 +1140,11 @@ NON0301 "c't Universale Graphic Adapter"
 NON0401 "c't Universal Ethernet Adapter"
 NON0501 "c't Universal 16-Bit Sound Adapter"
 NON0601 "c't Universal 8-Bit Adapter"
+NPI0120 "Network Peripherals NP-EISA-1 FDDI Interface"
+NPI0221 "Network Peripherals NP-EISA-2 FDDI Interface"
+NPI0223 "Network Peripherals NP-EISA-2E Enhanced FDDI Interface"
+NPI0301 "Network Peripherals NP-EISA-3 FDDI Interface"
+NPI0303 "Network Peripherals NP-EISA-3E Enhanced FDDI Interface"
 NSS0011 "Newport Systems Solutions WNIC Adapter"
 NVL0701 "Novell NE3200 Bus Master Ethernet"
 NVL0702 "Novell NE3200T Bus Master Ethernet"
