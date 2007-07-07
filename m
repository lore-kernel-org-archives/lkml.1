Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbXGGCJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbXGGCJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXGGCIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:08:53 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53187 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753371AbXGGCIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:08:52 -0400
Date: Sat, 7 Jul 2007 04:09:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1: SLUB_DEBUG=n compile error
Message-ID: <20070707020922.GB3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070707015021.GZ3492@stusta.de> <Pine.LNX.4.64.0707061902200.3257@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707061902200.3257@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 07:03:34PM -0700, Christoph Lameter wrote:
> On Sat, 7 Jul 2007, Adrian Bunk wrote:
> 
> > With CONFIG_SLUB_DEBUG=n:
> 
> Why switch CONFIG_SLUB_DEBUG off? This is an option for embedded systems. 
> Unlikely to occur on NUMA.

???
This compile error is not related to NUMA.

> > /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c: In function ÿÿinit_kmem_cache_nodeÿÿ:
> > /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c:1873: error: ÿÿstruct kmem_cache_nodeÿÿ has no member named ÿÿfullÿÿ
> > ...
> > make[2]: *** [mm/slub.o] Error 1
> 
> A fix for this is already in Andrew's tree.

Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

