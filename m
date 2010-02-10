Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab0BJXKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:10:42 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0BJXKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:10:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5888"; a="33887760"
Message-ID: <4B733CEE.9030105@codeaurora.org>
Date: Wed, 10 Feb 2010 15:10:38 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org> <4B7324D3.1000509@xenotime.net> <20100210224030.GC30854@n2100.arm.linux.org.uk>
In-Reply-To: <20100210224030.GC30854@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Feb 10, 2010 at 01:27:47PM -0800, Randy Dunlap wrote:
>> On 02/10/10 12:37, adharmap@codeaurora.org wrote:
>>> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
>>>
>>> Please refer to the post here
>>> http://lkml.org/lkml/2010/1/4/347
>>>
>>> These changes are to introduce barrierless dma_map_area and dma_unmap_area and
>>> use them to map the buffers in the scatterlist. For the last buffer, call
>>> the normal dma_map_area(aka with barriers) effectively executing the barrier
>>> at the end of the operation.
>>>
>>> Note that the barrierless operations are implemented for few arm
>>> architectures only and I would implement for others once these are okayed by the
>>> community.
>> So when you add these interfaces for other architectures, you will also
>> update Documentation/DMA-API.txt,  right??
> 
> Do we need barrier-less interfaces for anything other than the dma_*_sg
> functions?

I think, dma_*_sg are the only ones that could benefit from barrier-less 
interfaces.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

