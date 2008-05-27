Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYE0If1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYE0If1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYE0IfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:35:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:41429 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756050AbYE0IfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:35:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+0Pd0lCdy0KWCcbdbwlb0ummBQYb0lI9G1B9rpQV
	U3Ou752pmRDeg6
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in
	2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211876448.5760.24.camel@marge.simson.net>
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
	 <1211876448.5760.24.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 27 May 2008 10:35:12 +0200
Message-Id: <1211877312.5760.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 10:20 +0200, Mike Galbraith wrote:

> Hm, pbench's extreme dislike of preemption, and the starvation testcase
> I sent earlier having an absolute requirement of preemption kinda argues
> that some knobs and dials should be per task or task group (or, or... or
> scheduler should be all knowing all seeing;) 

(to somewhat solidify the random thought i'm sharing...)

Perhaps a SCHED_PREEMPT class so such things can co-exist:

SCHED_BATCH == I never preempt.
SCHED_NORMAL == I preempt sometimes.
SCHED_PREEMPT == I always preempt my waker.

(end of random synaptic firing;)

	-Mike

