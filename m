Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYENFri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYENFri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYENFr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:47:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:56038 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYENFr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:47:29 -0400
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
In-Reply-To: <200805132214.27510.nickpiggin@yahoo.com.au>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
	 <20080507234521.GN8276@duo.random> <20080508013459.GS8276@duo.random>
	 <200805132214.27510.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 13 May 2008 22:43:59 -0700
Message-Id: <1210743839.8297.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-13 at 22:14 +1000, Nick Piggin wrote:
> ea.
> 
> I don't see why you're bending over so far backwards to accommodate
> this GRU thing that we don't even have numbers for and could actually
> potentially be batched up in other ways (eg. using mmu_gather or
> mmu_gather-like idea).

I agree, we're better off generalizing the mmu_gather batching
instead...

I had some never-finished patches to use the mmu_gather for pretty much
everything except single page faults, tho various subtle differences
between archs and lack of time caused me to let them take the dust and
not finish them...

I can try to dig some of that out when I'm back from my current travel,
though it's probably worth re-doing from scratch now.

Ben.


