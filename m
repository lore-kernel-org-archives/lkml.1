Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXHUViZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXHUViZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXHUViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:38:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53934 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753352AbXHUViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:38:09 -0400
From: akepner@sgi.com
Date: Tue, 21 Aug 2007 14:37:07 -0700
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jes Sorensen <jes@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       rdreier@cisco.com, linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070821213707.GH5592@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com> <20070821193522.GD5592@sgi.com> <20070821201631.GF9163@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821201631.GF9163@parisc-linux.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 02:16:32PM -0600, Matthew Wilcox wrote:
> 
> So, let me try to understand ... your hardware allows writes from the
> device to pass other writes from the device?  Doesn't that violate the
> PCI spec?  I'm thinking about this (page 43 of PCI 2.3):
> ....

I should have stated this more carefully, but it's not a PCI reordering 
that's being addressed here, it's a reordering that can occur within 
the NUMA-interconnect. 

-- 
Arthur

