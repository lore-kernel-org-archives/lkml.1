Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbXF0U2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbXF0U2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXF0U2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:28:44 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63430 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030AbXF0U2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:28:43 -0400
Date: Wed, 27 Jun 2007 16:28:39 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: dma_mapping_ops for i386
Message-ID: <20070627202839.GC4344@rhun.congress.lan>
References: <46817016.7090400@goop.org> <200706270021.11434.ak@suse.de> <468270F5.7040408@goop.org> <200706271726.51013.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271726.51013.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 05:26:50PM +0200, Andi Kleen wrote:

> See the recent "quiet down swiotlb warnings" thread which uncovered
> quite some corpses in Xen's current IO setup.
> 
> Xen apparently bounces for multi page IOs which get merged from block
> lists because the block layer doesn't know they are not really 
> continuous in machine memory.
> 
> Proper fix is to tell the block layer to not merge in the first
> place instead.
>
> And probably some similar mechanism for network drivers that limits
> MTUs.

Will that guarantee that block and net IOs will not straddle a page
boundary?

Cheers,
Muli
