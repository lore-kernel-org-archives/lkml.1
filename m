Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXKMTW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXKMTW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXKMTWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:22:49 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:32465 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753664AbXKMTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:22:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UhpmNB6R3PV7DmLDOGwNx4xvwnIG5rJL5eyGnQmEG+491pNpP81lHgFwxzn8SI2SrfQK+YwHImSyRGLBp7xuNYuOJ8f2GRY1jk2AnhGRRuUPHr9bvX4y4IPuIVvQU1MjNPDUwtSlVV4w8sRlH6RFmDm7t+x6oc3W/foh9Wfimfw=  ;
X-YMail-OSG: JMJ2eR0VM1kwL5rb6f37tbu8IG8atUZ1dhC9CRohmQxh5riJvTrR3GlmURDloHXbgfxLbKdYaw--
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Tue, 13 Nov 2007 11:22:45 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <20071113093414.GA5270@elte.hu>
In-Reply-To: <20071113093414.GA5270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131122.45950.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Ingo Molnar wrote:
> 
> * David Brownell <david-b@pacbell.net> wrote:
> 
> > > > I speculate that either the design has changed (without fanfare), 
> > > > or else that stuff is in RT kernels and has not yet gone upstream.
> > > 
> > > Well whatever.  We shouldn't have to resort to caller-side party 
> > > tricks like this to get acceptable performance.
> > 
> > I'd be happy if, as originally presented, it were possible to just 
> > pass a raw_spinlock_t to spin_lock_irqsave() and friends.
> 
> that's a spinlock type abstraction of PREEMPT_RT, not of mainline.

Any reason that stuff shouldn't move into mainline?


> 	 Why do you want to use raw_spinlock_t?

Already answered elsewhere in this thread ... I'll highlight the
point that such bitops shouldn't be preemption points.
