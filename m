Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbXHFTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbXHFTQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbXHFTQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:16:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52808 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933406AbXHFTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:16:12 -0400
Date: Mon, 6 Aug 2007 12:16:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
In-Reply-To: <20070806121053.baed9691.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708061212550.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl>
 <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
 <p73r6mglaog.fsf@bingen.suse.de> <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
 <1186426079.11797.88.camel@lappy> <20070806185926.GB22499@one.firstfloor.org>
 <20070806121053.baed9691.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andrew Morton wrote:

> Plus I don't think there are many flags left in the upper 32-bits.  ia64
> swooped in and gobbled lots of them, although it's not immediately clear
> how many were consumed.

IA64 uses one of these bits for the uncached allocator.  10 bits used for 
the node. Sparsemem may use some of the rest.



