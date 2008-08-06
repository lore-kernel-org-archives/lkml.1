Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbYHFDhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbYHFDhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbYHFDhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:37:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38827 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYHFDhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:37:01 -0400
Date: Wed, 6 Aug 2008 05:37:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 8] x86/smp function calls: convert x86 tlb flushes to use function calls
Message-ID: <20080806033736.GB24801@one.firstfloor.org>
References: <patchbomb.1217636085@localhost> <87k5eu6d4f.fsf@basil.nowhere.org> <48991B84.2080704@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48991B84.2080704@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 08:33:24PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >
> >  
> >>1. use smp_call_function_mask to implement cross-cpu TLB flushes
> >>    
> >
> >
> >Do you have any measurements comparing performance of the old and 
> >the new call? TLB flush is quite time critical so we should be very
> >careful here.
> 
> No.  What benchmark would you suggest?

Micro benchmark. Just stick RDTSC around the calls and trigger
a few remote flushes by e.g. doing mmap/munmap on a multithreaded program
running on different CPUs.

-Andi
