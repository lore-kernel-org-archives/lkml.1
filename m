Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0BJWk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:40:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58407 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0BJWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:40:56 -0500
Date: Wed, 10 Feb 2010 22:40:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
Message-ID: <20100210224030.GC30854@n2100.arm.linux.org.uk>
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org> <4B7324D3.1000509@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7324D3.1000509@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 01:27:47PM -0800, Randy Dunlap wrote:
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

Do we need barrier-less interfaces for anything other than the dma_*_sg
functions?
