Return-Path: <linux-kernel-owner+w=401wt.eu-S1423021AbXBIMGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423021AbXBIMGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946389AbXBIMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:06:53 -0500
Received: from ozlabs.org ([203.10.76.45]:42091 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423021AbXBIMGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:06:52 -0500
Subject: Re: [PATCH 2/10] lguest: Export symbols for lguest as a module
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <200702091032.44547.ak@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
	 <1171012513.2718.32.camel@localhost.localdomain>
	 <200702091032.44547.ak@muc.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 23:06:06 +1100
Message-Id: <1171022766.2718.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 10:32 +0100, Andi Kleen wrote:
> On Friday 09 February 2007 10:15, Rusty Russell wrote:
> 
> > tsc_khz:
> > 	Simplest way of telling the guest how to interpret the TSC
> > 	counter.
> 
> 
> Are you sure this will work with varying TSC frequencies? 

I'm actually quite sure it doesn't (there's a FIXME in the lguest code).
Given the debate over how useful the TSC was, I originally didn't use
it, but (1) it's simple, and (2) when it doesn't change, it's pretty
accurate.

> In general you should get this from cpufreq.

Hmm, ok, I'll bite: how?  Time is a mystery I've avoided so far 8)

Thanks!
Rusty.


