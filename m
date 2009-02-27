Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZB0LWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZB0LWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZB0LWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:22:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55451 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZB0LWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:22:39 -0500
Date: Fri, 27 Feb 2009 12:22:34 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Message-ID: <20090227112234.GA27221@pengutronix.de>
References: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com> <1235686285-8600-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090227161302.1551.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090227161302.1551.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 27, 2009 at 04:32:45PM +0900, KOSAKI Motohiro wrote:
> > -#ifdef CONFIG_FRAME_POINTER
> > -/* TODO: need to fix this for ARM */
> > -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > -# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> > -# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> > -# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> > -# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> > -# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> > -# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> > -#else
> > -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> > -# define CALLER_ADDR1 0UL
> > -# define CALLER_ADDR2 0UL
> > -# define CALLER_ADDR3 0UL
> > -# define CALLER_ADDR4 0UL
> > -# define CALLER_ADDR5 0UL
> > -# define CALLER_ADDR6 0UL
> > -#endif
> > +#ifndef CALLER_ADDR0
> 
> but I think this "#ifndef CALLER_ADDR0" don't explain developer intention at all.
> ARCH_HAS_XXXXX macro is better?
OK, this seems clearer.  I'd use HAVE_ARCH_CALLER_ADDR though.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
