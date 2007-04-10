Return-Path: <linux-kernel-owner+w=401wt.eu-S1031058AbXDJQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031058AbXDJQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031059AbXDJQaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:30:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:46314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031058AbXDJQaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="71402792:sNHT99202077"
Message-ID: <461BBB66.4010303@linux.intel.com>
Date: Tue, 10 Apr 2007 09:29:26 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hch@infradead.org, ashok.raj@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, shaohua.li@intel.com
Subject: Re: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to provide
 unity map
References: <20070409215552.221374000@intel.com>	<20070409215723.969189000@intel.com>	<20070410083351.GA19691@infradead.org> <20070410.020702.88477115.davem@davemloft.net>
In-Reply-To: <20070410.020702.88477115.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 10 Apr 2007 09:33:51 +0100
> 
>> On Mon, Apr 09, 2007 at 02:55:57PM -0700, Ashok Raj wrote:
>>> Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
>>> Such drivers will be broken with IOMMU enabled. To workaround this issue, 
>>> we added two options.
>> All drm drivers do it.  If the usual out of tree crap vendors are too
>> stupid for their own sake it's their fault.
>>
>> So NACK to this patch.
> 
> That's my feeling as well, everything we care about should be using
> the proper APIs or else what is the point of them...

that's too simple; X uses /dev/mem as well, even with something as 
open as the Intel drivers.

Sad but true ;(

(it's getting resolved on the X side but existing X is like this)
