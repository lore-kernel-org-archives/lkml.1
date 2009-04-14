Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZDNSAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZDNSAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZDNSAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:00:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZDNSAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:00:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain>
References: <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, tj@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Date: Tue, 14 Apr 2009 18:57:45 +0100
Message-ID: <15312.1239731865@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We should have the DECLARE_PER_CPU() #defines next to the DEFINE_PER_CPU 
> ones, rather than somewhere else.
> 
> So moving the logic to <asm-generic/percpu.h> is wrong - make it all be in 
> <linux/percpu.h> so that they can be maintained together.

Agreed, it would be nice.  However, x86 requires it to be declared in the
middle of asm/percpu.h (ie: in asm-generic/percpu.h).  I'm trying to sort it
out, but it's like trying to juggle hyperdimensional spaghetti:-/ How much
header file overhaul do you wish to indulge in?  And can I split some headers
into separate headers for declarations and inline functions?

David
