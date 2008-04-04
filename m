Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbYDDQVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbYDDQVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYDDQVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:21:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21687 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYDDQVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:21:36 -0400
Date: Fri, 4 Apr 2008 09:21:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       jejb <James.Bottomley@HansenPartnership.com>
Subject: [PATCH bz #10388] doc: fix DMA-API function parameters
Message-Id: <20080404092106.243b5dd2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel bugzilla #10388.

DMA-API.txt has wrong argument type for some functions.
It uses struct device but should use struct pci_dev.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DMA-API.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lin2625-rc8-kdoc.orig/Documentation/DMA-API.txt
+++ lin2625-rc8-kdoc/Documentation/DMA-API.txt
@@ -145,7 +145,7 @@ Part Ic - DMA addressing limitations
 int
 dma_supported(struct device *dev, u64 mask)
 int
-pci_dma_supported(struct device *dev, u64 mask)
+pci_dma_supported(struct pci_dev *hwdev, u64 mask)
 
 Checks to see if the device can support DMA to the memory described by
 mask.
@@ -189,7 +189,7 @@ dma_addr_t
 dma_map_single(struct device *dev, void *cpu_addr, size_t size,
 		      enum dma_data_direction direction)
 dma_addr_t
-pci_map_single(struct device *dev, void *cpu_addr, size_t size,
+pci_map_single(struct pci_dev *hwdev, void *cpu_addr, size_t size,
 		      int direction)
 
 Maps a piece of processor virtual memory so it can be accessed by the
