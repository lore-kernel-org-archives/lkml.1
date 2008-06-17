Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYFQC31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYFQC31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 22:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYFQC3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 22:29:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbYFQC3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 22:29:17 -0400
Date: Mon, 16 Jun 2008 19:29:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Martin Peschke <mp3@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806171024.40662.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0806161928180.22820@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200806152033.02891.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0806160748050.19276@schroedinger.engr.sgi.com>
 <200806171024.40662.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Rusty Russell wrote:

> > The ia64 hook could simply return the address of percpu area that
> > was reserved when the per node memory layout was generated (which happens
> > very early during node bootstrap).
> 
> Apologies, this time I read the code.  I thought IA64 used the pinned TLB area 
> to access per-cpu vars under some circumstances, but they only do that via an 
> arch-specific macro.
> 
> So creating new congruent mappings to expand the percpu area(s) is our main 
> concern now?

The concern here was just consolidating the setup code for the per cpu 
areas.

