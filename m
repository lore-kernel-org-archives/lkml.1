Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYFGOQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYFGOQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbYFGOQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:16:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:52252 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750785AbYFGOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:16:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19pORYCWLFpXXBhtY04sCYhXHVTOIVKD+AWQIQVpl
	jNMedSIRALgLBr
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in
	2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Smith <gsmith@gregsmith.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1212844027.19205.82.camel@lappy.programming.kicks-ass.net>
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
Content-Type: text/plain
Date: Sat, 07 Jun 2008 16:16:19 +0200
Message-Id: <1212848179.4668.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-07 at 15:07 +0200, Peter Zijlstra wrote:
> On Sat, 2008-06-07 at 14:50 +0200, Mike Galbraith wrote:
> > Since I tested mysql+oltp and made the dang pdf of the results, I may
> > as well actually attach the thing <does that before continuing...>.
> > 
> > BTW, I have a question wrt avg_overlap.  When a wakeup cause the current
> > task to begin sharing CPU with a freshly awakened task, the current task
> > is tagged.. but the wakee isn't.  How come?  If one is sharing, so is
> > the other.
> 
> avg_overlap is about measuring how long we'll run after waking someone
> else. The other measure, how long our waker shares the cpu with us,
> hasn't proven to be relevant so far.

Yeah wrt relevance, I've been playing with making it mean this and that,
with approx 0 success ;-)  If it's a measure of how long we run after
waking though, don't we need to make sure it's not a cross CPU wakeup?

	-Mike

