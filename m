Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYJBWYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYJBWYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYJBWXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:23:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41985 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYJBWXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:23:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <alpine.LFD.2.00.0810011110440.3635@xanadu.home>
References: <alpine.LFD.2.00.0810011110440.3635@xanadu.home> <alpine.LFD.2.00.0809282123100.3635@xanadu.home> <20080924164826.14867.63020.stgit@warthog.procyon.org.uk> <1222426580.16700.258.camel@lappy.programming.kicks-ass.net> <alpine.LFD.2.00.0809260802310.3635@xanadu.home> <1222431635.16700.278.camel@lappy.programming.kicks-ass.net> <29968.1222871650@redhat.com> 
To: Nicolas Pitre <nico@cam.org>
Cc: dhowells@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
Date: Thu, 02 Oct 2008 23:23:35 +0100
Message-ID: <1703.1222986215@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> Oh, that's a possibility.  In that case __m_cnt_hi will be reverted to a 
> previous state just like if cnt32_to_63() has not been called yet since 
> the new half period.  And a subsequent call will fix that again.

Surely that's not good enough.  There's a 50% chance that reversion to a
previous state will result in an extra increment of the __m_cnt_hi on the next
call.

David
