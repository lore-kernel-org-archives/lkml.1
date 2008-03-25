Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYCYRwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYCYRwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYCYRv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:51:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYCYRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:51:58 -0400
Date: Tue, 25 Mar 2008 18:55:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
Message-ID: <20080325175508.GV2170@one.firstfloor.org>
References: <20080321061703.921169367@sgi.com> <20080321061727.269764652@sgi.com> <8763vfixb8.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803241253250.4218@schroedinger.engr.sgi.com> <20080325075236.GG2170@one.firstfloor.org> <Pine.LNX.4.64.0803251043140.15870@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803251043140.15870@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 10:45:06AM -0700, Christoph Lameter wrote:
> On Tue, 25 Mar 2008, Andi Kleen wrote:
> 
> > I liked your idea of fixing compound pages to not rely on order
> > better. Ok it is likely more work to implement @)
> 
> Right. It just requires a page allocator rewrite. 

Not when the trick of getting high order, returning left over pages
is used. I meant just updating the GFP_COMPOUND code to always
use number of pages instead of order so that it could deal with a compound
where the excess pages are already returned. That is not actually that 
much work (I reimplemented this recently for dma alloc and it's < 20 LOC) 

Of course the full rewrite would be also great, agreed :)

-Andi
