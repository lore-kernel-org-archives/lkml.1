Return-Path: <linux-kernel-owner+w=401wt.eu-S939561AbXHMXcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939561AbXHMXcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936419AbXHMXc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:32:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:47948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900AbXHMXc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:32:26 -0400
Date: Tue, 14 Aug 2007 02:26:35 +0200
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814002635.GR3406@bingen.suse.de>
References: <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <Pine.LNX.4.64.0708131614270.19910@schroedinger.engr.sgi.com> <20070814001659.GP3406@bingen.suse.de> <Pine.LNX.4.64.0708131625320.19910@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131625320.19910@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 04:27:42PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Andi Kleen wrote:
> 
> > > Ok then lets do it.
> > 
> > Conversion only makes sense once an API with a explicit mask
> > is in. Otherwise we have muddled semantics again.
> 
> pci_set_consistent_dma_mask
> 
> has that.

While on x86 it is roughly identical (although the low level
allocator is currently not very reliable) it makes a significant
difference on some platforms. e.g. I was told on PA-RISC
consistent memory is much more costly than non consistent ones.
That's probably true on anything that's not full IO cache
consistent.

So while it would be reasonable semantics for x86 and IA64
it's not for everybody else.

-Andi

> 
