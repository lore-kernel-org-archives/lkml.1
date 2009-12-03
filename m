Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZLCBoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZLCBoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZLCBoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:44:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:41081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752036AbZLCBoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:44:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18B6sgwCy0Bag+ar+AZCn/Fb1Hed8xGIgtSAuE9QO
	phoUpD0vZtUIZS
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Mike Galbraith <efault@gmx.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B17138D.3040003@bigpond.net.au>
References: <1259501027.6268.9.camel@marge.simson.net>
	 <1259754383.4003.610.camel@laptop>
	 <1259758150.6167.8.camel@marge.simson.net>
	 <4B17138D.3040003@bigpond.net.au>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 02:44:27 +0100
Message-Id: <1259804667.7691.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 11:25 +1000, Peter Williams wrote:
> On 02/12/09 22:49, Mike Galbraith wrote:
> > Hysterical reasons?  That might have been a doorstop conversion kit for
> > O(1), but boots fine with CFS, and prio 40 tasks are history.
> 
> In my (not so) humble opinion, there is still a lot of unnecessary cruft 
> in sched.c that should have been removed as the final (clean up) stage 
> of implementing CFS (i.e. stuff that was needed for O(1) but no longer 
> serves a useful purpose).  I know that the extra overhead of this code 
> is probably inconsequential (and the compiler may even optimize some of 
> it away) but it looks untidy and makes the code harder to understand.
> 
> Recent patches that I've submitted were intended as a start to removing 
> some of this cruft and I had intended to send more patches after they 
> were accepted.  I figured that it was better to do it as a number of 
> small changes rather than one big one.  Should I continue?

Certainly.

	-Mike

