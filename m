Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXH2ADR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXH2ADR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 20:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXH2ADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 20:03:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:45025 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXH2ADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 20:03:05 -0400
Subject: Re: [PATCH -rt 1/8] introduce PICK_FUNCTION
From: Daniel Walker <dwalker@mvista.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <46D4B356.7060604@yahoo.com.au>
References: <20070828213748.790253419@mvista.com>
	 <46D4B356.7060604@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 16:54:32 -0700
Message-Id: <1188345272.2435.343.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 09:44 +1000, Nick Piggin wrote:
> Daniel Walker wrote:
> > PICK_FUNCTION() is similar to the other PICK_OP style macros, and was
> > created to replace them all. I used variable argument macros to handle
> > PICK_FUNC_2ARG/PICK_FUNC_1ARG. Otherwise the marcos are similar to the
> > original macros used for semaphores. The entire system is used to do a
> > compile time switch between two different locking APIs. For example,
> > real spinlocks (raw_spinlock_t) and mutexes (or sleeping spinlocks).
> > 
> > This new macro replaces all the duplication from lock type to lock type.
> > The result of this patch, and the next two, is a fairly nice simplification,
> > and consolidation. Although the seqlock changes are larger than the originals
> > I think over all the patchset is worth while.
> > 
> > Incorporated peterz's suggestion to not require TYPE_EQUAL() to only
> > use pointers.
> 
> How come this is cc'ed to lkml? Is it something that is relevant to
> the mainline kernel... or?

The real time changes are usually developed on lkml , that's how it's
been in the past. I personally like CC'ing lkml since real time can
sometimes touch lots of different subsystems .. So it good to have a
diverse set of people reviewing ..

Daniel

