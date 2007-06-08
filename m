Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXFHRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXFHRqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937286AbXFHRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:46:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34483 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936025AbXFHRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:46:25 -0400
Message-ID: <466995DB.6080703@austin.ibm.com>
Date: Fri, 08 Jun 2007 12:46:03 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: apw@shadowen.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: add an exclusion for 'for_each' helper macros
References: <20070608171105.7391.40550.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070608171105.7391.40550.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dan Williams wrote:
> checkpatch currently complains about macros like the following:
> 
> #define for_each_dma_cap_mask(cap, mask) \
> 	for ((cap) = first_dma_cap(mask);       \
> 		(cap) < DMA_TX_TYPE_END;        \
> 		(cap) = next_dma_cap((cap), (mask)))
> 
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'd like it if this patch updated Chapter 12 of Documentation/CodingStyle as well. 
That section is where the rule to check came from and it would be nice for it to 
mention the exception to the rule as well.



