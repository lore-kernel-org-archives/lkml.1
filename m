Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbXI1A2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbXI1A2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 20:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbXI1A2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 20:28:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50142 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757159AbXI1A2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 20:28:36 -0400
From: akepner@sgi.com
Date: Thu, 27 Sep 2007 17:27:34 -0700
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA
Message-ID: <20070928002734.GL30013@sgi.com>
References: <20070925235843.GK30013@sgi.com> <20070926064950.GB30430@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926064950.GB30430@colo.lackof.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:49:50AM -0600, Grant Grundler wrote:

[edited out several points that I think have been already 
addresed by others in this thread.]

> ....
> Defining it terms of completion queues won't mean much to most folks.
> Better to add a description of completion queues to the DMA-API.txt if
> necessary.  dma_alloc_coherent() API is pretty well understood.

OK, next time I'll use a more generic description.

> 
> > There are four patches in this set:
> > 
> >   [1/4] dma: add dma_flags_set_dmaflush() to dma interface
> 
> Sorry - this feels like a "color of the shed" argument, but isn't
> this about DMA ordering attribute?
> "dmaflush" is an action and not an attribute to me.

Right - an attribute is a noun, not a verb. I'm going to try 
"s/dmaflush/dmabarrier/" in the next version.

> ....
> This patch updates Documentation/DMA-mapping.txt. But it's a change to
> the generic (not PCI specific) API described in DMA-API.txt.
> Can you update that as well please?
>....

Ja, I realized that soon after hitting the send button. I'll 
move the documentation to DMA-API.txt.

-- 
Arthur

