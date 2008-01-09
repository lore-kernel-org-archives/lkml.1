Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbYAIHSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbYAIHSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYAIHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:18:29 -0500
Received: from verein.lst.de ([213.95.11.210]:33965 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYAIHS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:18:28 -0500
Date: Wed, 9 Jan 2008 08:17:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       hch@lst.de, ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Message-ID: <20080109071727.GA10695@lst.de>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
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
> 
> This reverts commit 74a0b5762713a26496db72eac34fbbed46f20fce.
> Conflicts:

NACK.   If you want to do it you'll need a much better reason and an
in-tree user.  And if you want to redo it it should be available for
all platforms with a consistant API.

