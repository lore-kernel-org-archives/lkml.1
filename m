Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0BKAlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:41:40 -0500
Received: from xenotime.net ([72.52.64.118]:33931 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750844Ab0BKAlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:41:39 -0500
Message-ID: <4B735242.8000101@xenotime.net>
Date: Wed, 10 Feb 2010 16:41:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
       adharmap@quicinc.com
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>	<4B7324D3.1000509@xenotime.net> <20100211093835I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100211093835I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/10 16:39, FUJITA Tomonori wrote:
> On Wed, 10 Feb 2010 13:27:47 -0800
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
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
>>
>> So when you add these interfaces for other architectures, you will also
>> update Documentation/DMA-API.txt,  right??
> 
> Seems that you misunderstand him.
> 
> He is talking about other "arm" architectures. His patchset improves
> arm's internal implementation (dma_map_area and dma_unmap_area are not
> the DMA API; not exported for driver writers). He meant that the
> patchset doesn't cover all arm architectures.
> 
> This is about arm's implementation details and not related with other
> non arm architectures. So no need to update Documentation/DMA-API.txt.

OK, in that case I did misunderstand.  Thanks for the info.

-- 
~Randy
