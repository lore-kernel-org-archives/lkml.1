Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXH0WVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXH0WVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXH0WVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:21:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47979 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753688AbXH0WVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:21:31 -0400
From: akepner@sgi.com
Date: Mon, 27 Aug 2007 15:20:27 -0700
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] pci: let devices flush DMA to host memory
Message-ID: <20070827222027.GD29161@sgi.com>
References: <20070824180232.GP5592@sgi.com> <20070827220548.GB22484@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827220548.GB22484@colo.lackof.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 04:05:48PM -0600, Grant Grundler wrote:

> .....
> After reading the thread, my take is we need a more elegant way for a
> device driver to handle registration of DMA regions allocated by user
> space. The API would "make this page/region act like dma_alloc_coherent()".
> That implies strong ordering between CPU and DMA to/from the device.
> Maybe the code is the right thing and I want a name that makes
> sense in the context of current DMA API.

Need to think about this...

> 
> On IRC, willy suggested an mmap() flag and that sounds reasonable too
> though I don't know if it's feasible. 
> 

Yeah, we're doing something like this now as a band-aid solution. 
Not a flag to mmap(), but a magic offset value. But it wasn't 
acceptable to the maintainer of the mthca IB driver (Roland 
Dreier), hence the new proposal....

-- 
Arthur

