Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYAIChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYAIChp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYAIChi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:37:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:46534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYAIChh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:37:37 -0500
Date: Wed, 9 Jan 2008 03:37:36 +0100
From: Andi Kleen <ak@suse.de>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       hch@lst.de, ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
Message-ID: <20080109023736.GI25945@bingen.suse.de>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:34:46AM +0000, Dave Airlie wrote:
> 
> [This an initial RFC but I'd like to have this patch in before 2.6.24 goes 
> final as it really breaks this useful feature]
> 
> mmiotrace the MMIO access tracer used to reverse engineer binary blobs
> used this notifier interface and is planned on being pushed upstream.
> 
> Having users able to just use the tracer module without having to rebuild 
> their kernel to add in a page fault handler hack means we get a lot 
> greater coverage for reverse engineering efforts.
> 
> Signed-off-by: David Airlie <airlied@linux.ie>

Acked-by: Andi Kleen <ak@suse.de>

I never liked the original patch.

-Andi

