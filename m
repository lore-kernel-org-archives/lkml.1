Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXEQVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXEQVCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:02:36 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:46107 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbXEQVCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:02:35 -0400
Message-ID: <464CC2D9.5060409@dunaweb.hu>
Date: Thu, 17 May 2007 23:02:17 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for publishing this.

> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
> controller.
>
> This patch base on sata_nv.c file from kernel 2.6.22-rc1
>
> See attachment for the patch.
>
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> ==================================
> See attached file.
> ==================================
>   

However, I saw this in the patch:

+               /* determine if physical DMA addr spans 64K boundary.
+                * Note h/w doesn't support 64-bit, so we unconditionally
+                * truncate dma_addr_t to u32.
+                */
+               addr = (u32) sg_dma_address(sg);

Does it mean that I can't upgrade my machine to 4 GB or more
without losing NCQ or risking data corruption?
Can the code be made IOMMU-aware?

Best regards,
Zoltán Böszörményi

