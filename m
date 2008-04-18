Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYDRKp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYDRKp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYDRKpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:45:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYDRKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:45:20 -0400
Date: Fri, 18 Apr 2008 03:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-Id: <20080418034426.f710cbb9.akpm@linux-foundation.org>
In-Reply-To: <1208260942.6395.6.camel@twins>
References: <20080415115058.GA6788@in.ibm.com>
	<20080415115314.GA6975@in.ibm.com>
	<1208260942.6395.6.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 14:02:22 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> 
> > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > +			"abs_time:%p bitset:%d",
> > +			uaddr, fshared, val, abs_time, bitset);
> 
> This is some seriuosly ugly looking gunk, why would we want stuff like
> that scattered across the code?

My 2c: if we even begin to countenance merging stuff like that, it's time
for all the trace code to be removed.

<checks the email headers>

Nope, it wasn't April 1st.  Guys, get a grip.
