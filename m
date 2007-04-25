Return-Path: <linux-kernel-owner+w=401wt.eu-S2992802AbXDYQV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992802AbXDYQV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXDYQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:21:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53417 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992802AbXDYQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:21:57 -0400
Date: Wed, 25 Apr 2007 09:21:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] slub: update cpu after new_slab()
In-Reply-To: <Pine.LNX.4.64.0704251703360.24086@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704250920100.26221@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704251613280.19217@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250824070.24363@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704251642450.22530@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704250857170.24530@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704251703360.24086@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Hugh Dickins wrote:

> But, surely you wouldn't have expected it to stay on the processor
> throughout the waiting page allocation??  I think you're misremembering
> your expectations, and this was just a simple, understandable, oversight.

You do not know my fuzzy brain... Some thoughts go wrong once and 
twice and then are stuck in there and I need people like you to 
straighten me out.

> Quite a serious one, though: it got caught in my case by the NULL
> dereference, but it's probably been switching cpu there much more
> often - one cpu diddling with what's private to another, with
> unpredictable results.

Right. Thanks for catching it.
