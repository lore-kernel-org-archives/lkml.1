Return-Path: <linux-kernel-owner+w=401wt.eu-S935550AbXGWU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550AbXGWU65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXGWU6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:58:46 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:7757 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbXGWU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:58:45 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 16:58:44 EDT
Message-ID: <46A3F9AE.9030605@nvidia.com>
Date: Sun, 22 Jul 2007 20:43:26 -0400
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>, Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@osdl.org>, nedev <netdev@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] forcedeth: mcp73 device addition
X-NVConfidentiality: public
Content-Type: multipart/mixed;
 boundary="------------000003030009040605050004"
X-OriginalArrivalTime: 23 Jul 2007 20:53:38.0602 (UTC) FILETIME=[8B5310A0:01C7CD6B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000003030009040605050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch contains new device settings for MCP73 chipset.

Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>


--------------000003030009040605050004
Content-Type: text/plain;
 name="patch-forcedeth-mcp73"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-forcedeth-mcp73"

--- old/drivers/net/forcedeth.c	2007-07-22 19:02:41.000000000 -0400
+++ new/drivers/net/forcedeth.c	2007-07-22 19:31:56.000000000 -0400
@@ -5550,6 +5550,22 @@
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_27),
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
 	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_28),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_29),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_30),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
+	{	/* MCP73 Ethernet Controller */
+		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_31),
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+	},
 	{0,},
 };
 

--------------000003030009040605050004--
