Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab0BKAkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:40:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:39111 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0BKAkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:40:35 -0500
Date: Thu, 11 Feb 2010 09:39:17 +0900
To: rdunlap@xenotime.net
Cc: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
       adharmap@quicinc.com
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B7324D3.1000509@xenotime.net>
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
	<4B7324D3.1000509@xenotime.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100211093835I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 11 Feb 2010 09:39:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010 13:27:47 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 02/10/10 12:37, adharmap@codeaurora.org wrote:
> > From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> > 
> > Please refer to the post here
> > http://lkml.org/lkml/2010/1/4/347
> > 
> > These changes are to introduce barrierless dma_map_area and dma_unmap_area and
> > use them to map the buffers in the scatterlist. For the last buffer, call
> > the normal dma_map_area(aka with barriers) effectively executing the barrier
> > at the end of the operation.
> > 
> > Note that the barrierless operations are implemented for few arm
> > architectures only and I would implement for others once these are okayed by the
> > community.
> 
> So when you add these interfaces for other architectures, you will also
> update Documentation/DMA-API.txt,  right??

Seems that you misunderstand him.

He is talking about other "arm" architectures. His patchset improves
arm's internal implementation (dma_map_area and dma_unmap_area are not
the DMA API; not exported for driver writers). He meant that the
patchset doesn't cover all arm architectures.

This is about arm's implementation details and not related with other
non arm architectures. So no need to update Documentation/DMA-API.txt.
