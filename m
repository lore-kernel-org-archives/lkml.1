Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYIRFkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYIRFkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 01:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYIRFkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 01:40:23 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:60951 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYIRFkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 01:40:22 -0400
X-Greylist: delayed 1662 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 01:40:22 EDT
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]pci_dma_mapping_error changes
Date: Thu, 18 Sep 2008 08:12:25 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809180812.25143.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the example code consistent with changed API.

Signed-off-by: Marin Mitov <mitov@ispp.bas.bg>

===================================================
--- a/Documentation/DMA-mapping.txt	2008-09-14 11:34:48.000000000 +0300
+++ b/Documentation/DMA-mapping.txt	2008-09-14 11:37:17.000000000 +0300
@@ -740,7 +740,7 @@ failure can be determined by:
 	dma_addr_t dma_handle;
 
 	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(dma_handle)) {
+	if (pci_dma_mapping_error(pdev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
