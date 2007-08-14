Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbXHMXWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbXHMXWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXHMXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:22:16 -0400
Received: from ns.suse.de ([195.135.220.2]:49469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbXHMXWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:22:15 -0400
Date: Tue, 14 Aug 2007 02:16:24 +0200
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814001624.GO3406@bingen.suse.de>
References: <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com> <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com> <20070813234217.GI3406@bingen.suse.de> <Pine.LNX.4.64.0708131550100.30626@schroedinger.engr.sgi.com> <20070813235518.GK3406@bingen.suse.de> <Pine.LNX.4.64.0708131611001.19910@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131611001.19910@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 04:12:17PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Andi Kleen wrote:
> 
> > > What would be the point?
> > 
> > "so that drivers not need to ifdef" 
> 
> But they use GFP_DMA right now and drivers cannot use DMA32 if they want 

The way it was originally designed was that they use GFP_DMA32,
which would map to itself on x86-64, to GFP_DMA on ia64 and to
GFP_KERNEL on i386. Unfortunately that seems to have bitrotted
(perhaps I should have better documented it) 

> to be cross platforms compatible? Doesnt the dma API completely do away 
> with these things?

No GFP_DMA32 in my current plan is still there.

-Andi
