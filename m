Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbZE1PVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbZE1PVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZE1PUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:20:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3772 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820AbZE1PUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:20:50 -0400
X-BigFish: VPS4(ze80izzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KKD1AD-01-JYW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] dma-debug: add documentation for the driver filter
Date: Thu, 28 May 2009 17:19:31 +0200
Message-ID: <1243523971-12681-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 May 2009 15:19:34.0467 (UTC) FILETIME=[B4EC0930:01C9DFA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the driver filter feature to the dma-debug
documentation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/DMA-API.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index d9aa43d..eb6f9d5 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -704,12 +704,23 @@ this directory the following files can currently be found:
 				The current number of free dma_debug_entries
 				in the allocator.
 
+	dma-api/driver-filter
+				You can write a name of driver into this file
+				to limit the debug output to requests from that
+				particular driver. Write an empty string to
+				that file to disable the filter again.
+
 If you have this code compiled into your kernel it will be enabled by default.
 If you want to boot without the bookkeeping anyway you can provide
 'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
 Notice that you can not enable it again at runtime. You have to reboot to do
 so.
 
+If you want to see debug messages only for a special device driver you can
+specify the dma_debug_driver=<drivername> parameter. This will enable the
+driver filter at boot time. The debug code will only print errors for that
+driver afterwards. This filter can be disabled or changed later using debugfs.
+
 When the code disables itself at runtime this is most likely because it ran
 out of dma_debug_entries. These entries are preallocated at boot. The number
 of preallocated entries is defined per architecture. If it is too low for you
-- 
1.6.3.1


