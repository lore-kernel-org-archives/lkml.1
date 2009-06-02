Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZFBOiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZFBOiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFBOhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:37:11 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:15776
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755174AbZFBOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:37:09 -0400
X-SpamScore: 4
X-BigFish: VPS4(ze80izzz1202hzzz32i17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KKM8LD-04-0I3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] dma-debug: add documentation for the driver filter
Date: Tue, 2 Jun 2009 16:36:44 +0200
Message-ID: <1243953404-31799-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
References: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Jun 2009 14:36:48.0016 (UTC) FILETIME=[8F437100:01C9E38F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the driver filter feature to the dma-debug
documentation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/DMA-API.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index d9aa43d..25fb8bc 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -704,12 +704,24 @@ this directory the following files can currently be found:
 				The current number of free dma_debug_entries
 				in the allocator.
 
+	dma-api/driver-filter
+				You can write a name of a driver into this file
+				to limit the debug output to requests from that
+				particular driver. Write an empty string to
+				that file to disable the filter and see
+				all errors again.
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


