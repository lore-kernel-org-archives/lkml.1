Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXHVHqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXHVHqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXHVHqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:46:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55920 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbXHVHqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:46:12 -0400
Message-ID: <46CBE960.4090702@sgi.com>
Date: Wed, 22 Aug 2007 09:44:32 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: akepner@sgi.com, linux-kernel <linux-kernel@vger.kernel.org>,
       rdreier@cisco.com, linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com> <20070821193522.GD5592@sgi.com> <20070821201631.GF9163@parisc-linux.org>
In-Reply-To: <20070821201631.GF9163@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> So, let me try to understand ... your hardware allows writes from the
> device to pass other writes from the device?  Doesn't that violate the
> PCI spec?  I'm thinking about this (page 43 of PCI 2.3):

Hi Matthew,

Yes I believe this behavior on sn2 is 'bending' the PCI spec a bit. The
problem is that the NUMA fabric is a routed network in itself so there
can be multiple paths between the device and the physical memory it DMAs
to/from.

Cheers,
Jes
