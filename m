Return-Path: <linux-kernel-owner+w=401wt.eu-S1946467AbXBIN66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946467AbXBIN66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946468AbXBIN66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:58:58 -0500
Received: from colin.muc.de ([193.149.48.1]:2983 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946467AbXBIN65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:58:57 -0500
Date: 9 Feb 2007 14:58:55 +0100
Date: Fri, 9 Feb 2007 14:58:55 +0100
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/10] lguest: Export symbols for lguest as a module
Message-ID: <20070209135855.GC18080@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012458.2718.30.camel@localhost.localdomain> <1171012513.2718.32.camel@localhost.localdomain> <200702091032.44547.ak@muc.de> <1171022766.2718.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171022766.2718.94.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 11:06:06PM +1100, Rusty Russell wrote:
> On Fri, 2007-02-09 at 10:32 +0100, Andi Kleen wrote:
> > On Friday 09 February 2007 10:15, Rusty Russell wrote:
> > 
> > > tsc_khz:
> > > 	Simplest way of telling the guest how to interpret the TSC
> > > 	counter.
> > 
> > 
> > Are you sure this will work with varying TSC frequencies? 
> 
> I'm actually quite sure it doesn't (there's a FIXME in the lguest code).
> Given the debate over how useful the TSC was, I originally didn't use
> it, but (1) it's simple, and (2) when it doesn't change, it's pretty
> accurate.

But when it changes users become pretty unhappy

> 
> > In general you should get this from cpufreq.
> 
> Hmm, ok, I'll bite: how?  Time is a mystery I've avoided so far 8)

the old x86-64 time.c (before -mm) has a example in #ifdef CONFIG_CPUFREQ


-Andi
