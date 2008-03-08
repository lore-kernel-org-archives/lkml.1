Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYCHLzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYCHLzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYCHLzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:55:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47382 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYCHLzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:55:25 -0500
Date: Sat, 8 Mar 2008 12:57:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080308115703.GD27074@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <Pine.LNX.4.64.0803071841020.12220@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803071841020.12220@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 06:42:21PM -0800, Christoph Lameter wrote:
> On Fri, 7 Mar 2008, Andi Kleen wrote:
> 
> > The longer term goal is to convert all GFP_DMA allocations
> > to always specify the correct mask and then eventually remove
> > GFP_DMA.
> > 
> > Especially I hope kmalloc/kmem_cache_alloc GFP_DMA can be
> > removed soon. I have some patches to eliminate those users.
> > Then slab wouldn't need to maintain DMA caches anymore.
> 
> That would be greatly appreciated. Thanks for doing this.

I'm afraid it would not help you directly because you would still need 
to maintain that code for s390 (seems to be a heavy GFP_DMA user)
and probably some other architectures (unless you can get these
maintainers to get rid of GFP_DMA too) With my plan it can be just ifdefed
and the ifdef not enabled on x86.

-Andi
