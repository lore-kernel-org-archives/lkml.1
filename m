Return-Path: <linux-kernel-owner+w=401wt.eu-S935518AbXGWUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935518AbXGWUWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934781AbXGWUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:20:21 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42713 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764255AbXGWUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:20:10 -0400
Date: Mon, 23 Jul 2007 13:18:48 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 10/10] x86_64: k8topology add family 10h and 11h PCI IDs
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Joachim Deguara <joachim.deguara@amd.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231318.49387.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this one is dropped by Andi wrongly.

From: "Joachim Deguara" <joachim.deguara@amd.com>
This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges to
k8topology discovery.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/x86_64/mm/k8topology.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86_64/mm/k8topology.c	2007-07-23 11:14:46.000000000 -0700
+++ b/arch/x86_64/mm/k8topology.c	2007-07-23 11:17:20.000000000 -0700
@@ -28,11 +28,15 @@
 		u32 header;
 		
 		header = read_pci_config(0, num, 0, 0x00);  
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
+		if ((header != (PCI_VENDOR_ID_AMD | (0x1100<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1200<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1300<<16))))
 			continue; 	
 
 		header = read_pci_config(0, num, 1, 0x00); 
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
+		if ((header != (PCI_VENDOR_ID_AMD | (0x1101<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1201<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1301<<16))))
 			continue;	
 		return num; 
 	} 
