Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZE1XYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZE1XYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZE1XX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:23:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:39699 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZE1XX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:23:56 -0400
Date: Fri, 29 May 2009 08:23:51 +0900
To: rdreier@cisco.com
Cc: fujita.tomonori@lab.ntt.co.jp, rolandd@cisco.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] IB/mthca: replace dma_sync_single with
 dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <adaeiu86fde.fsf@cisco.com>
References: <20090528100943L.fujita.tomonori@lab.ntt.co.jp>
	<adaeiu86fde.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090529082417G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 29 May 2009 08:23:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 15:18:21 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > This replaces dma_sync_single() with dma_sync_single_for_cpu() because
>  > dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
>  > 
>  > /* Backwards compat, remove in 2.7.x */
> 
> Thanks for pointing this out... however I think sync_single_for_cpu
> looks wrong in these cases -- I think there should be a pair of
> sync_single_for_cpu/sync_single_for_device around this stuff.

Yeah, possibly. I just convert it without looking at the code. As you
know, the patch will not change anything. If dma_sync_single_for_cpu
doesn't work here, the driver is already broken.


> I'll take a closer look in the next day or too.

Cool, thanks!
