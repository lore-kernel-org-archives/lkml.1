Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbXEJI1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbXEJI1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbXEJI0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:26:40 -0400
Received: from mx1.cdac.in ([203.199.132.35]:4774 "EHLO mx1.cdac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbXEJI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:26:39 -0400
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 04:26:38 EDT
Message-ID: <4642D095.6070305@cdac.in>
Date: Thu, 10 May 2007 13:28:13 +0530
From: Mahesh <maheshk@cdac.in>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kernelnewbies@nl.linux.org
Subject: [HOWTO] accessing the DMA mapped data
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-imss-version: 2.046
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:3.6.1039(15166.003)
X-imss-scores: Clean:42.23425 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I have a small question regarding the accessing the data in the DMA 
mapped  region (in the driver).  In my driver I only have the 
'dma_addr_t addr' variable which is result after the 'dma_map_single'. 
I don't have access to the virtual address of the data region.

Is there helper routine which we will give me the virtual address back 
from the DMA mapped address???

After some searching in the net about it found 'dma_sync_single' which 
will help to synchronize it after 'modifying' the contents of the DMA mapped 
region. But to 'modify' the contents of DMA mapped region I require the virtual 
address, which is not available in my case.

Regards,
Mahesh.


