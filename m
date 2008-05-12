Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYELUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYELUBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYELUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:01:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47768 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbYELUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:01:30 -0400
Date: Mon, 12 May 2008 15:01:13 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 001/001] mmu-notifier-core v17
Message-ID: <20080512200113.GA31862@sgi.com>
References: <20080509193230.GH7710@duo.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509193230.GH7710@duo.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 09:32:30PM +0200, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <andrea@qumranet.com>
> 
> With KVM/GFP/XPMEM there isn't just the primary CPU MMU pointing to
> pages. There are secondary MMUs (with secondary sptes and secondary
> tlbs) too. sptes in the kvm case are shadow pagetables, but when I say
> spte in mmu-notifier context, I mean "secondary pte". In GRU case
> there's no actual secondary pte and there's only a secondary tlb
> because the GRU secondary MMU has no knowledge about sptes and every
> secondary tlb miss event in the MMU always generates a page fault that
> has to be resolved by the CPU (this is not the case of KVM where the a
> secondary tlb miss will walk sptes in hardware and it will refill the
>...

FYI, I applied to patch to a tree that has the GRU driver. All regression
tests passed.

--- jack
