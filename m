Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbXHFTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbXHFTJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932559AbXHFTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:09:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761201AbXHFTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:09:05 -0400
Date: Mon, 6 Aug 2007 12:09:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
In-Reply-To: <20070806185926.GB22499@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708061208280.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl>
 <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
 <p73r6mglaog.fsf@bingen.suse.de> <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
 <1186426079.11797.88.camel@lappy> <20070806185926.GB22499@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andi Kleen wrote:

> I always cringe when I hear that. It's really more than node/sparsemem
> use too many bits. If we get rid of 32bit NUMA that problem would be
> gone for the node at least because it could be moved into the mostly
> unused upper 32bit part on 64bit architectures.

Looks like that will not be possible. Seems that embedded systems 
now want NUMA support.
