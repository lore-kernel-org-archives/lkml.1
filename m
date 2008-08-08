Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbYHHToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbYHHToq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYHHTof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:44:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50239 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYHHToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:44:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489CA21F.1030604@s5r6.in-berlin.de>
Date: Fri, 08 Aug 2008 21:44:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Scatter-gather segment merges by IOMMU?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the block layer usually tries to merge s/g segments if consecutive 
segments combined fit into the queue's max_segment_size.  When such a 
scatter gather list is DMA-mapped, can it happen that an IOMMU collapses 
the elements even further, so that sg_dma_len() of a DMA-mapped s/g 
segment exceeds max_segment_size?

As I understood some discussions in the past, this could indeed happen, 
which is a nuisance.  But I may have misunderstood something, or 
something may have changed in the meantime...
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
