Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXG2WBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXG2WBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936240AbXG2WAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:00:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63640 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935349AbXG2WAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KwbFxy0zxdx2DEHlk2a/5JoqzsbOPQKwRq9K4V7X+eUbfwKny3vEPx4DkPqc5ZtEXxNyIStA8UFxWj7zxMccDFwBEHA+Cjnq0ym4CaXiXzlR3VyW4dW1vku7vt4gT5ToD/uDROKoxxQQ+bsDdS7mWvJNtilDrJoWyVBTPe00sQ8=
Date: Mon, 30 Jul 2007 01:01:25 +0300
From: Indrek Kruusa <indrek.kruusa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pci_ids: additional NFORCE MCP61 devices - (resend)
Message-Id: <20070730010125.45e21b2b.indrek.kruusa@gmail.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the following 7 Nforce devices:

- LPC Bridge (MCP61_LPC_BRG)
- Memory Controller (MCP61_MC1)
- High Definition Audio (MCP61_HDA)
- USB Controller (MCP61_OHCI)
- USB Controller (MCP61_EHCI)
- PCI bridge (MCP61_PCI_BRG)
- Memory Controller (MCP61_MC2)

to the pci_ids.h file.

Signed-off-by: Indrek Kruusa <indrek.kruusa@gmail.com>

lspci output on Gigabyte GA-M61SME-S2 (GF6100/NF405) can be seen from [1],[2]
 
thanks,
Indrek
 
______________
 
[1] http://www.hot.ee/bzmeez/nv_mcp61_lspci-n.txt
[2] http://www.hot.ee/bzmeez/nv_mcp61_lspci-vv.txt



diff -pur linux-2.6.git1/include/linux/pci_ids.h linux-2.6_p/include/linux/pci_ids.h
--- linux-2.6.git1/include/linux/pci_ids.h	2007-07-29 20:48:28.000000000 +0300
+++ linux-2.6_p/include/linux/pci_ids.h	2007-07-29 20:54:21.000000000 +0300
@@ -1206,13 +1206,20 @@
 #define PCI_DEVICE_ID_NVIDIA_QUADRO_FX_1100         0x034E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_14              0x0372
 #define PCI_DEVICE_ID_NVIDIA_NVENET_15              0x0373
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_LPC_BRG   0x03E0
 #define PCI_DEVICE_ID_NVIDIA_NVENET_16              0x03E5
 #define PCI_DEVICE_ID_NVIDIA_NVENET_17              0x03E6
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA      0x03E7
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_MC1       0x03EA
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SMBUS	    0x03EB
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE       0x03EC
 #define PCI_DEVICE_ID_NVIDIA_NVENET_18              0x03EE
 #define PCI_DEVICE_ID_NVIDIA_NVENET_19              0x03EF
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_HDA       0x03F0
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_OHCI      0x03F1
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_EHCI      0x03F2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_PCI_BRG   0x03F3
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_MC2       0x03F5
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2     0x03F6
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3     0x03F7
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_SMBUS	    0x0446
