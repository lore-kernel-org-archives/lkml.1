Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYCYRrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYCYRrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYCYRq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:46:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbYCYRq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:46:58 -0400
Date: Tue, 25 Mar 2008 10:45:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
In-Reply-To: <20080325075236.GG2170@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803251043140.15870@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061727.269764652@sgi.com>
 <8763vfixb8.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803241253250.4218@schroedinger.engr.sgi.com>
 <20080325075236.GG2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andi Kleen wrote:

> I liked your idea of fixing compound pages to not rely on order
> better. Ok it is likely more work to implement @)

Right. It just requires a page allocator rewrite. Which is overdue 
anyways given the fastpath issues. Volunteers?

> Also if anything preserving memory should be default, but maybe
> skippable a with __GFP_GO_FAST flag.

Well. Guess we need a definition of preserving memory. All allocations 
typically have some kind of overhead.


