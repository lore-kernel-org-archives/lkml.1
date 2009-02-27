Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZB0PWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZB0PWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZB0PV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:21:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZB0PV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:21:58 -0500
Date: Fri, 27 Feb 2009 10:21:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
In-Reply-To: <20090227112234.GA27221@pengutronix.de>
Message-ID: <alpine.DEB.2.00.0902271021370.25593@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com> <1235686285-8600-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090227161302.1551.A69D9226@jp.fujitsu.com> <20090227112234.GA27221@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, Uwe Kleine-K?nig wrote:

> Hi,
> 
> On Fri, Feb 27, 2009 at 04:32:45PM +0900, KOSAKI Motohiro wrote:
> > > -#ifdef CONFIG_FRAME_POINTER
> > > -/* TODO: need to fix this for ARM */
> > > -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > > -# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> > > -# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> > > -# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> > > -# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> > > -# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> > > -# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> > > -#else
> > > -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > > -# define CALLER_ADDR1 0UL
> > > -# define CALLER_ADDR2 0UL
> > > -# define CALLER_ADDR3 0UL
> > > -# define CALLER_ADDR4 0UL
> > > -# define CALLER_ADDR5 0UL
> > > -# define CALLER_ADDR6 0UL
> > > -#endif
> > > +#ifndef CALLER_ADDR0
> > 
> > but I think this "#ifndef CALLER_ADDR0" don't explain developer intention at all.
> > ARCH_HAS_XXXXX macro is better?
> OK, this seems clearer.  I'd use HAVE_ARCH_CALLER_ADDR though.

Yes, I agree using HAVE_ARH_CALLER_ADDR is the way to handle this.

Thanks,

-- Steve

