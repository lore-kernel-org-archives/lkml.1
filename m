Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbYFGR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbYFGR4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbYFGR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:56:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:34947 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761146AbYFGR40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:56:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+3NZxNkl+3sddaYq3MdhxTUs7MhwTu1zA+PFydQU
	Db96eLgnM+R7as
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in
	2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Smith <gsmith@gregsmith.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1212855380.19205.96.camel@lappy.programming.kicks-ass.net>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
	 <1211867950.5505.47.camel@marge.simson.net>
	 <Pine.GSO.4.64.0806060027290.8466@westnet.com>
	 <1212732780.13981.43.camel@marge.simson.net>
	 <1212838682.5571.6.camel@marge.simson.net>
	 <1212843008.4934.16.camel@marge.simson.net>
	 <1212844027.19205.82.camel@lappy.programming.kicks-ass.net>
	 <1212848179.4668.3.camel@marge.simson.net>
	 <1212855380.19205.96.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Sat, 07 Jun 2008 19:56:21 +0200
Message-Id: <1212861381.4953.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-07 at 18:16 +0200, Peter Zijlstra wrote:

> The idea was to dynamically detect sync wakeups, who's defining property
> is that the waker will sleep after waking the wakee. And who's effect is
> pulling tasks together on wakeups - so that we might have the most
> benefit of cache sharing.
> 
> So if we were to exclude cross cpu wakeups from this measurement we'd
> handicap the whole scheme, because then we'd never measure that its
> actually a sync wakeup and wants to run on the same cpu.

Ah, I get it now, thanks.

	-Mike

