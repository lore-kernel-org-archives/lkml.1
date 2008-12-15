Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYLOBw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYLOBw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYLOBwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 20:52:04 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:54885 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYLOBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 20:52:03 -0500
Date: Sun, 14 Dec 2008 19:51:47 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>, bcrl@kvack.org,
       list-linux-mm@kvack.org
Subject: Re: [rfc][patch] SLQB slab allocator
In-Reply-To: <84144f020812130103t11fb4054rb934376a034ec802@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812141950210.3237@quilx.com>
References: <20081212002518.GH8294@wotan.suse.de>  <Pine.LNX.4.64.0812122013390.15781@quilx.com>
 <84144f020812130103t11fb4054rb934376a034ec802@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, Pekka Enberg wrote:

> Lets not forget the order-0 page thing, which is nice from page
> allocator fragmentation point of view. But I suppose SLUB can use them
> as well if we get around fixing the page allocator fastpaths?

If the fastpath of the page allocator would be comparable in performance
to the slab allocators then page sized allocations could simply be
forwarded to the page allocator etc. IMHO this is how it should be ....
Right now slab allocators must buffer PAGE_SIZEd allocs due to page
allocator slowness.

