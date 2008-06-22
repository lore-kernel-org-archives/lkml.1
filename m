Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYFVOOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYFVOOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYFVOOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:14:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34432 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYFVOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:14:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 22 Jun 2008 16:13:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH resend] arm: export dma_sync_sg_for_device (fix build failure)
To: Russell King <rmk@arm.linux.org.uk>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Martin Michlmayr <tbm@cyrius.com>
Message-ID: <tkrat.f4459fea282b5e69@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 2006-06-18 03:49:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: arm: add EXPORT_SYMBOL(dma_sync_sg_for_device)

as it is for example needed by drivers/ieee1394/dma.c

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 arch/arm/common/dmabounce.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -651,6 +651,7 @@ EXPORT_SYMBOL(dma_unmap_sg);
 EXPORT_SYMBOL(dma_sync_single_for_cpu);
 EXPORT_SYMBOL(dma_sync_single_for_device);
 EXPORT_SYMBOL(dma_sync_sg);
+EXPORT_SYMBOL(dma_sync_sg_for_device);
 EXPORT_SYMBOL(dmabounce_register_dev);
 EXPORT_SYMBOL(dmabounce_unregister_dev);
 


Refreshed for 2.6.26-rc7, otherwise unchanged since the problem still
exists.
http://osdir.com/ml/kernel.firewire.user/2006-06/msg00038.html
http://marc.info/?l=linux-arm-kernel&m=115166450400713
http://marc.info/?l=linux-arm-kernel&m=121414061629428
-- 
Stefan Richter
-=====-==--- -==- =-==-
http://arcgraph.de/sr/

