Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXHVHl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXHVHl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXHVHlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:41:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55659 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbXHVHlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:41:17 -0400
Message-ID: <46CBE838.4000302@sgi.com>
Date: Wed, 22 Aug 2007 09:39:36 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akepner@sgi.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>	 <20070821193522.GD5592@sgi.com>	 <20070821130515.6e745b17.randy.dunlap@oracle.com>	 <1187729729.18410.48.camel@localhost.localdomain>	 <20070822003450.GM5592@sgi.com> <1187745249.18410.67.camel@localhost.localdomain>
In-Reply-To: <1187745249.18410.67.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-08-21 at 17:34 -0700, akepner@sgi.com wrote:
>> The term "posted DMA" is used to describe this behavior in the Altix 
>> Device Driver Writer's Guide, but it may be confusing things here. 
>> Maybe a better term will suggest itself if I can clarify....
> 
> OK, but posted DMA has a pretty specific meaning in terms of PCI, hence
> the confusion.

Maybe it would be more better to refer to this as 'out of order DMA'?

>> On Altix, DMA from a device isn't guaranteed to arrive in host memory 
>> in the order it was sent from the device. This reordering can happen 
>> in the NUMA interconnect (it's specifically not a PCI reordering.)
> 
> This is mmiowb and read_relaxed() again, isn't it?

I believe it's the same problem, except this time it's when exposing
structures to userland.

Cheers,
Jes
