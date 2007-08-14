Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXHNT4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXHNT4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbXHNT4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:56:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42283 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757692AbXHNT4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:56:12 -0400
Date: Tue, 14 Aug 2007 12:56:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070814002635.GR3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708141255340.30766@schroedinger.engr.sgi.com>
References: <20070813225841.GG3406@bingen.suse.de>
 <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
 <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
 <20070814000041.GL3406@bingen.suse.de> <Pine.LNX.4.64.0708131614270.19910@schroedinger.engr.sgi.com>
 <20070814001659.GP3406@bingen.suse.de> <Pine.LNX.4.64.0708131625320.19910@schroedinger.engr.sgi.com>
 <20070814002635.GR3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > pci_set_consistent_dma_mask
> > 
> > has that.
> 
> While on x86 it is roughly identical (although the low level
> allocator is currently not very reliable) it makes a significant
> difference on some platforms. e.g. I was told on PA-RISC
> consistent memory is much more costly than non consistent ones.
> That's probably true on anything that's not full IO cache
> consistent.
> 
> So while it would be reasonable semantics for x86 and IA64
> it's not for everybody else.

Right. That is the point of the function. It isolates these strange 
platform dependencies. That is why there is no need for ZONE_DMA32 on any 
other platform.

