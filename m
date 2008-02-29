Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYB2DeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYB2DeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 22:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYB2DeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 22:34:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45344 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751381AbYB2DeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 22:34:09 -0500
Date: Thu, 28 Feb 2008 21:34:02 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228213402.7260906f.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802281659460.3158@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
	<20080228113728.7b8e5811.pj@sgi.com>
	<alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
	<20080228164637.114fb19d.pj@sgi.com>
	<alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
	<20080228181611.49671331.pj@sgi.com>
	<alpine.DEB.1.00.0802281659460.3158@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, responding to pj, responding to ...:
>
> > > Move the watchdog/0 thread to a cpuset that doesn't have access to cpu 0.  
> > 
> > I still don't understand ... you must have some context in mind that
> > I've spaced out ... I can't even tell if that is a statement or a
> > question.
> > 
> 
> You said that you weren't aware of any problems that could arise that are 
> fixed with this added check in set_cpus_allowed(),

Ok, now I understand your question - thanks.

I think your question arises from misreading what I wrote.

I did not say that I wasn't "aware of any problems that could arise"

I did say, as you quoted, from Thu, 28 Feb 2008 11:37:28 -0600:
>
> I don't have strong opinions either way on this patch; it adds an error
> check that makes sense.  I haven't seen much problem not having this check,
> nor do I know of any code that depends on doing what this check prohibits.

 - This does not say no (none whatsoever) problem could (ever in the future) arise.

 - This does say not much (just a little) problem had arisen (so far in the past).

Apparently, you thought I was trying to reject the patch on the grounds
that no such problem could ever occur, and you were showing how such a
problem could occur.  I wasn't trying to reject the patch, and I agree
that the check made sense, and I agree that such a problem could occur,
as your example shows.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
