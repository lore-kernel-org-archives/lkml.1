Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbYCCTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbYCCTHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYCCTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:06:57 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59307 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752391AbYCCTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:06:56 -0500
Date: Mon, 3 Mar 2008 11:06:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <20080303093529.GB15091@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093529.GB15091@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> Introduce SLAB_SMP_ALIGN, for allocations where false sharing must be
> minimised on SMP systems.

Mandatory alignment are specified as a parameter to kmem_cache_create not 
as flags. Ycan specify the alignment as a parameter. i.e. L1_CACHE_BYTES 
or cache_line_size().

Maybe we should drop SLAB_HWCACHE_ALIGN because of the confusion is 
creates because it seems that flags can be used to enforce alignments?


