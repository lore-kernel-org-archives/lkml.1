Return-Path: <linux-kernel-owner+w=401wt.eu-S934823AbXHNUME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823AbXHNUME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXHNULq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:11:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:58091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935433AbXHNULp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:11:45 -0400
Date: Tue, 14 Aug 2007 23:05:51 +0200
From: Andi Kleen <ak@suse.de>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814210551.GU3406@bingen.suse.de>
References: <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu> <20070814001441.GN3406@bingen.suse.de> <20070814191158.GB14093@hexapodia.org> <20070814202350.GT3406@bingen.suse.de> <20070814194356.GL21492@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814194356.GL21492@hexapodia.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, if you stick a PCI chip with a 30-bit PCI DMA mask into a machine
> with memory above 1GB, then copying has to happen.  Unless the memory
> allocator can avoid returning memory in the un-dma-able region...

With GFP_DMA this was possible, but the capability will be gone
for x86 systems if your required DMA region is < 4GB.

Besides I'm currently not planning to change mips so it might
stay the same if Ralf prefers that.

-Andi
